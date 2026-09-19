-- ============================================================
-- The vorp_inventory compatibility layer
--
-- ## How does it work?
--
-- When any script calls:
--     exports.vorp_inventory:addItem(source, 'gold', 1)
--
-- it asks the runtime: 'who provides this export?' through an event named:
--     __cfx_export_vorp_inventory_addItem
--
-- So we raise our hand and answer on vorp_inventory's behalf. The script does not know
-- and needs not one letter changed.
--
-- ! A condition: vorp_inventory must be stopped, otherwise the two of them fight.
--
-- ## The essential difference between the two interfaces
--
-- VORP uses the callback style:      addItem(src, item, n, meta, cb)
-- The bag returns directly:            AddItem(src, item, n, meta)
--
-- So every wrapper here does two things: it translates the arguments, then it delivers the result
-- both ways - it calls the callback if there is one, and it always returns the value.
-- ============================================================

local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
local NativeStore = require 'modules.mysql.vorp'
local NativeDb = require 'modules.mysql.server'
local Gunbelt = require 'modules.bridge.vorp.ammo'
local function callable(cb)
    return type(cb) == 'function' or type(cb) == 'table' and
        (rawget(cb, '__cfx_functionReference') ~= nil or getmetatable(cb) and getmetatable(cb).__call ~= nil)
end
local function nativeRow(inv, id, kind)
    inv, id = Inventory(inv), tonumber(id)
    if not inv or not id then return nil end
    for _, row in pairs(inv.items or {}) do
        local native = row.metadata and row.metadata._vorp
        if native and tonumber(native.id) == id and (not kind or native.kind == kind) then return row end
    end
end
local function nativeId(row)
    if not row then return nil end
    local native = row.metadata and row.metadata._vorp
    if native and native.id then return native.id end
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.items[row.slot] == row then
            assert(Inventory.Save(inv), 'Could not allocate native VORP item id')
            native = row.metadata and row.metadata._vorp
            return assert(native and native.id, 'Native VORP item id was not committed')
        end
    end
end
local function publicMetadata(metadata)
    local clean = table.clone(metadata or {})
    clean._vorp = metadata and metadata._vorp and metadata._vorp.originalEnvelope
    return clean
end

-- ============================================================
-- 1) The impersonation tool - copy it as it is
-- ============================================================
-- The interface table: some scripts ask for it whole through vorp_inventoryApi()
-- like vorp_stables:  local VorpInv = exports.vorp_inventory:vorp_inventoryApi()
-- then they call with the dot:   VorpInv.registerInventory(...)
local Api = {}

local function export(name, fn)
    if fn then Api[name] = fn end

    AddEventHandler(('__cfx_export_vorp_inventory_%s'):format(name), function(setCB)
        setCB(fn or function()
            error(("export 'vorp_inventory.%s' is not supported in w_inventory"):format(name))
        end)
    end)
end

-- ============================================================
-- 2) The result-delivery tool - it settles the callback difference
-- ============================================================
local function respond(cb, ...)
    if callable(cb) then cb(...) end
    return ...
end

-- Normalise an internal slot into the public item shape returned by
-- vorp_inventory v2. Keeping one formatter for every read export avoids subtle
-- breakage in VORP resources that inspect id/type/percentage instead of count.
local function itemDurabilityPercent(slot)
    local metadata = slot.metadata or {}
    local definition = Items(slot.name)
    local native = metadata._vorp
    if native and definition and (definition.maxDegradation or 0) > 0 then
        local lifetime = definition.maxDegradation * 60
        return math.max(0, math.floor((lifetime - (os.time() - (tonumber(native.degradation) or 0))) / lifetime * 100))
    end
    local durability = tonumber(metadata._vorp and metadata._vorp.percentage or metadata.durability)

    if not durability then return 100 end
    if durability <= 100 then return math.max(0, math.min(100, durability)) end

    local lifetime = (tonumber(metadata.degrade) or 0) * 60
    if lifetime <= 0 then return durability > os.time() and 100 or 0 end

    return math.max(0, math.min(100, ((durability - os.time()) / lifetime) * 100))
end

local function toVorpItem(slot)
    if type(slot) ~= 'table' or not slot.name then return nil end

    local definition = Items(slot.name)
    if not definition or definition.nativeGunbelt then return nil end

    local metadata = slot.metadata or {}
    local count = math.max(0, tonumber(slot.count) or 0)
    local durability = itemDurabilityPercent(slot)
    local hasDurability = (definition.nativeDurability or 0) > 0
    local isDegradable = (definition.maxDegradation or 0) > 0
    local totalWeight = tonumber(slot.weight)
    local unitWeight = totalWeight and count > 0 and totalWeight / count
        or tonumber(definition.weight) or 0

    return {
        id = nativeId(slot),
        mainid = nativeId(slot),
        slot = slot.slot,
        name = slot.name,
        label = metadata.label or slot.label or definition.label or slot.name,
        desc = metadata.description or definition.description,
        description = metadata.description or definition.description,
        metadata = publicMetadata(metadata),
        type = definition.weapon and 'item_weapon' or 'item_standard',
        count = count,
        limit = definition.limit or -1,
        canUse = definition.usable == true or tonumber(definition.usable) == 1,
        canRemove = definition.canRemove ~= false,
        group = definition.group or (definition.weapon and 5 or 1),
        weight = unitWeight / 1000,
        percentage = durability,
        isDegradable = isDegradable,
        maxDegradation = definition.maxDegradation or 0,
        degradation = metadata._vorp and metadata._vorp.degradation or 0,
        durability = metadata._vorp and metadata._vorp.durability or 0,
        rarity = definition.rarity, instruction = definition.instruction,
        hasDurability = hasDurability,
        maxDurability = definition.nativeDurability,
        item = slot.name,
    }
end

-- ============================================================
-- 3) The items
--
-- Notice in the first two functions how VORP's signature is read then translated.
-- The rest of the functions follow the very same pattern to the letter.
-- ============================================================

--- VORP:  addItem(source, item, amount, metadata, callback, event)
--- The bag: AddItem(inv, item, count, metadata, slot, cb)
export('addItem', function(source, item, amount, metadata, cb)
    local ok = Inventory.AddItem(source, item, amount or 1, metadata)
    return respond(cb, ok == true)
end)

--- VORP:  subItem(source, item, amount, metadata, callback, event, percentage)
--- The bag: RemoveItem(inv, item, count, metadata, slot, ignoreTotal)
export('subItem', function(source, item, amount, metadata, cb)
    local ok = Inventory.RemoveItem(source, item, amount or 1, metadata)

    if ok == true then
        -- third-party VORP scripts listen for this event to sync the consumption
        TriggerEvent('vorp_inventory:Server:OnItemRemoved',
            { name = item, count = amount or 1, metadata = metadata }, source)
    end

    return respond(cb, ok == true)
end)

--- VORP:  canCarryItem(source, item, amount, callback)
export('canCarryItem', function(source, item, amount, cb)
    local ok = Inventory.CanCarryItem(source, item, amount or 1)
    return respond(cb, ok == true)
end)

--- VORP:  getItem(source, item, callback, metadata, percentage)
--- ! The callback here is the third argument and not the fifth - always read VORP's signature before translating
export('getItem', function(source, item, cb, metadata, percentage)
    local slots = Inventory.GetSlotsWithItem(source, item, metadata, false) or {}
    local selected

    for i = 1, #slots do
        local slot = slots[i]
        local durability = itemDurabilityPercent(slot)

        if percentage == nil or (tonumber(percentage) or 0) > 0 and durability >= tonumber(percentage)
            or (tonumber(percentage) or 0) <= 0 and durability <= 0 then
            selected = slot
            break
        end
    end

    return respond(cb, toVorpItem(selected))
end)

--- VORP:  getItemCount(source, callback, item, metadata, percentage)
--- ! Old scripts (RicX and v-doctorjob) call it in the form (source, item)
---    with no callback - so we detect the form from the second argument's type
export('getItemCount', function(source, a, b, c)
    local cb, item, metadata

    if type(a) == 'string' then
        item, metadata = a, b
    else
        cb, item, metadata = a, b, c
    end

    if not item then return respond(cb, 0) end

    return respond(cb, Inventory.GetItemCount(source, item, metadata) or 0)
end)

