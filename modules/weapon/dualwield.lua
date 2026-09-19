--[[
    Carrying two weapons - RDR3

    Giving the weapon twice is not enough. RDR2 holds the weapons in an internal item
    database, and every item has a GUID. And the two hands are two slots in that database:
        SLOTID_WEAPON_0   the right
        SLOTID_WEAPON_1   the left

    So the sequence:
        1) the character's GUID          CHARACTER / SLOTID_NONE
        2) the weapons container's GUID  CARRIED_WEAPONS / SLOTID_CARRIED_WEAPONS
        3) adding the weapon with a new GUID inside the container
        4) equipping it
        5) putting it in a particular hand

    And when the second weapon comes the first is moved to the left and the new one takes the right.

    The conditions: a one-handed pistol, a firearm, and the player has a left holster if the config requires it.

    DataView from w_lib (the dataview module) - a general library that works on every system,
    so the bag is not tied to a particular framework.
--]]

local DualWield = {}

local INVENTORY_ID = 1
local GUID_SIZE = 8 * 13

--- The weapons held right now: { { slot = the bag slot's number, guid = buffer } }
local equipped = {}

--- It increases with every intended holstering - the disappearance detector tells it from a spontaneous disappearance
local generation = 0

--- True while an equip is under way - client.lua's threads read it and keep their hands off
local busyFlag = false

--- Was the dual-wield feature unlocked in the game? (once per session)
local unlockDone = false

local enabled = GetConvarInt('inventory:dualwield', 1) == 1
local holsterNeeded = GetConvarInt('inventory:dualwield_holster', 1) == 1
local debugOn = GetConvarInt('inventory:dualwield_debug', 0) == 1

-- ============================================================
-- The RDR3 item database natives
-- ============================================================
local ITEMDATABASE_IS_KEY_VALID     = 0x6D5D51B188333FD1
local ITEMDATABASE_GET_FITS_SLOT_COUNT = 0x2970D1D6BFCF9B46
local ITEMDATABASE_GET_FITS_SLOT_INFO = 0x77210C146CED5261
local ITEMDATABASE_GET_HAS_SLOT_COUNT = 0x44915068579D7710
local ITEMDATABASE_GET_HAS_SLOT_INFO = 0x8A9BD0DB7E8376CF
local ITEMDATABASE_GET_BUNDLE_ID = 0x891A45960B6B768A
local ITEMDATABASE_GET_BUNDLE_ITEM_COUNT = 0x3332695B01015DF9
local ITEMDATABASE_GET_BUNDLE_ITEM_INFO = 0x5D48A77E4B668B57
local INVENTORY_GET_GUID_FROM_ITEMID = 0x886DFD3E185C8A89
local INVENTORY_ADD_ITEM_WITH_GUID  = 0xCB5D11F9508A928D
local INVENTORY_EQUIP_ITEM_WITH_GUID = 0x734311E2852760D0
local INVENTORY_MOVE_INVENTORY_ITEM = 0xDCCAA7C3BFD88862
local INVENTORY_REMOVE_GUID         = 0x3E4E811480B3AE79
local SET_CURRENT_PED_WEAPON_BY_GUID = 0x12FB95FE3D579238
local IS_WEAPON_A_GUN               = 0x705BE297EEBDB95D
local SET_PED_COMPONENT_ENABLED     = 0xD3A7B003ED343FD9
local UPDATE_PED_VARIATION          = 0xCC8CA3E88256E58F
local SET_PED_COMPONENT_DIRTY       = 0xAAB86462966168CE
local REQUEST_WEAPON_ASSET          = 0x72D4CB5DB927009C
local HAS_WEAPON_ASSET_LOADED       = 0xFF07CF465F48B830
local GET_WEAPON_COMPONENT_TYPE_MODEL = 0x59DE03442B6C9598
-- The two real unlocking natives - the two hashes circulating in the forums
-- (0xB16DCE53A8491E4F / 0x1AD5FCD0653BA66A) do not exist in the RDR3 database
local UNLOCK_SET_UNLOCKED           = 0x1B7C5ADA8A6910A0
local UNLOCK_SET_VISIBLE            = 0x46B901A8ECDB5A61
local SET_ALLOW_DUAL_WIELD          = 0x83B8D50EB9446BBA
local DUAL_WIELD_UNLOCK             = -200143754
local WARDROBE_SLOT                 = 0x3DABBFA7
local INVENTORY_CHILD_SLOT          = -1591664384

---@param itemData any? the parent's GUID buffer, or nil for the root
---@param category number
---@param slotId number
---@return table? view
local function getGuid(itemData, category, slotId)
    local out = DataView.ArrayBuffer(GUID_SIZE)
    local ok = Citizen.InvokeNative(INVENTORY_GET_GUID_FROM_ITEMID, INVENTORY_ID,
        itemData or 0, category, slotId, out:Buffer())

    -- ! In Lua zero is truthy. Were the native to return 0 as a sign of failure we would have counted it a success
    -- and returned an empty buffer, so ADD_ITEM_WITH_GUID fails with no visible reason.
    if debugOn then
        print(('^5[dualwield/guid]^7 ok=%s (%s)'):format(tostring(ok), type(ok)))
    end

    if not ok or ok == 0 then return nil end

    return out
end

---@param old any the source's GUID buffer
---@param new any the container's GUID buffer
---@param slot number
---@return table? view
local function moveItem(old, new, slot)
    local out = DataView.ArrayBuffer(GUID_SIZE)
    local ok = Citizen.InvokeNative(INVENTORY_MOVE_INVENTORY_ITEM, INVENTORY_ID,
        old, new, joaat(('SLOTID_WEAPON_%d'):format(slot)), 1, out:Buffer())

    -- Zero is truthy in Lua - it does not count as a success
    if not ok or ok == 0 then return nil end

    return out
end

local function releaseGuid(guid)
    Citizen.InvokeNative(INVENTORY_REMOVE_GUID, INVENTORY_ID, guid, 1, joaat('ADD_REASON_DEFAULT'))
end

-- ============================================================
-- The left holster - without one RDR2 does not accept the second weapon
-- ============================================================

local GET_NUM_COMPONENTS_IN_PED   = 0x90403E8107B60E81
local GET_COMPONENT_AT_INDEX      = 0x9b90842304c938a7

--- We go over the character's clothing pieces looking for the holsters_left category
---@return boolean
local function hasLeftHolster()
    local ped = cache.ped
    local count = Citizen.InvokeNative(GET_NUM_COMPONENTS_IN_PED, ped, Citizen.ResultAsInteger())

    if not count or count < 1 then return false end

    for index = 0, count - 1 do
        local category = Citizen.InvokeNative(GET_COMPONENT_AT_INDEX, ped, index, 0, Citizen.ResultAsInteger())

        if category == `holsters_left` then return true end
    end

    return false
end

--- Putting the left holster on
local function applyLeftHolster()
    local ped = cache.ped
    local gender = IsPedMale(ped) and 'M' or 'F'
    local component = joaat(('CLOTHING_ITEM_%s_OFFHAND_000_TINT_004'):format(gender))

    Citizen.InvokeNative(SET_PED_COMPONENT_ENABLED, ped, component, false, false, false)
    Citizen.InvokeNative(SET_PED_COMPONENT_ENABLED, ped, component, false, true, false)
    Citizen.InvokeNative(UPDATE_PED_VARIATION, ped, false, true, true, true, false)
    Citizen.InvokeNative(SET_PED_COMPONENT_DIRTY, ped, true)
end

--- Unlocking the dual-wield feature in the game then allowing it for the character.
--- ! It must come before placing the second hand's weapon - after it the engine refuses and returns it
--- to the right holster (and this was the cause of the stacking and the disappearing).
local function ensureDualUnlock()
    if not unlockDone then
        unlockDone = true
        Citizen.InvokeNative(UNLOCK_SET_UNLOCKED, DUAL_WIELD_UNLOCK, true)
        Citizen.InvokeNative(UNLOCK_SET_VISIBLE, DUAL_WIELD_UNLOCK, true)
    end

    Citizen.InvokeNative(SET_ALLOW_DUAL_WIELD, cache.ped, true)
end

--- Loading the weapon's assets before binding it - a record with no assets = a weapon that is not seen
local function streamAsset(weaponHash)
    Citizen.InvokeNative(REQUEST_WEAPON_ASSET, weaponHash, 0, true)

    local deadline = GetGameTimer() + 3000

    while not Citizen.InvokeNative(HAS_WEAPON_ASSET_LOADED, weaponHash) and GetGameTimer() < deadline do
        Wait(10)
    end
end

-- ============================================================
-- Exact GUID weapon components
-- ============================================================
--
-- RDR stores a customised gun as a tree of inventory records:
--
--     weapon GUID -> barrel / grip / frame ... -> tint ...
--
-- Giving a component to the visible weapon entity after it has been drawn
-- makes the engine rebuild that entity.  The rebuild is what caused the
-- repeated draw/holster loop and, because the component was not part of the
-- inventory tree, the final rebuilt weapon reverted to stock.  Components are
-- therefore attached to the exact weapon GUID before SET_CURRENT_* is called.

local fitsSlotCache = {}
local hasSlotCache = {}
local bundleParentCache = {}

---@param itemHash number
---@param countNative number
---@param infoNative number
---@param cacheTable table
---@return number[] slots
local function readItemSlots(itemHash, countNative, infoNative, cacheTable)
    local cached = cacheTable[itemHash]
    if cached then return cached end

    local slots = {}
    local seen = {}
    local count = Citizen.InvokeNative(countNative, itemHash, Citizen.ResultAsInteger())
    count = math.max(0, math.floor(tonumber(count) or 0))

    for index = 0, count - 1 do
        local out = DataView.ArrayBuffer(8)
        local ok = Citizen.InvokeNative(infoNative, itemHash, index, out:Buffer())

        if ok and ok ~= 0 then
            local slotHash = out:GetInt32(0)
            if slotHash and slotHash ~= 0 and not seen[slotHash] then
                seen[slotHash] = true
                slots[#slots + 1] = slotHash
            end
        end
    end

    cacheTable[itemHash] = slots
    return slots
end

---@param itemHash number
---@return number[]
local function getFitsSlots(itemHash)
    return readItemSlots(itemHash, ITEMDATABASE_GET_FITS_SLOT_COUNT,
        ITEMDATABASE_GET_FITS_SLOT_INFO, fitsSlotCache)
end

---@param itemHash number
---@return table<number, boolean>
local function getHasSlots(itemHash)
    local list = readItemSlots(itemHash, ITEMDATABASE_GET_HAS_SLOT_COUNT,
        ITEMDATABASE_GET_HAS_SLOT_INFO, hasSlotCache)
    local set = {}

    for i = 1, #list do set[list[i]] = true end
    return set
end

---@param weaponHash number
---@param slotHash number
---@return number? componentHash
local function getDefaultBundleComponentForSlot(weaponHash, slotHash)
    local weaponCache = bundleParentCache[weaponHash]
    if not weaponCache then
        weaponCache = {}
        bundleParentCache[weaponHash] = weaponCache
    end
    if weaponCache[slotHash] ~= nil then
        return weaponCache[slotHash] ~= false and weaponCache[slotHash] or nil
    end

    local bundleId = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ID,
        weaponHash, Citizen.ResultAsInteger())
    if not bundleId or bundleId == 0 then
        weaponCache[slotHash] = false
        return
    end

    local bundleData = DataView.ArrayBuffer(8 * 8)
    bundleData:SetInt32(0, 1)
    local count = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ITEM_COUNT,
        bundleId, bundleData:Buffer(), Citizen.ResultAsInteger())
    count = math.max(0, math.floor(tonumber(count) or 0))

    for index = 0, count - 1 do
        local itemData = DataView.ArrayBuffer(8 * 8)
        local ok = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ITEM_INFO,
            bundleId, bundleData:Buffer(), index, itemData:Buffer())

        if ok and ok ~= 0 then
            local componentHash = itemData:GetInt32(0)
            for _, fitSlot in ipairs(getFitsSlots(componentHash)) do
                if fitSlot == slotHash then
                    weaponCache[slotHash] = componentHash
                    return componentHash
                end
            end
        end
    end

    weaponCache[slotHash] = false
