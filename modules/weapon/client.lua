if not lib then return end
if shared.nativeRsgWeapons then return require 'modules.weapon.rsg' end

local Weapon = {}
local Items = require 'modules.items.client'
local Utils = require 'modules.utils.client'
local DualWield = require 'modules.weapon.dualwield'
local AmmoTypes = lib.load('data.ammo_types_RDR3')

--- A registry of 'this weapon's balance is already injected into the engine's pool'.
--- The RDR3 system pools the ammunition by type and not by weapon, so two weapons of one type
--- share one pool. We build the pool from the balances once at the first carry,
--- then we let the firing manage it. Without this registry every re-equip refills it from
--- old metadata = duping. It is cleared on holstering/removal.
-- RDR3 owns ammunition as one pool per ammo type, not one pool per inventory
-- weapon. Keep a single inventory slot as the owner of each live engine pool;
-- every other held weapon using that ammo type is stored as zero. This is the
-- same invariant VORP relies on and prevents both duplication and lost rounds.
local ammoPoolOwner = {}
local dualClipAmmo = {}
local lastFiredHand = 1

function Weapon.ClearAmmoPool(slot)
	if not slot then
		table.wipe(ammoPoolOwner)
		return
	end

	for ammoType, owner in pairs(ammoPoolOwner) do
		if owner == slot then ammoPoolOwner[ammoType] = nil end
	end
end

--- Exposed to client.lua so it reads the two hands' state
Weapon.DualWield = DualWield


local function usageFlag(value)
	return value == true or value == 1 or value == '1'
end

--- Apply used/used2 to the exact local slot objects immediately. The server
--- remains authoritative and returns the normalized state afterwards.
---@param hands table[]
local function applyLocalUsage(hands)
	local bySlot = {}

	for i = 1, #(hands or {}) do
		local row = hands[i]
		local slot = tonumber(row and row.slot)
		if slot then bySlot[slot] = row end
	end

	for slot, slotData in pairs(PlayerData and PlayerData.inventory or {}) do
		local item = slotData and Items[slotData.name]
		if item and item.weapon then
			local row = bySlot[tonumber(slotData.slot) or tonumber(slot)]
			local used = row ~= nil
			local used2 = used and usageFlag(row.used2) or false

			slotData.metadata = slotData.metadata or {}
			slotData.metadata.used = used
			slotData.metadata.used2 = used2
			slotData.metadata.weaponHand = used and tonumber(row.hand) or nil
			slotData.used = used
			slotData.used2 = used2
		end
	end
end