--- VORP:  getUserInventoryItems(source, callback)
--- VORP expects an array, and the bag returns a table indexed by the slot
export('getUserInventoryItems', function(source, cb)
    local inv = Inventory(source)
    local items = {}

    if inv and inv.items then
        for _, slot in pairs(inv.items) do
            local item = type(slot) == 'table' and slot.name and Items(slot.name)
            if item and not item.weapon and slot.name ~= 'money' and slot.name ~= 'gold' then
                items[#items + 1] = toVorpItem(slot)
            end
        end
    end

    return respond(cb, items)
end)

--- VORP:  getItemDB(item, callback)
export('getItemDB', function(item, cb)
    local data = Items(item)
    if not data then return respond(cb, nil) end

    if data.nativeDefinition then return respond(cb, table.clone(data.nativeDefinition)) end
    return respond(cb, {
        item = data.name,
        label = data.label,
        weight = (data.weight or 0) / 1000,
        desc = data.description,
    })
end)

--- VORP:  getItemById(source, id, callback)
--- A VORP id is a row in the database, and the nearest counterpart we have is the slot's number
export('getItemById', function(source, id, cb)
    return respond(cb, toVorpItem(nativeRow(source, id, 'item')))
end)

--- VORP:  subItemById(source, itemId, callback, event, amount)
export('subItemById', function(source, itemId, cb, _, amount)
    local slot = nativeRow(source, itemId, 'item')
    if not slot then return respond(cb, false) end

    -- The real VORP deducts one by default - not the whole stack
    -- (vorp_metabolism would have lost the whole food stack)
    local ok = Inventory.RemoveItem(source, slot.name, amount or 1, nil, slot.slot)

    if ok == true then
        TriggerEvent('vorp_inventory:Server:OnItemRemoved',
            { name = slot.name, count = amount or 1 }, source)
    end

    return respond(cb, ok == true)
end)

--- VORP:  setItemMetadata(source, itemId, metadata, amount, callback)
export('setItemMetadata', function(source, itemId, metadata, _, cb)
    local row = nativeRow(source, itemId, 'item')
    return respond(cb, row and Inventory.SetMetadata(source, row.slot, metadata) == true or false)
end)

-- ============================================================
-- 4) The usable items
--
-- VORP registers the function with itself, and the bag calls server.UseItem.
-- So we keep a registry of our own and connect the two.
-- ============================================================
local usableItems = {}

--- VORP: registerUsableItem(item, callback, resourceName)
--- Diagnostics: we count and print one summary after the last registration, to make it clear whether
--- v-metabolism/v-hud really registered their items through our bridge
local usableDebug = GetConvarInt('inventory:usedebug', 0) == 1
local usableCount = 0
local usableSummaryScheduled = false

export('registerUsableItem', function(item, cb)
    usableItems[item] = cb

    usableCount = usableCount + 1

    if usableDebug and not usableSummaryScheduled then
        usableSummaryScheduled = true
        CreateThread(function()
            Wait(3000)
            print(('^2[vorp-compat]^7 usable items registered: %d'):format(usableCount))
        end)
    end
end)

export('unRegisterUsableItem', function(item)
    usableItems[item] = nil
end)

--- Called from the bag when an item is used - it replaces the copy in server.lua
---
--- ! The argument's shape is taken from VORP's own resources' usage and not from the documentation:
---     data.source · data.item.label · data.item.id · data.item.mainid
--- and id and mainid are both the item's id, and it is passed to subItemById,
--- so we make them the slot's number here because that is what our function understands.
---@diagnostic disable-next-line: duplicate-set-field
function server.UseItem(source, itemName, data)
    local cb = usableItems[itemName]

    if usableDebug then
        print(('^3[vorp-compat]^7 use "%s" -> %s'):format(
            itemName, cb and 'vorp handler' or '^1NO HANDLER^7'))
    end

    if not cb then return end

    local row = Inventory.GetSlot(source, data.slot)
    if not row then return end
    local data = { source = source, item = toVorpItem(row) }
    if not data.item then return end
    if data.item.isDegradable and data.item.percentage <= 0 and not (data.item.metadata.useExpired or Items(itemName).useExpired) then
        if require('modules.bridge.vorp.settings').deleteExpired then
            Inventory.RemoveItem(source, row.name, 1, nil, row.slot)
        end
        return false
    end
    TriggerEvent('vorp_inventory:Server:OnItemUse', data)
    return cb(data)
end

lib.callback.register('w_inventory:vorp:useItem', function(source, slot, name)
    local inv = Inventory(source)
    local row = inv and inv.items[tonumber(slot)]
    local item = row and Items(row.name)
    if not item or item.weapon or row.name ~= name then return false end
    local state = Player(source).state
    if state.invBusy or state.inv_busy then return false end
    return server.UseItem(source, row.name, row) ~= false
end)

-- ============================================================
-- 5) Opening and closing the bag
-- ============================================================
local customInventories

export('openInventory', function(source, invId)
    if invId then
        invId = tostring(invId)
        local config = customInventories and customInventories[invId]
        local data = invId

        if config and config.shared == false then
            local ok, charId = pcall(function()
                return exports.w_lib:FwGetCharacterIdentifier(source)
            end)

            if not ok or charId == nil then return false end
            config.owners = config.owners or {}
            config.owners[tostring(charId)] = true
            data = { id = invId, owner = tostring(charId) }
        end

        return exports.w_inventory:forceOpenInventory(source, 'stash', data)
    end
    return exports.w_inventory:forceOpenInventory(source, 'player', source)
end)

--- ! closeInventory is a client-only export of the bag, so we close from the server directly
export('closeInventory', function(source)
    local inv = Inventory(source)
    if inv then inv:closeInventory() end

    TriggerClientEvent('w_inventory:closeInventory', source, true)
    return true
end)

-- ============================================================
-- 6) The weapons
--
-- ## The structural difference
-- VORP:    a weapon is a row in the database with a permanent weaponId
-- The bag: a weapon is an item in a slot, and weapons are stack = false
--          so every piece takes its own slot
--
-- The solution: the slot's number stands in for weaponId, and the serial number
-- is kept in metadata.serial so it stays a fixed reference for the scripts.
-- ============================================================

--- A serial number in VORP's style
local function generateSerial()
    local serial = tostring(math.random(10, 99))
    for _ = 1, 8 do serial = serial .. math.random(0, 9) end
    return serial
end

local function usageFlag(value)
    return value == true or value == 1 or value == '1'
end

local function weaponAmmoTable(slot)
    return NativeStore.weaponAmmo(slot)

end

--- Converting a weapon from the bag's form to VORP's form
local function toVorpWeapon(slot, source)
    if type(slot) ~= 'table' or not slot.name then return nil end

    local meta = slot.metadata or {}
    local value = meta.used
    if value == nil then value = slot.used end
    local used = usageFlag(value)

    return {
        id = nativeId(slot),
        name = slot.name,
        ammo = weaponAmmoTable(slot),
        components = NativeStore.weaponComponents(slot),
        serial_number = meta.serial,
        custom_label = meta.custom_label,
        custom_desc = meta.custom_desc,
        label = slot.label,
        used = used,
        used2 = used and tonumber(meta.weaponHand) == 1 or false,
        source = source,
    }
end

