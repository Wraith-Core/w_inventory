-- Framework-native offline operations for w_lib. Never write a second JSON
-- inventory to VORP characters, or edit a connected player's stale DB snapshot.
local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
local db = require 'modules.mysql.server'
local NativeVorp = shared.framework == 'vorp' and require 'modules.mysql.vorp'
local Catalog = require 'modules.items.catalog'
local function online(owner)
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.player and tostring(inv.owner) == tostring(owner) then return inv end
    end
end
local function publicRows(rows)
    local items, weapons = {}, {}
    for _, row in pairs(rows) do
        local item = assert(Items(row.name), 'Unknown native item: ' .. tostring(row.name))
        if not item.nativeCurrency and not item.nativeGunbelt and row.name ~= 'money' and row.name ~= 'gold' then
            local metadata = Catalog.copy(row.metadata or {})
            local native = metadata._vorp
            local id = native and native.id or row.slot
            local data = { name = item.nativeName or item.name, count = row.count, amount = row.count,
                id = id, itemId = id, slot = row.slot, label = metadata.label or item.label,
                weight = item.weight, metadata = metadata, info = metadata, type = item.weapon and 'weapon' or 'item' }
            if item.weapon then
                data.serial_number = metadata.serie or metadata.serial or ''
                data.ammo = NativeVorp and NativeVorp.weaponAmmo(row) or metadata.ammo or 0
                data.components = NativeVorp and NativeVorp.weaponComponents(row) or metadata.components or {}
                weapons[#weapons + 1] = data
            else items[#items + 1] = data end
        end
    end
    return items, weapons
end
exports('GetNativeStorage', function()
    return (shared.framework == 'vorp' or shared.framework == 'rsg') and shared.framework or nil
end)
exports('GetNativeOfflineInventory', function(owner)
    local inv = online(owner)
    if inv then return publicRows(inv.items) end
    return publicRows(db.loadPlayer(owner) or {})
end)
local function sameMetadata(a, b)
    local left, right = Catalog.copy(a or {}), Catalog.copy(b or {})
    if left._vorp and right._vorp then
        for _, key in ipairs({ 'degradation', 'durability', 'percentage' }) do
            if left._vorp[key] ~= right._vorp[key] then return false end
        end
    end
    left._vorp, right._vorp, left._w_rsg, right._w_rsg = nil, nil, nil, nil
    return table.matches(left, right)
end
local function mutate(owner, action, name, count, id, ammo)
    owner = tostring(owner)
    if online(owner) or server.nativeLoadingOwners[owner] then return false, 'Character is online; use the online inventory API' end
    while server.nativeOfflineLocks[owner] do Wait(0) end
    server.nativeOfflineLocks[owner] = true
    local ok, result, reason = xpcall(function()
        if online(owner) or server.nativeLoadingOwners[owner] then return false, 'Character is loading' end
        if not db.playerExists(owner) then return false, 'Character not found' end
        -- the row read here is the one written below: a character w_core moves to another number
        -- meanwhile (its number handed on) must not have its edit land on the next holder
        local rowId = db.playerRowId(owner)
        local rows = db.loadPlayer(owner) or {}
        local item = name and Items(name)
        if action == 'add' then
            if not item or item.nativeSource ~= (shared.backend == 'wcore' and 'wcore' or shared.framework) or item.nativeCurrency or item.nativeGunbelt then return false, 'Invalid native item' end
            count = tonumber(count) or 1
            if count ~= count or count < 1 or count % 1 ~= 0 then return false, 'Invalid quantity' end
            local slots = {}
            for _, row in pairs(rows) do slots[row.slot] = true end
            local separate = not item.stack or item.weapon
            for _ = 1, separate and count or 1 do
                local slot = 1
                while slots[slot] do slot = slot + 1 end
                local metadata = {}
                if NativeVorp and item.weapon and type(ammo) == 'table' then
                    local ammoType = item.ammoType
                    local loaded = math.min(500, tonumber(ammoType and ammo[ammoType]) or 0)
                    metadata = { ammo = loaded, _vorp = { kind = 'weapon', ammo = Catalog.copy(ammo),
                        activeAmmo = ammoType, loadedAmmo = loaded, components = {} } }
                end
                metadata = Items.Metadata({ id = 'offline:' .. owner, label = owner, player = {} }, item, metadata, separate and 1 or count)
                local merged = false
                if not separate then
                    for _, row in pairs(rows) do
                        if row.name:lower() == item.name:lower() and sameMetadata(row.metadata, metadata) then
                            row.count = row.count + count; merged = true; break
                        end
                    end
                end
                if not merged then
                    rows[#rows + 1] = { name = item.name, count = separate and 1 or count, slot = slot, metadata = metadata }
                    slots[slot] = true
                end
            end
        elseif action == 'remove' then
            count = tonumber(count) or 1
            if count ~= count or count < 1 or count % 1 ~= 0 then return false, 'Invalid quantity' end
            local matches, available = {}, 0
            for index, row in pairs(rows) do
                local definition = Items(row.name)
                local native = row.metadata and row.metadata._vorp
                local rowId = native and native.id or row.slot
                if definition and (not item or row.name:lower() == item.name:lower())
                    and (id == nil or definition.weapon and tostring(rowId) == tostring(id)) then
                    matches[#matches + 1] = { index = index, row = row }; available = available + row.count
                end
            end
            if (not item and id == nil) or available < count then return false, 'Item not found' end
            for _, match in ipairs(matches) do
                local take = math.min(count, match.row.count)
                match.row.count = match.row.count - take; count = count - take
                if match.row.count == 0 then rows[match.index] = nil end
                if count == 0 then break end
            end
        elseif action == 'clear' then
            -- /clearinv on an offline character. Cash and gunbelt ammo rows only mirror a
            -- core-owned account (the money is not the bag's to wipe): they stay.
            local kept = {}
            for _, row in pairs(rows) do
                local definition = Items(row.name)
                if row.name == 'money' or row.name == 'gold'
                    or definition and (definition.nativeCurrency or definition.nativeGunbelt) then
                    kept[#kept + 1] = row
                end
            end
            rows = kept
        else return false, 'Invalid operation' end
        if online(owner) then return false, 'Character is online' end
        return db.savePlayer(owner, json.encode(rows), nil, rowId) == true
    end, debug.traceback)
    server.nativeOfflineLocks[owner] = nil
    if not ok then return false, result end
    return result, reason
end
-- action: 'add' (name, count), 'remove' (name, count, weapon id) or 'clear' (every item row)
exports('MutateNativeOfflineInventory', mutate)
return true