--- Build a VORP-compatible usage snapshot without collapsing identical guns
--- by hash. Slot + serial remain the identity and hand 0 is the current gun.
---@param currentWeapon table?
---@return table state
function Weapon.GetUsageState(currentWeapon)
	local hands = DualWield.State()

	if #hands == 0 and currentWeapon and currentWeapon.slot then
		hands[1] = {
			slot = tonumber(currentWeapon.slot),
			hand = 0,
			hash = currentWeapon.hash,
			used = true,
			used2 = false,
		}
	end

	local isDual = #hands > 1

	for i = 1, #hands do
		local row = hands[i]
		local slotData = PlayerData and PlayerData.inventory and PlayerData.inventory[tonumber(row.slot)]
		local metadata = slotData and slotData.metadata or {}
		row.slot = tonumber(row.slot)
		row.hand = tonumber(row.hand) or 0
		row.name = slotData and slotData.name or row.name
		row.hash = row.hash or (row.name and joaat(row.name))
		row.serial = metadata.serial
		row.used = true
		row.used2 = isDual and row.hand == 0 or false
	end

	return { count = #hands, hands = hands }
end

--- Persist the exact hand state. A callback is used instead of a fire-and-
--- forget event so rapid draw/holster actions cannot commit out of order.
---@param currentWeapon table?
---@return boolean success
function Weapon.SyncUsage(currentWeapon)
	local state = Weapon.GetUsageState(currentWeapon)
	applyLocalUsage(state.hands)

	if not PlayerData or not PlayerData.source then return false end

	local called, ok, normalized = pcall(function()
		return lib.callback.await('w_inventory:setWeaponUsageState', false, state.hands)
	end)

	if called and ok == true and type(normalized) == 'table' then
		applyLocalUsage(normalized.hands or {})
		TriggerEvent('w_inventory:weaponUsageChanged', normalized)
		return true
	end

	return false
end

---@param mapping table<number, number>
---@param currentWeapon table?
---@return table? currentWeapon
function Weapon.RemapUsageSlots(mapping, currentWeapon)
	if type(mapping) ~= 'table' then return currentWeapon end

	local normalized = {}
	for oldSlot, newSlot in pairs(mapping) do
		oldSlot, newSlot = tonumber(oldSlot), tonumber(newSlot)
		if oldSlot and newSlot then normalized[oldSlot] = newSlot end
	end

	DualWield.RemapSlots(normalized)

	if currentWeapon and normalized[tonumber(currentWeapon.slot)] then
		currentWeapon.slot = normalized[tonumber(currentWeapon.slot)]
	end

	return currentWeapon
end

--- The bullet type's hash in the game (AMMO_XXX) for the weapon.
--- After the names were unified, ammoname became an item's name (ammorevolvernormal), and hashing it
--- does not give the type the RDR3 natives expect, so we take it from ammoType.
---@param data table the weapon's data from Items
---@param metadata table? the weapon slot's data
---@return number
local function getAmmoTypeHash(data, metadata)
	local special = metadata and metadata.specialAmmo
	local ammoType
	local family = data.ammoFamily

	if special ~= nil then
		-- Normalize every supported representation to the native AMMO_* name:
		-- VORP item name, w_inventory item name, numeric hash, old family alias,
		-- structured legacy metadata, or AMMO_*.
		local specialItem = type(special) == 'string' and Items[special] or nil
		ammoType = specialItem and specialItem.ammoType

		if not ammoType and AmmoTypes and family then
			local resolved = AmmoTypes.Resolve(family, special, function(name)
				return Items[name] ~= nil
			end)
			ammoType = resolved and resolved.ammo
		end

		if not ammoType and type(special) == 'string'
			and family and special:lower() == tostring(family):lower() then
			local default = AmmoTypes and AmmoTypes.GetDefault(family)
			ammoType = default and default.ammo
		end

		if not ammoType and type(special) == 'string' and special:upper():find('^AMMO_') then
			ammoType = special:upper()
		end
	end

	-- The melee weapons (the knives/the axes) have no ammunition type at all. GetHashKey(nil)
	-- in CfxLua is not safe, and passing a phantom type to the ammunition natives messes with the weapon's
	-- state, so we return 0 and the caller skips it.
	local name = ammoType or data.ammoType or data.ammoname
	if type(name) ~= 'string' or name == '' then return 0 end

	return GetHashKey(name)
end

local function statusValue(value, fallback)
	value = tonumber(value)
	if not value or value ~= value then value = fallback or 0.0 end
	return math.max(0.0, math.min(1.0, value))
end

local function nativeTrue(value)
	return value == true or value == 1
end

local function getWeaponObject(weaponHash, slot)
	local preferred = DualWield.HandForSlot and DualWield.HandForSlot(slot)

	local function atAttachPoint(attachPoint)
		local entity = GetCurrentPedWeaponEntityIndex(cache.ped, attachPoint)
		if not entity or entity == 0 or not DoesEntityExist(entity) then return end

		local _, heldHash = GetCurrentPedWeapon(cache.ped, true, attachPoint, false)
		if heldHash == weaponHash then return entity end
		if not weaponHash or heldHash == 0 or heldHash == unarmedHash then return entity end
	end

	if preferred ~= nil then
		local object = atAttachPoint(preferred)
		if object and object ~= 0 then return object end
	end

	local mainObject = atAttachPoint(0)
	if mainObject and mainObject ~= 0 then return mainObject end

	local offObject = atAttachPoint(1)
	if offObject and offObject ~= 0 then return offObject end

	for attachPoint = 2, 29 do
		local object = atAttachPoint(attachPoint)
		if object and object ~= 0 then return object end
	end
end

local function applyWeaponStatus(item, data)
	local deadline = GetGameTimer() + 3000
	local object

	repeat
		object = getWeaponObject(data.hash, item.slot)
		if object then break end
		Wait(0)
	until GetGameTimer() >= deadline

	if not object then return end

	local raw = type(item.metadata.weaponStatus) == 'table' and item.metadata.weaponStatus or {}
	local conditionLoss = (100 - math.max(0, math.min(100, tonumber(item.metadata.durability) or 100))) / 100
	local status = {
		degradation = statusValue(raw.degradation, conditionLoss),
		damage = statusValue(raw.damage, conditionLoss),
		dirt = statusValue(raw.dirt, 0.0),
		soot = statusValue(raw.soot, 0.0),
	}

	item.metadata.weaponStatus = status
	SetWeaponDegradation(object, status.degradation)
	SetWeaponDamage(object, status.damage, false)
	SetWeaponDirt(object, status.dirt, false)
	SetWeaponSoot(object, status.soot, false)
	TriggerEvent('w_inventory:equippedWeaponDegradationIsReady', item.slot)
end

function Weapon.CaptureStatus(item)
	if not item or not item.metadata or not item.hash then return end

	local object = getWeaponObject(item.hash, item.slot)
	if not object then return end

	local status = {
		degradation = statusValue(GetWeaponDegradation(object)),
		damage = statusValue(GetWeaponDamage(object)),
		dirt = statusValue(GetWeaponDirt(object)),
		soot = statusValue(GetWeaponSoot(object)),
	}

	item.metadata.weaponStatus = status
	TriggerServerEvent('w_inventory:updateWeapon', 'status', status, item.slot)
	return status
end

local TASK_ITEM_INTERACTION = 0xAE72E7DF013AAA61
local IS_PED_RUNNING_INSPECTION_TASK = 0x038B1F1674F0E242
local IS_WEAPON_ONE_HANDED = 0xD955FEE4B87AFA07
local IS_WEAPON_TWO_HANDED = 0x0556E9D2ECF39D01
local GET_WEAPON_PERMANENT_DEGRADATION = 0xD56E5F336C675EFA
local SET_PED_BLACKBOARD_BOOL = 0xCB9401F918CB0F75

local function weaponInteraction(item, phase)
	if not item or not item.hash then return end

	local oneHanded = nativeTrue(Citizen.InvokeNative(IS_WEAPON_ONE_HANDED, item.hash))
	local twoHanded = not oneHanded
		and nativeTrue(Citizen.InvokeNative(IS_WEAPON_TWO_HANDED, item.hash))
	if not oneHanded and not twoHanded then return end

	local prefix = oneHanded and 'SHORTARM_' or 'LONGARM_'
	return GetHashKey(prefix .. phase)
end

---Read the exact held object's live RDR wear without trusting a hash-only
---lookup. The slot-to-hand map keeps identical dual revolvers separated.
---@param item table
---@return table
function Weapon.GetMaintenanceStatus(item)
	local raw = item and item.metadata and item.metadata.weaponStatus or {}
	local status = {
		degradation = statusValue(raw and raw.degradation, 0.0),
		damage = statusValue(raw and raw.damage, 0.0),
		dirt = statusValue(raw and raw.dirt, 0.0),
		soot = statusValue(raw and raw.soot, 0.0),
	}

	if not item or not item.hash then return status end

	local object = getWeaponObject(item.hash, item.slot)
	if object then
		status.degradation = statusValue(GetWeaponDegradation(object), status.degradation)
		status.damage = statusValue(GetWeaponDamage(object), status.damage)
		status.dirt = statusValue(GetWeaponDirt(object), status.dirt)
		status.soot = statusValue(GetWeaponSoot(object), status.soot)
	end

	item.metadata.weaponStatus = status
	return status
end

---@param item table
---@param state table
function Weapon.ApplyMaintenanceState(item, state)
	if not item or not item.metadata or type(state) ~= 'table' then return false end

	item.metadata.durability = tonumber(state.condition) or item.metadata.durability
	item.metadata.weaponStatus = {
		degradation = statusValue(state.degradation, 0.0),
		damage = statusValue(state.damage, 0.0),
		dirt = statusValue(state.dirt, 0.0),
		soot = statusValue(state.soot, 0.0),
	}

	local object = item.hash and getWeaponObject(item.hash, item.slot)
	if not object then return false end

	local okPerm, permanent = pcall(function()
		return Citizen.InvokeNative(GET_WEAPON_PERMANENT_DEGRADATION, object, Citizen.ResultAsFloat())
	end)
	permanent = (okPerm and tonumber(permanent)) or 0.0
	local status = item.metadata.weaponStatus

	local targetDegradation = (status.degradation <= 0.0) and 0.0 or math.max(permanent, status.degradation)
	local targetDamage = (status.damage <= 0.0) and 0.0 or math.max(permanent, status.damage)

	SetWeaponDegradation(object, targetDegradation)
	SetWeaponDamage(object, targetDamage, false)
	SetWeaponDirt(object, status.dirt, false)
	SetWeaponSoot(object, status.soot, false)
	return true
end

---@param item table
---@return boolean
function Weapon.BeginInspection(item)
	if not item or not item.hash or not nativeTrue(IsWeaponAGun(item.hash)) then return false end

	local interaction = weaponInteraction(item, 'HOLD_ENTER')
	if not interaction then return false end

	Citizen.InvokeNative(SET_PED_BLACKBOARD_BOOL, cache.ped,
		'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', false, -1)
	Citizen.InvokeNative(TASK_ITEM_INTERACTION, cache.ped, item.hash, interaction, 1, 0, 0)
	return true
end

---@param item table
---@param duration number
---@param finalState table
---@return boolean
function Weapon.PlayCleaningInspection(item, duration, finalState)
	if not item or not item.hash then return false end

	local cleanInteraction = weaponInteraction(item, 'CLEAN_ENTER')
	local holdInteraction = weaponInteraction(item, 'HOLD_ENTER')
	if not cleanInteraction or not holdInteraction then return false end

	local object = getWeaponObject(item.hash, item.slot)
	local initial = Weapon.GetMaintenanceStatus(item)
	duration = math.max(800, math.floor(tonumber(duration) or 2800))

	Citizen.InvokeNative(SET_PED_BLACKBOARD_BOOL, cache.ped,
		'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', true, -1)
	Citizen.InvokeNative(TASK_ITEM_INTERACTION, cache.ped, item.hash, cleanInteraction, 1, 0, 0)

	local started = GetGameTimer()
	while GetGameTimer() - started < duration do
		if IsEntityDead(cache.ped) or IsPedDeadOrDying(cache.ped, true) then break end

		if object then
			local progress = math.min(1.0, (GetGameTimer() - started) / duration)
			SetWeaponDegradation(object, math.max(0.0, initial.degradation * (1.0 - progress)))
			SetWeaponDamage(object, math.max(0.0, initial.damage * (1.0 - progress)), false)
			SetWeaponDirt(object, math.max(0.0, initial.dirt * (1.0 - progress)), false)
			SetWeaponSoot(object, math.max(0.0, initial.soot * (1.0 - progress)), false)
		end

		Wait(0)
	end

	Citizen.InvokeNative(SET_PED_BLACKBOARD_BOOL, cache.ped,
		'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', false, -1)
	Weapon.ApplyMaintenanceState(item, finalState)

	if not IsEntityDead(cache.ped) and not IsPedDeadOrDying(cache.ped, true) then
		Citizen.InvokeNative(TASK_ITEM_INTERACTION, cache.ped, item.hash, holdInteraction, 1, 0, 0)
	end

	return true
end

function Weapon.IsInspecting()
	return nativeTrue(Citizen.InvokeNative(IS_PED_RUNNING_INSPECTION_TASK, cache.ped))
end

function Weapon.EndInspection()
	Citizen.InvokeNative(SET_PED_BLACKBOARD_BOOL, cache.ped,
		'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', false, -1)

	-- EndInspection is only called for a wheel-owned inspection session. Clear
	-- unconditionally because the native may briefly report false while moving
	-- between HOLD and CLEAN phases, otherwise the ped can remain stuck posing.
	ClearPedTasks(cache.ped, true, false)
end

--- * The equipped slot outside the two-hand registry.
---
--- DualWield.Equip refuses anything that is not a one-handed firearm pistol (IsWeaponOneHanded
--- then IsCompatible), so the bow and the long guns and the melee weapons never enter `equipped` and never
--- show in DualWield.Slots().
---
--- And heldSlotsForAmmo used to read that registry alone, so it came back **empty** for a carried bow.
--- Then applyAmmoSeparation computes the total as zero and writes
--- SetPedAmmoByType(AMMO_ARROW, 0) - that is, it wipes the bow's arrows on every equip or
--- shot or reload. And this is the cause of 'the bow does not load'.
local singleHeldSlot

--- Every slot really carried: the two tracked hands + the single weapon.
---@return number[]
local function heldSlots()
	local out, seen = {}, {}

	for _, heldSlot in ipairs(DualWield.Slots()) do
		local slot = tonumber(heldSlot)
		if slot and not seen[slot] then
			seen[slot] = true
			out[#out + 1] = slot
		end
	end

	if singleHeldSlot and not seen[singleHeldSlot] then
		out[#out + 1] = singleHeldSlot
	end

	return out
end

--- The only source for 'what is carried now'. Everyone who computes or displays
--- or diagnoses must read from it - two different sources mean a diagnostic that contradicts the accounting.
Weapon.HeldSlots = heldSlots

--- For the diagnostics alone: where every slot came from.
---@return number[] dual
---@return number? single
function Weapon.HeldSources()
	return DualWield.Slots(), singleHeldSlot
end

---@param ammoTypeHash number
---@param excludedSlot number?
---@return number[]
local function heldSlotsForAmmo(ammoTypeHash, excludedSlot)
	local slots = {}

	for _, heldSlot in ipairs(heldSlots()) do
		if heldSlot ~= excludedSlot then
			local heldItem = PlayerData.inventory and PlayerData.inventory[heldSlot]
			local heldData = heldItem and Items[heldItem.name]

			if heldData and heldData.ammoType
				and getAmmoTypeHash(heldData, heldItem.metadata) == ammoTypeHash then
				slots[#slots + 1] = heldSlot
			end
		end
	end

	return slots
end

--- How many carried weapons share this bullet type? The reload path needs it to know
--- when the loading task on the ped becomes a danger to the companion.
---@param ammoTypeHash number
---@return number[]
function Weapon.HeldSlotsForAmmo(ammoTypeHash)
	return heldSlotsForAmmo(ammoTypeHash)
end

--- This slot's bullet type **as the separation sees it** - from the weapon and its metadata.
---
--- ! Do not ask the loaded bullet item about its type: it may not declare ammoType at all, and its
--- normalisation may differ from the one heldSlotsForAmmo compares against. And any difference here means that
--- the 'two weapons share the type' guard falls silently and the loading task goes back to messing with the companion.
---@param slot number
---@return number ammoTypeHash zero for what has no ammunition
function Weapon.AmmoTypeForSlot(slot)
	local slotData = PlayerData and PlayerData.inventory and PlayerData.inventory[tonumber(slot) or -1]
	local itemData = slotData and Items[slotData.name]

	if not itemData then return 0 end
	return getAmmoTypeHash(itemData, slotData.metadata) or 0
end

-- ════════════════ The gunsmith's modifications -> the weapon's power ════════════════
--
-- The components are kept in the weapon's metadata (gunComps from w_gunsmith, and the native
-- components), and the metadata comes from the server - so the client cannot invent a piece it
-- does not own. The computation here is a reading of that data and no more.

local WeaponMods = lib.load('data.weapon_mods') or {}
local modCache = {}

--- Classifying a piece from its name: COMPONENT_SHORTARM_BARREL_MATERIAL_7 -> BARREL, 7
---@param name string
---@return string? part
---@return number materialLevel 0..1
local function classifyComponent(name)
    if type(name) ~= 'string' or name == '' then return nil, 0 end

    local upper = name:upper()

    -- The engravings and the colours are pure appearance
    for _, word in ipairs(WeaponMods.cosmetic or {}) do
        if upper:find(word, 1, true) then return nil, 0 end
    end

    -- The material's number scales the effect (it defaults to the highest if it is not stated)
    local level = tonumber(upper:match('MATERIAL_(%d+)')) or 10
    level = math.max(0, math.min(1, level / 10))

    -- The longest matching part name wins (GRIPSTOCK before GRIP and STOCK)
    local best
    for part in pairs(WeaponMods.parts or {}) do
        if upper:find(part, 1, true) and (not best or #part > #best) then best = part end
    end

    return best, level
end

--- The total of a particular weapon's modifications.
---@param item table the weapon's slot (it carries metadata)
---@return table stats increases in points for every statistic
---@return number damageMultiplier the real damage multiplier (1.0 = no modification)
function Weapon.GetModifiers(item)
    local metadata = item and item.metadata
    if not metadata then return {}, 1.0 end

    -- A simple fingerprint is enough for the cache: the modifications do not change except through the gunsmith
    local names = {}
    for _, comp in pairs(metadata.gunComps or {}) do
        if type(comp) == 'string' then names[#names + 1] = comp end
    end
    for i = 1, #(metadata.components or {}) do
        local comp = metadata.components[i]
        if type(comp) == 'string' then names[#names + 1] = comp end
    end

    if #names == 0 then return {}, 1.0 end

    table.sort(names)
    local key = table.concat(names, '|')
    local cached = modCache[key]
    if cached then return cached.stats, cached.multiplier end

    local stats = {}

    for i = 1, #names do
        local part, level = classifyComponent(names[i])
        local bonus = part and WeaponMods.parts[part]

        if bonus and level > 0 then
            for stat, value in pairs(bonus) do
                stats[stat] = (stats[stat] or 0) + value * level
            end
        end
    end

    -- The caps stop the pieces accumulating without limit
    for stat, value in pairs(stats) do
        local cap = WeaponMods.caps and WeaponMods.caps[stat]
        stats[stat] = math.floor(cap and math.min(value, cap) or value + 0.5)
    end

    local multiplier = 1.0 + (stats.damage or 0) * (WeaponMods.damagePerPoint or 0)
    multiplier = math.max(1.0, math.min(WeaponMods.maxDamageMultiplier or 1.25, multiplier))

    modCache[key] = { stats = stats, multiplier = multiplier }
    return stats, multiplier
end

--- Applying the damage multiplier to the held weapon (and returning it to 1.0 on holstering).
--- ! The native addresses the weapon by the hash and not by the copy, so two identical weapons share
--- the multiplier. We apply the drawn copy's multiplier, and that is the practically expected behaviour.
---@param item table?
---@param reset boolean?
function Weapon.ApplyDamageModifier(item, reset)
    local data = item and Items[item.name]
    local hash = item and (item.hash or (data and data.hash))
    if not hash then return end

    local multiplier = 1.0
    if not reset then
        local _, value = Weapon.GetModifiers(item)
        multiplier = value or 1.0
    end

    -- SET_PLAYER_WEAPON_TYPE_DAMAGE_MODIFIER: the player's damage with this weapon type
    pcall(function()
        Citizen.InvokeNative(0xD04AD186CE8BB129, PlayerId(), hash, multiplier + 0.0)
    end)
end

--- One weapon's store capacity (not the two hands' total).
local clipCapacityCache = {}

-- The magazine cap - the very same rule in the shared config.lua. It is needed here too:
-- this function writes the engine's store, so if it exceeded the bag's cap the weapon would carry rounds the
-- accounting does not know.
local AMMO_CLIP_CAP = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.ClipCap) or 10))
local AMMO_BOW_CAP  = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.BowCap) or 25))