--- VORP v2: createWeapon(source, weaponName, ammoTable, ignored, comps,
--- callback, existingWeaponId, customSerial, customLabel, customDesc, setUsed)
--- It returns weaponId
export('createWeapon', function(source, weaponName, ammo, ignored, comps, cb, weaponId,
        customSerial, customLabel, customDesc, setUsed)
    if type(weaponName) ~= 'string' then return respond(cb, false) end
    weaponName = weaponName:upper()

    if not Items(weaponName) then return respond(cb, false) end

    local definition = Items(weaponName)
    local activeAmmo = definition.ammoType
    if type(ammo) == 'table' and not activeAmmo then activeAmmo = next(ammo) end
    local ammoCount = type(ammo) == 'table' and tonumber(activeAmmo and ammo[activeAmmo]) or tonumber(ammo)
    ammoCount = math.max(0, math.min(500, math.floor(ammoCount or 0)))

    -- VORP passes components keyed by category; w_inventory stores a numeric
    -- component-hash array that the RDR client can apply directly.
    local list = {}
    local sourceComponents = type(comps) == 'table' and next(comps) and comps
        or type(ignored) == 'table' and ignored or {}
    for _, value in pairs(sourceComponents) do
        if type(value) == 'number' then
            list[#list + 1] = value
        elseif type(value) == 'string' and value ~= '' then
            list[#list + 1] = joaat(value)
        end
    end

    local previous = weaponId and nativeRow(source, weaponId, 'weapon')
    local previousMeta = previous and previous.metadata or {}

    local metadata = {
        ammo = math.max(0, math.floor(ammoCount)),
        components = list,
        serial = customSerial or previousMeta.serial or generateSerial(),
        custom_label = customLabel or previousMeta.custom_label,
        custom_desc = customDesc or previousMeta.custom_desc,
        durability = previousMeta.durability or 100,
        used = setUsed == true,
        used2 = false,
        _vorp = { kind = 'weapon', ammo = type(ammo) == 'table' and table.clone(ammo) or {},
            components = table.clone(sourceComponents), activeAmmo = activeAmmo, loadedAmmo = ammoCount },
    }

    if definition.nativeDefinition and definition.nativeDefinition.NoSerialNumber then
        metadata.serial, metadata.registered = nil, false
    end
    local ok, created = Inventory.AddItem(source, weaponName, 1, metadata)
    if not ok then return respond(cb, false) end

    -- We search by the serial number because it is unique, so we guarantee we found the very same piece
    local slot = type(created) == 'table' and created.slot and created or Inventory.GetSlotWithItem(source, weaponName, { serial = metadata.serial }, false)
    if slot then nativeId(slot) end

    -- VORP's old protocol: the client is told about the new piece
    -- (blackwater_lantern_holster listens for it)
    if slot and tonumber(source) then
        TriggerClientEvent('vorpInventory:receiveWeapon', tonumber(source), nativeId(slot), '', weaponName)

		if setUsed == true then
			Inventory.SetWeaponUsageState(source, {
				{ slot = slot.slot, hand = 0, serial = slot.metadata and slot.metadata.serial }
			}, false, false)
			TriggerClientEvent('vorpInventory:setWeaponUsed', tonumber(source), nativeId(slot), true)
		end
    end

    return respond(cb, slot and nativeId(slot) or false)
end)

--- VORP: subWeapon(source, weaponId, callback)
export('subWeapon', function(source, weaponId, cb)
    local slot = nativeRow(source, weaponId, 'weapon')
    if not slot or not slot.name then return respond(cb, false) end

    local ok = Inventory.RemoveItem(source, slot.name, 1, nil, slot.slot)

    if ok == true and tonumber(source) then
        TriggerClientEvent('vorpCoreClient:subWeapon', tonumber(source), weaponId)
    end

    return respond(cb, ok == true)
end)

--- VORP: deleteWeapon(source, weaponId, callback)
--- In VORP it deletes the row for good, and here removing the item is that very deletion
export('deleteWeapon', function(source, weaponId, cb)
    local slot = nativeRow(source, weaponId, 'weapon')
    if not slot or not slot.name then return respond(cb, false) end

    local ok = Inventory.RemoveItem(source, slot.name, 1, nil, slot.slot)

    if ok == true and tonumber(source) then
        TriggerClientEvent('vorpCoreClient:subWeapon', tonumber(source), weaponId)
    end

    return respond(cb, ok == true)
end)

--- VORP: canCarryWeapons(source, amount, callback, weaponName)
--- The real interface accepts a numeric hash too, and the name may be missing entirely
export('canCarryWeapons', function(source, amount, cb, weaponName)
    if weaponName then
        local resolved = type(weaponName) == 'string' and weaponName:upper() or nil

        if type(weaponName) == 'number' then
            for name, item in pairs(Items()) do
                if item and item.weapon and (tonumber(item.hash) == weaponName or joaat(name) == weaponName) then
                    resolved = name
                    break
                end
            end
        end

        if not resolved or not Items(resolved) then return respond(cb, false) end

        local ok = Inventory.CanCarryItem(source, resolved, amount or 1)
        return respond(cb, ok == true)
    end

    -- With no name there is no known weight - we settle for checking the free slots
    if server.canCarryNativeWeapon and not server.canCarryNativeWeapon(source, nil, amount) then return respond(cb, false) end
    local inv = Inventory(source)
    if not inv then return respond(cb, false) end

    local used = 0
    for _, s in pairs(inv.items) do
        if type(s) == 'table' and s.name then used = used + 1 end
    end

    return respond(cb, (inv.slots - used) >= (tonumber(amount) or 1))
end)

--- VORP: getUserInventoryWeapons(source, callback)
export('getUserInventoryWeapons', function(source, cb)
    local inv = Inventory(source)
    local weapons = {}

    if inv and inv.items then
        for _, slot in pairs(inv.items) do
            if type(slot) == 'table' and type(slot.name) == 'string'
                and slot.name:sub(1, 7) == 'WEAPON_' then
                weapons[#weapons + 1] = toVorpWeapon(slot, source)
            end
        end
    end

    return respond(cb, weapons)
end)

--- VORP: getUserWeapon(source, callback, weaponId)
export('getUserWeapon', function(source, cb, weaponId)
    return respond(cb, toVorpWeapon(nativeRow(source, weaponId, 'weapon'), source))
end)

-- VORP client compatibility: persist used/used2 while retaining exact slot
-- identity. This event can only alter the sender's own loaded inventory.
RegisterNetEvent('vorpinventory:setUsedWeapon', function(weaponId, used, used2)
    local src = source
    local inv = Inventory(src)
    local slot = inv and nativeRow(inv, weaponId, 'weapon')
    local item = slot and Items(slot.name)
    if not inv or not slot or not item or not item.weapon then return end

    local current = Inventory.GetWeaponUsageState(inv) or { hands = {} }
    local requested = {}
    local enabled = usageFlag(used) or usageFlag(used2)
    local dualCurrent = enabled and not usageFlag(used2)

    if enabled then
        if dualCurrent then
            requested[1] = { slot = slot.slot, hand = 0, serial = slot.metadata and slot.metadata.serial }

            for i = 1, #(current.hands or {}) do
                local held = current.hands[i]
                if tonumber(held.slot) ~= tonumber(slot.slot) then
                    requested[2] = { slot = held.slot, hand = 1, serial = held.serial }
                    break
                end
            end
        else
            local primary
            for i = 1, #(current.hands or {}) do
                local held = current.hands[i]
                if held.used2 and tonumber(held.slot) ~= tonumber(slot.slot) then
                    primary = held
                    break
                end
            end

            if primary then
                requested[1] = { slot = primary.slot, hand = 0, serial = primary.serial }
                requested[2] = { slot = slot.slot, hand = 1, serial = slot.metadata and slot.metadata.serial }
            else
                requested[1] = { slot = slot.slot, hand = 0, serial = slot.metadata and slot.metadata.serial }
            end
        end
    else
        for i = 1, #(current.hands or {}) do
            local held = current.hands[i]
            if tonumber(held.slot) ~= tonumber(slot.slot) then
                requested[1] = { slot = held.slot, hand = 0, serial = held.serial }
                break
            end
        end
    end

    Inventory.SetWeaponUsageState(inv, requested, false, false)
end)

--- VORP: removeAllUserAmmo(source)
--- VORP's ammunition is separate, and ours is inside every weapon's metadata
export('removeAllUserAmmo', function(source, cb)
    local inv = Inventory(source)
    if not inv or not inv.items then return respond(cb, false) end

    local ammoSlots = {}

    for _, slot in pairs(inv.items) do
        local item = slot and Items(slot.name)

        if item and item.weapon and slot.metadata and slot.metadata.ammo then
            local metadata = slot.metadata
            metadata.ammo = 0
            if metadata._vorp then
                metadata._vorp.ammo, metadata._vorp.loadedAmmo = {}, 0
            end
            metadata._ammoRevision = math.floor(tonumber(metadata._ammoRevision) or 0) + 1
            Inventory.SetMetadata(source, slot.slot, metadata)
        elseif item and item.nativeGunbelt then
            ammoSlots[#ammoSlots + 1] = {
                name = slot.name, count = slot.count, metadata = slot.metadata, slot = slot.slot
            }
        end
    end

    for i = 1, #ammoSlots do
        local ammo = ammoSlots[i]
        Inventory.RemoveItem(inv, ammo.name, ammo.count, ammo.metadata, ammo.slot)
    end

    Inventory.Save(inv)
    TriggerClientEvent('w_inventory:clearAllAmmo', source)

    return respond(cb, true)
end)

--- An old naming vorp_core uses - the same logic as closeInventory
export('CloseInv', function(source)
    local inv = Inventory(source)
    if inv then inv:closeInventory() end

    TriggerClientEvent('w_inventory:closeInventory', source, true)
    return true
end)

-- ============================================================
-- 7) The custom inventories
--
-- A VORP custom inventory = a stash here.
-- The bag provides no 'was it registered?' query, so we keep our own registry.
-- ============================================================
customInventories = {}         -- [id] = VORP custom-inventory policy + stash data
local blacklisted = {}         -- [id] = { [itemName] = true }

local DEFAULT_SLOTS = 50
local DEFAULT_WEIGHT = 500000  -- a generous weight because VORP limits by slots and not by weight

--- VORP calls it in two forms:
---   registerInventory(data)                          like vorp_banking
---   registerInventory(id, name, limit, acceptWeapons, shared, ...)
export('registerInventory', function(a, b, c, acceptWeapons, shared, ignoreItemStackLimit,
        whitelistItems, usePermissions, useBlackList, whitelistWeapons)
    local id, name, limit, data

    if type(a) == 'table' then
        data = a
        id, name, limit = data.id, data.name, data.limit
    else
        id, name, limit = a, b, c
        data = {
            acceptWeapons = acceptWeapons,
            shared = shared,
            ignoreItemStackLimit = ignoreItemStackLimit,
            whitelistItems = whitelistItems,
            UsePermissions = usePermissions,
            UseBlackList = useBlackList,
            whitelistWeapons = whitelistWeapons,
        }
    end

    if not id then return false end

    id = tostring(id)
    limit = tonumber(limit) or DEFAULT_SLOTS

    local config = customInventories[id] or {}
    config.slots = limit
    config.weight = tonumber(data.weight) or config.weight or DEFAULT_WEIGHT
    config.name = name or id
    config.acceptWeapons = data.acceptWeapons == true
    config.shared = data.shared == true
    config.ignoreItemStackLimit = data.ignoreItemStackLimit == true
    config.whitelistItems = data.whitelistItems == true
    config.whitelistWeapons = data.whitelistWeapons == true
    config.usePermissions = data.UsePermissions == true
    config.useBlackList = data.UseBlackList == true
    config.moveJobs = config.moveJobs or {}
    config.takeJobs = config.takeJobs or {}
    config.moveChars = config.moveChars or {}
    config.takeChars = config.takeChars or {}
    config.itemLimits = config.itemLimits or {}
    config.weaponLimits = config.weaponLimits or {}
    config.owners = config.owners or {}
    customInventories[id] = config
    NativeDb.registerNativeStash(id, config.shared)

    exports.w_inventory:RegisterStash(id, config.name, config.slots, config.weight,
        config.shared == false and true or false)

    return true
end)

local function getCustomConfig(inventoryId)
    local key = tostring(inventoryId)
    local direct = customInventories[key]
    if direct then return direct, key end

    for id, config in pairs(customInventories) do
        if config.shared == false and key:sub(1, #id + 1) == id .. ':' then
            return config, id
        end
    end
end

local function customInventoryRef(invId, owner)
    invId = tostring(invId)
    local config = customInventories[invId]

    if config and config.shared == false then
        if owner == nil then return nil end
        config.owners = config.owners or {}
        config.owners[tostring(owner)] = true
        return { id = invId, owner = tostring(owner) }
    end

    return invId
end

--- ! It is called with no callback in vorp_banking and vorp_housing, so it must return directly
export('isCustomInventoryRegistered', function(id, cb)
    return respond(cb, customInventories[tostring(id)] ~= nil)
end)

export('updateCustomInventorySlots', function(id, slots)
    id = tostring(id)
    local inv = customInventories[id]
    if not inv then return false end

    inv.slots = tonumber(slots) or inv.slots
    -- Registering again with the same id updates the stash's data
    exports.w_inventory:RegisterStash(id, inv.name or id, inv.slots, inv.weight,
        inv.shared == false and true or false)

    return true
end)

export('getCustomInventorySlots', function(id, cb)
    local inv = customInventories[tostring(id)]
    return respond(cb, inv and inv.slots or false)
end)

export('removeInventory', function(id)
    id = tostring(id)
    customInventories[id] = nil
    Inventory.Remove(id)
    return true
end)

export('deleteCustomInventory', function(id)
    id = tostring(id)
    local config = customInventories[id]

    if config and config.shared == false then
        for owner in pairs(config.owners or {}) do
            local inventory = Inventory(('%s:%s'):format(id, owner))

            if inventory then
                pcall(function() exports.w_inventory:ClearInventory(inventory.id) end)
                Inventory.Remove(inventory)
            end
        end
    else
        pcall(function() exports.w_inventory:ClearInventory(id) end)
        Inventory.Remove(id)
    end

    if MySQL and MySQL.update and MySQL.update.await then
        MySQL.update.await('DELETE FROM w_inventory WHERE name = ?', { id })
    end

    customInventories[id] = nil
    blacklisted[id] = nil

    return true
end)

--- Stopping an item entering a custom inventory
--- The bag has no blacklist, so we impose it with a hook on the item transfer
export('BlackListCustomAny', function(id, item)
    id = tostring(id)
    blacklisted[id] = blacklisted[id] or {}
    if customInventories[id] then customInventories[id].useBlackList = true end

    if type(item) == 'table' then
        for _, name in pairs(item) do
            if type(name) == 'string' then blacklisted[id][name:lower()] = true end
        end
    else
        if type(item) == 'string' then blacklisted[id][item:lower()] = true end
    end

    return true
end)

--- The hook that refuses to move a forbidden item into a stash it is forbidden in
--- ! It is deferred: calling the resource's own export while it is loading fails,
--- and had it failed here the whole file would have fallen and with it every compatibility export.
CreateThread(function()
    Wait(500)

    pcall(function()
        exports.w_inventory:registerHook('swapItems', function(payload)
            local fromId = tostring(payload.fromInventory)
            local toId = tostring(payload.toInventory)
            if fromId == toId then return true end

            local source = tonumber(payload.source)
            local fromConfig = getCustomConfig(fromId)
            local toConfig, toBaseId = getCustomConfig(toId)
            local slotData = payload.fromSlot
            if not source or not slotData or not slotData.name then return true end

            local okJob, job = pcall(function() return exports.w_lib:FwGetJob(source) end)
            local okGrade, grade = pcall(function() return exports.w_lib:FwGetJobGrade(source) end)
            local okChar, charId = pcall(function() return exports.w_lib:FwGetCharacterIdentifier(source) end)
            job = okJob and job or 'unemployed'
            grade = okGrade and tonumber(grade) or 0
            charId = okChar and tostring(charId) or ''

            local function hasPermission(config, jobs, chars)
                if not config or not config.usePermissions then return true end
                if not next(jobs) and not next(chars) then return true end

                local minimum = jobs[job]
                if minimum ~= nil and grade >= (tonumber(minimum) or 0) then return true end
                return chars[charId] == true
            end

            if fromConfig and not hasPermission(fromConfig, fromConfig.takeJobs, fromConfig.takeChars) then
                TriggerClientEvent('w_inventory:notify', source, {
                    type = 'error', key = 'stash_no_permission'
                })
                return false
            end

            if toConfig then
                if not hasPermission(toConfig, toConfig.moveJobs, toConfig.moveChars) then
                    TriggerClientEvent('w_inventory:notify', source, {
                        type = 'error', key = 'stash_no_permission'
                    })
                    return false
                end

                local item = Items(slotData.name)
                local isWeapon = item and item.weapon == true
                local list = blacklisted[toBaseId]

                if toConfig.useBlackList and list and list[slotData.name:lower()] then
                    TriggerClientEvent('w_inventory:notify', source, {
                        type = 'error', key = 'stash_item_blocked'
                    })
                    return false
                end

                if isWeapon and not toConfig.acceptWeapons then
                    TriggerClientEvent('w_inventory:notify', source, {
                        type = 'error', key = 'stash_no_weapons'
                    })
                    return false
                end

                local limits = isWeapon and toConfig.weaponLimits or toConfig.itemLimits
                local whitelist = isWeapon and toConfig.whitelistWeapons or toConfig.whitelistItems
                local limit = limits[slotData.name]

                if whitelist and limit == nil then
                    TriggerClientEvent('w_inventory:notify', source, {
                        type = 'error', key = 'stash_item_blocked'
                    })
                    return false
                end

                if limit ~= nil then
                    local current = Inventory.GetItemCount(toId, slotData.name) or 0
                    if current + (tonumber(payload.count) or 1) > tonumber(limit) then
                        TriggerClientEvent('w_inventory:notify', source, {
                            type = 'error', key = 'stash_limit_reached'
                        })
                        return false
                    end
                end
            end

            return true
        end)
    end)
end)

-- ============================================================
-- 8) Not supported yet - they give a clear error instead of a silent failure
--
-- ## How do you add a new function?
--
--   a) Read its signature in docs.vorp-core.com/api-reference/inventory
--   b) Find its counterpart in modules/inventory/server.lua
--   c) Write:  export('its name', function(VORP's arguments) ... return respond(cb, the result) end)
--   d) Delete its name from the list below
--
-- The weapons need their identity simulated through metadata.serial because VORP
-- gives every weapon a permanent weaponId in the database.
-- ============================================================
--- (There was a list of unsupported names here - they were all implemented below and in the filler blocks,
--- so the list was deleted. Any new name that appears in future: the same recipe above.)

--- A merged copy: the bag's fields as they are + VORP's spelling that third-party scripts read
--- (a copy and not a sharing - so no foreign fields leak into the saved slots)
local function toCustomRow(it)
    local metadata = type(it.metadata) == 'table' and it.metadata or {}
    local used = usageFlag(metadata.used or it.used)
    local used2 = used and usageFlag(metadata.used2 or it.used2) or false

    return {
        name = it.name, count = it.count, slot = it.slot,
        metadata = metadata, label = metadata.label or it.label, weight = it.weight,
        item_name = it.name, amount = it.count,
        item_crafted_id = it.slot, id = it.slot,
        crafted_id = it.slot, percentage = metadata.durability,
        charid = metadata.charid,
        desc = metadata.description or metadata.custom_desc,
        serial_number = metadata.serial or metadata.serial_number or '',
        custom_label = metadata.custom_label or '',
        custom_desc = metadata.custom_desc or metadata.description or '',
        ammo = metadata.ammo,
        components = metadata.components,
        used = used,
        used2 = used2,
        weaponHand = used and tonumber(metadata.weaponHand) or nil,
    }
end

export('getCustomInventoryItems', function(invId, cb)
    local ref = customInventoryRef(invId)
    if not ref then return respond(cb, false) end

    local all = exports.w_inventory:GetInventoryItems(ref) or {}
    local out = {}

    for _, it in pairs(all) do
        local data = it and Items(it.name)

        if data and not data.weapon then
            out[#out + 1] = toCustomRow(it)
        end
    end

    return respond(cb, out)
end)

export('getCustomInventoryWeapons', function(invId, cb)
    local ref = customInventoryRef(invId)
    if not ref then return respond(cb, false) end

    local all = exports.w_inventory:GetInventoryItems(ref) or {}
    local out = {}

    for _, it in pairs(all) do
        local data = it and Items(it.name)

        if data and data.weapon then
            out[#out + 1] = toCustomRow(it)
        end
    end

    return respond(cb, out)
end)

--- Adding a batch of items/weapons to a custom store - it accepts an array
--- whose elements are { name|item|weaponName, count|amount, metadata }
local function addBatchToCustom(invId, list, charId, cb)
    if type(charId) == 'function' and cb == nil then cb, charId = charId, nil end
    if type(list) ~= 'table' then return respond(cb, false) end

    local ref = customInventoryRef(invId, charId)
    if not ref then return respond(cb, false) end

    local inventory = Inventory(ref)
    if not inventory then return respond(cb, false) end

    local ok = true

    for _, entry in pairs(list) do
        if type(entry) == 'table' then
            local name = entry.name or entry.item or entry.weaponName
            local count = tonumber(entry.count or entry.amount) or 1
            local metadata = type(entry.metadata) == 'table' and table.clone(entry.metadata) or {}
            local item = name and Items(name)

            metadata.serial = metadata.serial or entry.serial or entry.serial_number
            metadata.ammo = metadata.ammo or entry.ammo
            metadata.components = metadata.components or entry.components or entry.comps
            metadata.custom_label = metadata.custom_label or entry.custom_label
            metadata.label = metadata.label or entry.custom_label
            metadata.custom_desc = metadata.custom_desc or entry.custom_desc
            metadata.description = metadata.description or entry.custom_desc
            if charId ~= nil then metadata.charid = metadata.charid or charId end

            if item and item.weapon then
                if type(metadata.ammo) == 'table' then
                    local total, selected = 0, nil

                    for ammoType, amount in pairs(metadata.ammo) do
                        amount = math.max(0, math.floor(tonumber(amount) or 0))
                        total = total + amount
                        if amount > 0 then selected = selected or ammoType end
                    end

                    metadata.ammo = total
                    if selected and selected ~= item.ammoType then metadata.specialAmmo = selected end
                end

                if type(metadata.components) == 'table' then
                    local components = {}

                    for _, component in pairs(metadata.components) do
                        if type(component) == 'number' then
                            components[#components + 1] = component
                        elseif type(component) == 'string' and component ~= '' then
                            components[#components + 1] = joaat(component)
                        end
                    end

                    metadata.components = components
                end
            end

            if name and not Inventory.AddItem(inventory, name, count, metadata) then
                ok = false
            end
        end
    end

    if ok then Inventory.Save(inventory) end
    return respond(cb, ok)
end

export('addItemsToCustomInventory', addBatchToCustom)
export('addWeaponsToCustomInventory', addBatchToCustom)

-- ============================================================
-- 9) The complete interface table
--
-- It must come last so it gathers everything registered above.
-- ============================================================
-- ============================================================
-- Filling in the rest of the real vorp_inventoryApi interface (v4.4)
-- The names are taken to the letter from vorp_inventory/server/vorpInventoryApi.lua
-- ============================================================

--- A weapon's slot by its id (the id here = the slot's number)
local function weaponSlot(source, weaponId)
    local inv = Inventory(tonumber(source) or source)

    if not inv then return nil end

    return nativeRow(inv, weaponId, 'weapon')
end

--- Syncing a modified slot with its owner
local function syncSlot(source, slotData)
    local inv = Inventory(tonumber(source) or source)

    if not inv or not slotData then return false end

    return Inventory.SetMetadata(inv, slotData.slot, slotData.metadata) == true
end

export('getWeaponBullets', function(source, a, b)
    local cb, weaponId

    if callable(a) then
        cb, weaponId = a, b
    else
        weaponId, cb = a, b
    end

    local s = weaponSlot(source, weaponId)

	return respond(cb, s and weaponAmmoTable(s) or 0)
end)

--- The very ammunition catalogue the client relies on - for every type's item names
local AmmoCatalog = lib.load('data.ammo_types_RDR3')

--- The single-round item's name for a bullet type (AMMO_X <- the item)
local function ammoItemFor(ammoType)
    for _, entries in pairs(AmmoCatalog.Families) do
        for i = 1, #entries do
            if entries[i].ammo == ammoType then
                for j = 1, #(entries[i].items or {}) do
                    if Items(entries[i].items[j]) then return entries[i].items[j] end
                end
            end
        end
    end
end

--- Two real forms in the base:
---   a) xakra/v-scene:  (source, bulletType, amount, cb)    <- bullet items
---   b) SS-Core:        (source, weaponId, ammoType, amount) <- a weapon's load
local function bulletsOp(sign)
    return function(source, a, b, c, d)
        if type(a) == 'string' and not tonumber(a) then
            if sign < 0 then return respond(callable(c) and c, false) end
            return respond(callable(c) and c, Gunbelt.add(source, a, b))
        end

        local s = weaponSlot(source, a)
        local cb = callable(d) and d or (callable(c) and c or nil)

        if not s then return respond(cb, false) end

        local amount = tonumber(c) or tonumber(b) or 0
        if amount ~= amount or amount < 0 then return respond(cb, false) end

        amount = math.floor(amount)

        local weapon = Items(s.name)
        local ammoType = type(b) == 'string' and b or weapon and weapon.ammoType
        if not ammoType or ammoType:sub(1, 5) ~= 'AMMO_' then return respond(cb, false) end
        local ammo = NativeStore.weaponAmmo(s)
        ammo[ammoType] = math.max(0, (tonumber(ammo[ammoType]) or 0) + sign * amount)
        local native = s.metadata._vorp or {}
        native.ammo = ammo
        if (native.activeAmmo or weapon.ammoType) == ammoType then
            s.metadata.ammo = math.min(500, ammo[ammoType])
            native.activeAmmo, native.loadedAmmo = ammoType, s.metadata.ammo
        end
        s.metadata._vorp = native
        s.metadata._ammoRevision = math.floor(tonumber(s.metadata._ammoRevision) or 0) + 1
        if not syncSlot(source, s) then return respond(cb, false) end

        return respond(cb, true)
    end
end

export('addBullets', bulletsOp(1))
export('subBullets', bulletsOp(-1))

export('getWeaponComponents', function(source, weaponId, cb)
    local s = weaponSlot(source, weaponId)

    return respond(cb, s and NativeStore.weaponComponents(s) or {})
end)

--- ! VORP's real direction is the reverse of what the name suggests:
---    the first argument is 'the receiver' and the third is its previous holder
export('giveWeapon', function(receiver, weaponId, holder, cb)
    receiver = tonumber(receiver)
    holder = tonumber(holder) or receiver

    if not receiver then return respond(cb, false) end

    -- v-scene passes the weapon's name and not its id - a direct creation for the receiver
    if type(weaponId) == 'string' and weaponId:upper():sub(1, 7) == 'WEAPON_' then
        return respond(cb, Inventory.AddItem(receiver, weaponId:upper(), 1) == true)
    end

    local s = weaponSlot(holder, weaponId)

    if not s then return respond(cb, false) end

    local name, meta = s.name, s.metadata

    if not Inventory.RemoveItem(holder, name, 1, meta, s.slot) then
        return respond(cb, false)
    end

    local ok = Inventory.AddItem(receiver, name, 1, meta)

    if not ok and receiver ~= holder then
        -- It failed at the receiver: we give it back to its holder so the weapon is not lost
        Inventory.AddItem(holder, name, 1, meta)
    end

    if ok == true then
        TriggerClientEvent('vorpCoreClient:subWeapon', holder, weaponId)

        local landed = Inventory.GetSlotWithItem(receiver, name,
            meta and meta.serial and { serial = meta.serial } or nil, true)

        if landed then
            TriggerClientEvent('vorpInventory:receiveWeapon', receiver, nativeId(landed), '', name)
        end
    end

    return respond(cb, ok and true or false)
end)

export('getItemContainingMetadata', function(source, item, metadata, cb)
    return respond(cb, toVorpItem(Inventory.GetSlotWithItem(source, item, metadata, false)))
end)

export('getItemMatchingMetadata', function(source, item, metadata, cb)
    return respond(cb, toVorpItem(Inventory.GetSlotWithItem(source, item, metadata, true)))
end)

local function setCustomLimit(id, name, limit, weapon)
    local config = customInventories[tostring(id)]
    limit = tonumber(limit)

    if not config or type(name) ~= 'string' or not limit or limit < 0 then return false end

    local limits = weapon and config.weaponLimits or config.itemLimits
    limits[name] = math.floor(limit)
    return true
end

local function setItemLimit(id, name, limit)
    return setCustomLimit(id, name, limit, false)
end

local function setWeaponLimit(id, name, limit)
    return setCustomLimit(id, name, limit, true)
end

local function addJobPermission(id, jobName, grade, direction)
    local config = customInventories[tostring(id)]
    if not config or type(jobName) ~= 'string' then return false end

    config.usePermissions = true
    config[direction][jobName] = math.max(0, math.floor(tonumber(grade) or 0))
    return true
end

local function addCharPermission(id, charId, state, direction)
    local config = customInventories[tostring(id)]
    if not config or charId == nil then return false end

    if type(charId) == 'table' then
        state = charId.state
        charId = charId.charid or charId.name
    end

    if charId == nil then return false end
    config.usePermissions = true
    config[direction][tostring(charId)] = state ~= false
    return true
end

export('setInventoryItemLimit', setItemLimit)
export('setInventoryWeaponLimit', setWeaponLimit)
export('setCustomInventoryItemLimit', setItemLimit)
export('setCustomInventoryWeaponLimit', setWeaponLimit)
export('AddPermissionMoveToCustom', function(id, jobName, grade)
    return addJobPermission(id, jobName, grade, 'moveJobs')
end)
export('AddPermissionTakeFromCustom', function(id, jobName, grade)
    return addJobPermission(id, jobName, grade, 'takeJobs')
end)
export('AddCharIdPermissionMoveToCustom', function(id, charId, state)
    return addCharPermission(id, charId, state, 'moveChars')
end)
export('AddCharIdPermissionTakeFromCustom', function(id, charId, state)
    return addCharPermission(id, charId, state, 'takeChars')
end)

--- VORP: canCarryItems(source, amount, cb) - VORP's cap is the number of pieces,
--- and our cap is the weight and the slots, and AddItem itself imposes them on execution. Here is
--- an equivalent first gate: an empty slot and free weight.
export('canCarryItems', function(source, amount, cb)
    local inv = Inventory(tonumber(source) or source)

    if not inv then return respond(cb, false) end

    local freeWeight = (inv.maxWeight or 0) - (inv.weight or 0)
    local used = 0

    for _ in pairs(inv.items) do
        used = used + 1
    end

    local hasSlot = used < (inv.slots or 0)

    return respond(cb, (hasSlot and freeWeight > 0) and true or false)
end)

-- The real interface's names that are synonyms of our functions (the v4.4 spelling)
local API_ALIASES = {
    RegisterUsableItem = 'registerUsableItem',
    OpenInv = 'openInventory',
    getDBItem = 'getItemDB',
    getItemByMainId = 'getItemById',
    subItemID = 'subItemById',
    deletegun = 'deleteWeapon',
    getUserInventory = 'getUserInventoryItems',
    getUserWeapons = 'getUserInventoryWeapons',
    getItemByName = 'getItem',
    getcomps = 'getWeaponComponents',
}

for realName, ourName in pairs(API_ALIASES) do
    assert(Api[ourName], 'compat alias missing base: ' .. ourName)
    export(realName, Api[ourName])
end

-- ============================================================
-- Filling in the rest of the calls observed in the full base scan
-- (SS-Core, xakra_weapons, v-scene, herbalist, spooni, v-bridge)
-- ============================================================

--- The player's total load per bullet type - gathered from his weapons' metadata
export('getUserAmmo', function(source, cb)
    return respond(cb, Gunbelt.get(source))
end)

--- Opening a player's bag (or another player's, for an admin)
--- The real form: (data, cb) where data = { source, target } - that is how
--- SS-Core calls it when searching; and we keep the old positional form as well
export('openPlayerInventory', function(a, b, c)
    if type(a) == 'table' then
        local src = tonumber(a.source)
        local tgt = tonumber(a.target) or src

        if not src or not tgt then return respond(b, false) end

        exports.w_inventory:forceOpenInventory(src, 'player', tgt)
        return respond(b, true)
    end

    local tgt = tonumber(b) or tonumber(a) or a
    exports.w_inventory:forceOpenInventory(a, 'player', tgt)

    return respond(c, true)
end)

