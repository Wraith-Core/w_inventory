-- RSG owns weapon GUIDs, ammunition, quality, components and equipped metadata.
-- W supplies inventory UI and calls the same validated use flow as the native bag.
local Native = {}
local Items = require 'modules.items.client'
local busy = false
local projectionRevision = 0
local unarmed = `WEAPON_UNARMED`

local function truth(value) return value == true or value == 1 or value == '1' end
local function coreData()
    local ok, data = pcall(function() return exports.w_lib:FwGetPlayerData() end)
    return ok and type(data) == 'table' and data or {}
end
local function nativeCall(name, ...)
    local args = table.pack(...)
    local ok, result = pcall(function()
        local api = exports['rsg-weapons']
        return api[name](api, table.unpack(args, 1, args.n))
    end)
    return ok and result or nil
end
function Native.ready()
    return GetResourceState('rsg-weapons') == 'started'
end
local function infoOf(item)
    local info = {}
    for key, value in pairs(item.metadata or item.info or {}) do
        if key ~= '_w_rsg' then info[key] = value end
    end
    return info
end
local function nativeKind(item, definition)
    return definition and (definition.nativeType or definition.nativeDefinition and definition.nativeDefinition.type)
        or item.type
end
local function weaponKind(kind)
    return kind == 'weapon' or kind == 'weapon_thrown' or kind == 'equipment'
end
local function drawn(hash, hand)
    local ok, found, current = pcall(GetCurrentPedWeapon, PlayerPedId(), true, hand or 0, true)
    return ok and truth(found) and current == hash and current ~= unarmed
end
function Native.state()
    local state = { ready = Native.ready() and PlayerData.loaded == true, weapons = {}, items = {},
        dual = { enabled = false, count = 0, slots = {} }, oil = { enabled = false, count = 0 },
        caps = { dual = false, clean = false, condition = true, ammoSwitch = false, stow = true, slots = true } }
    if not state.ready then return state end
    local used, guids = nativeCall('GetUsedWeapons'), nativeCall('EquippedWeapons')
    if type(used) ~= 'table' or type(guids) ~= 'table' then state.ready = false; return state end
    local hands = {}
    local validGuids = #guids <= 2
    for index, entry in ipairs(guids) do
        if type(entry) ~= 'table' or entry.id == nil or entry.guid == nil then validGuids = false; break end
        hands[tostring(entry.id)] = #guids == 2 and index == 1 and 1 or 0
    end
    state.dual.enabled, state.caps.dual = validGuids, validGuids
    local data = coreData()
    local knives = data.metadata and data.metadata.equippedknives or {}
    for key, item in pairs(PlayerData.inventory or {}) do
        local definition = item and Items[item.name]
        if definition then
            local slot, info = tonumber(item.slot or key), infoOf(item)
            local kind = nativeKind(item, definition)
            local name = definition.nativeName or item.name
            local hash = definition.hash or joaat(name)
            local serial = info.serie ~= nil and tostring(info.serie) or nil
            if weaponKind(kind) then
                local okGun, gun = pcall(IsWeaponAGun, hash)
                local okHand, oneHand = pcall(IsWeaponOneHanded, hash)
                local sidearm = okGun and truth(gun) and okHand and truth(oneHand)
                local equipped = kind == 'weapon' and serial ~= nil and used[serial] ~= nil
                    or kind == 'equipment' and (truth(knives[name]) or HasPedGotWeapon(PlayerPedId(), hash, 0, false))
                local hand = serial and hands[serial] or 0
                local visible = equipped and drawn(hash, hand)
                if sidearm and hands[serial] == nil then visible = false end
                local row = { slot = slot, name = name, label = definition.label or name, hash = hash,
                    serial = serial, count = item.count or item.amount or 1,
                    oneHanded = okHand and truth(oneHand), isGun = okGun and truth(gun),
                    throwable = kind == 'weapon_thrown', nativeType = kind,
                    equipped = equipped == true, held = equipped == true, drawn = visible == true,
                    hand = hand, dualCapable = validGuids and sidearm,
                    condition = tonumber(info.quality), loaded = GetAmmoInPedWeapon(PlayerPedId(), hash),
                    capacity = 0, stats = {}, ammoOptions = {}, image = definition.image }
                state.weapons[#state.weapons + 1] = row
                if serial and hands[serial] ~= nil and equipped then
                    state.dual.count = state.dual.count + 1
                    state.dual.slots[#state.dual.slots + 1] = slot
                end
            else
                state.items[#state.items + 1] = { slot = slot, name = name, label = definition.label or name,
                    count = item.count or item.amount or 0, usable = definition.nativeDefinition and definition.nativeDefinition.useable }
            end
        end
    end
    table.sort(state.weapons, function(a, b) return a.slot < b.slot end)
    table.sort(state.items, function(a, b) return a.slot < b.slot end)
    return state
end
local function findSlot(slot)
    for _, row in ipairs(Native.state().weapons) do if row.slot == tonumber(slot) then return row end end
end
local function awaitState(predicate)
    local deadline = GetGameTimer() + 1800
    repeat
        if predicate() then return true end
        Wait(0)
    until GetGameTimer() >= deadline
    return false
end
function Native.use(slot)
    if busy then return false, 'busy' end
    slot = tonumber(slot)
    local item = slot and PlayerData.inventory and PlayerData.inventory[slot]
    if not item then return false, 'invalid_weapon' end
    local before = findSlot(slot)
    busy = true
    local called, accepted, reason = pcall(function()
        return lib.callback.await('w_inventory:rsg:useItem', false, slot, item.name,
            (item.metadata or {}).serie)
    end)
    if called and accepted == true and before and before.nativeType ~= 'weapon_thrown' then
        accepted = awaitState(function()
            local after = findSlot(slot)
            return after and after.equipped ~= before.equipped
        end)
        if not accepted then reason = 'native_use_not_confirmed' end
    end
    busy = false
    return called and accepted == true, called and reason or 'native_use_failed'
end
function Native.holster()
    if not Native.ready() then return false, 'rsg_weapons_not_ready' end
    if busy then return false, 'busy' end
    local called = pcall(HolsterPedWeapons, PlayerPedId(), true, false, true, false)
    if not called then return false, 'holster_failed' end
    local ok = awaitState(function()
        for _, row in ipairs(Native.state().weapons) do if row.drawn then return false end end
        return true
    end)
    return ok, not ok and 'holster_failed' or nil
end
function Native.draw(slots)
    if not Native.ready() then return false, 'rsg_weapons_not_ready' end
    if busy then return false, 'busy' end
    if type(slots) ~= 'table' or #slots < 1 or #slots > 2 then return false, 'invalid_weapon' end
    local state, selected, count, seen = Native.state(), {}, 0, {}
    if not state.ready then return false, 'rsg_weapons_not_ready' end
    for _, row in ipairs(state.weapons) do if row.equipped then count = count + 1 end end
    if count ~= #slots then return false, 'loadout_changed' end
    local guids, bySerial = nativeCall('EquippedWeapons'), {}
    for _, entry in ipairs(type(guids) == 'table' and guids or {}) do bySerial[tostring(entry.id)] = entry end
    for index, slot in ipairs(slots) do
        local row = findSlot(slot)
        if not row or not row.equipped or seen[row.slot] then return false, 'loadout_changed' end
        seen[row.slot] = true
        if #slots == 2 and row.hand ~= index - 1 then return false, 'hand_mismatch' end
        if row.nativeType == 'weapon' and (not row.serial or row.condition == nil or row.condition <= 1) then
            return false, 'broken_weapon'
        end
        local guid = row.serial and bySerial[row.serial]
        if row.dualCapable and not guid then return false, 'loadout_changed' end
        selected[index] = { row = row, guid = guid and guid.guid }
    end
    busy = true
    local called, result = pcall(function()
        for _, target in ipairs(selected) do
            if target.guid then
                Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), target.guid, false, target.row.hand, false, false)
            else
                SetCurrentPedWeapon(PlayerPedId(), target.row.hash, false, 0, false, false)
            end
        end
        return awaitState(function()
            for _, target in ipairs(selected) do if not drawn(target.row.hash, target.row.hand) then return false end end
            return true
        end)
    end)
    busy = false
    return called and result == true, not (called and result == true) and 'draw_failed' or nil