end

--- Every slot of the weapon's default pack: [slotHash] = the default componentHash.
--- The very source of truth the game uses to build the weapon.
---@param weaponHash number
---@return table<number, number>
local bundleSlotMapCache = {}
local function getBundleSlotMap(weaponHash)
    local cached = bundleSlotMapCache[weaponHash]
    if cached then return cached end

    local map = {}
    local bundleId = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ID,
        weaponHash, Citizen.ResultAsInteger())

    if bundleId and bundleId ~= 0 then
        local bundleData = DataView.ArrayBuffer(8 * 8)
        bundleData:SetInt32(0, 1)
        local count = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ITEM_COUNT,
            bundleId, bundleData:Buffer(), Citizen.ResultAsInteger())
        count = math.max(0, math.floor(tonumber(count) or 0))

        for index = 0, count - 1 do
            local itemData = DataView.ArrayBuffer(8 * 8)
            local ok = Citizen.InvokeNative(ITEMDATABASE_GET_BUNDLE_ITEM_INFO,
                bundleId, bundleData:Buffer(), index, itemData:Buffer())

            if ok and ok ~= 0 then
                local componentHash = itemData:GetInt32(0)
                for _, fitSlot in ipairs(getFitsSlots(componentHash)) do
                    if map[fitSlot] == nil then map[fitSlot] = componentHash end
                end
            end
        end
    end

    bundleSlotMapCache[weaponHash] = map
    return map