export('getInventoryItems', function(source, cb)
    return respond(cb, exports.w_inventory:GetInventoryItems(tonumber(source) or source) or {})
end)

--- ! The real signature: (id, item, craftedId, cb, metadata) - the callback
---    is fourth (spooni would have waited for it forever had we read it as the third)
local function metadataEquals(a, b)
    if a == b then return true end
    if type(a) ~= type(b) then return false end
    if type(a) ~= 'table' then return false end

    for key, value in pairs(a) do
        if not metadataEquals(value, b[key]) then return false end
    end

    for key in pairs(b) do
        if a[key] == nil then return false end
    end

    return true
end

local function getCustomSlot(invId, craftedId, itemName, wantWeapon)
    local ref = customInventoryRef(invId)
    if not ref then return end

    local inv = Inventory(ref)
    if not inv then return end

    local slotId = tonumber(craftedId)
    if slotId then
        local slotData = nativeRow(inv, slotId, wantWeapon == true and 'weapon' or wantWeapon == false and 'item' or nil)
        local item = slotData and Items(slotData.name)

        if slotData and item
            and (not itemName or slotData.name == itemName)
            and (wantWeapon == nil or (item.weapon == true) == wantWeapon) then
            return slotData, inv
        end

        return nil, inv
    end

    for _, slotData in pairs(inv.items) do
        local item = slotData and Items(slotData.name)

        if item and (not itemName or slotData.name == itemName)
            and (wantWeapon == nil or (item.weapon == true) == wantWeapon) then
            return slotData, inv
        end
    end

    return nil, inv