local function clipCapacity(itemData)
	if not itemData or not itemData.hash then return 0 end

	if itemData.hash == `WEAPON_BOW` or itemData.hash == `WEAPON_BOW_IMPROVED` then
		return AMMO_BOW_CAP
	end

	local configured = tonumber(itemData.clipSize)
	if configured and configured > 0 then
		return math.min(math.floor(configured), AMMO_CLIP_CAP)
	end

	local cached = clipCapacityCache[itemData.hash]
	if cached then return cached end

	local ok, clip = pcall(GetMaxAmmoInClip, cache.ped, itemData.hash, true)

	if ok and type(clip) == 'number' and clip > 0 and clip <= 500 then
		clipCapacityCache[itemData.hash] = math.min(math.floor(clip), AMMO_CLIP_CAP)
		return clipCapacityCache[itemData.hash]
	end

	return AMMO_CLIP_CAP
end

--- * The ammunition separation: every weapon has its own balance, not a shared pool.
---
--- RDR3 has one reserve per bullet **type**, so there is no way to give every weapon
--- its own reserve - the Navy and the Cattleman are both AMMO_REVOLVER. But every weapon's
--- clip is addressed separately. After every equip/reload/shot, restore each clip
--- from its inventory balance and remove excess ammunition from the shared pool.
--- Automatic reload behaviour belongs to the RedM engine.
---
--- ! SET_AMMO_IN_CLIP addresses the weapon by the hash, and two identical weapons share it.
--- For those we take the larger so the full one is not crippled, and the separation stays in the accounting: every hand
--- deducts from its own weapon's metadata (ObserveFiring resolves the firing hand).
-- ════════════════════════════════════════════════════════════════════════════
-- Matching the family - the engine carries no more of any kind than the bag says
--
-- * The fault it treats, measured in numbers:
--
--     type AMMO_REVOLVER_EXPRESS_EXPLOSIVE : pool=0    <- the loaded kind, clean
--     type AMMO_REVOLVER                   : pool=27   <- the previous kind, alive with no owner
--
-- applyAmmoSeparation treats **one type** - the one passed to it. And switching the bullet
-- type or unloading it leaves the previous kind's pool as it is, and nothing ever comes back to it.
-- And the revolver family is five kinds, so five pools accumulate unaccounted for.
--
-- The rule here: for every kind in the family, what the engine carries must not exceed the sum of
-- the balances of **all** the bag's weapons of that kind - carried or holstered (the holstered
-- bow needs its pool to be drawn). And the excess is deleted.
-- ════════════════════════════════════════════════════════════════════════════

--- A reverse map: the type's hash <- the family's key. Built once.
local familyOfType

local function buildFamilyMap()
    familyOfType = {}
    if not AmmoTypes or type(AmmoTypes.Families) ~= 'table' then return end

    for family, entries in pairs(AmmoTypes.Families) do
        for i = 1, #entries do
            local name = entries[i].ammo
            if type(name) == 'string' then familyOfType[GetHashKey(name)] = family end
        end
    end
end

