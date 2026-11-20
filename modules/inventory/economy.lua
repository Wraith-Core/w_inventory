-- Currency rows are projections. Every physical transfer has two ledger accounts.
return function(Inventory, Inventories, Items)
    local function ready()
        local okN, name = pcall(function() return exports.w_lib:EconName() end)
        if not okN or name ~= 'w_centralbank' then return false end
        local okR, r = pcall(function() return exports.w_lib:EconIsReady() end)
        return okR and r == true
    end
    function Inventory.CashAccount(inv)
        if not inv then return nil end
        if inv.type == 'player' then return 'player:' .. tostring(inv.owner) .. ':cash' end
        local kind = inv.type == 'trunk' and 'trunk' or inv.type == 'glovebox' and 'glovebox'
            or inv.type == 'drop' and 'drop' or inv.type == 'temp' and 'temp' or 'stash'
        local key = tostring(inv.dbId or inv.id)
        if kind == 'stash' and inv.owner and type(inv.owner) ~= 'boolean' then key = key .. ':' .. tostring(inv.owner) end
        return 'inventory:' .. kind .. ':' .. key .. ':cash'
    end
    function Inventory.SyncBearerCash(inv)
        if not ready() then return end
        local owner = type(inv.owner) == 'string' and inv.owner or ''
        for _, row in pairs(inv.items or {}) do
            local meta = row.metadata or row.info
            local claim = row.name == 'moneybag' and type(meta) == 'table' and meta.economyClaim
            if type(claim) == 'string' and claim:match('^moneybag:%x+:cash$') then
                local stableId = (inv.type == 'glovebox' or inv.type == 'trunk') and (inv.dbId or inv.id)
                    or tostring(inv.dbId or inv.id):match('^horse_(%d+)$')
                if stableId then
                    local ok, value = pcall(MySQL.scalar.await, 'SELECT charidentifier FROM stables WHERE id = ?', {stableId})
                    if not ok or not value then return end
                    owner = tostring(value)
                end
                exports.w_lib:EconSetAccountOwner(claim, owner)
            end
        end
    end
    local function account(inv)
        if not ready() then return nil end
        local id = Inventory.CashAccount(inv)
        if inv.type ~= 'player' then
            local owner = type(inv.owner) == 'string' and inv.owner or nil
            local stableId = (inv.type == 'glovebox' or inv.type == 'trunk') and (inv.dbId or inv.id)
                or tostring(inv.dbId or inv.id):match('^horse_(%d+)$')
            if stableId then
                local ok, value = pcall(MySQL.scalar.await, 'SELECT charidentifier FROM stables WHERE id = ?', {stableId})
                if not ok or not value then return nil end
                owner = tostring(value)
            end
            if not exports.w_lib:EconEnsureAccount(id, owner, 'inventory') then return nil end
            if owner and not exports.w_lib:EconSetAccountOwner(id, owner) then return nil end
        end
        return id
    end
    function Inventory.ReflectCash(inv)
        inv = Inventory(inv)
        local id = inv and account(inv)
        if not id then return false end
        local value = exports.w_lib:EconGetBalance(id)
        if value == nil then return false end
        local updates, slot = {}, nil
        for index, row in pairs(inv.items) do
            if row.name == 'money' or row.name == 'cash' then
                slot = slot or index
                inv.items[index] = nil
                updates[#updates + 1] = {item={slot=index}, inventory=inv.id}
            end
        end
        if value > 0 then
            if not slot then
                slot = 1
                while inv.items[slot] do slot = slot + 1 end
            end
            if slot > inv.slots then Inventory.SetSlotCount(inv, slot) end
            local item = Items('money')
            local row = {name='money', label=item.label, count=value, slot=slot, metadata={}, stack=true, close=item.close}
            row.weight = Inventory.SlotWeight(item, row)
            inv.items[slot] = row
            updates[#updates + 1] = {item=row, inventory=inv.id}
        end
        inv.nativeCashObserved = value
        inv.weight = Inventory.CalculateWeight(inv.items)
        if inv.changed ~= nil then inv.changed = true end
        inv:syncSlotsWithClients(updates, true)
        return true
    end
    function Inventory.ChangeCash(inv, amount)
        inv = Inventory(inv)
        amount = tonumber(amount)
        local id = inv and account(inv)
        if not id or not amount or amount ~= amount or amount == math.huge or amount == -math.huge then return false, 'economy_unavailable' end
        local ok, reason = exports.w_lib:EconAdjustAccount(id, amount, 'inventory-currency')
        if ok then Inventory.ReflectCash(inv) end
        return ok, reason
    end
    function Inventory.TransferCash(from, to, amount)
        local a, b = account(from), account(to)
        if not a or not b then return false, 'economy_unavailable' end
        local ok, reason = exports.w_lib:EconTransfer(a, b, amount, 'physical-cash-transfer')
        if ok then Inventory.ReflectCash(from); Inventory.ReflectCash(to) end
        return ok, reason
    end
    function Inventory.ReclaimCash(inv)
        local id = account(inv)
        if not id then return false end
        local amount = exports.w_lib:EconGetBalance(id)
        if amount == nil then return false end
        local moves, seen = {}, {}
        if amount > 0 then moves[#moves+1] = {from=id,to='central:reserve',amount=amount} end
        for _, row in pairs(inv.items or {}) do
            local meta = row.metadata or row.info
            local claim = row.name == 'moneybag' and type(meta) == 'table' and meta.economyClaim
            if type(claim) == 'string' and claim:match('^moneybag:%x+:cash$') and not seen[claim] then
                local held = exports.w_lib:EconGetBalance(claim)
                if held and held > 0 then moves[#moves+1] = {from=claim,to='central:reserve',amount=held} end
                seen[claim] = true
            end
        end
        if #moves==0 then return true end
        local ok = exports.w_lib:EconTransferMany(moves, 'expired-physical-cash')
        if ok then Inventory.ReflectCash(inv) end
        return ok == true
    end
    exports.w_lib:EconOnBalanceChanged(function(id)
        for _, inv in pairs(Inventories) do
            if Inventory.CashAccount(inv) == id then Inventory.ReflectCash(inv) end
        end
    end)
end
