local Inventory = require 'modules.inventory.client'
local Weapon = require 'modules.weapon.client'

-- ============================================================
-- The player leaving or switching character
-- ============================================================
RegisterNetEvent('vorp_core:Client:playerLeave', client.onLogout)

-- ============================================================
-- The player's status (hunger and thirst)
--
-- ! VORP runs the whole metabolism inside vorp_metabolism with its own system, and exposes
-- no event and no export to change the hunger and the thirst from outside - I searched and found none.
--
-- And this does no practical harm: food items in VORP are registered through
-- registerUsableItem and it takes care of their metabolism itself. The status field in the bag's own items
-- belongs to items native to the bag that do not exist here.
--
-- So if you add food items in the bag's own form, connect this function to your system.
-- ============================================================
---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values) end

AddStateBagChangeHandler('inv_busy', ('player:%s'):format(cache.serverId), function(_, _, value)
    LocalPlayer.state:set('invBusy', value, false)
end)

-- ============================================================
-- Releasing the bag after the player is set up
--
-- ! The bag sets invBusy = true when the client loads (client.lua:48)
-- and blocks opening as long as it is so (client.lua:59). The RSG bridge turns it off in the
-- SetPlayerData handler, and there is no counterpart to that in VORP - so the bag stayed locked forever.
-- ============================================================
RegisterNetEvent('w_inventory:setPlayerInventory', function()
    LocalPlayer.state:set('invBusy', false, false)
    LocalPlayer.state:set('canUseWeapons', true, false)
end)

RegisterNetEvent('w_inventory:clearAllAmmo', function()
    local catalog = lib.load('data.ammo_types_RDR3')

    for _, entries in pairs(catalog.Families) do
        for i = 1, #entries do
            SetPedAmmoByType(cache.ped, joaat(entries[i].ammo), 0)
        end
    end
end)

-- ============================================================
-- Blocking the bag from opening
-- ! This is an event and not an export - vorp_crawfish and others call it with:
--     TriggerClientEvent('vorp_inventory:blockInventory', src, true)
-- ============================================================
RegisterNetEvent('vorp_inventory:blockInventory', function(state)
    LocalPlayer.state:set('invBusy', state == true, false)

    -- Closing is safe even if it is already closed, so no prior check is needed
    if state then
        exports.w_inventory:closeInventory()
    end
end)

-- ============================================================
-- Blocking the bag while eating and drinking
--
-- vorp_metabolism plays a consumption animation of up to ~7 seconds
-- (useItemsActions.lua: Wait(1000) + TaskPlayAnim(5000) + Wait)
-- and fires no event when it ends, so we block the bag for the whole duration.
--
-- The duration is adjustable: setr inventory:consumetime 7000
-- ============================================================
local consumeTime = GetConvarInt('inventory:consumetime', 7000)
local consumeUntil = 0

RegisterNetEvent('vorpmetabolism:useItem', function()
    exports.w_inventory:closeInventory()
    LocalPlayer.state:set('invBusy', true, false)

    local finishAt = GetGameTimer() + consumeTime
    consumeUntil = finishAt

    CreateThread(function()
        Wait(consumeTime)

        -- Another consumption started after us? Let it be the one that releases the bag
        if consumeUntil ~= finishAt then return end

        LocalPlayer.state:set('invBusy', false, false)
    end)
end)

-- ============================================================
-- Compatibility with scripts that call vorp_inventory's exports on the client
-- ============================================================
local function export(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(string.strsplit('.', exportName, 2)), function(setCB)
        setCB(func or function()
            error(("export '%s' is not supported when using w_inventory"):format(exportName))
        end)
    end)
end

export('vorp_inventory.getItemCount', function(itemName)
    return Inventory.GetItemCount(itemName)
end)

--- ! The bag has no IsInventoryOpen export, but the state is available
export('vorp_inventory.isInventoryOpen', function()
    return LocalPlayer.state.invOpen == true
end)