end
function Native.clear()
    local state = Native.state()
    if not state.ready then return false, 'rsg_weapons_not_ready' end
    for _, row in ipairs(state.weapons) do
        if row.equipped then
            local ok, reason = Native.use(row.slot)
            if not ok then return false, reason end
        end
    end
    return Native.holster()
end
function Native.current()
    for _, row in ipairs(Native.state().weapons) do
        if row.drawn and row.hand == 0 then return PlayerData.inventory[row.slot] end
    end
end
function Native.detachMissing(logout)
    if not Native.ready() then return end
    local present = {}
    if not logout then
        for _, item in pairs(PlayerData.inventory or {}) do
            local serial = (item.metadata or {}).serie
            if serial ~= nil then present[tostring(serial)] = true end
        end
    end
    for serial, entry in pairs(nativeCall('GetUsedWeapons') or {}) do
        if not present[tostring(serial)] then
            if entry.data then
                TriggerEvent('rsg-weapons:client:UseWeapon', entry.data)
            else
                nativeCall('RemoveWeaponFromPeds', entry.name, tostring(serial))
            end
            if not logout and entry.data then
                TriggerServerEvent('rsg-weapons:server:saveEquippedWeapon', entry.data, false)
            end
        end
    end
end
AddEventHandler('w_inventory:updateInventory', function()
    projectionRevision = projectionRevision + 1
    Native.detachMissing(false)
end)
AddEventHandler('RSGCore:Client:OnPlayerUnload', function() Native.detachMissing(true) end)
-- Only a UI projection: info/PlayerData metadata remains native and unchanged.
CreateThread(function()
    local previous, revision = {}, -1
    while true do
        Wait(300)
        if revision ~= projectionRevision then previous, revision = {}, projectionRevision end
        local state, updates, nextState = Native.state(), {}, {}
        for _, weapon in ipairs(state.weapons) do
            local signature = tostring(weapon.equipped) .. ':' .. tostring(weapon.hand) .. ':' .. tostring(weapon.condition)
            nextState[weapon.slot] = signature
            if previous[weapon.slot] ~= signature then
                local original = PlayerData.inventory[weapon.slot]
                local item = table.clone(original)
                item.metadata = table.clone(original.metadata or {})
                item.used, item.used2 = weapon.equipped, weapon.equipped and weapon.hand == 0
                item.metadata.used, item.metadata.used2 = item.used, item.used2
                item.metadata.durability = weapon.condition
                updates[#updates + 1] = { item = item, inventory = 'player' }
            end
        end
        if #updates > 0 then SendNUIMessage({ action = 'refreshSlots', data = { items = updates, itemCount = {} } }) end
        previous = nextState
    end
end)
return Native
