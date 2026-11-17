-- Wraith Core stores the bag and job progression in the same InnoDB database.
-- The first commit records the rolled reward. The second commits both effects.
return function(Inventory, Inventories, Items, cartPlan)
    local Codec = shared.framework == 'rsg' and require 'modules.mysql.rsg' or nil
    local states = {}

    local function boundedInt(v, lo, hi)
        return type(v) == 'number' and v >= lo and v <= hi and v % 1 == 0
    end

    local function validText(v)
        return type(v) == 'string' and #v <= 512
    end

    local function validRequest(r)
        if type(r) ~= 'table' or type(r.key) ~= 'string' or #r.key > 80 or not r.key:match('^[%w:_%-]+$')
            or type(r.track) ~= 'string' or #r.track > 40 or not r.track:match('^[a-z][a-z0-9_]*$')
            or not boundedInt(r.xp, 0, 10000) or type(r.lines) ~= 'table' or #r.lines > 12 then return false end
        local count = 0
        for i, line in pairs(r.lines) do
            if not boundedInt(i, 1, #r.lines) or type(line) ~= 'table' or type(line.item) ~= 'string'
                or #line.item > 64 or not line.item:match('^[%w_]+$') or not boundedInt(line.count, 1, 1000)
                or line.metadata ~= nil then return false end
            local l = line.label
            if l ~= nil and not validText(l) and not (type(l) == 'table'
                and (validText(l.ar) or validText(l.en))
                and (l.ar == nil or validText(l.ar)) and (l.en == nil or validText(l.en))) then return false end
            if type(l) == 'table' then
                for field in pairs(l) do if field ~= 'ar' and field ~= 'en' then return false end end
            end
            for field in pairs(line) do
                if field ~= 'item' and field ~= 'count' and field ~= 'label' then return false end
            end
            count = count + 1
        end
        return count == #r.lines
    end

    local function bundle(row)
        local r = { key = row.node_key, track = row.track, xp = tonumber(row.xp), lines = json.decode(row.items_json) }
        assert(validRequest(r), 'Invalid saved gathering reward')
        return r
    end

    local function sameReward(saved, request)
        if saved.key ~= request.key or saved.track ~= request.track or saved.xp ~= request.xp or #saved.lines ~= #request.lines then return false end
        for i, a in ipairs(saved.lines) do
            local b = request.lines[i]
            if a.item ~= b.item or a.count ~= b.count then return false end
            if type(a.label) == 'table' then
                if type(b.label) ~= 'table' or a.label.ar ~= b.label.ar or a.label.en ~= b.label.en then return false end
            elseif a.label ~= b.label then return false end
        end
        return true
    end

    local function matches(row, ctx, request)
        return tonumber(row.player_id) == ctx.id and sameReward(bundle(row), request)
    end

    local function attached(ctx)
        local inv = ctx.inv
        return Inventories[inv.id] == inv and not inv.purged and tonumber(inv.ownerRow) == ctx.id
    end

    local function acquire(ctx)
        ctx.working = true
        ctx.inv.nativeTransfer = coroutine.running()
        if not server.nativeOfflineLocks[ctx.owner] then server.nativeOfflineLocks[ctx.owner] = ctx end
        states[ctx.inv] = ctx
    end

    local function release(ctx)
        ctx.working = false
        if ctx.uncertain then
            -- A stale disconnect/autosave must wait for the commit outcome.
            ctx.inv.nativeTransfer = 'gathering_unknown:' .. ctx.key
            return
        end
        states[ctx.inv] = nil
        ctx.inv.nativeTransfer = nil
        if server.nativeOfflineLocks[ctx.owner] == ctx then server.nativeOfflineLocks[ctx.owner] = nil end
    end

    local function lookup(ctx, query, key, pending)
        local field = pending and 'pending_owner' or 'node_key'
        local rows = query(('SELECT node_key, player_id, track, xp, items_json, completed_at FROM %s WHERE %s = ?'):format(ctx.awards, field), { key })
        return rows and rows[1]
    end

    local function player(ctx, query)
        local rows = query('SELECT id, citizenid, w_gather_revision FROM players WHERE id = ? FOR UPDATE', { ctx.id })
        return rows and rows[1]
    end

    local function prepare(ctx, request)
        local reason
        local ok = MySQL.startTransaction(function(query)
            local row = player(ctx, query)
            if not row or tostring(row.citizenid) ~= ctx.owner then reason = 'no_character' return false end
            if tonumber(row.w_gather_revision) ~= (ctx.inv.gatherRevision or 0) then reason = 'inventory_busy' return false end
            local existing = lookup(ctx, query, request.key)
            if existing then
                if not matches(existing, ctx, request) then reason = 'conflict' return false end
            elseif lookup(ctx, query, ctx.id, true) then
                reason = 'pending'
                return false
            else
                query(('INSERT INTO %s (node_key, player_id, pending_owner, track, xp, items_json, created_at) '
                    .. 'VALUES (?, ?, ?, ?, ?, ?, ?)'):format(ctx.awards),
                    { request.key, ctx.id, ctx.id, request.track, request.xp, json.encode(request.lines), os.time() })
            end
            return true
        end)
        return ok == true, reason or 'pending'
    end

    local function planBag(ctx, request)
        for _, line in ipairs(request.lines) do
            local item = Items(line.item)
            if not item or item.nativeSource ~= 'wcore' or item.nativeCurrency or item.nativeGunbelt
                or line.item == 'money' or line.item == 'cash' or line.item == 'gold' then return nil, 'invalid_request' end
        end
        if #request.lines == 0 then return {} end
        local plan, reason = cartPlan(ctx.inv, request.lines, nil, 1000)
        if plan then return plan end
        if reason == 'weight_limit' or reason == 'inventory_full' or reason == 'item_limit' or reason == 'weapon_limit' then
            return nil, 'inventory_full'
        end
        return nil, 'unavailable'
    end

    local function publish(ctx, revision)
        local plan, inv = ctx.plan, ctx.inv
        if not ctx.applied or not plan.items or not attached(ctx) then return end
        inv.items, inv.weight, inv.changed, inv.gatherRevision = plan.items, plan.weight, false, revision
        local ok, why = pcall(function()
            local updates = {}
            for slot in pairs(plan.changed) do
                updates[#updates + 1] = { item = plan.items[slot], inventory = inv.id }
            end
            if server.syncInventory then server.syncInventory(inv) end
            inv:syncSlotsWithClients(updates, true)
        end)
        if not ok then lib.print.error('Gathering inventory notification failed: ' .. tostring(why)) end
    end

    -- This lock waits for any previous writer, including one whose COMMIT acknowledgement was lost.
    local function confirm(ctx)
        local proof, owner, total, removed, revision
        local ok = MySQL.startTransaction(function(query)
            local current = player(ctx, query)
            if not current then removed = true return true end
            owner = tostring(current.citizenid)
            revision = tonumber(current.w_gather_revision)
            local receipt = lookup(ctx, query, ctx.key)
            if receipt and receipt.completed_at and tonumber(receipt.player_id) == ctx.id then
                proof = bundle(receipt)
                local rows = query(('SELECT xp FROM %s WHERE citizenid = ? AND track = ?'):format(ctx.progress), {owner, proof.track})
                total = rows and rows[1] and tonumber(rows[1].xp) or 0
            end
            return true
        end)
        if ok ~= true then return false, 'pending' end
        ctx.uncertain = false
        if removed then return false, 'no_character' end
        if not proof then return false, ctx.rejected or 'pending' end
        if attached(ctx) and revision ~= ((ctx.inv.gatherRevision or 0) + (ctx.applied and ctx.plan.items and 1 or 0)) then
            return false, 'inventory_busy'
        end
        publish(ctx, revision)
        proof.totalXp = total
        TriggerEvent('w_inventory:gatheringNodeSettled', owner, proof.track)
        return true, proof
    end

    local function settle(ctx, request)
        Inventory.AwaitGatheringSaves(ctx.inv)
        if not attached(ctx) then return false, 'no_character' end
        local existing
        if request then
            existing = MySQL.single.await(('SELECT * FROM %s WHERE node_key = ?'):format(ctx.awards), { request.key })
            if existing and not matches(existing, ctx, request) then return false, 'conflict' end
        else
            existing = MySQL.single.await(('SELECT * FROM %s WHERE pending_owner = ?'):format(ctx.awards), { ctx.id })
            if not existing then return true, nil end
        end
        if existing then request = bundle(existing) end
        ctx.key = request.key
        if existing and existing.completed_at then return confirm(ctx) end
        local plan, reason = planBag(ctx, request)
        if not plan then return false, reason end
        if not attached(ctx) or ctx.owner ~= tostring(ctx.inv.owner) then return false, 'no_character' end
        if Inventory.HasForeignSlotTransfer(ctx.inv) then return false, 'inventory_busy' end
        ctx.plan = plan
        if not existing then
            local prepared, why = prepare(ctx, request)
            if not prepared then return false, why end
        end
        local encoded = plan.items and Codec.encode(plan.items) or nil
        ctx.uncertain = true
        -- The request remains durable if planning, capacity, or the database interrupts this step.
        pcall(MySQL.startTransaction, function(query)
            local row = player(ctx, query)
            if not attached(ctx) or not row or tostring(row.citizenid) ~= tostring(ctx.inv.owner) then return false end
            if tonumber(row.w_gather_revision) ~= (ctx.inv.gatherRevision or 0) then
                ctx.rejected = 'inventory_busy'
                return false
            end
            local receipt = lookup(ctx, query, ctx.key)
            if not receipt or not matches(receipt, ctx, request) then return false end
            if receipt.completed_at then return true end
            if encoded then
                query('UPDATE players SET inventory = ?, w_gather_revision = w_gather_revision + 1 WHERE id = ?', {encoded, ctx.id})
            end
            if request.xp > 0 then
                query(('INSERT INTO %s (citizenid, track, xp, runs, last_at) VALUES (?, ?, ?, 0, ?) '
                    .. 'ON DUPLICATE KEY UPDATE xp = LEAST(2000000000, xp + VALUES(xp)), last_at = VALUES(last_at)'):format(ctx.progress),
                    {row.citizenid, request.track, request.xp, os.time()})
            end
            query(('UPDATE %s SET completed_at = ?, pending_owner = NULL WHERE node_key = ?'):format(ctx.awards), {os.time(), ctx.key})
            ctx.applied = true
            return true
        end)
        return confirm(ctx)
    end

    local function guarded(ctx, fn, ...)
        acquire(ctx)
        local ok, success, result = pcall(fn, ctx, ...)
        release(ctx)
        if not ok then
            if not ctx.reported then lib.print.error('Gathering settlement failed: ' .. tostring(success)); ctx.reported = true end
            return false, ctx.key and 'pending' or 'unavailable'
        end
        return success, result
    end

    exports('SettleGatheringNode', function(src, owner, prefix, request)
        if GetInvokingResource() ~= 'w_jobs' then return false, 'forbidden' end
        if not shared.ready or shared.backend ~= 'wcore' or not Codec then return false, 'unavailable' end
        if type(prefix) ~= 'string' or #prefix > 50 or not prefix:match('^[a-zA-Z_][%w_]*$')
            or (request ~= nil and not validRequest(request)) then return false, 'invalid_request' end
        local inv = Inventories[tonumber(src)]
        if type(owner) ~= 'string' or not inv or not inv.player or inv.purged or tostring(inv.owner) ~= owner then
            return false, 'no_character'
        end
        local playerId = tonumber(inv.ownerRow) or Inventory.GatheringOwnerRow(inv)
        if not playerId or Inventories[inv.id] ~= inv or tostring(inv.owner) ~= owner then return false, 'no_character' end
        local ctx = states[inv]
        if ctx then
            if ctx.working then return false, 'inventory_busy' end
            local ok, result = guarded(ctx, confirm)
            if not ok then return false, result end
            if ctx.awards ~= prefix .. 'node_awards' then return false, 'pending' end
            if not request then return true, result end
            if request.key == result.key then
                if not sameReward(result, request) then return false, 'conflict' end
                return true, result
            end
            return false, 'pending'
        end
        if inv.nativeTransfer or Inventory.HasForeignSlotTransfer(inv) or server.nativeOfflineLocks[owner]
            or (server.nativeLoadingOwners and server.nativeLoadingOwners[owner]) then return false, 'inventory_busy' end
        ctx = {inv=inv, owner=owner, id=playerId, awards=prefix .. 'node_awards', progress=prefix .. 'progress'}
        return guarded(ctx, settle, request)
    end)

    function Inventory.GatheringState(owner)
        for _, ctx in pairs(states) do
            if ctx.owner == tostring(owner) then return ctx.working, ctx.uncertain == true end
        end
        return false, false
    end

    function Inventory.MoveGatheringOwner(old, new, inv)
        local ctx = states[inv]
        if not ctx or ctx.owner ~= tostring(old) then return end
        if server.nativeOfflineLocks[ctx.owner] == ctx then server.nativeOfflineLocks[ctx.owner] = nil end
        ctx.owner = tostring(new)
        if not server.nativeOfflineLocks[ctx.owner] then server.nativeOfflineLocks[ctx.owner] = ctx end
    end

    function Inventory.RecoverGathering(inv)
        local ctx = states[inv]
        if ctx and not ctx.working then return guarded(ctx, confirm) end
    end

    CreateThread(function()
        while true do
            Wait(2000)
            local held = {}
            for inv, ctx in pairs(states) do if not ctx.working then held[#held + 1] = inv end end
            for _, inv in ipairs(held) do Inventory.RecoverGathering(inv) end
        end
    end)
end