-- ============================================================
-- Impersonating vorp_inventory's client exports
--
-- The real bag exports 10 functions on the client side, and encrypted scripts
-- may call them there where a text scan sees nothing. We cover the whole contract.
-- ============================================================
local Items = require 'modules.items.client'
local AmmoTypes = lib.load('data.ammo_types_RDR3')

local function export(name, fn)
    AddEventHandler(('__cfx_export_vorp_inventory_%s'):format(name), function(setCB)
        setCB(fn)
    end)
end

--- A callback that crosses a resource boundary arrives as a funcref (a table with __call),
--- never as a Lua function; both shapes have to be accepted or the VORP-style export
--- callbacks fired by other resources never run.
local function isCallable(value)
    local valueType = type(value)

    if valueType == 'function' then return true end

    return valueType == 'table' and (rawget(value, '__cfx_functionReference') ~= nil
        or (getmetatable(value) and getmetatable(value).__call ~= nil))
end

local function respond(cb, ...)
    if isCallable(cb) then cb(...) end
    return ...
end

export('closeInventory', function()
    return exports.w_inventory:closeInventory()
end)

export('setHotbarVisible', function(visible)
    SendNUIMessage({ action = 'setHotbarVisible', visible = visible == true })
    return true
end)

local function toVorpItem(slotData)
    if type(slotData) ~= 'table' or not slotData.name then return false end

    local item = Items[slotData.name]
    if not item or item.weapon then return false end

    local metadata = type(slotData.metadata) == 'table' and slotData.metadata or {}

    return {
        id = metadata._vorp and metadata._vorp.id,
        slot = slotData.slot,
        item_crafted_id = metadata._vorp and metadata._vorp.id,
        name = slotData.name,
        label = metadata.label or slotData.label or item.label,
        count = tonumber(slotData.count) or 0,
        amount = tonumber(slotData.count) or 0,
        limit = item.limit or -1,
        weight = (tonumber(item.weight) or 0) / 1000,
        metadata = (function() local value = table.clone(metadata); value._vorp = metadata._vorp and metadata._vorp.originalEnvelope; return value end)(),
        desc = metadata.description or item.description or '',
        degradation = metadata.degradation or 0,
        maxDegradation = item.degrade or 0,
        durability = metadata.durability or 100,
    }
end