--- It deletes from the engine whatever exceeds the bag's balances in every kind of this type's family.
---@param ammoTypeHash number
local function reconcileFamily(ammoTypeHash)
    if not familyOfType then buildFamilyMap() end

    local family = familyOfType[ammoTypeHash]
    local entries = family and AmmoTypes.GetAll and AmmoTypes.GetAll(family)
    if not entries or #entries == 0 then return end

    -- What the bag owns of every kind - one pass over the items and not a pass per kind.
    local owed = {}

    for _, slotData in pairs(PlayerData.inventory or {}) do
        local itemData = slotData and Items[slotData.name]

        if itemData and itemData.weapon and itemData.ammoType then
            local hash = getAmmoTypeHash(itemData, slotData.metadata)

            if hash ~= 0 then
                owed[hash] = (owed[hash] or 0)
                    + math.max(0, math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
            end
        end
    end

    for i = 1, #entries do
        local name = entries[i].ammo
        local hash = type(name) == 'string' and GetHashKey(name) or nil

        if hash then
            local live = math.max(0, math.floor(tonumber(GetPedAmmoByType(cache.ped, hash)) or 0))
            local mine = owed[hash] or 0

            if live > mine then
                Citizen.InvokeNative(0xB6CFEC32E3742779, cache.ped, hash, live - mine,
                    GetHashKey('REMOVE_REASON_DROPPED')) -- _REMOVE_AMMO_FROM_PED_BY_TYPE
            end
        end
    end
end

Weapon.ReconcileAmmoFamily = reconcileFamily

---@param ammoTypeHash number
---@return number total
local function applyAmmoSeparation(ammoTypeHash)
	if not ammoTypeHash or ammoTypeHash == 0 then return 0 end

	local slots = heldSlotsForAmmo(ammoTypeHash)
	local total = 0
	local clipByHash = {}

	for i = 1, #slots do
		local slotData = PlayerData.inventory and PlayerData.inventory[slots[i]]
		local itemData = slotData and Items[slotData.name]

		if itemData then
			local balance = math.max(0,
				math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
			local capacity = clipCapacity(itemData)
			local clip = capacity > 0 and math.min(balance, capacity) or balance

			total = total + balance
			clipByHash[itemData.hash] = math.max(clipByHash[itemData.hash] or 0, clip)
		end
	end

	SetPedAmmoByType(cache.ped, ammoTypeHash, total)

	-- The order matters: setting the reserve may refill the stores, so we write them after it.
	local chambered = 0
	for hash, clip in pairs(clipByHash) do
		pcall(SetAmmoInClip, cache.ped, hash, clip)
		chambered = chambered + clip
	end

	-- * Draining the reserve: no bullets outside the stores.
	--
	-- SET_PED_AMMO_BY_TYPE writes the **reserve** and not the total. So writing the sum of
	-- the balances into it counts the player's rounds twice: once in his weapon's store and once in
	-- the type's reserve. And the game's wheel shows (store + reserve), so a weapon with 6
	-- whose owner loaded 6 into its companion shows as 18. And that is a bullet that does not exist.
	--
	-- And in this system the engine's reserve has no meaning to begin with: what the player owns is either
	-- loaded into a weapon (and that is in the store) or items in the bag. So we drain it.
	--
	-- ! With _REMOVE_AMMO_FROM_PED_BY_TYPE and not with SetPedAmmoByType(0): the first
	-- subtracts from the reserve, and the second rewrites it so it messes with the stores along with it. Then we rewrite
	-- the stores as insurance - if the removal touched them they come back to their balance.
	local live = math.max(0, math.floor(tonumber(GetPedAmmoByType(cache.ped, ammoTypeHash)) or 0))
	local spare = live - chambered

	if spare > 0 then
		Citizen.InvokeNative(0xB6CFEC32E3742779, cache.ped, ammoTypeHash, spare,
			GetHashKey('REMOVE_REASON_DROPPED')) -- _REMOVE_AMMO_FROM_PED_BY_TYPE

		for hash, clip in pairs(clipByHash) do
			pcall(SetAmmoInClip, cache.ped, hash, clip)
		end
	end

	-- * And the family's other kinds: the previous kind's pool stays alive with no owner after every
	-- type switch or unload, and nothing comes back to it. See reconcileFamily above.
	reconcileFamily(ammoTypeHash)

	return total
end

Weapon.ApplyAmmoSeparation = applyAmmoSeparation

-- ! Do not add a periodic watchdog that matches the engine against the bag. It was tried and it produced an endless
-- loading loop, and the reason is measured in numbers:
--
--   we wrote SetPedAmmoByType(AMMO_REVOLVER, 12)   -> we read it back as 18
--   we wrote it zero after emptying both weapons    -> we read it back as 6
--   we wrote the Cattleman's store zero             -> we read it back as 1
--
-- The engine adjusts what we write and does not accept it as it is: the pool and the stores are one accounting to it,
-- and writing one of them moves the other. So any watchdog that compares then writes on a difference will never have
-- the two sides agree, so it writes every turn forever - and every write plays a loading animation.
--
-- The honest accounting is in the bag alone, and w_hud's display reads from it. Whatever excess the engine
-- carries is not shown nor counted in a shot (ObserveFiring deducts from the metadata).

--- Resetting the separation for every carried ammunition type (after an equip/holster/reload).
function Weapon.RefreshHeldAmmo()
	local seen = {}

	-- heldSlots and not DualWield.Slots: the bow and the long guns are not in the two-hand registry.
	for _, heldSlot in ipairs(heldSlots()) do
		local slotData = PlayerData.inventory and PlayerData.inventory[heldSlot]
		local itemData = slotData and Items[slotData.name]

		if itemData and itemData.ammoType then
			local ammoTypeHash = getAmmoTypeHash(itemData, slotData.metadata)

			if ammoTypeHash ~= 0 and not seen[ammoTypeHash] then
				seen[ammoTypeHash] = true
				applyAmmoSeparation(ammoTypeHash)
			end
		end
	end
end

local function readDualClips()
	local _, weapon0 = GetCurrentPedWeapon(cache.ped, false, 0, true)
	local _, weapon1 = GetCurrentPedWeapon(cache.ped, true, 1, true)
	local _, clip0 = GetAmmoInClip(cache.ped, weapon0)
	local _, clip1 = GetAmmoInClip(cache.ped, weapon1)

	return weapon0, weapon1, tonumber(clip0) or 0, tonumber(clip1) or 0
end

local function firedDualHand(weapon0, weapon1, clip0, clip1)
	local fired0 = dualClipAmmo[0] ~= nil and clip0 < dualClipAmmo[0]
	local fired1 = dualClipAmmo[1] ~= nil and clip1 < dualClipAmmo[1]

	if fired0 ~= fired1 then return fired0 and 0 or 1 end

	local heldWeapon = GetPedCurrentHeldWeapon(cache.ped)
	if weapon0 ~= weapon1 then
		if heldWeapon == weapon0 then return 0 end
		if heldWeapon == weapon1 then return 1 end
	end

	if fired0 then return 0 end
	if fired1 then return 1 end

	-- Identical revolvers can report one shared clip value. Alternating the
	-- fallback keeps wear balanced while the ammo itself remains one pool.
	lastFiredHand = lastFiredHand == 0 and 1 or 0
	return lastFiredHand
end

---Return true when at least one currently held firearm still owns ammunition.
---@param fallbackWeapon table?
---@return boolean
function Weapon.HasUsableHeldAmmo(fallbackWeapon)
	-- heldSlots and not DualWield.Slots: the bow and the long guns are not in the two-hand registry, so
	-- the guard used to fall back to fallbackWeapon alone. And this guard is what stops the firing
	-- of the chambered round the engine keeps in a weapon whose balance is zero.
	local slots = heldSlots()

	if #slots == 0 then
		return fallbackWeapon and fallbackWeapon.metadata
			and (tonumber(fallbackWeapon.metadata.ammo) or 0) > 0 or false
	end

	-- * After the separation: it is enough that any carried weapon has its own balance.
	for i = 1, #slots do
		local slotData = PlayerData.inventory and PlayerData.inventory[slots[i]]
		local itemData = slotData and Items[slotData.name]

		if slotData and itemData and itemData.ammoType
			and (tonumber(slotData.metadata and slotData.metadata.ammo) or 0) > 0 then
			return true
		end
	end

	return false
end

---VORP allows two identical sidearms to be equipped even when their saved
---clips currently contain different ammunition types. RDR owns the live ammo
---pools by AMMO_* type and the exact fired hand is resolved from its weapon
---entity, so this must never be an equip-time blocker.
---@param item table
---@param data table
---@return boolean
function Weapon.CanEquip(item, data)
	return true
end

---Observe a firing frame and debit exactly one round from the matching engine
---pool and inventory owner. The server independently validates and commits it.
---@param fallbackWeapon table?
---@param shootingNow boolean
---@param shotEdge boolean
---@return table? result
function Weapon.ObserveFiring(fallbackWeapon, shootingNow, shotEdge)
	local count = DualWield.Count()
	local weapon0, weapon1, clip0, clip1

	if count > 1 then
		weapon0, weapon1, clip0, clip1 = readDualClips()
	end

	local result

	if shootingNow and shotEdge then
		local firedSlot
		local firedHand

		if count > 1 then
			firedHand = firedDualHand(weapon0, weapon1, clip0, clip1)
			firedSlot = DualWield.SlotForHand(firedHand)
		elseif count == 1 then
			firedSlot = DualWield.Slots()[1]
			firedHand = DualWield.HandForSlot(firedSlot) or 0
		else
			firedSlot = fallbackWeapon and fallbackWeapon.slot
			firedHand = 0
		end

		local fired = firedSlot and PlayerData.inventory and PlayerData.inventory[firedSlot]
		local firedData = fired and Items[fired.name]

		if fired and firedData and firedData.weapon and firedData.ammoType
			and not firedData.throwable and fired.metadata then
			-- Match VORP's shot accounting: ask the exact hand entity which
			-- AMMO_* pool actually fired. This matters for two identical hashes;
			-- SetAmmoTypeForPedWeapon is hash-scoped, while each hand still has an
			-- exact entity whose active ammo type can be queried reliably.
			local weaponObject = GetCurrentPedWeaponEntityIndex(cache.ped, firedHand or 0)
			local liveAmmoType = weaponObject and weaponObject ~= 0
				and GetCurrentPedWeaponAmmoType(cache.ped, weaponObject) or nil
			local ammoTypeHash = liveAmmoType and liveAmmoType ~= 0 and liveAmmoType
				or getAmmoTypeHash(firedData, fired.metadata)
			-- * The separation: the deduction is on the weapon that really fired, not on a 'pool
			-- owner' shared between them. The deduction used to always go to the type's owner, so the Navy's
			-- rounds were drained when the Cattleman fired and the other way round.
			if getAmmoTypeHash(firedData, fired.metadata) ~= ammoTypeHash
				and #heldSlotsForAmmo(ammoTypeHash) == 0 then
				-- A momentary transition in the native may report an old/zero type; we fall back
				-- to this very copy's type instead of deducting one kind from another kind's balance.
				ammoTypeHash = getAmmoTypeHash(firedData, fired.metadata)
			end

			local owner, ownerSlot = fired, firedSlot
			local previousAmmo = math.max(0, math.floor(tonumber(owner.metadata.ammo) or 0))

			-- * A round that came out of a weapon whose balance is zero.
			--
			-- It happens with two weapons of an identical hash: SET_AMMO_IN_CLIP addresses the weapon
			-- by the hash, so their store is one in the engine and they share what is in it, and the round
			-- really came out of the companion's balance. And this branch used to settle for resetting
			-- so the round fell with nobody deducted - a free bullet every time, and that is
			-- what makes the balance look as if it grows.
			--
			-- We charge it to the companion whose balance it came out of. The server is built for this to begin with:
			-- recordWeaponShot accepts a firing slot and an owner slot that differ, and it requires
			-- them both to be carried and of the same bullet family, and it can only deduct.
			if previousAmmo <= 0 then
				local companions = heldSlotsForAmmo(ammoTypeHash, firedSlot)

				for i = 1, #companions do
					local candidate = PlayerData.inventory and PlayerData.inventory[companions[i]]
					local balance = math.max(0,
						math.floor(tonumber(candidate and candidate.metadata and candidate.metadata.ammo) or 0))

					if balance > 0 then
						owner, ownerSlot, previousAmmo = candidate, companions[i], balance
						break
					end
				end
			end

			if previousAmmo > 0 then
				local nextAmmo = math.max(0, previousAmmo - 1)

				owner.metadata.ammo = nextAmmo
				owner.metadata._ammoRevision = math.floor(tonumber(owner.metadata._ammoRevision) or 0) + 1
				fired.metadata._shotRevision = math.floor(tonumber(fired.metadata._shotRevision) or 0) + 1

				-- A redistribution: the reserve = the sum of the balances, and every weapon's store =
				-- its own balance. So the weapon that emptied stops alone with no touching its companion.
				applyAmmoSeparation(ammoTypeHash)

				local drain = math.max(0, tonumber(firedData.durability) or 0)
				fired.metadata.durability = math.max(0, (tonumber(fired.metadata.durability) or 100) - drain)
				owner.timer = GetGameTimer() + (nextAmmo <= 0 and 200 or 400)

				TriggerServerEvent('w_inventory:recordWeaponShot', firedSlot, ownerSlot,
					nextAmmo, owner.metadata._ammoRevision, fired.metadata._shotRevision)
				result = { weapon = owner, fired = fired, ammo = nextAmmo }
			else
				-- An empty weapon fired from its companion's reserve (it happens with two identical weapons
				-- because the store is addressed by the hash). We reset at once so the companion does not lose
				-- a round it never fired.
				applyAmmoSeparation(ammoTypeHash)
			end
		end
	end

	if count > 1 then
		dualClipAmmo[0], dualClipAmmo[1] = clip0, clip1
	else
		table.wipe(dualClipAmmo)
	end

	return result
end

---@param updates table<number, number>
local function syncAmmoOwners(updates)
	local revisions = lib.callback.await('w_inventory:syncDualAmmo', false, updates)

	if type(revisions) ~= 'table' then return false end

	for slot, revision in pairs(revisions) do
		local slotData = PlayerData.inventory and PlayerData.inventory[tonumber(slot)]
		if slotData and slotData.metadata then
			slotData.metadata._ammoRevision = tonumber(revision) or slotData.metadata._ammoRevision
		end
	end

	return revisions
end

---Move an already-live RDR3 ammo pool to one held inventory slot.
---
---RDR3 owns ammunition by ammo type, while the inventory owns it by weapon
---instance. Before reloading either hand, make that slot the sole metadata
---owner of the live pool so loading the off-hand cannot replace or duplicate
---the rounds currently shared by both hands.
---@param ownerSlot number
---@return number? liveAmmo
---@return number? weaponCount
---@return number[]? matchingSlots
function Weapon.ReassignAmmoPool(ownerSlot)
	local ownerItem = PlayerData.inventory and PlayerData.inventory[ownerSlot]
	local ownerData = ownerItem and Items[ownerItem.name]

	if not ownerItem or not ownerData or not ownerData.weapon or not ownerData.ammoType then return end
	if not DualWield.HasSlot(ownerSlot) then
		return tonumber(ownerItem.metadata and ownerItem.metadata.ammo) or 0, 1, { ownerSlot }
	end

	local ammoTypeHash = getAmmoTypeHash(ownerData, ownerItem.metadata)
	local matchingSlots = heldSlotsForAmmo(ammoTypeHash)
	local foundOwner = false

	for i = 1, #matchingSlots do
		if matchingSlots[i] == ownerSlot then foundOwner = true; break end
	end

	if not foundOwner then return end

	-- * After the separation there is no pool to be moved any more: every weapon has its own balance. What is left to this
	-- function is resetting the reserve and the stores from the balances, and returning this
	-- weapon's balance alone - so the reload computes its difference against its own store and not against both stores.
	local ownAmmo = math.max(0, math.floor(tonumber(ownerItem.metadata.ammo) or 0))

	-- One weapon of its type in the hands: the live reserve belongs to it and it is the freshest after
	-- a shot the observer has not picked up yet.
	if #matchingSlots == 1 then
		local liveAmmo = math.max(0, math.floor(tonumber(GetPedAmmoByType(cache.ped, ammoTypeHash)) or 0))

		if liveAmmo ~= ownAmmo then
			ownAmmo = liveAmmo
			ownerItem.metadata.ammo = ownAmmo
			syncAmmoOwners({ [ownerSlot] = ownAmmo })
		end
	end

	applyAmmoSeparation(ammoTypeHash)

	return ownAmmo, 1, { ownerSlot }
end

---Clear the live RDR ammo pool represented by an inventory slot after the
---server has returned those rounds to the inventory.
---@param slot number
---@param revision number?
---@return boolean
function Weapon.ClearLoadedAmmo(slot, revision)
	local slotData = PlayerData.inventory and PlayerData.inventory[slot]
	local itemData = slotData and Items[slotData.name]

	if not slotData or not itemData or not itemData.ammoType or not slotData.metadata then return false end

	local ammoTypeHash = getAmmoTypeHash(itemData, slotData.metadata)

	slotData.metadata.ammo = 0
	slotData.metadata.specialAmmo = nil
	slotData.metadata._ammoRevision = tonumber(revision) or slotData.metadata._ammoRevision
	ammoPoolOwner[ammoTypeHash] = nil

	-- * The unloading must reach the engine, otherwise the bullets multiply with two presses: the rounds come back
	-- to the bag as items and stay in the weapon, so you load and unload endlessly.
	--
	-- ! SET_AMMO_IN_CLIP is not the deletion tool. Measured by experiment: the Cattleman's store was written
	-- zero and read back as 1 - the engine does not accept a write of zero. The dedicated tool is
	-- _REMOVE_AMMO_FROM_PED and it addresses the weapon by the hash directly.
	--
	-- * And the order is intended: we empty the whole hash first then we rebuild. So a twin of
	-- the same hash in the hand recovers its balance from applyAmmoSeparation afterwards - cleaner than
	-- trying to except it, and it leaves the emptied weapon not one round.
	local live = math.max(0,
		math.floor(tonumber(GetAmmoInPedWeapon(cache.ped, itemData.hash)) or 0))

	if live > 0 then
		Citizen.InvokeNative(0xF4823C813CB8277D, cache.ped, itemData.hash, live,
			GetHashKey('REMOVE_REASON_DROPPED')) -- _REMOVE_AMMO_FROM_PED
	end

	pcall(SetAmmoInClip, cache.ped, itemData.hash, 0)

	-- * And every **kind** in the family has its own independent pool in the engine.
	--
	-- The arrow family alone is five kinds (ordinary . fire . poison . dynamite . small game)
	-- and so are the bullets. And unloading one kind leaves the rest, so the engine chambers an arrow
	-- from a pool we never touched - 'the bullets disappeared then came back'.
	--
	-- So we clear every kind in the family: the weapon was emptied, so it keeps no balance in the engine
	-- of any kind. And what is in the bag are items that are not touched.
	local family = itemData.ammoFamily
	local entries = family and AmmoTypes and AmmoTypes.GetAll and AmmoTypes.GetAll(family)

	for i = 1, #(entries or {}) do
		local typeHash = entries[i].ammo and GetHashKey(entries[i].ammo)
		local pooled = typeHash and math.max(0,
			math.floor(tonumber(GetPedAmmoByType(cache.ped, typeHash)) or 0)) or 0

		if pooled > 0 then
			Citizen.InvokeNative(0xB6CFEC32E3742779, cache.ped, typeHash, pooled,
				GetHashKey('REMOVE_REASON_DROPPED')) -- _REMOVE_AMMO_FROM_PED_BY_TYPE
		end
	end

	-- Then the separation: emptying this weapon does not touch its companion. The type's whole reserve used to be
	-- zeroed, so the Cattleman lost its bullets just because you emptied the Navy.
	--
	-- RefreshHeldAmmo and not applyAmmoSeparation for one type: we cleared every kind in the family
	-- above, so there may be a carried companion of another kind in it. This one rebuilds every
	-- carried type from its owners' balances - so the companion recovers its balance whatever its kind.
	Weapon.RefreshHeldAmmo()

	return true
end

--- Loading the weapon's assets before giving it to the character.
--- The patch packs' weapons (patchpack knives and others) do not have their assets streamed automatically, so
--- GIVE_DELAYED_WEAPON_TO_PED succeeds on paper while the weapon never shows in the hand and never
--- works - while the world model when dropped is streamed through another path so the item looks sound.
--- The dual-wield module already does this for every firearm; the ordinary path was missing it.
---@param weaponHash number
---@return boolean
local function requestWeaponAsset(weaponHash)
	if not weaponHash then return false end
	if Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash) then return true end -- HAS_WEAPON_ASSET_LOADED

	Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, 0, true) -- REQUEST_WEAPON_ASSET

	local deadline = GetGameTimer() + 3000

	while not Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash) and GetGameTimer() < deadline do
		Wait(10)
	end

	return Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash) == true