end

---@param componentHash number
local function streamComponent(componentHash)
    local model = Citizen.InvokeNative(GET_WEAPON_COMPONENT_TYPE_MODEL,
        componentHash, Citizen.ResultAsInteger())

    if not model or model == 0 or not IsModelValid(model) then return end

    -- the library streams the model (2.5 s cap); the hash is returned either way
    pcall(lib.requestModel, model, 2500)
    return model
end

---@param parent any
---@param componentHash number
---@param slotHash number
---@return table? guidView
local function addGuidComponent(parent, componentHash, slotHash)
    -- Default bundle pieces may already exist under a freshly-created weapon.
    -- Reuse that exact child GUID so nested pieces (grip tint, wrap tint, ...)
    -- can be attached to it without creating a duplicate component.
    local existing = getGuid(parent, componentHash, INVENTORY_CHILD_SLOT)
    if existing then
        Citizen.InvokeNative(INVENTORY_EQUIP_ITEM_WITH_GUID, INVENTORY_ID,
            existing:Buffer(), true)
        return existing
    end

    local model = streamComponent(componentHash)
    local child = DataView.ArrayBuffer(GUID_SIZE)
    local added = Citizen.InvokeNative(INVENTORY_ADD_ITEM_WITH_GUID, INVENTORY_ID,
        child:Buffer(), parent, componentHash, slotHash, 1, joaat('ADD_REASON_DEFAULT'))

    if not added or added == 0 then
        if model and HasModelLoaded(model) then SetModelAsNoLongerNeeded(model) end
        return nil
    end

    local equippedOk = Citizen.InvokeNative(INVENTORY_EQUIP_ITEM_WITH_GUID,
        INVENTORY_ID, child:Buffer(), true)

    if not equippedOk or equippedOk == 0 then
        releaseGuid(child:Buffer())
        if model and HasModelLoaded(model) then SetModelAsNoLongerNeeded(model) end
        return nil
    end

    if model and HasModelLoaded(model) then SetModelAsNoLongerNeeded(model) end
    return child
end