--- Every one of the player's items as an array
export('getInventoryItems', function(cb)
    local out = {}

    if PlayerData and PlayerData.inventory then
        for _, slotData in pairs(PlayerData.inventory) do
            local item = toVorpItem(slotData)
            if item then out[#out + 1] = item end
        end
    end

    return respond(cb, next(out) and out or false)
end)

--- One item by name (the first slot that matches it)
export('getInventoryItem', function(itemName, cb)
    if PlayerData and PlayerData.inventory then
        for _, slotData in pairs(PlayerData.inventory) do
            if slotData and slotData.name == itemName then
                return respond(cb, toVorpItem(slotData))
            end
        end
    end

    return respond(cb, false)
end)

export('getServerItem', function(data, cb)
    if type(data) == 'string' then
        return respond(cb, Items[data] or false)
    end

    if type(data) == 'table' then
        local out = {}

        for _, name in ipairs(data) do
            if Items[name] then out[#out + 1] = Items[name] end
        end

        return respond(cb, out)
    end

    return respond(cb, false)
end)

local function ammoLabel(entry)
    if shared.localeKey() == 'ar' then return entry.label end
    return entry.label_en or entry.label
end

--- Labelling a bullet type (AMMO_X -> its shown name) from our catalogue
export('getAmmoLabel', function(ammoType, cb)
    for _, entries in pairs(AmmoTypes.Families) do
        for i = 1, #entries do
            if entries[i].ammo == ammoType or (type(ammoType) == 'number' and joaat(entries[i].ammo) == ammoType) then
                return respond(cb, ammoLabel(entries[i]))
            end
        end
    end

    return respond(cb, ammoType)
end)

local hashToName

local function buildWeaponIndex()
    if hashToName then return end
    hashToName = {}

    for name, data in pairs(Items) do
        if data.weapon then
            hashToName[tonumber(data.hash) or joaat(name)] = name
            hashToName[joaat(name)] = name
        end
    end
end

local function resolveWeapon(value)
    if type(value) == 'table' then value = value.name or value.hash or value.HashName end

    if type(value) == 'string' then
        local named = Items[value] or Items[value:upper()]
        if named and named.weapon then return named, named.name or value:upper() end

        value = tonumber(value)
    end

    if type(value) == 'number' then
        buildWeaponIndex()
        local name = hashToName[value]
        if name then return Items[name], name end
    end
end

local function resolveAmmoFamily(value)
    if type(value) == 'string' and AmmoTypes.Families[value] then return value end

    local data = resolveWeapon(value)
    if data and data.ammoFamily then return data.ammoFamily end

    if type(value) == 'string' then
        local groupFamily = value:lower():gsub('^group_', 'ammo_')
        if AmmoTypes.Families[groupFamily] then return groupFamily end

        for family, entries in pairs(AmmoTypes.Families) do
            for i = 1, #entries do
                if entries[i].ammo == value then return family end
            end
        end
    end
end

--- The bullet types a family or a weapon accepts
export('getWeaponAmmoTypes', function(groupOrWeapon, cb)
    local family = resolveAmmoFamily(groupOrWeapon)
    local out = {}

    if family and AmmoTypes.Families[family] then
        for _, entry in ipairs(AmmoTypes.Families[family]) do
            out[#out + 1] = entry.ammo
        end
    else
        local data = resolveWeapon(groupOrWeapon)
        if data and data.ammoType then out[1] = data.ammoType end
    end

    return respond(cb, out)
end)

--- A catalogue of a weapon's ammunition options (for the bullet switcher in the weapon wheel): for every variant
--- { ammo = the game's type, label = the shown name, items = the items' names }.
--- Checking ownership and applying it happen in the consumer through the bag's standard exports.
local function getWeaponAmmoOptions(weaponName, cb)
    local family = resolveAmmoFamily(weaponName)
    local out = {}

    if family and AmmoTypes.Families[family] then
        for _, entry in ipairs(AmmoTypes.Families[family]) do
            out[#out + 1] = { ammo = entry.ammo, label = ammoLabel(entry), items = entry.items }
        end
    end

    return respond(cb, out)
end

-- Native VORP consumers receive the compatibility alias, while our own
-- resources call the physical authority directly and never depend on an alias.
export('getWeaponAmmoOptions', getWeaponAmmoOptions)
exports('getWeaponAmmoOptions', getWeaponAmmoOptions)

export('getWeaponName', function(weaponHash, cb)
    local _, name = resolveWeapon(weaponHash)
    return respond(cb, name or weaponHash)
end)

local function weaponField(field, fallback)
    return function(weaponName, cb)
        local data = resolveWeapon(weaponName)

        return respond(cb, data and data[field] or fallback)
    end
end

export('getWeaponDefaultLabel', function(weapon, cb)
    local data = resolveWeapon(weapon)
    return respond(cb, data and data.label or weapon)
end)
export('getWeaponDefaultDesc', function(weapon, cb)
    local data = resolveWeapon(weapon)
    return respond(cb, data and data.description or weapon)
end)
export('getWeaponDefaultWeight', weaponField('weight', 0.25))

local function defaultWeaponData(name, data)
    return {
        name = name,
        HashName = name,
        hash = data.hash or joaat(name),
        label = data.label,
        Name = data.label,
        weight = data.weight,
        Weight = data.weight,
        desc = data.description or '',
        Desc = data.description or '',
        ammoname = data.ammoname,
        ammoFamily = data.ammoFamily,
        Components = data.components,
    }
end

--- The default weapons data. VORP usually passes an array of the names it wants.
export('getWeaponsDefaultData', function(request, cb)
    if isCallable(request) then cb, request = request, nil end

    local out = {}

    if type(request) == 'table' then
        for _, value in ipairs(request) do
            local data, name = resolveWeapon(value)
            if data and name then out[#out + 1] = defaultWeaponData(name, data) end
        end
    else
        for name, data in pairs(Items) do
            if data.weapon then out[#out + 1] = defaultWeaponData(name, data) end
        end
    end

    return respond(cb, out)
end)

local function resolveUseSlot(data, wantWeapon)
    local id = type(data) == 'number' and data or type(data) == 'table'
        and tonumber(data.id or data.item_crafted_id or data.weaponId)
    local explicitSlot = type(data) == 'table' and tonumber(data.slot)
    if PlayerData and PlayerData.inventory then
        for _, row in pairs(PlayerData.inventory) do
            local native = row.metadata and row.metadata._vorp
            local item = Items[row.name]
            if (id and native and tonumber(native.id) == id or not id and explicitSlot == row.slot)
                and item and (wantWeapon == nil or item.weapon == wantWeapon) then return row.slot end
        end
    end
    if id then return nil end

    local name = type(data) == 'string' and data or type(data) == 'table' and data.name
    if name and PlayerData and PlayerData.inventory then
        for _, slotData in pairs(PlayerData.inventory) do
            local item = slotData and Items[slotData.name]
            if slotData and slotData.name == name and item
                and (wantWeapon == nil or item.weapon == wantWeapon) then
                return slotData.slot
            end
        end
    end
end

export('useWeapon', function(data)
    local slot = resolveUseSlot(data, true)
    if not slot then return false end

    exports.w_inventory:useSlot(slot, true)
    return true
end)

export('useItem', function(data)
    local slot = resolveUseSlot(data, false)
    if not slot then return false end

    exports.w_inventory:useSlot(slot)
    return true
end)

RegisterNetEvent('vorpInventory:setWeaponUsed', function(weaponId, used)
    local slot = resolveUseSlot(tonumber(weaponId), true)
    if not slot then return end

    if used == true or used == 1 or used == '1' then
        exports.w_inventory:useSlot(slot, true)
    else
        TriggerEvent('w_inventory:disarmSlot', slot, true)
    end
end)


-- ============================================================
-- VORP's client events the base scripts broadcast
-- (vorp_character, the lockers, herbalist, spawnplayer in the core)
-- ============================================================
RegisterNetEvent('vorp_inventory:CloseInv', function()
    exports.w_inventory:closeInventory()
end)

RegisterNetEvent('vorp_inventory:CloseCustomInv', function()
    exports.w_inventory:closeInventory()
end)

-- ============================================================
-- The readiness and status signals VORP used to broadcast
--   vorpinventory:loaded          after the bag is set up
--   IsInvActive (statebag)        while opening and closing
--   vorp_stables:setClosedInv     third-party VORP scripts listen for it
-- ============================================================
RegisterNetEvent('w_inventory:setPlayerInventory', function()
    TriggerEvent('vorpinventory:loaded')
end)

AddStateBagChangeHandler('invOpen', ('player:%s'):format(cache.serverId), function(_, _, value)
    local isOpen = value == true

    LocalPlayer.state:set('IsInvActive', isOpen, false)
    TriggerServerEvent('w_inventory:vorp:setInventoryActive', isOpen)
    TriggerEvent('vorp_inventory:Client:OnInvStateChange', isOpen)
    TriggerEvent('vorp_stables:setClosedInv', not isOpen)
end)

-- ============================================================
-- The fishing rod: VORP clears vorp_fishing when the rod is put away
-- ============================================================
local lastHeldWeapon

AddEventHandler('w_inventory:currentWeapon', function(weapon)
    local newName = weapon and weapon.name or nil

    if lastHeldWeapon == 'WEAPON_FISHINGROD' and newName ~= 'WEAPON_FISHINGROD' then
        TriggerEvent('vorp_fishing:resetFishing')
    end

    lastHeldWeapon = newName
end)