end

---@param weapon table
---@param ammo number
local function persistWeaponAmmo(weapon, ammo)
	if not weapon or not weapon.metadata then return false end

	local revision = math.floor(tonumber(weapon.metadata._ammoRevision) or 0) + 1
	local ok, serverRevision = lib.callback.await('w_inventory:updateWeapon', false,
		'ammo', math.max(0, math.floor(tonumber(ammo) or 0)), weapon.slot, nil, revision)

	weapon.metadata._ammoRevision = tonumber(serverRevision) or (ok and revision)
		or weapon.metadata._ammoRevision

	return ok == true
end

-- Minimal self-contained fallback for gunsmith metadata. The richer plan is
-- normally supplied by w_gunsmith, but weapon restoration must not silently
-- discard gunComps when that resource is still starting or its export is not
-- available yet.
local GUID_COMPONENT_SLOT = {
	gripBase = joaat('egkzxeea_0x6c331a5f'),
	gripTint = joaat('hapviwga_0x57575690'),
	wrapBase = joaat('dkxlkpba_0xfc47ff5c'),
	wrapTint = joaat('eltbxawa_0x1d09a85c'),
	frameMaterial = joaat('tcjzguba_0xa9d72b85'),
	barrelMaterial = joaat('xwspsshc_0x3d351086'),
	sightMaterial = joaat('syrtpvva_0xd426ea5a'),
	triggerMaterial = joaat('vwctsoca_0xdc1a0de6'),
	hammerMaterial = joaat('tpjpnvga_0xe680ecdf'),
}