end

local function saveCustom(inv)
    if inv then Inventory.Save(inv) end
end

--- VORP: (id, itemName, itemCraftedId, callback, metadata)
export('getCustomInventoryItemCount', function(invId, itemName, craftedId, cb, metadata)
    if callable(craftedId) then
        cb, craftedId = craftedId, nil
    end

    local ref = customInventoryRef(invId)
    local inv = ref and Inventory(ref)
    if not inv then return respond(cb, 0) end

    local total = 0

    if craftedId ~= nil then
        local slotData = getCustomSlot(invId, craftedId, itemName, false)

        if slotData and (not metadata or metadataEquals(slotData.metadata or {}, metadata)) then
            total = tonumber(slotData.count) or 0
        end
    else
        for _, slotData in pairs(inv.items) do
            local item = slotData and Items(slotData.name)

            if item and not item.weapon and slotData.name == itemName
                and (not metadata or metadataEquals(slotData.metadata or {}, metadata)) then
                total = total + (tonumber(slotData.count) or 0)
            end
        end
    end

    return respond(cb, total)
end)

--- VORP: (id, weaponName, callback). Also accepts the old (id, callback) form.
export('getCustomInventoryWeaponCount', function(invId, weaponName, cb)
    if callable(weaponName) then
        cb, weaponName = weaponName, nil
    end

    local ref = customInventoryRef(invId)
    local inv = ref and Inventory(ref)
    local total = 0

    if inv then
        for _, slotData in pairs(inv.items) do
            local item = slotData and Items(slotData.name)

            if item and item.weapon and (not weaponName or slotData.name == weaponName) then
                total = total + (tonumber(slotData.count) or 1)
            end
        end
    end

    return respond(cb, total)
end)