---@param plan table?
---@return table[]
local function normalizeComponentPlan(plan)
    local raw = type(plan) == 'table' and (plan.components or plan) or {}
    local entries = {}
    local seen = {}

    for order, value in pairs(raw) do
        local descriptor = type(value) == 'table' and value or { component = value }
        local component = descriptor.component or descriptor.name or descriptor.hash
        local componentHash

        if type(component) == 'number' then
            componentHash = component
        elseif type(component) == 'string' then
            componentHash = joaat(component)
        end

        if componentHash and componentHash ~= 0 and not seen[componentHash] then
            seen[componentHash] = true
            local fits = {}
            local nativeFits = getFitsSlots(componentHash)

            for i = 1, #nativeFits do fits[#fits + 1] = nativeFits[i] end
            local explicitSlot = tonumber(descriptor.slotHash)
            if #fits == 0 and explicitSlot and explicitSlot ~= 0 then
                fits[1] = explicitSlot
            end

            entries[#entries + 1] = {
                hash = componentHash,
                name = type(component) == 'string' and component or tostring(componentHash),
                default = descriptor.default == true,
                priority = tonumber(descriptor.priority) or 50,
                order = tonumber(order) or #entries + 1,
                fits = fits,
                slotHash = explicitSlot,
                forceRoot = descriptor.root == true,
                parentSlotHash = tonumber(descriptor.parentSlotHash),
            }
        end
    end

    table.sort(entries, function(a, b)
        if a.priority ~= b.priority then return a.priority < b.priority end
        if a.default ~= b.default then return a.default end
        if a.order ~= b.order then return a.order < b.order end
        return a.name < b.name
    end)

    -- A selected barrel/grip replaces the factory entry occupying that same
    -- inventory slot.  Do not add both and let the engine fight over which one
    -- is equipped; that was another source of object replacement.
    local customSlots = {}
    for i = 1, #entries do
        local entry = entries[i]
        if not entry.default then
            for j = 1, #entry.fits do customSlots[entry.fits[j]] = true end
        end
    end

    local final = {}
    for i = 1, #entries do
        local entry = entries[i]
        local shadowed = false

        if entry.default then
            for j = 1, #entry.fits do
                if customSlots[entry.fits[j]] then
                    shadowed = true
                    break
                end
            end
        end

        if not shadowed then final[#final + 1] = entry end
    end

    return final
end

---@param rootGuid any
---@param weaponHash number
---@param plan table?
---@return number applied
---@return number requested
local function decorateWeaponGuid(rootGuid, weaponHash, plan)
    local entries = normalizeComponentPlan(plan)
    if #entries == 0 then return 0, 0 end

    local plannedParentSlots = {}
    for i = 1, #entries do
        local entry = entries[i]
        if entry.slotHash then plannedParentSlots[entry.slotHash] = true end
        for j = 1, #entry.fits do plannedParentSlots[entry.fits[j]] = true end
    end

    local nodes = {
        {
            guid = rootGuid,
            hash = weaponHash,
            slots = getHasSlots(weaponHash),
        }
    }
    local pending = {}
    for i = 1, #entries do pending[i] = entries[i] end
    local applied = 0

    local function findParent(entry)
        if entry.forceRoot then
            return nodes[1], entry.slotHash or entry.fits[1]
        end

        -- Explicit nested-parent fallback used for grip tints.  Native slot
        -- discovery remains the primary path and works for every weapon class.
        if entry.parentSlotHash then
            for i = #nodes, 2, -1 do
                if nodes[i].parentSlot == entry.parentSlotHash then
                    return nodes[i], entry.slotHash or entry.fits[1]
                end
            end

            -- A tint may be saved without an explicit grip component because
            -- the stock grip comes from the weapon bundle. Materialize that
            -- exact default child only when no selected plan entry will occupy
            -- the parent slot; this avoids duplicate default/custom grips.
            if not plannedParentSlots[entry.parentSlotHash] then
                local componentHash = getDefaultBundleComponentForSlot(
                    weaponHash, entry.parentSlotHash)
                local child = componentHash and addGuidComponent(
                    nodes[1].guid, componentHash, entry.parentSlotHash)

                if child then
                    local parentNode = {
                        guid = child:Buffer(),
                        hash = componentHash,
                        slots = getHasSlots(componentHash),
                        parentSlot = entry.parentSlotHash,
                    }
                    nodes[#nodes + 1] = parentNode
                    return parentNode, entry.slotHash or entry.fits[1]
                end
            end
        end

        for fitIndex = 1, #entry.fits do
            local slotHash = entry.fits[fitIndex]
            for nodeIndex = #nodes, 1, -1 do
                if nodes[nodeIndex].slots[slotHash] then
                    return nodes[nodeIndex], slotHash
                end
            end
        end

        -- Some decoration entries have incomplete item-database slot metadata.
        -- A known explicit slot is still safe on the root (except nested tints,
        -- which were handled above).
        if entry.slotHash and not entry.parentSlotHash then
            return nodes[1], entry.slotHash
        end

    end

    --- A last resort when the item database returns no slot for the component (the barrel's case and its siblings):
    --- we try the weapon's default pack slots one by one, **and the engine is the one that judges** -
    --- the addition succeeds only if the component really suits the slot. No guessing and no inferred
    --- names: INVENTORY_ADD_ITEM_WITH_GUID's result is the arbiter.
    ---@param entry table
    ---@return table? child
    ---@return number? slotHash
    local function attachByProbing(entry)
        for slotHash in pairs(getBundleSlotMap(weaponHash)) do
            if nodes[1].slots[slotHash] then
                local child = addGuidComponent(nodes[1].guid, entry.hash, slotHash)
                if child then return child, slotHash end
            end
        end
    end

    -- Dependencies are discovered from the item database, so a tint can wait
    -- one pass until its grip/wrap parent has been inserted.
    for _ = 1, #entries + 1 do
        local progressed = false

        for index = #pending, 1, -1 do
            local entry = pending[index]
            local parent, slotHash = findParent(entry)
            local child

            if parent and slotHash then
                child = addGuidComponent(parent.guid, entry.hash, slotHash)
            elseif not parent then
                -- With no known slot: try the pack's slots and let the engine decide
                child, slotHash = attachByProbing(entry)
            end

            if child then
                nodes[#nodes + 1] = {
                    guid = child:Buffer(),
                    hash = entry.hash,
                    slots = getHasSlots(entry.hash),
                    parentSlot = slotHash,
                }
                applied = applied + 1
                table.remove(pending, index)
                progressed = true
            end
        end

        if #pending == 0 or not progressed then break end
    end

    if debugOn then
        print(('^5[dualwield/components]^7 weapon=%s applied=%d requested=%d unresolved=%d')
            :format(weaponHash, applied, #entries, #pending))
        for i = 1, #pending do
            print(('^3[dualwield/components]^7 unresolved: %s'):format(pending[i].name))
        end
    end

    return applied, #entries
end

---@param hand number
---@param weaponHash number
---@return boolean
local function handWeaponReady(hand, weaponHash)
    local object = GetCurrentPedWeaponEntityIndex(cache.ped, hand)
    if not object or object == 0 or not DoesEntityExist(object) then return false end

    local _, currentHash = GetCurrentPedWeapon(cache.ped, hand == 1, hand, true)
    return currentHash == weaponHash
end

--- Putting on a wardrobe item through the GUID database - VORP's own route
local function addWardrobeItem(itemName, slotHash)
    local character = getGuid(nil, `CHARACTER`, `SLOTID_NONE`)

    if not character then return false end

    local wardrobe = getGuid(character:Buffer(), `WARDROBE`, WARDROBE_SLOT)

    if not wardrobe then return false end

    local out = DataView.ArrayBuffer(GUID_SIZE)
    local added = Citizen.InvokeNative(INVENTORY_ADD_ITEM_WITH_GUID, INVENTORY_ID,
        out:Buffer(), wardrobe:Buffer(), joaat(itemName), slotHash, 1, joaat('ADD_REASON_DEFAULT'))

    if not added or added == 0 then return false end

    Citizen.InvokeNative(INVENTORY_EQUIP_ITEM_WITH_GUID, INVENTORY_ID, out:Buffer(), true)

    return true
end

--- The left holster: the two wardrobe items (the holster upgrade + the piece) and the visible component.
--- Without these there is no valid left attach point so everything bounces back to the right holster.
local function ensureOffhandHolster()
    local gender = IsPedMale(cache.ped) and 'M' or 'F'

    addWardrobeItem(('CLOTHING_ITEM_%s_OFFHAND_000_TINT_004'):format(gender), 0xF20B6B4A)
    addWardrobeItem('UPGRADE_OFFHAND_HOLSTER', 0x39E57B01)
    applyLeftHolster()
end

--- Exposed to the hotbar thread: a second pistol placed with no use needs the visible
--- left holster as well
DualWield.EnsureOffhandHolster = ensureOffhandHolster

-- ============================================================
-- The interface
-- ============================================================

---@return boolean
function DualWield.IsEnabled()
    return enabled
end

--- Is this weapon fit for dual wielding? A one-handed pistol and a firearm
---
--- ! InvokeNative with no type specifier does not necessarily return a boolean, so comparing it
--- with == true always fails. We rely on logical truth as VORP does.
---@param hash number
---@return boolean
function DualWield.IsCompatible(hash)
    if not hash then return false end

    if IsWeaponOneHanded(hash) ~= 1 then return false end

    return Citizen.InvokeNative(IS_WEAPON_A_GUN, hash) and true or false
end

---@return number
function DualWield.Count()
    return #equipped
end

--- Is an equip under way right now? The watching threads stand aside as long as it is true
---@return boolean
function DualWield.Busy()
    return busyFlag
end

--- Is this hash for a weapon we track in the hands?
---@param hash number
---@return boolean
function DualWield.HasHash(hash)
    for i = 1, #equipped do
        if equipped[i].hash == hash then return true end
    end

    return false
end

--- Is this bag slot currently held?
---@param slot number
---@return boolean
function DualWield.HasSlot(slot)
    for i = 1, #equipped do
        if equipped[i].slot == slot then return true end
    end

    return false
end

---@param slot number
---@return number? hand
function DualWield.HandForSlot(slot)
    for i = 1, #equipped do
        if equipped[i].slot == slot then return equipped[i].hand end
    end
end

---@param hand number
---@return number? slot
function DualWield.SlotForHand(hand)
    for i = 1, #equipped do
        if equipped[i].hand == hand then return equipped[i].slot end
    end
end

--- Giving the weapon and putting it in a hand
---@param name string the weapon model's name
---@param slot number the bag's slot
---@return boolean success
--- Printing the failure's reason then returning false - enabled with inventory:dualwield_debug 1
---@return false
local function dbg(fmt, ...)
    if debugOn then print(('^1[dualwield]^7 ' .. fmt):format(...)) end
    return false
end

local function giveInner(name, slot, componentPlan)
    local weaponHash = joaat(name)

    local valid = Citizen.InvokeNative(ITEMDATABASE_IS_KEY_VALID, weaponHash, 0)

    if not valid or valid == 0 then
        return dbg('IS_KEY_VALID rejected %s', name)
    end

    local character = getGuid(nil, `CHARACTER`, `SLOTID_NONE`)

    if not character then return dbg('failed to get character GUID') end

    local container = getGuid(character:Buffer(), `CARRIED_WEAPONS`, `SLOTID_CARRIED_WEAPONS`)

    if not container then return dbg('failed to get CARRIED_WEAPONS container GUID') end

    -- ! RDR2 refuses adding or moving an item into an occupied hand slot. And w_inventory
    -- places the weapons through GIVE_DELAYED_WEAPON_TO_PED so they occupy the slot from outside this
    -- system. VORP does not fall into this because it manages the container alone.
    --
    -- And the removal must come before the move: the incoming weapon may occupy the left slot,
    -- so moving the first one into it fails as long as it is there.
    -- Remnants of the old giving occupy the slot so the addition is refused. But removing by the hash
    -- on a twin we track destroys the player's other weapon - so we remove no hash but
    -- one that is not ours. And the removal is not immediate, so we wait for it to really go with a time cap.
    local hadIt = HasPedGotWeapon(cache.ped, weaponHash, 0, false)

    if hadIt and not DualWield.HasHash(weaponHash) then
        RemoveWeaponFromPed(cache.ped, weaponHash)

        local deadline = GetGameTimer() + 600

        while HasPedGotWeapon(cache.ped, weaponHash, 0, false) and GetGameTimer() < deadline do
            Wait(0)
        end
    end

    if debugOn then
        print(('^5[dualwield/pre]^7 wasOnPed=%s | actuallyGone=%s')
            :format(tostring(hadIt), tostring(not HasPedGotWeapon(cache.ped, weaponHash, 0, false))))
    end

    -- ! We track the hand every weapon occupies (hand). And the new one always enters
    -- the right slot (0) - the left slot (1) the engine accepts only as the target of
    -- a move for an already-bound item. Never a direct addition into it.
    local handSlot = 0
    local moved = false

    local function rollbackFirstWeapon()
        if not moved or not equipped[1] then return end

        local first = equipped[1]
        if moveItem(first.guid, container:Buffer(), 0) then
            first.hand = 0
            Citizen.InvokeNative(SET_CURRENT_PED_WEAPON_BY_GUID, cache.ped, first.guid, true, 0, false, false)
        end
    end

    if #equipped == 1 then
        -- The unlocking and the allowing and the left holster - all of them before placing the second hand's weapon,
        -- otherwise the engine refuses and sends everything back to the right holster
        ensureDualUnlock()
        ensureOffhandHolster()

        local first = equipped[1]

        if first.hand ~= 1 then
            if not moveItem(first.guid, container:Buffer(), 1) then
                return dbg('failed to move first weapon to left slot')
            end

            first.hand = 1
            moved = true
        end
    end

    streamAsset(weaponHash)

    local itemData = DataView.ArrayBuffer(GUID_SIZE)
    local slotHash = joaat(('SLOTID_WEAPON_%d'):format(handSlot))

    local added = Citizen.InvokeNative(INVENTORY_ADD_ITEM_WITH_GUID, INVENTORY_ID,
        itemData:Buffer(), container:Buffer(), weaponHash, slotHash, 1, joaat('ADD_REASON_DEFAULT'))

    if debugOn then
        print(('^5[dualwield/add]^7 hash=%s slotHash=%s handSlot=%d added=%s (%s)')
            :format(weaponHash, slotHash, handSlot, tostring(added), type(added)))
    end

    if not added or added == 0 then
        rollbackFirstWeapon()
        return dbg('ADD_ITEM_WITH_GUID failed')
    end

    local equipOk = Citizen.InvokeNative(INVENTORY_EQUIP_ITEM_WITH_GUID, INVENTORY_ID, itemData:Buffer(), true)

    if not equipOk or equipOk == 0 then
        releaseGuid(itemData:Buffer())
        rollbackFirstWeapon()
        return dbg('EQUIP_ITEM_WITH_GUID failed')
    end

    -- ── The components in the GUID tree: disabled on purpose ─────────────────────────────
    --
    -- It was tried twice and failed twice for the same reason: the engine accepts some components as children
    -- and refuses others (the barrel and its derivatives specifically: applied=1 out of 7), and what is refused leaves
    -- the weapon in an inconsistent state so the engine rebuilds it <- an endless holster/draw loop.
    -- It is enabled by hand for experiment only: setr w_inventory:guidComponents 1
    local customApplied, customRequested = 0,
        (type(componentPlan) == 'table' and type(componentPlan.components) == 'table')
        and #componentPlan.components or 0

    if GetConvarInt('w_inventory:guidComponents', 0) == 1 then
        customApplied = decorateWeaponGuid(itemData:Buffer(), weaponHash, componentPlan) or 0
    end

    Citizen.InvokeNative(SET_CURRENT_PED_WEAPON_BY_GUID, cache.ped, itemData:Buffer(), true, handSlot, false, false)

    if moved then
        -- The first one moved to the right, so we pin it back there
        Citizen.InvokeNative(SET_CURRENT_PED_WEAPON_BY_GUID, cache.ped, equipped[1].guid, true, 1, false, false)
    end

    -- The inventory state is committed only after RDR exposes a real entity in
    -- every requested hand. SET_CURRENT_PED_WEAPON_BY_GUID has no useful return
    -- value and can silently fail when a hand slot remains occupied. Without
    -- this check the bag reported used=true while the engine object was 0.
    local deadline = GetGameTimer() + 1000
    local ready
    repeat
        ready = handWeaponReady(handSlot, weaponHash)
            and (not moved or handWeaponReady(1, equipped[1].hash))
        if ready then break end
        Wait(0)
    until GetGameTimer() >= deadline

    if not ready then
        releaseGuid(itemData:Buffer())
        rollbackFirstWeapon()
        return dbg('weapon object did not settle in the requested hand')
    end

    equipped[#equipped + 1] = {
        slot = slot,
        guid = itemData:Buffer(),
        hash = weaponHash,
        hand = handSlot,
        name = name,
        serial = PlayerData and PlayerData.inventory and PlayerData.inventory[slot]
            and PlayerData.inventory[slot].metadata
            and (PlayerData.inventory[slot].metadata.serial or PlayerData.inventory[slot].metadata.serial_number),
        customApplied = customApplied,
        customRequested = customRequested,
    }

    -- The spontaneous-disappearance detector: it watches for five seconds and prints the moment the weapon
    -- goes off the character with no intended holstering - to tell a deferred cleanup or
    -- an external script's interference from our own errors.
    if debugOn then
        local gen = generation
        local t0 = GetGameTimer()

        CreateThread(function()
            while GetGameTimer() - t0 < 5000 do
                Wait(250)

                if generation ~= gen then return end -- holstered on purpose

                if not HasPedGotWeapon(cache.ped, weaponHash, 0, false) then
                    print(('^1[dualwield/vanish]^7 %s vanished on its own after %d ms!')
                        :format(name, GetGameTimer() - t0))
                    return
                end
            end

            print(('^2[dualwield/vanish]^7 %s survived 5s - stable'):format(name))
        end)
    end

    return true
end

--- The general wrapper: it raises the busy flag so the watching threads in
--- client.lua stand aside for the whole equip - the hand's flipping during it used to provoke them so they holstered
--- what had just been equipped or drew another weapon.
function DualWield.Give(name, slot, componentPlan)
    busyFlag = true

    local called, ok = pcall(giveInner, name, slot, componentPlan)

    busyFlag = false

    if not called then return dbg('equip transaction failed: %s', tostring(ok)) end
    return ok == true
end

--- The other slot carrying the same weapon hash, if there is one.
--- The engine stores the ammunition per hash and not per item, so these two share one pool.
---@param slot number
---@return number? twinSlot
function DualWield.Twin(slot)
    local hash

    for i = 1, #equipped do
        if equipped[i].slot == slot then
            hash = equipped[i].hash
            break
        end
    end

    if not hash then return end

    for i = 1, #equipped do
        if equipped[i].slot ~= slot and equipped[i].hash == hash then
            return equipped[i].slot
        end
    end
end

--- The slots held right now, in order
---@return number[]
function DualWield.Slots()
    local out = {}

    for i = 1, #equipped do
        out[i] = equipped[i].slot
    end

    return out
end

--- Return a detached snapshot of the real hand assignments.
--- VORP semantics are preserved:
---   used=true  => the weapon is equipped
---   used2=true => the current/right-hand weapon of a dual pair
---@return table[] hands
function DualWield.State()
    local out = {}
    local isDual = #equipped > 1

    for i = 1, #equipped do
        local entry = equipped[i]
        out[#out + 1] = {
            slot = entry.slot,
            hand = entry.hand,
            hash = entry.hash,
            used = true,
            used2 = isDual and entry.hand == 0 or false,
            customApplied = tonumber(entry.customApplied) or 0,
            customRequested = tonumber(entry.customRequested) or 0,
        }
    end

    return out
end

--- Draw the existing GUIDs without recreating weapons or changing usage/ammo.
--- Swapping occupied hand slots requires the normal inventory equip transaction.
---@param slots number[] right hand first, then left hand
---@return boolean
---@return string?
function DualWield.Draw(slots)
    if busyFlag then return false, 'busy' end
    if type(slots) ~= 'table' or #slots < 1 or #slots > 2 or #slots ~= #equipped then
        return false, 'loadout_changed'
    end

    local ordered, seen = {}, {}
    for index, requested in ipairs(slots) do
        local slot = tonumber(requested)
        if not slot or seen[slot] then return false, 'invalid_weapon' end
        seen[slot] = true
        for _, entry in ipairs(equipped) do
            if entry.slot == slot then ordered[index] = entry break end
        end
        local entry = ordered[index]
        local item = PlayerData and PlayerData.inventory and PlayerData.inventory[slot]
        local metadata = item and item.metadata or {}
        local serial = metadata.serial or metadata.serial_number
        if not entry or not entry.guid or not item or joaat(item.name) ~= entry.hash
            or (entry.serial == nil) ~= (serial == nil)
            or (entry.serial ~= nil and tostring(entry.serial) ~= tostring(serial)) then
            return false, 'loadout_changed'
        end
    end
    for index, entry in ipairs(ordered) do
        if #ordered == 2 and entry.hand ~= index - 1 then return false, 'hand_mismatch' end
    end

    busyFlag = true
    local called, result = pcall(function()
        for _, entry in ipairs(ordered) do
            Citizen.InvokeNative(SET_CURRENT_PED_WEAPON_BY_GUID, cache.ped,
                entry.guid, false, entry.hand, false, false)
        end
        local deadline = GetGameTimer() + 1200
        repeat
            local ready = true
            for _, entry in ipairs(ordered) do
                if not handWeaponReady(entry.hand, entry.hash) then ready = false break end
            end
            if ready then return true end
            Wait(0)
        until GetGameTimer() >= deadline
        return false
    end)
    busyFlag = false
    if not called then return false, 'engine_failed' end
    return result == true, result ~= true and 'draw_failed' or nil
end

--- Atomically remap tracked inventory slots after an in-inventory slot swap.
--- GUIDs and hand assignments stay unchanged; only the bag identity moves.
---@param mapping table<number, number>
---@return boolean
function DualWield.RemapSlots(mapping)
    if type(mapping) ~= 'table' then return false end

    local nextSlots = {}

    for i = 1, #equipped do
        local current = equipped[i].slot
        local replacement = tonumber(mapping[current]) or current

        if replacement < 1 or replacement % 1 ~= 0 or nextSlots[replacement] then
            return false
        end

        nextSlots[replacement] = true
    end

    for i = 1, #equipped do
        equipped[i].slot = tonumber(mapping[equipped[i].slot]) or equipped[i].slot
    end

    return true
end

--- Do we take over equipping this weapon? And if so we do it.
--- It returns false so the ordinary path carries on.
---@param name string
---@param hash number
---@param slot number
---@return boolean handled
---@return boolean? success
---@return string? reason
function DualWield.Equip(name, hash, slot, componentPlan)
    -- Temporary diagnostics: setr inventory:dualwield_debug 1
    local function log(fmt, ...)
        if debugOn then print(('^3[dualwield]^7 ' .. fmt):format(...)) end
    end

    log('request %s | held=%d | enabled=%s | holsterNeeded=%s',
        name, #equipped, tostring(enabled), tostring(holsterNeeded))

    if not enabled then
        log('rejected: feature disabled')
        return false
    end

    -- A guard against the side paths (the hotbar and others): an already-held weapon is not
    -- added again - we count it handled so it does not pass through the ordinary giving either
    if DualWield.HasSlot(slot) then
        log('weapon already held - ignoring')
        return true, true
    end

    if IsWeaponOneHanded(hash) ~= 1 then
        log('rejected: not one-handed')
        return false
    end

    if not DualWield.IsCompatible(hash) then
        log('rejected: not a firearm')
        return false
    end

    -- A third weapon: no
    if #equipped >= 2 then
        log('rejected: both hands full')
        return true, false, 'hands_full'
    end

    if #equipped == 1 then
        local holster = hasLeftHolster()

        log('left holster present: %s', tostring(holster))

        if holsterNeeded and not holster then
            log('rejected: no left holster')
            return true, false, 'left_holster_required'
        end
    end

    local ok = DualWield.Give(name, slot, componentPlan)

    log('result: %s | heldNow=%d', tostring(ok), #equipped)

    return true, ok == true, ok == true and nil or 'engine_failed'
end

--- Forgetting one slot, or all of them when no slot is passed
---@param slot number?
-- _INVENTORY_REMOVE_GUID - it wipes the item's record from the GUID database.
-- ! RemoveWeaponFromPed removes the visible weapon only and leaves its record occupying
-- the hand's slot, so any move into it afterwards fails. VORP uses this native for this
-- very reason.
function DualWield.Forget(slot)
    generation = generation + 1

    if not slot then
        for i = 1, #equipped do
            releaseGuid(equipped[i].guid)
        end

        equipped = {}
        return
    end

    local removed = false

    for i = #equipped, 1, -1 do
        if equipped[i].slot == slot then
            releaseGuid(equipped[i].guid)
            table.remove(equipped, i)
            removed = true

            if debugOn then
                print(('^5[dualwield/forget]^7 freed slot %d and erased its record'):format(slot))
            end
        end
    end

    -- One is left after its companion was holstered and it is in the left slot: we return it to the right
    -- as a single weapon (VORP's route) - otherwise it stuck there and the next dual wield failed
    if removed and #equipped == 1 and equipped[1].hand == 1 then
        local character = getGuid(nil, `CHARACTER`, `SLOTID_NONE`)
        local container = character and getGuid(character:Buffer(), `CARRIED_WEAPONS`, `SLOTID_CARRIED_WEAPONS`)

        if container and moveItem(equipped[1].guid, container:Buffer(), 0) then
            equipped[1].hand = 0
            Citizen.InvokeNative(SET_CURRENT_PED_WEAPON_BY_GUID, cache.ped, equipped[1].guid, true, 0, false, false)

            if debugOn then
                print('^5[dualwield/forget]^7 returned remaining weapon to right holster')
            end
        end
    end
end

-- The dual-wield state for the external interfaces (the w_weaponwheel weapon wheel): read only.
-- hand: 0 = the right hand (the primary), 1 = the left hand (the secondary).
exports('getDualWieldState', function()
    local hands = DualWield.State()
    local out = { count = #hands, hands = hands }

    for i = 1, #hands do
        local item = PlayerData and PlayerData.inventory and PlayerData.inventory[hands[i].slot]
        local metadata = item and item.metadata
        hands[i].serial = metadata and metadata.serial
        hands[i].name = item and item.name
    end

    return out
end)

-- Public compatibility alias: same payload and VORP-style used/used2 flags.
exports('getWeaponUsageState', function()
    local hands = DualWield.State()
    local primary

    for i = 1, #hands do
        local item = PlayerData and PlayerData.inventory and PlayerData.inventory[hands[i].slot]
        local metadata = item and item.metadata
        hands[i].serial = metadata and metadata.serial
        hands[i].name = item and item.name
        if hands[i].hand == 0 then primary = hands[i].slot end
    end

    return { count = #hands, hands = hands, primary = primary }
end)

return DualWield