local function fallbackGuidDescriptor(component)
	local descriptor = { component = component, priority = 30 }
	if type(component) ~= 'string' then return descriptor end

	if component:find('GRIPSTOCK_TINT', 1, true) then
		descriptor.priority = 90
		descriptor.slotHash = GUID_COMPONENT_SLOT.gripTint
		descriptor.parentSlotHash = GUID_COMPONENT_SLOT.gripBase
	elseif component:find('WRAP_TINT', 1, true) then
		descriptor.priority = 90
		descriptor.slotHash = GUID_COMPONENT_SLOT.wrapTint
		descriptor.root = true
	elseif component:find('_GRIP', 1, true)
		and not component:find('MATERIAL', 1, true)
		and not component:find('ENGRAVING', 1, true) then
		descriptor.priority = 10
		descriptor.slotHash = GUID_COMPONENT_SLOT.gripBase
	elseif component:find('_WRAP', 1, true)
		and not component:find('MATERIAL', 1, true)
		and not component:find('ENGRAVING', 1, true) then
		descriptor.priority = 10
		descriptor.slotHash = GUID_COMPONENT_SLOT.wrapBase
	elseif component:find('FRAME_MATERIAL', 1, true) then
		descriptor.priority = 40
		descriptor.slotHash = GUID_COMPONENT_SLOT.frameMaterial
	elseif component:find('BARREL_MATERIAL', 1, true) then
		descriptor.priority = 40
		descriptor.slotHash = GUID_COMPONENT_SLOT.barrelMaterial
	elseif component:find('SIGHT_MATERIAL', 1, true) then
		descriptor.priority = 40
		descriptor.slotHash = GUID_COMPONENT_SLOT.sightMaterial
	elseif component:find('TRIGGER_MATERIAL', 1, true) then
		descriptor.priority = 40
		descriptor.slotHash = GUID_COMPONENT_SLOT.triggerMaterial
	elseif component:find('HAMMER_MATERIAL', 1, true) then
		descriptor.priority = 40
		descriptor.slotHash = GUID_COMPONENT_SLOT.hammerMaterial
	elseif component:find('ENGRAVING_MATERIAL', 1, true) then
		descriptor.priority = 70
	elseif component:find('ENGRAVING', 1, true) then
		descriptor.priority = 60
	elseif component:find('MATERIAL', 1, true) then
		descriptor.priority = 40
	end

	return descriptor
end