--- VORP: (id, itemName, amount, itemCraftedId, callback)
export('removeItemFromCustomInventory', function(invId, itemName, amount, craftedId, cb)
    if callable(craftedId) then
        cb, craftedId = craftedId, nil
    end

    local ref = customInventoryRef(invId)
    local inv = ref and Inventory(ref)
    if not inv then return respond(cb, false) end

    local count = math.max(1, math.floor(tonumber(amount) or 1))
    local slotData = craftedId and getCustomSlot(invId, craftedId, itemName, false) or nil
    local ok

    if craftedId ~= nil then
        ok = slotData and Inventory.RemoveItem(inv, slotData.name, count, slotData.metadata, slotData.slot)
    else
        ok = Inventory.RemoveItem(inv, itemName, count)
    end

    if ok == true then saveCustom(inv) end
    return respond(cb, ok == true)
end)

export('removeWeaponFromCustomInventory', function(invId, weaponName, cb)
    local slotData, inv = getCustomSlot(invId, nil, weaponName, true)
    if not slotData or not inv then return respond(cb, false) end

    local ok = Inventory.RemoveItem(inv, slotData.name, 1, slotData.metadata, slotData.slot)
    if ok == true then saveCustom(inv) end

    return respond(cb, ok == true)
end)

export('removeCustomInventoryWeaponById', function(invId, weaponId, cb)
    local slotData, inv = getCustomSlot(invId, weaponId, nil, true)
    if not slotData or not inv then return respond(cb, false) end

    local ok = Inventory.RemoveItem(inv, slotData.name, 1, slotData.metadata, slotData.slot)
    if ok == true then saveCustom(inv) end

    return respond(cb, ok == true)
end)

