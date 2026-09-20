-- Selective debt custody. Only the central bank can appraise/seize belongings;
-- police custody is a different namespace and cannot return these assets.
local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
local db = require 'modules.mysql.server'
local Codec = shared.framework == 'rsg' and require 'modules.mysql.rsg' or nil
local central, ready, vehicleLocks, unknownCustody = 'w_centralbank', false, {}, {}
local function allowed() return GetInvokingResource() == central end
local function finite(value) return type(value) == 'number' and value == value and value ~= math.huge and value ~= -math.huge end
local function clone(value) return json.decode(json.encode(value)) end
local function canonical(value)
    if type(value) ~= 'table' then return json.encode(value) end
    local keys, out = {}, {}
    for key in pairs(value) do keys[#keys + 1] = key end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    for _, key in ipairs(keys) do out[#out + 1] = canonical(key) .. ':' .. canonical(value[key]) end
    return '{' .. table.concat(out, ',') .. '}'
end
local function version(row)
    local text = canonical({ name = row.name, count = row.count, slot = row.slot, metadata = row.metadata or {} })
    local hash = 0xcbf29ce484222325
    for i = 1, #text do hash = (hash ~ text:byte(i)) * 0x100000001b3 end
    return ('%016x'):format(hash)
end
local function eligible(row)
    local item = Items(row.name)
    return item and not item.nativeCurrency and not item.nativeGunbelt
        and row.name ~= 'money' and row.name ~= 'cash' and row.name ~= 'gold'
        and row.name ~= 'moneybag' and row.name ~= 'dirty_money' and row.name ~= 'bloodmoney'
        and not ((row.metadata or {}).economyClaim)
        and not ((row.metadata or {}).container)
end
local function live(owner)
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.player and tostring(inv.owner) == owner then return inv end
    end
end
local function appraisals(value)
    return type(value) == 'table' and (value.itemValues or value) or {}
end
local function positiveId(value)
    value = tostring(value or '')
    if value == '' or #value > 57 or not value:match('^[%w_%-:]+$') then return nil end
    return value
end
local function publishCustody(inv, rows)
    if not inv then return end
    local changed, bySlot = {}, {}
    for oldSlot in pairs(inv.items) do changed[#changed + 1] = { item = { slot = oldSlot }, inventory = inv.id } end
    for _, row in pairs(rows) do bySlot[row.slot] = row; changed[#changed + 1] = { item = row, inventory = inv.id } end
    inv.items, inv.weight, inv.changed = bySlot, Inventory.CalculateWeight(bySlot), false
    Inventory.SetWeaponUsageState(inv, {}, false, true)
    inv:syncSlotsWithClients(changed, true)
    if server.syncInventory then server.syncInventory(inv) end
end
local function custodyReceipt(owner, caseId, assetId)
    local observed, receipt = false, nil
    -- Some installed oxmysql versions return from startTransaction before
    -- their queued COMMIT finishes. A fresh transaction must acquire the same
    -- source-row lock before its current receipt read can prove the outcome.
    -- This transaction only reads, so its own eventual commit is not evidence.
    pcall(MySQL.startTransaction, function(query)
        local player = query('SELECT citizenid FROM players WHERE citizenid = ? FOR UPDATE', { owner })
        assert(player and player[1], 'Character missing during custody verification')
        local receipts = query('SELECT quantity FROM w_inventory_debt_custody WHERE case_id = ? AND citizenid = ? AND asset_id = ? FOR UPDATE', { caseId, owner, assetId })
        assert(type(receipts) == 'table', 'Custody receipt read unavailable')
        receipt, observed = receipts[1], true
        return true
    end)
    if not observed then error('Custody commit could not be verified') end
    return receipt
end
CreateThread(function()
    MySQL.ready.await()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS w_inventory_debt_custody (
        case_id VARCHAR(57) NOT NULL, citizenid VARCHAR(64) NOT NULL,
        asset_id VARCHAR(96) NOT NULL, quantity INT NOT NULL,
        escrow_owner VARCHAR(64) NOT NULL, snapshot LONGTEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (case_id, citizenid, asset_id, quantity)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    ready = true
end)
exports('ListDebtAssets', function(citizenid, appraisal)
    if not allowed() then return nil, 'forbidden' end
    if not ready or not shared.ready or not Codec then return nil, 'inventory_unavailable' end
    local owner = tostring(citizenid or '')
    if server.nativeOfflineLocks[owner] or server.nativeLoadingOwners[owner] then return nil, 'inventory_busy' end
    local inv = live(owner)
    if inv and (inv.nativeTransfer or Inventory.HasForeignSlotTransfer(inv)) then return nil, 'inventory_busy' end
    local rows, values, out = inv and inv.items or db.loadPlayer(owner) or {}, appraisals(appraisal), {}
    for _, row in pairs(rows) do
        local unit = tonumber(values[row.name])
        if eligible(row) and finite(unit) and unit > 0 and tonumber(row.count) and row.count > 0 then
            unit = math.floor(unit * 100 + 0.5) / 100
            local fingerprint = version(row)
            out[#out + 1] = { id = ('slot:%s:%s'):format(row.slot, fingerprint), kind = 'inventory',
                label = row.label or Items(row.name).label or row.name, value = unit * row.count,
                unitValue = unit, count = row.count, version = fingerprint }
        end
    end
    table.sort(out, function(a, b) return a.id < b.id end)
    return out
end)
exports('SeizeDebtAsset', function(citizenid, request, caseId)
    if not allowed() then return false, 'forbidden' end
    if not ready or not shared.ready or not Codec then return false, 'inventory_unavailable' end
    caseId = positiveId(caseId)
    local owner = tostring(citizenid or '')
    local assetId = type(request) == 'table' and request.id or request
    local slot, expected
    if type(assetId) == 'string' then slot, expected = assetId:match('^slot:(%d+):(%x+)$') end
    slot = tonumber(slot)
    if not caseId or not slot or not expected then return false, 'invalid_asset' end
    local recovery = unknownCustody[owner]
    if recovery and (recovery.caseId ~= caseId or recovery.assetId ~= assetId) then return false, 'inventory_busy' end
    if not recovery and server.nativeOfflineLocks[owner] or server.nativeLoadingOwners[owner] then return false, 'inventory_busy' end
    local inv = live(owner)
    if inv and ((inv.nativeTransfer and not recovery) or Inventory.HasForeignSlotTransfer(inv)) then return false, 'inventory_busy' end
    server.nativeOfflineLocks[owner] = true
    if inv then
        inv.nativeTransfer = coroutine.running()
        Inventory.CloseAll(inv)
        inv:closeInventory()
    end
    local uncertain = recovery ~= nil
    local ok, result, reason = xpcall(function()
        local quantity = type(request) == 'table' and tonumber(request.count) or nil
        if quantity and (not finite(quantity) or quantity < 1 or quantity % 1 ~= 0) then return false, 'invalid_quantity' end
        -- On restart, consult the durable receipt before requiring the old slot.
        local receipt = custodyReceipt(owner, caseId, assetId)
        if receipt then
            if recovery then publishCustody(inv, db.loadPlayer(owner) or {}) end
            uncertain, unknownCustody[owner] = false, nil
            return quantity == nil or quantity == tonumber(receipt.quantity), 'already_in_custody'
        end
        if recovery then
            uncertain, unknownCustody[owner] = false, nil
            return false, 'custody_commit_failed'
        end
        if inv and not Inventory.Save(inv) then return false, 'save_failed' end
        if not inv and (live(owner) or server.nativeLoadingOwners[owner]) then return false, 'inventory_busy' end
        local rows = clone(inv and inv.items or db.loadPlayer(owner) or {})
        local target, index
        for key, row in pairs(rows) do if tonumber(row.slot) == slot then target, index = row, key; break end end
        if not target or not eligible(target) or version(target) ~= expected then return false, 'asset_changed' end
        quantity = quantity or target.count
        if quantity > target.count then return false, 'asset_changed' end
        local seized = clone(target)
        seized.count = quantity
        target.count = target.count - quantity
        if target.count == 0 then rows[index] = nil end
        local escrow = 'escrow:' .. caseId
        local stashKey = '__w_debt:' .. owner .. ':' .. escrow
        local encoded = Codec.encode(rows)
        uncertain = true
        pcall(MySQL.startTransaction, function(query)
            local player = query('SELECT citizenid FROM players WHERE citizenid = ? FOR UPDATE', { owner })
            assert(player and player[1], 'Character missing')
            local existing = query('SELECT items FROM inventories WHERE identifier = ? FOR UPDATE', { stashKey })
            local stash = Codec.decode(existing and existing[1] and existing[1].items or nil)
            local used = {}
            for _, row in pairs(stash) do used[row.slot] = true end
            seized.slot = 1
            while used[seized.slot] do seized.slot = seized.slot + 1 end
            stash[#stash + 1] = seized
            query('UPDATE players SET inventory = ? WHERE citizenid = ?', { encoded, owner })
            query('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = VALUES(items)', { stashKey, Codec.encode(stash) })
            query('INSERT INTO w_inventory_debt_custody (case_id, citizenid, asset_id, quantity, escrow_owner, snapshot) VALUES (?, ?, ?, ?, ?, ?)',
                { caseId, owner, assetId, quantity, escrow, json.encode(seized) })
            return true
        end)
        local recorded = custodyReceipt(owner, caseId, assetId)
        if not recorded or tonumber(recorded.quantity) ~= quantity then
            uncertain = false
            return false, 'custody_commit_failed'
        end
        publishCustody(inv, rows)
        uncertain = false
        return true
    end, debug.traceback)
    if uncertain then
        unknownCustody[owner] = { caseId = caseId, assetId = assetId }
        if inv then inv.nativeTransfer = 'debt_unknown:' .. caseId end
    else
        if inv then inv.nativeTransfer = nil end
        server.nativeOfflineLocks[owner] = nil
    end
    if not ok then print('[w_inventory] debt custody: ' .. tostring(result)); return false, 'custody_failed' end
    return result, reason
end)

-- The horse row retains its containers. Freeze loaded storage across an owner
-- transfer so a previous owner cannot move goods or overwrite the saved row.
local function vehicleInventories(id)
    local out = {}
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if (inv.type == 'glovebox' or inv.type == 'trunk') and tostring(inv.dbId) == tostring(id)
            or inv.type == 'stash' and tostring(inv.dbId) == 'horse_' .. tostring(id) then out[#out + 1] = inv end
    end
    return out
end
exports('BeginDebtAssetStorage', function(id, caseId)
    if GetInvokingResource() ~= 'w_stables' then return false, 'forbidden' end
    id = tonumber(id)
    if not id or vehicleLocks[id] then return false, 'inventory_busy' end
    local inventories = vehicleInventories(id)
    for _, inv in ipairs(inventories) do
        if inv.nativeTransfer or Inventory.HasForeignSlotTransfer(inv) then return false, 'inventory_busy' end
    end
    local token = 'debt:' .. tostring(caseId) .. ':' .. id
    vehicleLocks[id] = { token = token, inventories = inventories }
    local ok, err = pcall(function()
        for _, inv in ipairs(inventories) do inv.nativeTransfer = coroutine.running(); Inventory.CloseAll(inv) end
        for _, inv in ipairs(inventories) do assert(Inventory.Save(inv), 'save_failed') end
        for _, inv in ipairs(inventories) do inv.nativeTransfer = token end
    end)
    if not ok then
        for _, inv in ipairs(inventories) do inv.nativeTransfer = nil end
        vehicleLocks[id] = nil
        return false, tostring(err)
    end
    return token
end)
exports('FinishDebtAssetStorage', function(id, token, committed)
    if GetInvokingResource() ~= 'w_stables' then return false end
    id = tonumber(id)
    local lock = vehicleLocks[id]
    if not lock or lock.token ~= token then return false end
    for _, inv in ipairs(lock.inventories) do
        inv.nativeTransfer = nil
        if committed then Inventory.CloseAll(inv); Inventory.Remove(inv) end
    end
    vehicleLocks[id] = nil
    return true
end)
local function debtStorage(id, token)
    if not Codec then return nil, 'inventory_unavailable' end
    local loaded, contents = {}, {}
    for _, inv in ipairs(vehicleInventories(id)) do
        if inv.nativeTransfer and inv.nativeTransfer ~= token or Inventory.HasForeignSlotTransfer(inv) then return nil, 'inventory_busy' end
        local name = inv.type == 'stash' and 'horse_stash' or inv.type
        loaded[name], contents[name] = true, inv.items
    end
    local row = MySQL.single.await('SELECT glovebox, trunk FROM stables WHERE id = ?', { id })
    if not row then return nil, 'invalid_asset' end
    for _, column in ipairs({ 'glovebox', 'trunk' }) do
        if not loaded[column] then contents[column] = Codec.decode(row[column]) end
    end
    if not loaded.horse_stash then
        local stash = db.loadStash('', 'horse_' .. id)
        contents.horse_stash = stash and json.decode(stash) or {}
    end
    -- Offline storage may still contain an old cash display row after central
    -- collection. It is no longer an asset when its authoritative account is zero.
    for name, rows in pairs(contents) do
        local clean = {}
        for _, item in pairs(rows) do
            if item.name == 'money' or item.name == 'cash' then
                local account = name == 'horse_stash' and ('inventory:stash:horse_' .. id .. ':cash')
                    or ('inventory:' .. name .. ':' .. id .. ':cash')
                local ok, balance = pcall(function()
                    return exports[central]:IsReady() and exports[central]:GetBalance(account)
                end)
                if not ok or balance ~= 0 then return nil, 'unsettled_horse_cash' end
            else clean[#clean + 1] = item end
        end
        contents[name] = clean
    end
    local fingerprint = {}
    for name, rows in pairs(contents) do
        local normalized = {}
        for _, item in pairs(rows) do normalized[tostring(item.slot)] = version(item) end
        fingerprint[name] = normalized
    end
    return contents, version({ name = 'horse_storage', slot = tonumber(id), count = 1, metadata = fingerprint })
end
exports('DebtAssetStorageVersion', function(id, token)
    if GetInvokingResource() ~= 'w_stables' then return nil, 'forbidden' end
    local contents, fingerprint = debtStorage(id, token)
    return contents and fingerprint or nil, not contents and fingerprint or nil
end)
exports('DebtAssetStorageValue', function(id, appraisal)
    if GetInvokingResource() ~= 'w_stables' then return nil, 'forbidden' end
    local contents, fingerprint = debtStorage(id)
    if not contents then return nil, fingerprint end
    local values, total = appraisals(appraisal), 0
    for _, rows in pairs(contents) do
        for _, row in pairs(rows) do
            local unit = tonumber(values[row.name])
            if not eligible(row) or not finite(unit) or unit < 0 then return nil, 'unappraised_horse_storage' end
            total = total + unit * row.count
        end
    end
    return math.floor(total * 100 + 0.5) / 100, fingerprint
end)