--- Build an optional, data-only component plan for the exact RDR inventory
--- GUID transaction. w_inventory understands ordinary metadata.components on
--- its own; w_gunsmith can enrich the plan with factory parents and its
--- category-specific customisation metadata when that resource is installed.
---@param item table
---@param data table
---@return table?
local function buildGuidComponentPlan(item, data)
	local metadata = type(item.metadata) == 'table' and item.metadata or {}
	local nativeComponents = type(metadata.components) == 'table' and metadata.components or {}
	local gunComps = type(metadata.gunComps) == 'table' and metadata.gunComps or {}

	if GetResourceState('w_gunsmith') == 'started' then
		local ok, plan = pcall(function()
			return exports.w_gunsmith:GetWeaponGuidComponentPlan(
				data.hash, gunComps, nativeComponents)
		end)

		if ok and type(plan) == 'table' and type(plan.components) == 'table' then
			return plan
		end
	end

	local components = {}
	for _, component in pairs(gunComps) do
		if type(component) == 'number' or type(component) == 'string' then
			components[#components + 1] = fallbackGuidDescriptor(component)
		end
	end
	for _, component in pairs(nativeComponents) do
		if type(component) == 'number' or type(component) == 'string' then
			components[#components + 1] = fallbackGuidDescriptor(component)
		end
	end

	return #components > 0 and { components = components } or nil
end

--- Draws the weapon: the game plays its own draw animation (the equipping is animated by the
--- weapon swap task), so no animation is played here.
---@param item table the inventory slot
---@param data table the item definition
---@param _ boolean? unused (kept for the callers' signature)
---@param options { skipUsageSync?: boolean, silent?: boolean }?
function Weapon.Equip(item, data, _, options)
	local playerPed = cache.ped
    local sleep

	item.hash = data.hash
	item.ammo = data.ammoname
	item.melee = IsWeaponAGun(data.hash) == 0
	item.timer = 0
	item.throwable = data.throwable
	item.group = GetWeapontypeGroup(item.hash)

	local dualHandled = false
	local dualSuccess
	local dualError
	local usageSynced = false

	do
		-- ! The dual-wield module is tried first. It puts the weapon in through the game's item
		-- database, and GIVE_DELAYED_WEAPON_TO_PED before it puts it into the
		-- CARRIED_WEAPONS container so ADD_ITEM_WITH_GUID fails because it already exists.
		-- So if the module took it over we do not give the weapon the ordinary way.
		local guidComponentPlan = buildGuidComponentPlan(item, data)
		dualHandled, dualSuccess, dualError = DualWield.Equip(
			data.model or item.name, data.hash, item.slot, guidComponentPlan)

		-- A compatible sidearm transaction is owned by the GUID manager. If RDR
		-- rejects it, never fall through to the hash-only give path: that path
		-- cannot represent an identical second gun and creates a ghost used state.
		if dualHandled and dualSuccess ~= true then
			return nil, nil, dualError or 'engine_failed'
		end

		-- Commit the exact hand/slot/serial state before touching the shared
		-- RDR ammo pool. The server can then reject forged two-slot ammo updates
		-- that do not belong to the pair actually held by this character.
		if dualHandled and not (options and options.skipUsageSync) then
			usageSynced = Weapon.SyncUsage(item)
		end

		if not dualHandled and not HasPedGotWeapon(playerPed, data.hash, 0, false) then
			-- Without streaming the assets a patch-pack weapon does not show in the hand and is not usable
			requestWeaponAsset(data.hash)

			local currentWeaponAmmo = GetAmmoInPedWeapon(playerPed, data.hash)

			-- RemoveAmmoFromPed
			-- N_0xf4823c813cb8277d(playerPed, data.hash, currentWeaponAmmo, `REMOVE_REASON_DEBUG`)

			--[[ GiveWeaponToPed ]]
			if data.throwable then
				Citizen.InvokeNative(0xB282DC6EBD803C75, playerPed, data.hash, tonumber(item.count), true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
			else
				Citizen.InvokeNative(0xB282DC6EBD803C75, playerPed, data.hash, 0, true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
				-- AddAmmoToPedByType( playerPed, GetHashKey(item.metadata.specialAmmo or item.ammo), item.metadata.ammo )
				-- A weapon with no ammunition type (a knife/an axe) is not bound to a type; binding to a zero
				-- type leaves the weapon with no valid ammunition so it is not usable.
				local ammoTypeHash = getAmmoTypeHash(data, item.metadata)
				if ammoTypeHash ~= 0 then
					SetAmmoTypeForPedWeapon(playerPed, data.hash, ammoTypeHash)
				end
			end

			-- GIVE_DELAYED_WEAPON_TO_PED is deferred and reports no failure. When the engine
			-- refuses the weapon (missing assets or a name/hash that does not exist in this build)
			-- the player used to see the item 'equipped' in the bag and nothing in his hand. We check
			-- and report instead of staying silent.
			local deadline = GetGameTimer() + 400

			while not HasPedGotWeapon(playerPed, data.hash, 0, false) and GetGameTimer() < deadline do
				Wait(0)
			end

			if not HasPedGotWeapon(playerPed, data.hash, 0, false) then
				warn(('w_inventory: RDR refused to give %s (%s). Missing weapon asset or invalid hash.')
					:format(item.name, tostring(data.model or item.name)))

				Utils.Notify({
					id = 'weapon_engine_refused',
					type = 'error',
					description = locale('dual_equip_failed')
				})
			end

		end

		-- The components in RDR3 include the engravings and the materials and the colours.
		-- VORP's technique: they are applied at the object level by the hash after the weapon is drawn - for every case
		-- (single or dual). The dual one equips the weapon through a GUID, but the components are here (not as GUID
		-- children, since that is what the engine refuses and it causes the flickering/the wiping). They are redone at every equip so they do not disappear.
		local nativeComps = item.metadata.components
		local gunComps = item.metadata.gunComps

		-- ── The weapon's customisation: w_gunsmith alone owns it ───────────────────────────
		--
		-- The bag **writes** no component. The reason for the contract: the engine rebuilds the weapon's entity
		-- at every component fitting, and entity-level components are not recorded in
		-- HasWeaponGotWeaponComponent - so two writers = an eternal holster/draw loop.
		-- We notify the owner once at the equip, and it guarantees one pass by a fingerprint.
		--
		-- The fallback (w_gunsmith is stopped): the bag fits the native components only,
		-- once inside the equipping transaction - with no loop.
		local gunsmithOwns = GetResourceState('w_gunsmith') == 'started'
		local hasCustom = (gunComps and next(gunComps) ~= nil)
			or (nativeComps and #nativeComps > 0)

		if hasCustom and gunsmithOwns then
			local hand = DualWield.HandForSlot and DualWield.HandForSlot(item.slot) or 0
			local payload = {}

			for key, comp in pairs(gunComps or {}) do payload[key] = comp end
			for i = 1, #(nativeComps or {}) do
				local comp = nativeComps[i]
				if type(comp) == 'string' then payload['native' .. i] = comp end
			end

			pcall(function()
				exports.w_gunsmith:ApplyWeaponCustomization(payload, hand or 0)
			end)
		elseif nativeComps then
			for i = 1, #nativeComps do
				local comp = nativeComps[i]
				if type(comp) == 'number' then
					ApplyWeaponComponent(playerPed, data.hash, comp)
				elseif type(comp) == 'string' then
					ApplyWeaponComponent(playerPed, data.hash, joaat(comp))
				end
			end
		end
	end

	do
		local savedAmmo = item.metadata.ammo or 0
		local ammoTypehash = getAmmoTypeHash(data, item.metadata)
		local pedAlreadyHadWeapon = HasPedGotWeapon(playerPed, data.hash, 0, false)
		local hasAmmoType = ammoTypehash ~= 0

		if not pedAlreadyHadWeapon and hasAmmoType then
			local currentPedAmmo = GetPedAmmoByType(playerPed, ammoTypehash)
			if currentPedAmmo > 0 then
				Citizen.InvokeNative(0xB6CFEC32E3742779, playerPed, ammoTypehash, currentPedAmmo, GetHashKey('REMOVE_REASON_DROPPED'))
			end
			SetPedAmmoByType(playerPed, ammoTypehash, savedAmmo)
			Citizen.InvokeNative(0xCC9C4393523833E2, playerPed, data.hash, ammoTypehash)
		end

		-- ! There used to be broken dual-wield logic here: it compared a boolean against a weapon's hash
		--     (hasPrimaryWeapon == data.hash) so it never came true, and it always fell
		--     through to SetCurrentPedWeapon. It was replaced with the dualwield module
		--     which uses the RDR3 item database as the game itself does.
		if not dualHandled then
			SetCurrentPedWeapon(playerPed, data.hash, false, 0, false, false)
		else
			-- The dual-wield path bypasses the regular give block, so always bind
			-- the weapon to its real engine ammo type here.
			SetAmmoTypeForPedWeapon(playerPed, data.hash, ammoTypehash)

			-- * The separation: we no longer gather the two weapons' balances into one 'owner' after today. The
			-- gathering used to make the empty Cattleman fire from the Navy's bullets the moment it was drawn.
			-- Every weapon keeps its balance in its metadata, and the reserve is built as a sum
			-- while every one's store is set to its own balance.
			applyAmmoSeparation(ammoTypehash)
			savedAmmo = math.max(0, math.floor(tonumber(item.metadata.ammo) or 0))
		end

		-- A weapon the dual-wield module did not take over (a bow/a long gun/a melee weapon): register it here, otherwise
		-- the ammunition accounting never saw it so its ammunition was wiped. See singleHeldSlot above.
		singleHeldSlot = (not dualHandled) and item.slot or nil

		if pedAlreadyHadWeapon and not dualHandled and hasAmmoType then
			local currentPedAmmo = GetPedAmmoByType(playerPed, ammoTypehash)
			if currentPedAmmo ~= savedAmmo then
				SetPedAmmoByType(playerPed, ammoTypehash, savedAmmo)
			end
		end
	end

	if not usageSynced and not (options and options.skipUsageSync) then
		Weapon.SyncUsage(item)
	end

	TriggerEvent('w_inventory:currentWeapon', item, 'equipped')

	if client.weaponnotify and not (options and options.silent) then
		Utils.ItemNotify({ item, 'ui_equipped' })
	end

	if IsWeaponAGun(data.hash) ~= 0 then
		Citizen.CreateThreadNow(function() applyWeaponStatus(item, data) end)
	end

	-- The gunsmith's power: the barrel/trigger/sight pieces really raise the damage
	Weapon.ApplyDamageModifier(item)

	return item, sleep
end

--- Should this weapon's copy stay on the body after holstering?
---
--- ═══ Why ═══
--- The decorative-copies thread in client.lua shows the slots 1-5 weapons on the body. So if
--- the weapon were taken off the ped here, the thread would see it missing in less than a second and give it
--- again - **and that is a clean rebuild**: a weapon built with its factory pieces and a new GUID
--- tree, so the tint and the etching that were put on it with the weapon in the hand are lost.
---
--- And the engravings cannot be fitted to the holster at all (the tree refuses the occupied slot, and emptying it
--- wipes the weapon from every one of its copies on the body). So their only route is to be put on with the hand holding it
--- then **the copy is not rebuilt**: the fitting and the removal are both on (ped + hash), so what
--- settled on the hash the holstered copy inherits by construction.
---
--- The condition is deliberately narrow: a hotbar weapon that has a saved customisation only. Anything else takes the old
--- path to the letter. And the thread would have brought it back after a second anyway, so the ped's state
--- after this branch is the same - minus the rebuild alone.
---@param item table?
---@return boolean
local function holsterKeepsInstance(item)
	if not item or not item.hash then return false end

	-- The tracked two-hand weapons are managed by the dual-wield module with explicit GUID copies, and the
	-- decorative-copies thread does not show them at all.
	if DualWield.HasHash(item.hash) then return false end

	-- * The holstered weapon stays visible in its holster - RDR2 behaviour.
	--
	-- RemoveWeaponFromPed used to drop it off the body with every holstering, so the player played the holstering
	-- animation then saw the weapon **disappear** instead of settling into the holster. And the only line
	-- responsible for that is what this function guards.
	--
	-- ! And nothing else is touched: taking the type's ammunition off the character and returning the damage multiplier
	-- to 1 and applyAmmoSeparation all keep working as they are (see the condition in
	-- Weapon.Disarm below) - so the 'loose bullets' treated there do not come back.
	--
	-- Set it to false in config.lua to go back to the old behaviour.
	if Config.KeepHolsteredOnBody ~= false then return true end

	-- The old behaviour: only the customised hotbar weapon is excepted, because taking it off means
	-- a clean rebuild a moment later and the tint and the etching lost with it.
	if GetResourceState('w_gunsmith') ~= 'started' then return false end

	local slot = tonumber(item.slot)
	if not slot or slot > 5 then return false end

	local gunComps = item.metadata and item.metadata.gunComps
	return type(gunComps) == 'table' and next(gunComps) ~= nil
end

function Weapon.Disarm(currentWeapon, noAnim, keepHolstered, skipUsageSync, silent)
	-- The single weapon leaves the hand: take it out of the ammunition accounting before any redistribution,
	-- otherwise its ammunition stayed counted in its type's pool while it was holstered.
	if singleHeldSlot and currentWeapon and tonumber(currentWeapon.slot) == singleHeldSlot then
		singleHeldSlot = nil
	end

	-- The holstering invalidates the owner's fingerprint: the next draw deserves a fresh customisation pass
	if GetResourceState('w_gunsmith') == 'started' then
		pcall(function() exports.w_gunsmith:ForgetWeaponCustomization() end)
	end

	local preserveSharedWeapon = false
	local nextWeapon
	local trackedItem = currentWeapon and Items[currentWeapon.name]

	-- Slot updates received from the server intentionally contain persistent
	-- fields only. Rehydrate transient weapon fields before disarming an
	-- off-hand instance so exact-slot removal never falls back to a hash-only
	-- operation (which could remove its identical twin).
	if currentWeapon and trackedItem then
		currentWeapon.metadata = currentWeapon.metadata or {}
		currentWeapon.hash = currentWeapon.hash or trackedItem.hash
		currentWeapon.ammo = currentWeapon.ammo or trackedItem.ammoname
		currentWeapon.throwable = currentWeapon.throwable or trackedItem.throwable
		currentWeapon.group = currentWeapon.group or GetWeapontypeGroup(currentWeapon.hash)
		if currentWeapon.melee == nil and currentWeapon.hash then
			currentWeapon.melee = IsWeaponAGun(currentWeapon.hash) == 0
		end
	end

	if currentWeapon and (currentWeapon.timer ~= nil or DualWield.HasSlot(currentWeapon.slot)) then
		Weapon.CaptureStatus(currentWeapon)
		currentWeapon.timer = nil

		local itemData = Items[currentWeapon.name]
		local hasAmmoPool = itemData and not currentWeapon.melee and not currentWeapon.throwable
			and currentWeapon.metadata and currentWeapon.metadata.ammo ~= nil
			and (itemData.ammoType or itemData.ammoname)
		local ammoTypeHash = hasAmmoPool and getAmmoTypeHash(itemData, currentWeapon.metadata)
		local livePool = ammoTypeHash and math.max(0, GetPedAmmoByType(cache.ped, ammoTypeHash)) or 0

		-- Release only this inventory slot's GUID, then transfer the shared
		-- engine pool to one remaining weapon of the same ammo family.
		DualWield.Forget(currentWeapon.slot)

		if ammoTypeHash then
			-- DualWield.Forget above took this slot out of the hands, so what comes back here
			-- is the remaining companion only.
			local remaining = heldSlotsForAmmo(ammoTypeHash)

			-- * The separation: the holstered weapon keeps its own balance and does not hand it to its companion.
			-- It used to be zeroed and the whole reserve moved to the remaining one, so the Navy's rounds
			-- moved to the Cattleman just by holstering the Navy.
			--
			-- Alone: the live reserve belongs to it alone and it is fresher than the metadata (it may
			-- have fired a moment before the holstering), so we take it. With a carried companion: the reserve
			-- is the sum of the two so it will not do, and we rely on its accounting balance that
			-- ObserveFiring updates with every shot.
			local ownBalance = #remaining > 0
				and math.max(0, math.floor(tonumber(currentWeapon.metadata.ammo) or 0))
				or livePool

			currentWeapon.metadata.ammo = ownBalance
			persistWeaponAmmo(currentWeapon, ownBalance)

			if #remaining > 0 then
				-- Another weapon of the same hash is still carried: removing the weapon by the hash
				-- would remove its remaining copy too, so we keep it.
				preserveSharedWeapon = DualWield.HasHash(currentWeapon.hash)

				-- Rebuilding the reserve and the stores from the remaining ones' balances alone.
				applyAmmoSeparation(ammoTypeHash)
				nextWeapon = PlayerData.inventory and PlayerData.inventory[remaining[1]]
			else
				-- No companion left: we empty this type's reserve off the character so no loose
				-- bullets stay for a weapon drawn later to pick up.
				ammoPoolOwner[ammoTypeHash] = nil
				SetPedAmmoByType(cache.ped, ammoTypeHash, 0)
			end
		end

		-- A second held gun may use another ammo family. It is still the active
		-- tracked weapon after this slot is holstered.
		if not nextWeapon then
			local heldSlots = DualWield.Slots()
			nextWeapon = heldSlots[1] and PlayerData.inventory and PlayerData.inventory[heldSlots[1]]
		end

		if not skipUsageSync then Weapon.SyncUsage(nextWeapon) end

		if client.weaponnotify and not silent then
			Utils.ItemNotify({ currentWeapon, 'ui_holstered' })
		end

		TriggerEvent('w_inventory:currentWeapon', nextWeapon, nextWeapon and 'equipped' or 'disarm')
	end

	if currentWeapon then
		if not keepHolstered and not preserveSharedWeapon then
			local ammoHash = GetPedAmmoTypeFromWeapon(cache.ped, currentWeapon.hash)
			local ammoCount = GetAmmoInPedWeapon(cache.ped, currentWeapon.hash)
			Citizen.InvokeNative(0xB6CFEC32E3742779, cache.ped, ammoHash, ammoCount, GetHashKey('REMOVE_REASON_DROPPED'))  --_REMOVE_AMMO_FROM_PED_BY_TYPE

			Weapon.ApplyDamageModifier(currentWeapon, true)

			-- * A customised weapon in the hotbar stays on the body: taking it off here means a clean
			-- rebuild a moment later, and the tint and the etching lost with it. See
			-- holsterKeepsInstance above.
			if not holsterKeepsInstance(currentWeapon) then
				RemoveWeaponFromPed(cache.ped, currentWeapon.hash)
			end

			-- ! _REMOVE_AMMO_FROM_PED_BY_TYPE wipes the whole **type's** reserve, and it is
			-- shared with any other weapon of the same calibre. After the separation, holstering the Navy came to
			-- pass through here (a differing hash) so it drew the Cattleman's bullets with it. We rebuild
			-- the reserve from the remaining ones' balances at once.
			if ammoHash and ammoHash ~= 0 then applyAmmoSeparation(ammoHash) end
		end

		--[[ GetPedCurrentHeldWeapon]]
		local heldWeapon = N_0x8425c5f057012dab(cache.ped)

		--[[ Only use Swap if the weapon currently carried by the ped is the same one we are trying to disarm. ]]
		-- A hash is not an instance identity. When an identical twin remains in
		-- the GUID registry, the native still reports the same hash; holstering by
		-- that hash here would also put the surviving gun away and start another
		-- draw/holster reconciliation cycle.
		if heldWeapon == currentWeapon.hash and not DualWield.HasHash(currentWeapon.hash) then
			--[[ HolsterPedWeapons ]]
			N_0x94a3c1b804d291ec(cache.ped, false, false, true, false)

			TaskSwapWeapon(cache.ped, 0, 0, 0, 0)
		end

	end

	return nextWeapon
end

function Weapon.ClearAll(currentWeapon, skipUsageSync)
	-- The holstering invalidates the owner's fingerprint: the next draw deserves a fresh customisation pass
	if GetResourceState('w_gunsmith') == 'started' then
		pcall(function() exports.w_gunsmith:ForgetWeaponCustomization() end)
	end

	local visited = {}
	local pending = currentWeapon

	-- Drain the actual hand registry one exact slot at a time. This preserves
	-- the final shared ammo pool and status of both weapons before their GUIDs
	-- are released; a single hash-level clear loses the off-hand instance.
	while pending and pending.slot and not visited[tonumber(pending.slot)] do
		visited[tonumber(pending.slot)] = true
		pending = Weapon.Disarm(pending, true, nil, true, true)
	end

	local remainingSlots = DualWield.Slots()
	for i = 1, #remainingSlots do
		local slot = tonumber(remainingSlots[i])
		if slot and not visited[slot] then
			local weapon = PlayerData and PlayerData.inventory and PlayerData.inventory[slot]
			if weapon then Weapon.Disarm(weapon, true, nil, true, true) end
		end
	end

	DualWield.Forget()
	singleHeldSlot = nil
	Weapon.ClearAmmoPool()
	RemoveAllPedWeapons(PlayerPedId(), true, true)

	if not skipUsageSync then Weapon.SyncUsage(nil) end
end

do
	function ApplyWeaponComponent(ped, weaponHash, weaponComponentHash)

		local weapon_component_model_hash = Citizen.InvokeNative(0x59DE03442B6C9598, weaponComponentHash)  -- GetWeaponComponentTypeModel

		if weapon_component_model_hash and weapon_component_model_hash ~= 0 then
			-- the library streams the model; a model that never loads is skipped, not an error
			if pcall(lib.requestModel, weapon_component_model_hash, 5000) then
				Citizen.InvokeNative(0x74C9090FDD1BB48E, ped, weaponComponentHash, weaponHash, true)  -- GiveWeaponComponentToEntity
				SetModelAsNoLongerNeeded(weapon_component_model_hash)
			end
		end
	end

	function GetSelectedPedWeapon(playerPed)
		local _, wep = GetCurrentPedWeapon(playerPed, true, 0, true)
		return wep
	end

	-- ============================================================
	-- The RDR3 components catalogue (the engravings and the materials and the colours are components too)
	-- It is made available to external scripts like the blacksmith's menu to show what is available for every weapon
	-- ============================================================
	local WeaponComponents = lib.load('data.weapon_components_RDR3')

	--- The component slots available for a weapon, like BARREL_ENGRAVING and GRIPSTOCK_TINT
	exports('GetWeaponComponents', function(weaponName)
		return WeaponComponents.GetComponents(weaponName)
	end)

	--- Checking that a shared component really belongs to this weapon
	exports('IsWeaponComponentValid', function(weaponName, component)
		return WeaponComponents.IsValid(weaponName, component)
	end)

	-- The old GUID/dual-wield implementation used to live here as a second
	-- authority. It has been removed; modules/weapon/dualwield.lua is now the
	-- only owner of weapon GUIDs and hand slots. Keeping two registries caused
	-- duplicate GUIDs, disappearing weapons, and unstable ammo ownership.
	local attachOriginal = true

	local function replaceCurrentAttachPoint(itemSlot)
		itemSlot = type(itemSlot) == 'table' and tonumber(itemSlot.slot) or tonumber(itemSlot)
		if not itemSlot then return end

		local weapon = PlayerData and PlayerData.inventory and PlayerData.inventory[itemSlot]

		if not weapon then
			weapon = lib.callback.await('w_inventory:getItemBySlot', false, itemSlot)
		end

		if not weapon or type(weapon.name) ~= 'string' then return end

		local attachPoint = attachOriginal and 12 or 0
		Citizen.InvokeNative(0xADF692B254977C0C, cache.ped, joaat(weapon.name), true, attachPoint)
		attachOriginal = not attachOriginal
	end

	AddEventHandler('w_inventory:ReplaceCurrentAttachPoint', replaceCurrentAttachPoint)
	-- Backward-compatible name used by the original item definitions.
	AddEventHandler('Inventory:Weapon:ReplaceCurrentAttachPoint', replaceCurrentAttachPoint)
end

-- ============================================================
-- ============================================================
-- Re-applying the components: removed.
--
-- It used to be a loop every 750ms that checked for missing components and refitted them. And it breaks the contract
-- (a second periodic writer), and it is a direct cause of the holster/draw loop: the fitting pushes the engine
-- to rebuild the entity, and the new entity looks 'incomplete' so the loop tries again.
--
-- The alternative: w_gunsmith applies the customisation at every equip (Weapon.Equip), and drawing the weapon
-- from the holster passes through the equipping - so the same coverage with no loop.
-- ============================================================

Utils.Disarm = Weapon.Disarm
Utils.ClearWeapons = Weapon.ClearAll

return Weapon