--- VORP: (id, itemCraftedId, metadata, amount, callback, identifier)
export('updateCustomInventoryItem', function(invId, craftedId, metadata, amount, cb)
    local slotData, inv = getCustomSlot(invId, craftedId, nil, false)
    if not slotData or not inv then return respond(cb, false) end

    local desired = amount == nil and slotData.count or math.floor(tonumber(amount) or 0)
    if desired < 1 then return respond(cb, false) end

    local current = tonumber(slotData.count) or 0
    local ok = true

    if desired > current then
        ok = Inventory.AddItem(inv, slotData.name, desired - current, slotData.metadata, slotData.slot) == true
    elseif desired < current then
        ok = Inventory.RemoveItem(inv, slotData.name, current - desired, slotData.metadata, slotData.slot) == true
    end

    if ok and metadata ~= nil then
        ok = Inventory.SetMetadata(inv, slotData.slot, metadata) == true
    end

    if ok then saveCustom(inv) end
    return respond(cb, ok == true)
end)

--- An item's durability by its id (the id here = the slot's number)
export('setItemDurability', function(source, itemId, durability, cb)
    local row = nativeRow(source, itemId, 'item')
    local value = tonumber(durability)
    if not row or not value or value ~= value or value < 0 then return respond(cb, false) end
    row.metadata._vorp.durability = value
    return respond(cb, Inventory.SetMetadata(source, row.slot, row.metadata) == true)
end)

--- xakra's weapon fields: a label and a name and a serial number - all of them metadata here
--- We write both fields (label + custom_label) so the round trip through
--- getUserWeapon(s) is correct, and we detect the sourceless form (weaponId, value, cb)
local metaSetterWarned = {}

local function weaponMetaSetter(field, mirror)
    return function(source, weaponId, value, cb)
        if callable(value) and cb == nil then
            -- A sourceless form - there is no way to know the weapon's owner
            if not metaSetterWarned[field] then
                metaSetterWarned[field] = true
                print(('^3[vorp-compat]^7 %s called without player source - ignoring'):format(field))
            end

            return respond(value, false)
        end

        local slotData = weaponSlot(source, weaponId)

        if not slotData then return respond(cb, false) end

        slotData.metadata[field] = value
        if mirror then slotData.metadata[mirror] = value end
        syncSlot(source, slotData)

        return respond(cb, true)
    end
end

export('setWeaponCustomLabel', weaponMetaSetter('label', 'custom_label'))
export('setWeaponCustomDesc', weaponMetaSetter('description', 'custom_desc'))
export('setWeaponSerialNumber', weaponMetaSetter('serial'))

