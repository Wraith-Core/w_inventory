-- Marketplace deliveries commit the native inventory and receipt together.
-- A receipt survives consumption, trading, disconnects and lost acknowledgements.
return function(Inventory, Inventories, Items, cartPlan, db)
    local Codec = shared.framework == 'rsg' and require 'modules.mysql.rsg' or nil
    local ready, unknown, listingUnknown, working = false, {}, {}, {}
    local function canonical(value)
        if type(value) ~= 'table' then return json.encode(value) end
        local keys, out = {}, {}
        for key in pairs(value) do keys[#keys + 1] = key end
        table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
        for _, key in ipairs(keys) do out[#out + 1] = canonical(key) .. ':' .. canonical(value[key]) end
        return '{' .. table.concat(out, ',') .. '}'
    end
    CreateThread(function()
        MySQL.ready.await()
        MySQL.query.await([[CREATE TABLE IF NOT EXISTS w_inventory_market_receipts (
            claim_id VARCHAR(96) NOT NULL PRIMARY KEY, citizenid VARCHAR(64) NOT NULL,
            request LONGTEXT NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
        ready = true
    end)
    local function publish(inv, rows)
        local changed, slots = {}, {}
        for slot in pairs(inv.items) do changed[#changed + 1] = {item={slot=slot},inventory=inv.id} end
        for _, row in pairs(rows) do
            row.weight = Inventory.SlotWeight(Items(row.name), row)
            slots[row.slot] = row
            changed[#changed + 1] = {item=row,inventory=inv.id}
        end
        inv.items, inv.weight, inv.changed = slots, Inventory.CalculateWeight(slots), false
        -- Publish the committed cache before callbacks or releasing the lock.
        pcall(function()
            if server.syncInventory then server.syncInventory(inv) end
            inv:syncSlotsWithClients(changed, true)
        end)
    end
    local function deliverClaim(source, claim, owner, name, count, metadata)
        if not ready or not Codec or not shared.ready then return false, 'inventory_unavailable' end
        owner, claim = tostring(owner or ''), tostring(claim or '')
        if #claim < 1 or #claim > 96 or not claim:match('^[%w_:%-]+$') then return false, 'invalid_claim' end
        local inv = Inventories[tonumber(source)]
        if not inv or not inv.player or tostring(inv.owner) ~= owner then return false, 'wrong_character' end
        local item = Items(name)
        if not item or item.nativeCurrency or item.nativeGunbelt or name == 'money' or name == 'cash' or name == 'gold'
            or name == 'moneybag' or type(metadata) ~= 'table' or metadata.economyClaim then return false, 'invalid_item' end
        if type(count) ~= 'number' or count < 1 or count % 1 ~= 0 or count > 1200 then return false, 'invalid_count' end
        local request = canonical({owner=owner,name=name,count=count,metadata=metadata})
        local recovery = unknown[owner]
        if recovery and (recovery.claim ~= claim or recovery.request ~= request) then return false, 'inventory_busy' end
        if working[owner] or (inv.nativeTransfer and not recovery) or Inventory.HasForeignSlotTransfer(inv)
            or (server.nativeOfflineLocks[owner] and not recovery) then return false, 'inventory_busy' end
        working[owner] = true
        inv.nativeTransfer, server.nativeOfflineLocks[owner] = coroutine.running(), true
        local uncertain = recovery ~= nil
        local ok, result, reason = xpcall(function()
            local receipt = MySQL.single.await('SELECT citizenid, request FROM w_inventory_market_receipts WHERE claim_id = ?', {claim})
            if receipt and not recovery then
                return receipt.citizenid == owner and receipt.request == request, 'already_delivered'
            end
            Inventory.CloseAll(inv); inv:closeInventory()
            if not recovery then
                if not Inventory.Save(inv) then return false, 'save_failed' end
                local lines, remaining = {}, count
                while remaining > 0 do
                    local amount = math.min(100, remaining)
                    lines[#lines + 1] = {item=name,count=amount,metadata=metadata}; remaining = remaining - amount
                end
                local plan, err = cartPlan(inv, lines)
                if not plan then return false, err end
                local encoded = Codec.encode(plan.items)
                uncertain = true
                pcall(MySQL.startTransaction, function(query)
                    local player = query('SELECT citizenid FROM players WHERE citizenid = ? FOR UPDATE', {owner})
                    assert(player and player[1], 'Missing marketplace recipient')
                    local old = query('SELECT citizenid, request FROM w_inventory_market_receipts WHERE claim_id = ?', {claim})
                    if old and old[1] then
                        assert(old[1].citizenid == owner and old[1].request == request, 'Marketplace claim conflict')
                        return true
                    end
                    query('UPDATE players SET inventory = ? WHERE citizenid = ?', {encoded,owner})
                    query('INSERT INTO w_inventory_market_receipts (claim_id,citizenid,request) VALUES (?,?,?)', {claim,owner,request})
                    return true
                end)
            end
            -- Establish durability independently of startTransaction wrappers
            -- which may return true before their final COMMIT has completed.
            -- Lock the writer's player row before reading the durable receipt;
            -- neither success nor a planned cache snapshot is published early.
            local saved, proof
            local fenced = MySQL.startTransaction(function(query)
                local rows = query('SELECT inventory FROM players WHERE citizenid = ? FOR UPDATE', {owner})
                assert(rows and rows[1], 'Missing marketplace recipient')
                saved = rows[1].inventory
                local rows2 = query('SELECT citizenid, request FROM w_inventory_market_receipts WHERE claim_id = ?', {claim})
                proof = rows2 and rows2[1]
                return true
            end)
            if fenced ~= true then return false, 'delivery_unknown' end
            if proof then
                assert(proof.citizenid == owner and proof.request == request, 'Marketplace claim conflict')
                publish(inv, Codec.decode(saved)); uncertain = false
                return true, 'recovered'
            end
            uncertain = false
            return false, 'delivery_rolled_back'
        end, debug.traceback)
        if uncertain then
            unknown[owner] = {claim=claim,request=request,source=source,name=name,count=count,metadata=metadata}
            inv.nativeTransfer = 'market_unknown:' .. claim
        else
            unknown[owner], inv.nativeTransfer, server.nativeOfflineLocks[owner] = nil, nil, nil
        end
        working[owner] = nil
        if not ok then print('[w_inventory] Market delivery held: ' .. tostring(result)); return false, 'delivery_unknown' end
        return result, reason
    end
    local function escrowListing(source, id, owner)
        if not ready or not Codec or not shared.ready then return false, 'inventory_unavailable' end
        owner, id = tostring(owner or ''), tostring(id or '')
        local inv = Inventories[tonumber(source)]
        if not inv or not inv.player or tostring(inv.owner) ~= owner then return false, 'wrong_character' end
        local recovery = listingUnknown[owner]
        if recovery and recovery.id ~= id then return false, 'inventory_busy' end
        if working[owner] or (inv.nativeTransfer and not recovery) or Inventory.HasForeignSlotTransfer(inv)
            or (server.nativeOfflineLocks[owner] and not recovery) then return false, 'inventory_busy' end
        working[owner] = true
        inv.nativeTransfer, server.nativeOfflineLocks[owner] = coroutine.running(), true
        local uncertain = recovery ~= nil
        local ok,result,reason = xpcall(function()
            local draft = MySQL.single.await('SELECT * FROM w_market_listing_intents WHERE id=? AND charid=?',{id,owner})
            if not draft then return false,'missing_listing' end
            if draft.state ~= 'prepared' and not recovery then return draft.state ~= 'abandoned', 'already_escrowed' end
            Inventory.CloseAll(inv); inv:closeInventory()
            if not recovery then
                if not Inventory.Save(inv) then return false,'save_failed' end
                local p = json.decode(draft.payload)
                local row, item = inv.items[tonumber(p.slot)], Items(p.name)
                if not item or item.nativeCurrency or item.nativeGunbelt or p.name=='moneybag' or p.metadata.economyClaim
                    or p.name=='money' or p.name=='cash' or p.name=='gold' then return false,'invalid_item' end
                if not row or row.name ~= p.name or type(p.count)~='number' or p.count<1 or p.count%1~=0
                    or row.count < p.count or canonical(row.metadata or {}) ~= canonical(p.metadata) then return false,'item_changed' end
                local rows = json.decode(json.encode(inv.items))
                local slot = tonumber(p.slot)
                -- JSON object keys become strings for sparse slot maps.
                local target = rows[slot] or rows[tostring(slot)]
                if target.count == p.count then rows[slot],rows[tostring(slot)] = nil,nil else target.count=target.count-p.count end
                local encoded = Codec.encode(rows)
                uncertain = true
                pcall(MySQL.startTransaction,function(query)
                    local player = query('SELECT citizenid FROM players WHERE citizenid=? FOR UPDATE',{owner})
                    assert(player and player[1], 'Missing listing owner')
                    local active = query('SELECT state FROM w_market_listing_intents WHERE id=? AND charid=? FOR UPDATE',{id,owner})
                    assert(active and active[1] and active[1].state=='prepared','Listing intent changed')
                    query('UPDATE players SET inventory=? WHERE citizenid=?',{encoded,owner})
                    query("UPDATE w_market_listing_intents SET state='escrowed' WHERE id=?",{id})
                    return true
                end)
            end
            -- Always fence, including a true transaction return: a wrapper's
            -- early acknowledgement must never publish uncommitted escrow.
            local proof,saved
            local fenced = MySQL.startTransaction(function(query)
                local rows=query('SELECT inventory FROM players WHERE citizenid=? FOR UPDATE',{owner})
                assert(rows and rows[1],'Missing listing owner');saved=rows[1].inventory
                local draft=query('SELECT state FROM w_market_listing_intents WHERE id=? AND charid=?',{id,owner})
                proof=draft and draft[1];return true
            end)
            if fenced~=true or not proof then return false,'listing_unknown' end
            if proof.state~='prepared' and proof.state~='abandoned' then
                publish(inv,Codec.decode(saved));uncertain=false;return true,'recovered'
            end
            uncertain=false;return false,'listing_rolled_back'
        end,debug.traceback)
        if uncertain then listingUnknown[owner]={id=id,source=source};inv.nativeTransfer='market_listing_unknown:'..id
        else listingUnknown[owner],inv.nativeTransfer,server.nativeOfflineLocks[owner]=nil,nil,nil end
        working[owner] = nil
        if not ok then print('[w_inventory] Listing held for recovery: '..tostring(result));return false,'listing_unknown' end
        return result,reason
    end
    exports('DeliverMarketClaim',function(...)
        if GetInvokingResource()~='w_marketplace' then return false,'forbidden' end
        return deliverClaim(...)
    end)
    exports('EscrowMarketListing',function(...)
        if GetInvokingResource()~='w_marketplace' then return false,'forbidden' end
        return escrowListing(...)
    end)
    -- A lost database reply must also recover if its owner disconnects while
    -- inventory removal is waiting on the lock. Use the original loaded bag.
    CreateThread(function()
        while true do
            Wait(10000)
            for owner,p in pairs(unknown) do
                pcall(deliverClaim,p.source,p.claim,owner,p.name,p.count,p.metadata)
            end
            for owner,p in pairs(listingUnknown) do pcall(escrowListing,p.source,p.id,owner) end
        end
    end)
end