export('addWeaponComponent', function(source, weaponId, component, category, cb)
    if callable(category) then cb = category end
    local slotData = weaponSlot(source, weaponId)

    if not slotData then return respond(cb, false) end

    slotData.metadata.components = slotData.metadata.components or {}
    if type(category) == 'string' then
        slotData.metadata._vorp = slotData.metadata._vorp or {}
        local native = slotData.metadata._vorp
        native.components = native.components or {}
        native.components[category] = component
    end
	if type(component) == 'string' then component = joaat(component) end
    slotData.metadata.components[#slotData.metadata.components + 1] = component
    syncSlot(source, slotData)

    return respond(cb, true)
end)

export('subWeaponComponent', function(source, weaponId, component, category, cb)
    if callable(category) then cb = category end
    local slotData = weaponSlot(source, weaponId)
    local comps = slotData and slotData.metadata and slotData.metadata.components

    if not comps then return respond(cb, false) end
	if type(component) == 'string' then component = joaat(component) end

    for i = #comps, 1, -1 do
        if comps[i] == component then
            table.remove(comps, i)
            syncSlot(source, slotData)

            return respond(cb, true)
        end
    end

    return respond(cb, false)
end)

export('addWeaponComponents', function(source, weaponId, components, cb)
    local slotData = weaponSlot(source, weaponId)
    if not slotData or type(components) ~= 'table' then return respond(cb, false) end

    slotData.metadata.components = slotData.metadata.components or {}
    for _, component in pairs(components) do
        if type(component) == 'string' then component = joaat(component) end
        if type(component) == 'number' then
            slotData.metadata.components[#slotData.metadata.components + 1] = component
        end
    end
    syncSlot(source, slotData)
    return respond(cb, true)
end)

export('subWeaponComponents', function(source, weaponId, components, cb)
    local slotData = weaponSlot(source, weaponId)
    local current = slotData and slotData.metadata and slotData.metadata.components
    if not current or type(components) ~= 'table' then return respond(cb, false) end

    local remove = {}
    for _, component in pairs(components) do
        remove[type(component) == 'string' and joaat(component) or component] = true
    end
    for i = #current, 1, -1 do
        if remove[current[i]] then table.remove(current, i) end
    end
    syncSlot(source, slotData)
    return respond(cb, true)
end)

--- A bulk removal: VORP separates the items from the weapons, and we tell them apart by the weapon flag
local function subAllOf(wantWeapon)
    return function(source, cb)
        local inv = Inventory(tonumber(source) or source)

        if not inv then return respond(cb, false) end

        local doomed = {}

        for slot, slotData in pairs(inv.items) do
            local it = Items(slotData.name)

            if it and ((it.weapon and true or false) == wantWeapon) then
                doomed[#doomed + 1] = { slot = slot, name = slotData.name,
                                        count = slotData.count, metadata = slotData.metadata }
            end
        end

        for i = 1, #doomed do
            local d = doomed[i]
            Inventory.RemoveItem(inv, d.name, d.count, d.metadata, d.slot)
        end

        return respond(cb, true)
    end
end

export('subAllItems', subAllOf(false))
export('subAllWeapons', subAllOf(true))

--- The custom stores' data - vorp_lockers indexes the result directly (6 places)
export('getCustomInventoryData', function(id, cb)
    id = tostring(id)
    local data = customInventories[id]

    if not data then return respond(cb, false) end

    return respond(cb, {
        id = id,
        name = data.name or id,
        limit = data.slots,
        slots = data.slots,
        shared = data.shared,
        acceptWeapons = data.acceptWeapons,
        ignoreItemStackLimit = data.ignoreItemStackLimit,
        whitelistItems = data.whitelistItems,
        whitelistWeapons = data.whitelistWeapons,
        UsePermissions = data.usePermissions,
        UseBlackList = data.useBlackList,
        PermissionMoveTo = data.moveJobs,
        PermissionTakeFrom = data.takeJobs,
        CharIdPermissionMoveTo = data.moveChars,
        CharIdPermissionTakeFrom = data.takeChars,
        limitedItems = data.itemLimits,
        limitedWeapons = data.weaponLimits,
    })
end)

export('updateCustomInventoryData', function(id, data, cb)
    id = tostring(id)
    local inv = customInventories[id]

    if not inv or type(data) ~= 'table' then return respond(cb, false) end

    if tonumber(data.limit) then inv.slots = tonumber(data.limit) end
    if data.name then inv.name = data.name end
    if data.acceptWeapons ~= nil then inv.acceptWeapons = data.acceptWeapons == true end
    if data.shared ~= nil then inv.shared = data.shared == true end
    if data.ignoreItemStackLimit ~= nil then inv.ignoreItemStackLimit = data.ignoreItemStackLimit == true end
    if data.whitelistItems ~= nil then inv.whitelistItems = data.whitelistItems == true end
    if data.whitelistWeapons ~= nil then inv.whitelistWeapons = data.whitelistWeapons == true end
    if data.UsePermissions ~= nil then inv.usePermissions = data.UsePermissions == true end
    if data.UseBlackList ~= nil then inv.useBlackList = data.UseBlackList == true end
    if type(data.PermissionMoveTo) == 'table' then inv.moveJobs = data.PermissionMoveTo end
    if type(data.PermissionTakeFrom) == 'table' then inv.takeJobs = data.PermissionTakeFrom end
    if type(data.CharIdPermissionMoveTo) == 'table' then inv.moveChars = data.CharIdPermissionMoveTo end
    if type(data.CharIdPermissionTakeFrom) == 'table' then inv.takeChars = data.CharIdPermissionTakeFrom end
    if type(data.limitedItems) == 'table' then inv.itemLimits = data.limitedItems end
    if type(data.limitedWeapons) == 'table' then inv.weaponLimits = data.limitedWeapons end

    exports.w_inventory:RegisterStash(id, inv.name or id, inv.slots, inv.weight,
        inv.shared == false and true or false)

    return respond(cb, true)
end)

-- Capitalised spellings v-scene and herbalist use
local MORE_ALIASES = {
    AddBullets = 'addBullets',
    AddItem = 'addItem',
    GiveWeapon = 'giveWeapon',
    getInventoryItem = 'getItem',
}

for realName, ourName in pairs(MORE_ALIASES) do
    assert(Api[ourName], 'compat alias missing base: ' .. ourName)
    export(realName, Api[ourName])
end

-- ============================================================
-- The old load protocol: the client broadcasts vorpinventory:getInventory
-- and the server replies with a giveLoadout event - blackwater_lantern_holster listens for it
-- ============================================================
RegisterNetEvent('vorpinventory:getInventory', function()
    local src = source
    local inv = Inventory(src)

    if not inv then return end

    local loadout = {}

    for slot, s in pairs(inv.items) do
        if type(s) == 'table' and type(s.name) == 'string'
            and s.name:sub(1, 7) == 'WEAPON_' then
            local weapon = toVorpWeapon(s, src)
            weapon.currInv, weapon.dropped = 'default', 0
            loadout[#loadout + 1] = weapon
        end
    end

    TriggerClientEvent('vorpInventory:giveLoadout', src, loadout)
end)

-- ============================================================
-- VORP's global clock: some scripts read GlobalState.TimeNow
-- ============================================================
CreateThread(function()
    while true do
        GlobalState.TimeNow = os.time()
        Wait(1000)
    end
end)

-- ============================================================
-- Covering the vorpCore:* events - the old core broadcasts them internally instead of calling
-- directly. There is no readable consumer today, but the encrypted ones may broadcast them tomorrow
-- ============================================================
local LEGACY_EVENTS = {
    ['vorpCore:subWeapon'] = 'subWeapon',
    ['vorpCore:giveWeapon'] = 'giveWeapon',
    ['vorpCore:registerWeapon'] = 'createWeapon',
    ['vorpCore:addItem'] = 'addItem',
    ['vorpCore:subItem'] = 'subItem',
    ['vorpCore:setItemMetadata'] = 'setItemMetadata',
    ['vorpCore:subItemID'] = 'subItemID',
    ['vorpCore:getItem'] = 'getItem',
    ['vorpCore:getItemByMainId'] = 'getItemByMainId',
    ['vorpCore:getItemByName'] = 'getItemByName',
    ['vorpCore:getcomps'] = 'getcomps',
    ['vorpCore:deletegun'] = 'deletegun',
    ['vorpinventory:removeammo'] = 'removeAllUserAmmo',
    ['vorpCore:getItemContainingMetadata'] = 'getItemContainingMetadata',
    ['vorpCore:getItemMatchingMetadata'] = 'getItemMatchingMetadata',
    ['vorpCore:getItemCount'] = 'getItemCount',
    ['vorpCore:getUserInventory'] = 'getUserInventory',
    ['vorpCore:canCarryItems'] = 'canCarryItems',
    ['vorpCore:canCarryItem'] = 'canCarryItem',
    ['vorpCore:canCarryWeapons'] = 'canCarryWeapons',
    ['vorpCore:subBullets'] = 'subBullets',
    ['vorpCore:addBullets'] = 'addBullets',
    ['vorpCore:getWeaponBullets'] = 'getWeaponBullets',
    ['vorpCore:getUserWeapons'] = 'getUserWeapons',
    ['vorpCore:getUserWeapon'] = 'getUserWeapon',
    ['vorpCore:registerUsableItem'] = 'registerUsableItem',
    ['vorpCore:registerInventory'] = 'registerInventory',
    ['vorpCore:removeInventory'] = 'removeInventory',
    ['vorpCore:openCustomInventory'] = 'openInventory',
    ['vorpCore:closeCustomInventory'] = 'closeInventory',
    ['vorpCore:setInventoryItemLimit'] = 'setInventoryItemLimit',
    ['vorpCore:setInventoryWeaponLimit'] = 'setInventoryWeaponLimit',
    ['vorp_inventory:Server:AddPermissionMoveToCustom'] = 'AddPermissionMoveToCustom',
    ['vorp_inventory:Server:AddPermissionTakeFromCustom'] = 'AddPermissionTakeFromCustom',
    ['vorp_inventory:Server:BlackListCustom'] = 'BlackListCustomAny',
    ['vorp_inventory:Server:updateCustomInventorySlots'] = 'updateCustomInventorySlots',
}

for eventName, apiName in pairs(LEGACY_EVENTS) do
    assert(Api[apiName], 'compat event missing API: ' .. apiName)
    AddEventHandler(eventName, Api[apiName])
end

export('vorp_inventoryApi', function()
    return Api
end)
