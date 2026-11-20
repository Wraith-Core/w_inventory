if not lib then return end

require 'modules.bridge.client'
require 'modules.interface.client'

local Utils = require 'modules.utils.client'
local Weapon = require 'modules.weapon.client'
local NativeWeapons = shared.framework == 'rsg' and Weapon.Native or nil
local currentWeapon

--- Holster one exact inventory weapon instance. Slot identity is required so
--- two weapons with the same model/hash cannot affect one another.
---@param slot number
---@param noAnim? boolean
---@return boolean
local function disarmTrackedSlot(slot, noAnim)
	slot = tonumber(slot)
	if not slot then return false end

	if currentWeapon?.slot ~= slot and not Weapon.DualWield.HasSlot(slot) then
		return false
	end

	local weapon = PlayerData and PlayerData.inventory and PlayerData.inventory[slot]
	if not weapon and currentWeapon?.slot == slot then weapon = currentWeapon end
	if not weapon then return false end

	currentWeapon = Weapon.Disarm(weapon, noAnim ~= false)
	return true
end


exports('getCurrentWeapon', function()
    if NativeWeapons then return NativeWeapons.current() end
	return currentWeapon
end)

RegisterNetEvent('w_inventory:disarm', function(noAnim)
	currentWeapon = Weapon.Disarm(currentWeapon, noAnim)
end)

RegisterNetEvent('w_inventory:disarmSlot', function(slot, noAnim)
	disarmTrackedSlot(slot, noAnim)
end)

RegisterNetEvent('w_inventory:clearWeapons', function()
	Weapon.ClearAll(currentWeapon)
	currentWeapon = nil
end)

local StashTarget

exports('setStashTarget', function(id, owner)
	StashTarget = id and { id = id, owner = owner }
end)

---@type boolean | number
local invBusy        = true

---@type boolean?
local invOpen        = false
local plyState       = LocalPlayer.state
local IsPedCuffed    = IsPedCuffed
local playerPed      = cache.ped
local unarmedHash    = -1569615261
local heldWeapon     = nil
local heldWeaponInfo = nil
local lastUseTime    = 0
local cooldown       = 1000 -- 1 second cooldown (in ms)
local weaponWasShooting = false
local weaponWatchdogPauseUntil = 0

---Temporarily suspend weapon observers while another trusted resource mutates
---the exact RDR weapon object (for example, applying gunsmith components).
---Component natives can report a short UNARMED transition even though the
---inventory weapon is still equipped; treating that transition as a holster
---creates an endless draw/holster loop.
---@param duration number? milliseconds
---@return number pauseUntil
--- It suspends the weapon watchdog *and the component re-application loop* together (the weapon module reads
--- Weapon.watchdogPauseUntil) - so they do not interfere with w_gunsmith's fitting.
local function pauseWeaponWatchdog(duration)
	duration = math.max(0, math.min(10000, math.floor(tonumber(duration) or 1500)))
	weaponWatchdogPauseUntil = math.max(weaponWatchdogPauseUntil, GetGameTimer() + duration)
	-- Share the value with the weapon module (the component re-application loop in modules/weapon)
	if Weapon then Weapon.watchdogPauseUntil = weaponWatchdogPauseUntil end
	return weaponWatchdogPauseUntil
end

exports('pauseWeaponWatchdog', pauseWeaponWatchdog)

lib.onCache('ped', function(ped)
	playerPed = ped
	Utils.WeaponWheel()
end)

plyState:set('invBusy', true, false)
plyState:set('invHotkeys', false, false)
plyState:set('canUseWeapons', false, false)

local function canOpenInventory()
	if not PlayerData.loaded then
		return shared.info('cannot open inventory', '(is not loaded)')
	end

	if IsPauseMenuActive() then return end

	if invBusy or invOpen == nil then
		return shared.info('cannot open inventory', '(is busy)')
	end

	if PlayerData.dead or IsPedFatallyInjured(playerPed) then
		return shared.info('cannot open inventory', '(fatal injury)')
	end

	if PlayerData.cuffed or IsPedCuffed(playerPed) then
		return shared.info('cannot open inventory', '(cuffed)')
	end

	return true
end

--- w_lib's X surrender: its clip on the ped, or the handsUp state bag his own client replicates
--- (a clip on a remote ped is not always seen). A named BOOL native answers 1 / false here.
---@param ped number
---@return boolean
local function hasHandsUp(ped)
	local playing = IsEntityPlayingAnim(ped, 'script_proc@robberies@homestead@lonnies_shack@deception', 'hands_up_loop', 3)
	if playing == true or playing == 1 then return true end
	local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(ped))
	return serverId > 0 and Player(serverId).state.handsUp == true
end

--- A player can be searched when he is down, cuffed or holding his hands up (the arrest
--- animation w_policejob plays, or w_lib's X surrender).
---@param ped number
---@return boolean
local function canOpenTarget(ped)
	return IsPedFatallyInjured(ped)
		or IsPedDeadOrDying(ped, true)
		or IsPedCuffed(ped)
		or IsEntityPlayingAnim(ped, 'mech_busted@arrest', 'hands_up_transition', 3)
		or hasHandsUp(ped)
end

local defaultInventory = {
	type = 'newdrop',
	slots = shared.playerslots,
	weight = 0,
	maxWeight = shared.playerweight,
	items = {}
}

local currentInventory = defaultInventory

--- The server names some inventories with a dictionary key ('ui_inv_glovebox', 'police_evidence',
--- ...); translate it here so the title follows the player's language. A label that is not
--- a key comes back untouched.
---@param inventory table?
---@return table?
local function localizeInventory(inventory)
	if inventory and type(inventory.label) == 'string' then
		-- '<key> <number>': drops ('ui_drop 12') and numbered lockers ('evidence_location 1');
		-- the number fills the key's %s when it has one, otherwise it follows the text
		local prefix, number = inventory.label:match('^(%S+) (%d+)$')

		if prefix then
			local text = locale(prefix)

			inventory.label = text:find('%%') and locale(prefix, number) or ('%s %s'):format(text, number)
		else
			inventory.label = locale(inventory.label)
		end
	end

	return inventory
end

-- A map from the clothing interface's command -> the ped component category of the library
-- (w.component: to check what is worn, to take it off and to put it back on)
local CommandToCategory = {
	hat = 'hats',
	mask = 'masks',
	glasses = 'eyewear',
	ear = 'hair_accessories',
	neck = 'neckwear',
	shirt = 'shirts_full',
	vest = 'vests',
	bagoff = 'satchels',
	gloves = 'gloves',
	watch = 'accessories',
	pants = 'pants',
	shoes = 'boots',
	bracelet = 'jewelry_bracelets',
	coats = 'coats',
	coats_closed = 'coats_closed',
	neckties = 'neckties',
	suspenders = 'suspenders',
	belts = 'belts',
	belt_buckles = 'belt_buckles',
	ponchos = 'ponchos',
	cloaks = 'cloaks',
	dresses = 'dresses',
	skirts = 'skirts',
	chaps = 'chaps',
	boot_accessories = 'boot_accessories',
	gunbelts = 'gunbelts',
	spats = 'spats',
	gauntlets = 'gauntlets',
	armor = 'armor',
	badges = 'badges',
	jewelry_rings_left = 'jewelry_rings_left',
	jewelry_rings_right = 'jewelry_rings_right',
	holsters_left = 'holsters_left',
	loadouts = 'loadouts',
	outfit = 'outfit',
}

--- The categories of this map that really carry a component on the ped right now.
---@return string[]
local function getWornClothingCategories()
	local worn = {}
	local ok, equipped = pcall(w.component.getComponentsEquiped, cache.ped)

	if not ok or type(equipped) ~= 'table' then return worn end

	local present = {}

	for _, data in pairs(equipped) do
		local category = type(data) == 'table' and data.category
		local hash = type(data) == 'table' and data.hash

		if type(category) == 'string' and hash and hash ~= 0 then
			present[category] = true
		end
	end

	for _, category in pairs(CommandToCategory) do
		if present[category] then worn[#worn + 1] = category end
	end

	return worn
end

-- Saving the last clothing taken off from the interface (to put it back on later)
local lastRemovedClothes = {}

local function sendWornAndRemovedToNui()
	local worn = getWornClothingCategories()
	-- The categories we took off from our interface count as 'removed' (they can be put back on)
	local removed = {}
	for cat, _ in pairs(lastRemovedClothes) do
		removed[#removed + 1] = cat
	end
	for _, cat in ipairs(removed) do
		for i = #worn, 1, -1 do
			if worn[i] == cat then
				table.remove(worn, i)
				break
			end
		end
	end
	SendNUIMessage({
		action = 'setWornClothingCategories',
		data = {
			wornClothingCategories = worn,
			removedClothingCategories = removed,
		},
	})
end

local CraftingBenches = require 'modules.crafting.client'
local Inventory = require 'modules.inventory.client'

---@param inv string?
---@param data any?
---@return boolean?
function client.openInventory(inv, data)
	if invOpen then
		if type(data) == "table" and data.netid then
			local entity = NetworkGetEntityFromNetworkId(data.netid)

			-- the saddlebag closes when somebody sits on the horse
			if inv == "glovebox" then
				if DoesEntityExist(entity) and not Citizen.InvokeNative(0xAAB0FE202E9FC9F0, entity, -1) then -- IS_MOUNT_SEAT_FREE
					return client.closeInventory()
				end
			end
		end

		if not inv and currentInventory.type == 'newdrop' then
			return client.closeInventory()
		end

		if IsNuiFocused() then
			if inv == 'container' and currentInventory.id == PlayerData.inventory[data].metadata.container then
				return client.closeInventory()
			end

			if currentInventory.type == 'drop' and (not data or currentInventory.id == (type(data) == 'table' and data.id or data)) then
				return client.closeInventory()
			end

			if inv ~= 'drop' and inv ~= 'container' then
				if (data?.id or data) == currentInventory?.id then
					-- Triggering exports.w_inventory:openInventory('stash', 'mystash') twice in rapid succession is weird behaviour
					return warn(("script tried to open inventory, but it is already open\n%s"):format(Citizen
						.InvokeNative(`FORMAT_STACK_TRACE` & 0xFFFFFFFF, nil, 0, Citizen.ResultAsString())))
				else
					return client.closeInventory()
				end
			end
		end
	elseif IsNuiFocused() then
		-- If triggering from another nui, may need to wait for focus to end.
		Wait(100)

		-- People still complain about this being an "error" and ask "how fix" despite being a warning
		-- for people with above room-temperature iqs to look into resource conflicts on their own.
		-- if IsNuiFocused() then
		-- 	warn('other scripts have nui focus and may cause issues (e.g. disable focus, prevent input, overlap inventory window)')
		-- end
	end

	if canOpenInventory() then
		local left, right

		if inv == 'player' and data ~= cache.serverId then
			local targetId, targetPed

			if not data then
				targetId, targetPed = w.getClosestPlayer(GetEntityCoords(playerPed), 2.0)
				data = targetId and GetPlayerServerId(targetId)
			else
				local serverId = type(data) == 'table' and data.id or data

				if serverId == cache.serverId then return end

				targetId = serverId and GetPlayerFromServerId(serverId)
				targetPed = targetId and GetPlayerPed(targetId)
			end

			local targetCoords = targetPed and GetEntityCoords(targetPed)

			if not targetCoords or #(targetCoords - GetEntityCoords(playerPed)) > 1.8 or not (client.hasGroup(shared.police) or canOpenTarget(targetPed)) then
				Utils.Notify({
					id = 'inventory_right_access',
					type = 'error',
					description = locale(
						'inventory_right_access')
				})
				return
			end
		end

		if inv == 'shop' and invOpen == false then
			if cache.vehicle then
				Utils.Notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
				return
			end

			left, right = lib.callback.await('w_inventory:openShop', 200, data)
		elseif inv == 'crafting' then
			if cache.vehicle then
				Utils.Notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
				return
			end

			left = lib.callback.await('w_inventory:openCraftingBench', 200, data.id, data.index)

			if left then
				right = CraftingBenches[data.id]

				if not right?.items then return end

				local coords, distance

				if not right.points then
					coords = GetEntityCoords(cache.ped)
					distance = 2
				else
					coords = right.points[data.index]
					distance = 2
				end

				right = {
					type = 'crafting',
					id = data.id,
					label = right.label or locale('crafting_bench'),
					index = data.index,
					slots = right.slots,
					items = right.items,
					coords = coords,
					distance = distance
				}
			end
		elseif invOpen ~= nil then
			if inv == 'policeevidence' then
				if not data then
					local input = lib.inputDialog(locale('police_evidence'), {
						{ label = locale('locker_number'), type = 'number', required = true, icon = 'calculator' }
					}) --[[@as number[]? ]]

					if not input then return end

					data = input[1]
				end
			end

			left, right = lib.callback.await('w_inventory:openInventory', false, inv, data)
		end

		if left then
			plyState.invOpen = true

			SetInterval(client.interval, 100)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)

			currentInventory = localizeInventory(right) or defaultInventory
			left.items = PlayerData.inventory
			left.groups = PlayerData.groups

			SendNUIMessage({
				action = 'setupInventory',
				data = {
					leftInventory = left,
					rightInventory = currentInventory,
					wornClothingCategories = getWornClothingCategories(),
					removedClothingCategories = {},
				}
			})

			if not currentInventory.coords and not inv == 'container' then
				currentInventory.coords = GetEntityCoords(playerPed)
			end

			-- Stash exists (useful for custom stashes)
			return true
		else
			-- Stash does not exist
			if left == false then return false end
			if invOpen == false then
				Utils.Notify({
					id = 'inventory_right_access',
					type = 'error',
					description = locale(
						'inventory_right_access')
				})
			end
			if invOpen then client.closeInventory() end
		end
	else
		Utils.Notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
	end
end

RegisterNetEvent('w_inventory:openInventory', client.openInventory)
exports('openInventory', client.openInventory)

RegisterNetEvent('w_inventory:forceOpenInventory', function(left, right)
	if source == '' then return end

	plyState.invOpen = true

	SetInterval(client.interval, 100)
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)

	currentInventory = localizeInventory(right) or defaultInventory
	currentInventory.ignoreSecurityChecks = true
	left.items = PlayerData.inventory
	left.groups = PlayerData.groups

	SendNUIMessage({
		action = 'setupInventory',
		data = {
			leftInventory = left,
			rightInventory = currentInventory,
			wornClothingCategories = getWornClothingCategories(),
			removedClothingCategories = {},
		}
	})
end)

local Animations = lib.load('data.animations')
local Items = require 'modules.items.client'
local usingItem = false

-- The cap on the ammunition inside the weapon. Fixed and not depending on GetMaxAmmo because it returns zero
-- in RDR3 as long as w_inventory is the one managing the bullets.
-- The source is config.lua (shared) - the server reads the very same number and validates against it.
local AMMO_CAPACITY = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.ClipCap) or 10))
local BOW_CAPACITY = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.BowCap) or 25))

--- How many rounds the weapon holds loaded (its clip + its own spare rounds), by its kind
--- (Config.Ammo.Categories). The engine clip stays the weapon's real size (modules/weapon/client.lua
--- clipCapacity); the rest waits in the type's reserve so the game reloads by itself.
--- * The cap is the server's rule too (weaponCapacity reads the same helper) - so the client does not
--- compute a shortfall it refuses.
local function getWeaponCapacity(weaponItem)
	if not weaponItem then return AMMO_CAPACITY end
	if weaponItem.hash == `WEAPON_BOW` or weaponItem.hash == `WEAPON_BOW_IMPROVED` then
		return BOW_CAPACITY
	end

	return shared.weaponLoadCap(weaponItem.name)
end

---@param data { name: string, label: string, count: number, slot: number, metadata: table<string, any>, weight: number }
lib.callback.register('w_inventory:usingItem', function(data, noAnim)
	local item = Items[data.name]

	if item and usingItem then
		if not item.client then return true end
		---@cast item +WClientProps
		item = item.client

		if type(item.anim) == 'string' then
			item.anim = Animations.anim[item.anim]
		end

		if item.prop then
			if item.prop[1] then
				for i = 1, #item.prop do
					if type(item.prop) == 'string' then
						item.prop = Animations.prop[item.prop[i]]
					end
				end
			elseif type(item.prop) == 'string' then
				item.prop = Animations.prop[item.prop]
			end
		end

		if not item.disable then
			item.disable = { combat = true }
		elseif item.disable.combat == nil then
			-- Backwards compatibility; you probably don't want people shooting while eating and bandaging anyway
			item.disable.combat = true
		end

		local success = (not item.usetime or noAnim or lib.progressBar({
			duration = item.usetime,
			label = item.label or locale('using', data.metadata.label or data.label),
			useWhileDead = item.useWhileDead,
			canCancel = item.cancel,
			disable = item.disable,
			anim = item.anim or item.scenario,
			prop = item.prop --[[@as ProgressProps]]
		})) and not PlayerData.dead

		if success then
			if item.notification then
				Utils.Notify({ description = locale(item.notification) })
			end

			if item.status then
				if client.setPlayerStatus then
					client.setPlayerStatus(item.status)
				end
			end

			return true
		end
	end
end)

local function canUseItem(isAmmo)
	local ped = cache.ped

	-- The ammunition does not require a weapon in hand: the bow is holstered automatically when the arrows run out,
	-- and loading it from the bag must stay possible. The ammunition branch itself checks
	-- that a suitable weapon exists and refuses if it finds none.
	return not usingItem
		and PlayerData.loaded
		and not PlayerData.dead
		and not invBusy
		and not lib.progressActive()
		and not IsPedRagdoll(ped)
		and not IsPedFalling(ped)
end

---@param data table
---@param cb fun(response: SlotWithItem | false)?
---@param noAnim? boolean
local function useItem(data, cb, noAnim)
	local slotData, result = PlayerData.inventory[data.slot]

	if not slotData or not canUseItem(data.ammo and true) then return end

	if currentWeapon?.timer and currentWeapon.timer > 100 then return end

	if invOpen and data.close then client.closeInventory() end

	usingItem = true
	---@type boolean?
	-- protected: an await that throws (w_lib rejects a callback after its timeout) used to skip the
	-- reset below and leave usingItem on for good - combat blocked, no item usable, until a relog
	local called
	called, result = pcall(lib.callback.await, 'w_inventory:useItem', 200, data.name, data.slot, slotData.metadata, noAnim)

	if not called then
		warn(('w_inventory: using "%s" failed: %s'):format(tostring(slotData.name), tostring(result)))
		result = nil
	end

	if result and cb then
		local success, response = pcall(cb, result and slotData)

		if not success and response then
			warn(('^1An error occurred while calling item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(slotData.name,
				response))
		end
	end

	if result then
		TriggerEvent('w_inventory:usedItem', slotData.name, slotData.slot, next(slotData.metadata) and slotData
			.metadata)
	end

	Wait(500)
	usingItem = false
end

AddEventHandler('w_inventory:usedItem', function(name, slot, metadata)
	TriggerServerEvent('w_inventory:usedItemInternal', slot)
end)

AddEventHandler('w_inventory:item', useItem)
exports('useItem', useItem)

--- Puts the equipped weapons away before a satchel item is used. Assigned below, next to the
--- weapon-wheel loadout bridge that owns the holster transaction (dual wield included).
local holsterForItem

---@param slot number
---@return boolean?
local function useSlot(slot, noAnim)
    if NativeWeapons then
        if not canUseItem(false) then return false, 'busy' end
        local item = PlayerData.inventory[tonumber(slot)]
        local data = item and Items[item.name]
        if not data then return false, 'invalid_item' end
        if data.nativeType ~= 'weapon' and data.nativeType ~= 'weapon_thrown'
            and IsPedInMeleeCombat(PlayerPedId()) then return false, 'in_melee' end
        if invOpen and data.close then client.closeInventory() end
        return NativeWeapons.use(slot)
    end
	local item = PlayerData.inventory[slot]
	if not item then return end

	local data = Items[item.name]
	if not data then return end
    if data.nativeSource == 'vorp' and not data.weapon and not data.nativeGunbelt then
        if not canUseItem(false) then return false, 'busy' end
        if invOpen and data.close then client.closeInventory() end
        return lib.callback.await('w_inventory:vorp:useItem', false, slot, item.name)
    end

	if canUseItem(data.ammo and true) then
		local durability = item.metadata.durability --[[@as number?]]
		local consume = data.consume --[[@as number?]]
		local label = item.metadata.label or item.label --[[@as string]]

		-- Naive durability check to get an early exit
		-- People often don't call the 'useItem' export and then complain about "broken" items being usable
		-- This won't work with degradation since we need access to os.time on the server
		if durability and durability <= 100 and consume then
			if durability <= 0 then
				Utils.Notify({ type = 'error', description = locale('no_durability', label) })
				return
			elseif consume ~= 0 and consume < 1 and durability < consume * 100 then
				Utils.Notify({ type = 'error', description = locale('not_enough_durability', label) })
				return
			end
		end

		data.slot = slot

		if item.metadata.container then
			return client.openInventory('container', item.slot)
		elseif data.client then
			if invOpen and data.close then client.closeInventory() end

			if data.export then
				return data.export(data, { name = item.name, slot = item.slot, metadata = item.metadata })
			elseif data.client.event then -- re-add it, so I don't need to deal with morons taking screenshots of errors when using trigger event
				return TriggerEvent(data.client.event, data,
					{ name = item.name, slot = item.slot, metadata = item.metadata })
			end
		end

		if data.effect then
			data:effect({ name = item.name, slot = item.slot, metadata = item.metadata })
		elseif data.weapon then
			if EnableWeaponWheel or not plyState.canUseWeapons then return end
			-- Drawing, holstering, dual-wield GUID work, and Rockstar item
			-- interactions all report short UNARMED windows. The observer below is
			-- for external weapon changes, not for interrupting our own transaction.
			pauseWeaponWatchdog(1500)

			if IsCinematicCamRendering() then SetCinematicModeActive(false) end

			if currentWeapon and currentWeapon.slot == data.slot then
				-- Unequipping really takes the weapon off the player (it does not leave it
				-- 'holstered' in the ped's store). Leaving the record standing used to keep
				-- the weapon in the player's hand and in the weapon wheel despite its use being cancelled,
				-- so the wheel showed weapons the bag does not use.
				currentWeapon       = Weapon.Disarm(currentWeapon, true, false)
				heldWeapon          = nil
				heldWeaponInfo      = nil

				-- The weapon wheel's rule: what the bag does not use does not appear in it.
				-- No weapon in use left => nothing left on the character.
				if not currentWeapon then Weapon.ClearAll(nil) end
				return
			end

			-- A weapon held in the hands but not currentWeapon - and currentWeapon
			-- itself may be nil after the last one is holstered. Without this independent
			-- check an already-held weapon is 'equipped' again instead of being holstered.
			if Weapon.DualWield.HasSlot(data.slot) then
				-- Use the full disarm transaction so the remaining hand and its
				-- shared ammunition continue to be tracked.
				currentWeapon = Weapon.Disarm(item, true)
				return
			end

			local equipped = false
			useItem(data, function(result)
				if result then
					local sleep, equipError
					local previousWeapon = currentWeapon
					local nextWeapon
					nextWeapon, sleep, equipError = Weapon.Equip(item, data)

					if nextWeapon then
						currentWeapon = nextWeapon
						equipped = true
					else
						currentWeapon = previousWeapon
						local localeKey = equipError == 'left_holster_required' and 'dual_holster_required'
							or equipError == 'hands_full' and 'dual_hands_full'
							or equipError and 'dual_equip_failed'

						if localeKey then
							-- * The game's own art: two crossed pistols. 'You need a left holster'
							--   with a generic cross reads as an error, and with this it reads as an unmet condition - which is
							--   what it is. And w_hud already uses the file in the wheel.
							local icon = (localeKey == 'dual_holster_required'
								or localeKey == 'dual_hands_full')
								and 'nui://w_lib/web/build/assets/images/wheel/weapon_dualwield.png' or nil

							Utils.Notify({
								id = localeKey,
								type = 'error',
								icon = icon,
								description = locale(localeKey)
							})
						end
					end

					if sleep then Wait(sleep) end
				end
			end, true)
			return equipped
		elseif data.ammo then
			-- Loading is now from the weapon itself through the 'reload' button in its menu.
			-- Using the ammunition directly was removed because it does not determine which weapon
			-- gets filled when you carry two.
			Utils.Notify({
				id = 'use_weapon_reload',
				title = locale('ammo_title'),
				type = 'info',
				description = locale('use_weapon_reload')
			})
		elseif currentWeapon then
			-- ! RDR keeps an equipped weapon as currentWeapon while it rests in its holster (see the
			--   watchdog: being holstered is not being unequipped), so this branch used to drop, with
			--   no word, every item of a player wearing a gun belt - food, drink, medicine and horse
			--   care simply did nothing. Put the guns away first, as the game does before any satchel
			--   item, then use it; an allowArmed item keeps the weapon in hand.
			if not data.allowArmed and holsterForItem then holsterForItem() end
			useItem(data)
		elseif not data.ammo then
			useItem(data)
		end
	end
end
exports('useSlot', useSlot)

--- Equip one exact inventory weapon instance without leaving stale GUIDs in
--- either RDR hand. A compatible second sidearm is preserved as dual wield;
--- every other transition is an atomic holster-all -> draw transaction.
---@param slot number
---@param noAnim? boolean
---@return boolean
local function selectWeaponSlot(slot, noAnim)
    if NativeWeapons then return useSlot(slot, noAnim) end
	slot = tonumber(slot)
	local item = slot and PlayerData.inventory and PlayerData.inventory[slot]
	local data = item and Items[item.name]

	if not item or not data or not data.weapon then return false end

	-- 'Using' an already-equipped weapon = unequipping it, not nothing. This used to return
	-- true at once, so the use button/the double click/the hotbar never lowered the weapon
	-- from the player's hand. We hand the matter to useSlot as it owns the full holstering
	-- transaction (the second hand and the shared ammunition pool included).
	if currentWeapon?.slot == slot or Weapon.DualWield.HasSlot(slot) then
		return useSlot(slot, noAnim ~= false) == true
	end

	local usage = Weapon.GetUsageState(currentWeapon)
	local canAddAsSecondSidearm = false

	if usage.count == 1 and Weapon.DualWield.IsCompatible(data.hash) then
		local held = usage.hands[1]
		local heldItem = held and PlayerData.inventory and PlayerData.inventory[tonumber(held.slot)]
		local heldData = heldItem and Items[heldItem.name]

		canAddAsSecondSidearm = heldData ~= nil
			and Weapon.DualWield.IsCompatible(heldData.hash)
	end

	if usage.count > 0 and not canAddAsSecondSidearm then
		Weapon.ClearAll(currentWeapon)
		currentWeapon = nil
		heldWeapon = nil
		heldWeaponInfo = nil
		Wait(0)
	end

	return useSlot(slot, noAnim ~= false) == true
end

exports('selectWeaponSlot', selectWeaponSlot)

-- Rebuild one held exact GUID after a gunsmith save. The updated component
-- tree is committed while holstered, then the weapon is drawn once in its
-- final form. This is intentionally not implemented as a visible-object patch.
local refreshingWeaponGuid = {}

---@param slot number
---@param serial any
---@param gunComps table
---@return boolean
---@return string?
local function refreshWeaponGuidComponents(slot, serial, gunComps)
	slot = tonumber(slot)
	local item = slot and PlayerData.inventory and PlayerData.inventory[slot]
	local data = item and Items[item.name]
	if not item or not data or not data.weapon then return false, 'invalid_weapon' end
	if not Weapon.DualWield.HasSlot(slot) then return false, 'not_held' end
	if refreshingWeaponGuid[slot] then return false, 'busy' end

	local actualSerial = item.metadata and (item.metadata.serial or item.metadata.serial_number)
	if serial ~= nil and tostring(serial) ~= tostring(actualSerial) then
		return false, 'serial_mismatch'
	end

	local clean = {}
	for key, component in pairs(type(gunComps) == 'table' and gunComps or {}) do
		if type(component) == 'string' then clean[key] = component end
	end
	item.metadata = item.metadata or {}
	item.metadata.gunComps = clean

	refreshingWeaponGuid[slot] = true
	pauseWeaponWatchdog(5000)

	local ok, result, reason = pcall(function()
		-- Capture both exact instances before releasing anything. Rebuilding only
		-- the edited off-hand gun makes RDR move the other gun left/right and can
		-- swap used2. Rebuild the original left hand first and original right hand
		-- second, so the final serial/slot/hand assignment is unchanged.
		local state = Weapon.GetUsageState(currentWeapon)
		local rebuild = {}

		for _, held in ipairs(type(state) == 'table' and state.hands or {}) do
			local heldSlot = tonumber(held.slot)
			local heldItem = heldSlot and PlayerData.inventory[heldSlot]
			local heldData = heldItem and Items[heldItem.name]

			if heldItem and heldData and heldData.weapon then
				rebuild[#rebuild + 1] = {
					hand = tonumber(held.hand) or 0,
					item = heldItem,
					data = heldData,
				}
			end
		end

		if #rebuild == 0 then return false, 'not_held' end

		table.sort(rebuild, function(a, b)
			-- DualWield.Give always puts the newest gun in hand 0. Therefore hand
			-- 1 must be restored first, followed by hand 0.
			return a.hand > b.hand
		end)

		Weapon.ClearAll(currentWeapon, true)
		currentWeapon = nil
		heldWeapon = nil
		heldWeaponInfo = nil
		Wait(0)

		for index = 1, #rebuild do
			local entry = rebuild[index]
			local rebuilt, _, equipError = Weapon.Equip(entry.item, entry.data, true, {
				skipUsageSync = true,
				silent = true,
			})

			if not rebuilt then
				-- Do not leave the server claiming two used weapons when the engine
				-- accepted only the instances rebuilt so far.
				Weapon.SyncUsage(currentWeapon)
				return false, equipError or 'engine_failed'
			end
			currentWeapon = rebuilt
		end

		heldWeapon = nil
		heldWeaponInfo = nil
		Weapon.SyncUsage(currentWeapon)
		return true
	end)

	refreshingWeaponGuid[slot] = nil
	if not ok then return false, tostring(result) end
	return result == true, reason
end

exports('refreshWeaponGuidComponents', refreshWeaponGuidComponents)

--- Holster every exact weapon instance, including both members of an
--- identical dual-wield pair, while committing ammo and used/used2 first.
---@return boolean
---@param noAnim? boolean it skips the holstering animation (for the internal paths and for death)
local function clearWeapons(noAnim)
    if NativeWeapons then return NativeWeapons.clear() end
	-- * The holstering animation on RDR3.
	--
	-- Weapon.Disarm plays no animation of its own, so the weapon used to be taken off at once: it
	-- disappeared from the hand then its copy appeared in the holster. And that is what the player sees on TAB.
	--
	-- We use the game's own animation and wait for the switching task to end before taking it off, so the
	-- animation completes first then the decorative copy is handed to the holster.
	if not noAnim and currentWeapon then
		local ped = PlayerPedId()
		HolsterPedWeapons(ped, true, false, true, false)

		local deadline = GetGameTimer() + 1200 -- a cap: we do not suspend the holstering if the task never started
		while GetScriptTaskStatus(ped, `SCRIPT_TASK_SWAP_WEAPON`, true) ~= 8
			and GetGameTimer() < deadline do
			Wait(0)
		end
	end

	Weapon.ClearAll(currentWeapon)
	currentWeapon = nil
	heldWeapon = nil
	heldWeaponInfo = nil
	return true
end

exports('clearWeapons', clearWeapons)

local activeWeaponInspection

local function weaponSerial(item)
	local metadata = item and item.metadata or {}
	return metadata.serial or metadata.serial_number
end

local function sameWeaponSerial(a, b)
	if a == nil or b == nil then return a == b end
	return tostring(a) == tostring(b)
end

-- Weapon-wheel visual loadout bridge. Legacy `held` means registered inventory
-- instances; `drawn` reports what is in the hands while `equipped` remains Use.
local wheelLoadoutBusy = false

local function wheelWeaponDrawn(slot, hash, hand)
	if Weapon.DualWield.HasSlot(slot) then
		hand = Weapon.DualWield.HandForSlot(slot)
	elseif not currentWeapon or currentWeapon.slot ~= slot then
		return false
	end

	local called, found, currentHash = pcall(GetCurrentPedWeapon, PlayerPedId(), true, hand or 0, true)
	if not called or not (found == true or found == 1) or currentHash ~= hash then return false end
	local ok, object = pcall(GetCurrentPedWeaponEntityIndex, PlayerPedId(), hand or 0)
	-- the native answers 1 on this client, never true: `== true` read every drawn gun as holstered
	return ok and object ~= nil and object ~= 0 and DoesEntityExist(object) and true or false
end

local function runWheelLoadoutAction(action)
	if not PlayerData or not PlayerData.loaded or not PlayerData.inventory then return false, 'not_ready' end
	if wheelLoadoutBusy or usingItem or invBusy or activeWeaponInspection or Weapon.DualWield.Busy() then
		return false, 'busy'
	end
	if PlayerData.dead or IsPedFatallyInjured(PlayerPedId()) then return false, 'dead' end

	wheelLoadoutBusy, usingItem = true, true
	pauseWeaponWatchdog(2200)
	local called, result, reason = pcall(action)
	wheelLoadoutBusy, usingItem = false, false
	if not called then return false, 'engine_failed' end
	return result == true, reason
end

local function holsterWeaponWheelLoadout()
    if NativeWeapons then return NativeWeapons.holster() end
	return runWheelLoadoutAction(function()
		local usage = Weapon.GetUsageState(currentWeapon)
		if usage.count == 0 then return true end
		HolsterPedWeapons(PlayerPedId(), true, false, true, false)
		local deadline = GetGameTimer() + 1200
		repeat
			local drawn = false
			for _, entry in ipairs(usage.hands) do
				if wheelWeaponDrawn(entry.slot, entry.hash, entry.hand) then drawn = true break end
			end
			if not drawn then
				heldWeapon, heldWeaponInfo = unarmedHash, currentWeapon
				return true
			end
			Wait(0)
		until GetGameTimer() >= deadline
		return false, 'holster_failed'
	end)
end

local function drawWeaponWheelLoadout(slots)
    if NativeWeapons then return NativeWeapons.draw(slots) end
	return runWheelLoadoutAction(function()
		if type(slots) ~= 'table' or #slots < 1 or #slots > 2 then return false, 'invalid_weapon' end
		local usage = Weapon.GetUsageState(currentWeapon)
		if usage.count ~= #slots then return false, 'loadout_changed' end
		local active, seen = {}, {}
		for _, entry in ipairs(usage.hands) do active[tonumber(entry.slot)] = entry end
		for _, requested in ipairs(slots) do
			local slot = tonumber(requested)
			if not slot or seen[slot] or not active[slot] then return false, 'loadout_changed' end
			seen[slot] = true
			local item = PlayerData.inventory[slot]
			local data = item and Items[item.name]
			if not data or not data.weapon or data.hash ~= active[slot].hash then
				return false, 'loadout_changed'
			end
		end

		if Weapon.DualWield.Count() > 0 then
			local ok, reason = Weapon.DualWield.Draw(slots)
			if not ok then return false, reason end
		else
			local item = PlayerData.inventory[tonumber(slots[1])]
			if #slots ~= 1 or not currentWeapon or currentWeapon.slot ~= item.slot
				or currentWeapon.name ~= item.name
				or not sameWeaponSerial(weaponSerial(currentWeapon), weaponSerial(item)) then
				return false, 'loadout_changed'
			end
			-- Restore only this already-equipped slot's saved ammunition before drawing.
			-- Holstering can leave a bow/rifle with an empty native clip.
			local ammoType = Weapon.AmmoTypeForSlot(item.slot)
			if ammoType ~= 0 and not Items[item.name].throwable then
				SetAmmoTypeForPedWeapon(PlayerPedId(), currentWeapon.hash, ammoType)
				Weapon.ApplyAmmoSeparation(ammoType)
			end
			SetCurrentPedWeapon(PlayerPedId(), currentWeapon.hash, false, 0, false, false)
			local deadline = GetGameTimer() + 1200
			while not wheelWeaponDrawn(item.slot, currentWeapon.hash, 0) do
				if GetGameTimer() >= deadline then return false, 'draw_failed' end
				Wait(0)
			end
		end
		heldWeapon, heldWeaponInfo = nil, nil
		return true
	end)
end

exports('holsterWeaponWheelLoadout', holsterWeaponWheelLoadout)
holsterForItem = holsterWeaponWheelLoadout
exports('drawWeaponWheelLoadout', drawWeaponWheelLoadout)
-- End weapon-wheel visual loadout bridge.

local function exactInspectionWeapon(slot, name, serial)
	slot = tonumber(slot)
	local item = slot and PlayerData.inventory and PlayerData.inventory[slot]
	local data = item and Items[item.name]

	if not item or not data or not data.weapon or item.name ~= name then return end
	if not sameWeaponSerial(weaponSerial(item), serial) then return end

	item.metadata = item.metadata or {}
	item.hash = data.hash
	item.slot = slot
	return item, data
end

local function releaseWeaponInspection()
	local active = activeWeaponInspection
	local item = active and exactInspectionWeapon(active.slot, active.name, active.serial) or nil

	Weapon.EndInspection()
	activeWeaponInspection = nil
	-- START_TASK_ITEM_INTERACTION can report UNARMED for a few frames while
	-- exiting. Keep the generic held-weapon watchdog asleep through that edge;
	-- otherwise it calls useSlot on the same weapon and toggles it back out.
	pauseWeaponWatchdog(900)

	if item then
		heldWeapon = item.hash
		heldWeaponInfo = item
	end
end

---Put one exact weapon instance in the primary hand and start Rockstar's
---SHORTARM/LONGARM inspection pose. Identical models remain separated by
---slot + name + serial before any task or server callback is allowed.
local function beginWeaponInspection(slot, name, serial)
	if activeWeaponInspection then return { ok = false, reason = 'busy' } end

	local item, data = exactInspectionWeapon(slot, name, serial)
	local isGun = item and IsWeaponAGun(data.hash)
	if not item or (isGun ~= true and isGun ~= 1) then
		return { ok = false, reason = 'invalid_weapon' }
	end

	-- Reserve the inspection before equipping or starting the Rockstar task.
	-- The 100 ms generic weapon watchdog must not interpret the task's temporary
	-- UNARMED frames as an external draw/holster request.
	activeWeaponInspection = {
		slot = item.slot,
		name = item.name,
		serial = weaponSerial(item),
		pending = true,
	}

	local usage = Weapon.GetUsageState(currentWeapon)
	if usage.count ~= 1 or currentWeapon?.slot ~= item.slot then
		Weapon.ClearAll(currentWeapon)
		currentWeapon = nil
		heldWeapon = nil
		heldWeaponInfo = nil
		Wait(0)

		if useSlot(item.slot, true) ~= true then
			activeWeaponInspection = nil
			return { ok = false, reason = 'equip_failed' }
		end
	end

	item, data = exactInspectionWeapon(slot, name, serial)
	if not item or not Weapon.BeginInspection(item) then
		activeWeaponInspection = nil
		return { ok = false, reason = 'inspect_failed' }
	end

	local observed = Weapon.GetMaintenanceStatus(item)
	local response = lib.callback.await('w_inventory:getWeaponMaintenance', false,
		item.slot, item.name, weaponSerial(item), observed)

	if type(response) ~= 'table' or response.ok ~= true then
		releaseWeaponInspection()
		return type(response) == 'table' and response or { ok = false, reason = 'server_error' }
	end

	activeWeaponInspection.pending = nil

	return response
end

exports('beginWeaponInspection', beginWeaponInspection)

local function getWeaponMaintenance(slot, name, serial)
	local item = exactInspectionWeapon(slot, name, serial)
	if not item then return { ok = false, reason = 'invalid_weapon' } end

	local observed = Weapon.GetMaintenanceStatus(item)
	local response = lib.callback.await('w_inventory:getWeaponMaintenance', false,
		item.slot, item.name, weaponSerial(item), observed)
	return type(response) == 'table' and response or { ok = false, reason = 'server_error' }
end

exports('getWeaponMaintenance', getWeaponMaintenance)

local function cleanInspectedWeapon(slot, name, serial)
	local active = activeWeaponInspection
	if not active or tonumber(slot) ~= active.slot or name ~= active.name
		or not sameWeaponSerial(serial, active.serial) then
		return { ok = false, reason = 'invalid_weapon' }
	end

	local item = exactInspectionWeapon(slot, name, serial)
	if not item then return { ok = false, reason = 'invalid_weapon' } end

	local observed = Weapon.GetMaintenanceStatus(item)
	local response = lib.callback.await('w_inventory:cleanWeapon', false,
		item.slot, item.name, weaponSerial(item), observed)

	if type(response) ~= 'table' then return { ok = false, reason = 'server_error' } end
	if response.ok ~= true then return response end

	-- Re-resolve after the server's slot sync; it may replace the client table.
	item = exactInspectionWeapon(slot, name, serial)
	if item then
		local duration = Config.WeaponMaintenance and Config.WeaponMaintenance.cleanDuration or 2800
		if not Weapon.PlayCleaningInspection(item, duration, response.state) then
			Weapon.ApplyMaintenanceState(item, response.state)
		end
	end

	return response
end

exports('cleanInspectedWeapon', cleanInspectedWeapon)

local function endWeaponInspection()
	releaseWeaponInspection()
	return true
end

exports('endWeaponInspection', endWeaponInspection)
exports('isWeaponInspecting', function()
	return activeWeaponInspection ~= nil and Weapon.IsInspecting()
end)

local restoreGeneration = 0

-- Wraith host: setPlayerInventory arrives at character login while w_creators is still rendering
-- and placing the ped, so the saved weapons wait for w_core's post-spawn signal. Not the
-- isLoggedIn bag alone: w_hud's probe sets it at login. True at load = w_inventory restarted in the world.
local worldReady = LocalPlayer.state.isLoggedIn == true
exports.w_lib:FwOnCharacterLoaded(function() worldReady = true end)
exports.w_lib:FwOnCharacterUnloaded(function() worldReady = false end)

local function isUsageFlag(value)
	return value == true or value == 1 or value == '1'
end

--- Restore the persisted VORP-style used/used2 pair after character load.
--- The left weapon is equipped first, then the used2/current weapon, matching
--- the GUID transaction required by RDR3 for two identical revolvers.
local function restoreUsedWeapons()
    if NativeWeapons then return end
	restoreGeneration += 1
	local generation = restoreGeneration
	local primary, secondary
	local slots = {}

	for slot in pairs(PlayerData.inventory or {}) do slots[#slots + 1] = tonumber(slot) end
	table.sort(slots)

	for i = 1, #slots do
		local item = PlayerData.inventory[slots[i]]
		local data = item and Items[item.name]
		local metadata = item and item.metadata or {}
		local used = data and data.weapon and isUsageFlag(metadata.used or item.used)

		if used then
			local ref = { slot = item.slot, serial = metadata.serial }
			if isUsageFlag(metadata.used2 or item.used2) and not primary then
				primary = ref
			elseif not secondary then
				secondary = ref
			end
		end
	end

	if Config.RestoreUsedWeapons == false then
		return Weapon.SyncUsage(nil)
	end

	local order = {}
	if primary and secondary then
		order[1], order[2] = secondary, primary
	elseif primary or secondary then
		order[1] = primary or secondary
	else
		return
	end

	CreateThread(function()
		local wcore = shared.backend == 'wcore'
		if wcore then
			while not worldReady do
				Wait(250)
				if generation ~= restoreGeneration or not PlayerData.loaded then return end
			end
		end
		Wait(500)
		if generation ~= restoreGeneration or not PlayerData.loaded then return end

		-- the bag and hotkeys work in the short gap before w_core's signal: a weapon the player
		-- drew himself there is kept as it is, never equipped a second time
		if wcore and (currentWeapon or Weapon.DualWield.Count() > 0) then
			return Weapon.SyncUsage(currentWeapon)
		end

		for i = 1, #order do
			local ref = order[i]
			local item = PlayerData.inventory and PlayerData.inventory[ref.slot]
			local metadata = item and item.metadata or {}
			local data = item and Items[item.name]

			if item and data and data.weapon
				and (ref.serial == nil or tostring(ref.serial) == tostring(metadata.serial))
				and Weapon.CanEquip(item, data) then
				local equipped = Weapon.Equip(item, data, true, {
					skipUsageSync = true,
					silent = true,
				})

				if equipped then
					currentWeapon = equipped
					Wait(100)
				end
			end
		end

		Weapon.SyncUsage(currentWeapon)
	end)
end

---@param id number
---@param slot number
local function useButton(id, slot)
	if PlayerData.loaded and not invBusy and not lib.progressActive() then
		local item = PlayerData.inventory[slot]
		if not item then return end

		local data = Items[item.name]
		local buttons = data?.buttons
		local buttonId = tonumber(id)

		-- Compatibility with older/custom NUI builds that sent the visible label
		-- instead of the numeric button index. The production React UI sends the
		-- index, but resolving a label here keeps integrations from failing silently.
		if not buttonId and type(id) == 'string' and buttons then
			for index = 1, #buttons do
				if buttons[index].label == id then
					buttonId = index
					break
				end
			end
		end

		if buttonId and buttons and buttons[buttonId]?.action then
			buttons[buttonId].action(slot)
		end
	end
end

-- ============================================================
-- Defined at the bottom of the file after findAmmoSlot; the buttons capture it as an upvalue
local reloadWeapon

-- The packing and unpacking options in the ammunition's right-button menu.
-- The linking (ammoPack / ammoUnpack) happens in modules/items/shared.lua,
-- and the conversion itself on the server - here is only a request and a notification of the result.
-- ============================================================
do
	-- ! It is called from RegisterNUICallback, and lib.callback.await needs a thread
	-- that can suspend. Without CreateThread the call is aborted silently so nothing happens.
	local function requestPack(slot)
		CreateThread(function()
			local operationId = lib.callback.await('w_inventory:prepareAmmoPack', false, slot)
            if not operationId then return end
            local success, reason, amount = lib.callback.await('w_inventory:packAmmo', false, slot, operationId)

			if success then
				return Utils.Notify({
					title = locale('ammo_title'),
					type = 'success',
					description = reason == 'packed'
						and locale('ammo_packed', amount)
						or locale('ammo_unpacked', amount)
				})
			end

			Utils.Notify({
				title = locale('ammo_title'),
				type = 'error',
				description = reason == 'need' and locale('ammo_pack_need', amount)
					or reason == 'weight' and locale('ammo_pack_weight')
					or locale('ammo_pack_failed')
			})
		end)
	end

	for _, item in pairs(Items) do
		if item.ammoPack or item.ammoUnpack then
			item.buttons = item.buttons or {}
			-- `key` keeps the dictionary key so the label follows a live language switch
			local key = item.ammoPack and 'button_pack' or 'button_unpack'
			item.buttons[#item.buttons + 1] = {
				label = locale(key),
				key = key,
				action = requestPack,
			}
		end

		-- The reload button on the weapon itself: the only path to loading, and it determines the exact
		-- copy of the weapon when you carry two identical ones.
		if item.weapon and (item.ammoname or item.throwable) then
			item.buttons = item.buttons or {}
			item.buttons[#item.buttons + 1] = {
				label = locale('button_refill'),
				key = 'button_refill',
				action = function(slot)
					CreateThread(function() reloadWeapon(slot) end)
				end,
			}
		end
	end
end

--- Re-translate the button labels built above after the language changed.
local function relabelItemButtons()
	for _, item in pairs(Items) do
		local buttons = type(item) == 'table' and item.buttons

		if buttons then
			for i = 1, #buttons do
				local button = buttons[i]
				if button.key then button.label = locale(button.key) end
			end
		end
	end
end

--- The item catalogue the NUI needs (labels, buttons, category, image); built at load and
--- again after a language switch.
local function buildItemData()
	local ItemData = table.create(0, #Items)

	for _, v in pairs(Items --[[@as table<string, WClientItem>]]) do
		local buttons = v.buttons and {} or nil

		if buttons then
			for i = 1, #v.buttons do
				buttons[i] = { label = v.buttons[i].label, group = v.buttons[i].group }
			end
		end

		local itemType = 'item_misc'
		if v.weapon then itemType = 'item_weapon'
		elseif v.ammo then itemType = 'item_ammo'
		elseif v.client and (v.client.status or v.client.food) then itemType = 'item_food'
		elseif v.allowArmed then itemType = 'item_food'
		elseif v.consume and v.close then itemType = 'item_food'
		end

		ItemData[v.name] = {
			label = v.label,
			stack = v.stack,
			close = v.close,
			count = v.count or 0,
			description = v.description,
			buttons = buttons,
			ammoName = v.ammoname,
			image = v.client?.image,
			category = itemType,
			weapon = v.weapon or false
		}
	end

	return ItemData
end

local function openNearbyInventory() client.openInventory('player') end

exports('openNearbyInventory', openNearbyInventory)

local currentInstance
local playerCoords
local Shops = require 'modules.shops.client'

---@todo remove or replace when the bridge module gets restructured
function OnPlayerData(key, val)
	if key ~= 'groups' and key ~= 'ped' and key ~= 'dead' then return end

	if key == 'groups' then
		Inventory.Stashes()
		Inventory.Evidence()
		Shops.refreshShops()
	elseif key == 'dead' and val then
		Weapon.ClearAll(currentWeapon)
		currentWeapon = nil
		client.closeInventory()
	end

	Utils.WeaponWheel()
end

-- People consistently ignore errors when one of the "modules" failed to load
if not Utils or not Weapon or not Items or not Inventory then return end

local invHotkeys = false

---@type function?
--- The first slot holding ammunition suitable for the current weapon.
--- The primary ammunition comes first, and if it runs out we look for any type from the same family
--- (VORP defines every type as a separate item, not as metadata on one item).
local function findAmmoSlot(ammoName, specialAmmo)
	-- The currently loaded type first, so the reload does not jump between types.
	-- * Exclude the weapons: weapons carry ammoFamily (for the ammunition types system), so without this
	--   a corrupt specialAmmo value (a weapon's name) may be treated as ammunition.
	if type(specialAmmo) == 'string' and Items[specialAmmo]?.ammoFamily and not Items[specialAmmo]?.weapon then
		local slotId = Inventory.GetSlotIdWithItem(specialAmmo, nil, false)

		if slotId then return slotId end
	end

	local slotId = Inventory.GetSlotIdWithItem(ammoName, { type = specialAmmo }, false)

	if slotId then return slotId end

	local ammoItem = Items[ammoName]
	local family = ammoItem and ammoItem.ammoFamily

	if not family or not PlayerData.inventory then return end

	for _, slotData in pairs(PlayerData.inventory) do
		local item = slotData and Items[slotData.name]

		-- The boxes and the weapons are excluded: no loading except from a real unpacked bullet item.
		-- * (Weapons carry the same ammoFamily so they were matched as 'ammunition' - this is the cause of loading with no bullets.)
		if item and item.ammoFamily == family and not item.ammoUnpack and not item.weapon and slotData.count > 0 then
			return slotData.slot
		end
	end
end


--- The ammunition state for the carried weapons - for the display interface in w_hud.
---
--- * The only source: metadata.ammo - that is, **what is loaded in this weapon** and nothing else.
---
--- Not the engine's natives: RDR3 has one pool per bullet **type** and not per weapon,
--- and the weapon's store is addressed by the hash, so any reading from it mixes the two weapons up.
---
--- And not the bag's items: the bag's bullets are not in the weapon. They are not read nor shown nor
--- counted until they are loaded. (It used to be counted as a 'reserve' so it looked as if the weapon owned it.)
---@return table[] hands
-- ! Defined here and not before ownedAmmoTypes: the /ammodebug command below reads the family's
-- kinds from it, and a closure that precedes the local's definition sees it as a global, that is nil - so it goes
-- quiet with no error and no use.
local AmmoTypes = lib.load('data.ammo_types_RDR3')

exports('getHeldAmmoState', function()
	local hands = {}
	if not PlayerData or not PlayerData.inventory then return hands end

	-- The very source the separation is computed from: the two-hand record + the single weapon (a bow/a long gun).
	local slots = Weapon.HeldSlots()

	if #slots == 0 and currentWeapon and currentWeapon.slot then
		slots = { currentWeapon.slot }
	end

	for i = 1, #slots do
		local slot = tonumber(slots[i])
		local slotData = slot and PlayerData.inventory[slot]
		local weaponItem = slotData and Items[slotData.name]

		-- * The throwables: the stack is the ammunition.
		--
		-- Dynamite and molotovs and throwing knives have no metadata.ammo - one
		-- in your hand and the rest are throws, and every throw deletes one from the stack (the 'throw' path
		-- on the server). So their honest balance is count and not ammo.
		--
		-- They were excluded here so they never showed in the display at all: you carry ten sticks of dynamite
		-- and no number beside them.
		local throwable = weaponItem and weaponItem.throwable

		if slotData and weaponItem and weaponItem.weapon
			and (throwable or weaponItem.ammoname) then
			local metadata = slotData.metadata or {}
			local loaded = throwable
				and math.max(0, math.floor(tonumber(slotData.count) or 0))
				or math.max(0, math.floor(tonumber(metadata.ammo) or 0))

			-- * The loaded bullet kind - for its picture in the display.
			-- Every item's picture is in w_inventory/web/images under the item's name, so the name
			-- is enough and the display builds the path. And the special kind if there is one, otherwise the primary one.
			local ammoItem = not throwable and (
				type(metadata.specialAmmo) == 'string'
					and Items[metadata.specialAmmo] and metadata.specialAmmo
				or weaponItem.ammoname
			) or nil

			hands[#hands + 1] = {
				slot      = slot,
				name      = slotData.name,
				label     = weaponItem.label or slotData.name,
				hand      = Weapon.DualWield.HandForSlot(slot) or 0,
				loaded    = loaded,
				ammoItem  = ammoItem,
				-- A throwable's capacity is what you carry and not a fixed number: it has no store to be filled to.
				capacity  = throwable and loaded or getWeaponCapacity(weaponItem),
				throwable = throwable or nil,
				active    = currentWeapon ~= nil and currentWeapon.slot == slot,
			}
		end
	end

	-- A fixed order: the right hand first, so the two cards do not swap places by
	-- themselves between one call and the next.
	table.sort(hands, function(a, b)
		if a.hand ~= b.hand then return a.hand < b.hand end
		return a.slot < b.slot
	end)

	return hands
end)


-- ════════════════════════════════════════════════════════════════════════════
-- The weapon wheel's state - one read is enough for the whole wheel
--
-- * The source is the bag and not the engine, for the very reason explained above getHeldAmmoState: the ammunition
--   pool in RDR3 is per **type** and not per weapon, so reading it mixes the two weapons up.
--
-- * And no classification here. We export the raw attributes (oneHanded / isGun / throwable) and the wheel
--   decides which slot suits them - the classification is a display policy the bag has no business with, and had it been written
--   here it would have needed the bag edited whenever the server wanted another ordering.
-- ════════════════════════════════════════════════════════════════════════════

--- Counting what is in the bag per item name (the scattered stacks are summed).
---@return table<string, number>
local function bagItemCounts()
	local counts = {}

	for _, slotData in pairs(PlayerData and PlayerData.inventory or {}) do
		local count = slotData and math.floor(tonumber(slotData.count) or 0)

		if slotData and slotData.name and count > 0 then
			counts[slotData.name] = (counts[slotData.name] or 0) + count
		end
	end

	return counts
end

--- The picture the wheel draws for a bag row: the same file the bag shows for it, in the bag UI's
--- own order (getItemUrl): the row's metadata.image, then the item's client.image.
--- ★ Sent two ways: `imageUrl` exactly as the bag loads it, and `image` as the bare file name the
---   wheel also tries in its own image folders. Without them the wheel guessed '<name>.png', which
---   is not the file of the 30 items whose picture has another name (satchel_small -> bag_small,
---   the cooked meats, the scopes ...), of an ammo kind (ammo_revolver -> ammo_bullet_normal) nor
---   of a weapon whose file is not its upper-case name.
--- ⚠️ metadata.imageurl (an address outside the game) is left out: the wheel loads local art only.
---@return string? image, string? imageUrl
local function wheelImage(item, metadata)
	local url
	if type(metadata) == 'table' and type(metadata.image) == 'string' and metadata.image ~= '' then
		url = ('%s/%s.png'):format(client.imagepath, metadata.image)
	elseif item and type(item.client) == 'table' and type(item.client.image) == 'string' and item.client.image ~= '' then
		url = item.client.image
	end
	if not url then return nil, nil end
	return url:match('([^/]+)%.%w+$'), url
end

--- The family's bullet kinds **the player really owns**, with each one's balance.
---
--- * A kind with no item in the bag stays in the list with a balance of zero: the wheel shows it
---   greyed out as the game does, and does not allow switching to it. Deleting it used to make the kinds'
---   order change whenever a kind ran out - which is worse than showing it greyed out.
---@param family string?
---@param counts table<string, number>
---@return table[]
local function ownedAmmoOptions(family, counts)
	local out = {}
	local entries = family and AmmoTypes and AmmoTypes.Families and AmmoTypes.Families[family]

	if not entries then return out end

	local english = shared.localeKey() == 'en'

	for _, entry in ipairs(entries) do
		-- * The name sent back to switchWeaponAmmo must be one the player can load. The registry
		--   now lists the box first (ammo_box_*), so 'the first defined name' offered a box: its
		--   count ignored the loose rounds (greyed out) and switching to it was refused.
		--   Order: the loose stack held most of, else a held box (the reload opens it), else the
		--   first defined loose name (greyed out). The count is every round of the kind, boxes included.
		local itemName, held, boxName, fallback, rounds = nil, 0, nil, nil, 0

		for i = 1, #entry.items do
			local name = entry.items[i]
			local def = Items[name]

			if def then
				local count = counts[name] or 0

				if def.ammoUnpack then
					rounds = rounds + count * math.max(1, math.floor(tonumber(def.ammocount) or 1))
					if count > 0 and not boxName then boxName = name end
				else
					rounds = rounds + count
					fallback = fallback or name
					if count > held then itemName, held = name, count end
				end
			end
		end

		itemName = itemName or boxName or fallback

		if itemName then
			local image, imageUrl = wheelImage(Items[itemName])
			out[#out + 1] = {
				item  = itemName,
				ammo  = entry.ammo,
				label = (english and entry.label_en) or entry.label or itemName,
				count = rounds,
				image = image,
				imageUrl = imageUrl,
			}
		end
	end

	return out
end

--- The kind loaded in a weapon right now - its item's name (nil means the primary one).
---@param weaponItem table
---@param metadata table
---@param family string?
---@return string?
local function loadedAmmoItem(weaponItem, metadata, family)
	if type(metadata.specialAmmo) == 'string' and Items[metadata.specialAmmo] then
		return metadata.specialAmmo
	end

	local default = family and AmmoTypes and AmmoTypes.GetDefault
		and AmmoTypes.GetDefault(family, function(n) return Items[n] ~= nil end)

	return default and default.item or weaponItem.ammoname
end

--- Everything the wheel shows, in one call.
---@return table
exports('getWeaponWheelState', function()
    if NativeWeapons then return NativeWeapons.state() end
	local state = {
		ready   = false,
		weapons = {},
		items   = {},
		oil     = nil,
		dual    = { enabled = false, count = 0, slots = {} },
	}

	if not PlayerData or not PlayerData.inventory then return state end

	state.ready = true

	local counts = bagItemCounts()
	local held   = {}

	for _, slot in ipairs(Weapon.HeldSlots()) do
		held[tonumber(slot)] = true
	end

	if currentWeapon and currentWeapon.slot then held[currentWeapon.slot] = true end

	local maintenance = Config.WeaponMaintenance or {}
	local oilName     = type(maintenance.item) == 'string' and maintenance.item or 'kit_gun_oil'
	local oilItem     = Items[oilName]

	state.oil = {
		name     = oilName,
		label    = oilItem and oilItem.label or oilName,
		count    = counts[oilName] or 0,
		required = math.max(1, math.floor(tonumber(maintenance.consume) or 1)),
		enabled  = maintenance.enabled ~= false,
	}

	local dualHands = Weapon.DualWield.State()
	state.dual.enabled = Weapon.DualWield.IsEnabled() and true or false
	state.dual.count   = #dualHands

	for i = 1, #dualHands do
		state.dual.slots[i] = dualHands[i].slot
	end

	for slot, slotData in pairs(PlayerData.inventory) do
		local weaponItem = slotData and Items[slotData.name]

		if weaponItem and weaponItem.weapon then
			slot = tonumber(slot)

			local metadata  = slotData.metadata or {}
			local hash      = slotData.hash or weaponItem.hash
			local throwable = weaponItem.throwable and true or false
			local count     = math.max(0, math.floor(tonumber(slotData.count) or 0))
			local used, used2 = metadata.used, metadata.used2
			if used == nil then used = slotData.used end
			if used2 == nil then used2 = slotData.used2 end

			-- A throwable's balance is its stack, and a firearm's balance is what is in its own store.
			local loaded = throwable and count
				or math.max(0, math.floor(tonumber(metadata.ammo) or 0))

			local family = weaponItem.ammoname
				and Items[weaponItem.ammoname]
				and Items[weaponItem.ammoname].ammoFamily
				or weaponItem.ammoFamily

			-- ! The natives are guarded: a hash for an unloaded weapon may throw instead of returning false.
			local okHanded, oneHanded = pcall(IsWeaponOneHanded, hash)
			local okGun, isGun        = pcall(IsWeaponAGun, hash)

			local stats, multiplier = Weapon.GetModifiers(slotData)
			local components = {}
            for category, component in pairs(type(metadata.gunComps) == 'table' and metadata.gunComps or {}) do
                if type(component) == 'string' or type(component) == 'number' then components[category] = component end
            end
			local image, imageUrl = wheelImage(weaponItem, metadata)

			state.weapons[#state.weapons + 1] = {
				slot      = slot,
				name      = slotData.name,
				label     = weaponItem.label or slotData.name,
				image     = image,
				imageUrl  = imageUrl,
				hash      = hash,
				serial    = metadata.serial,
				components = components,
				count     = count,

				-- Raw attributes - the wheel classifies with them
				oneHanded = okHanded and (oneHanded == true or oneHanded == 1) or false,
				isGun     = okGun and (isGun == true or isGun == 1) or false,
				throwable = throwable,

				-- The ammunition (from the bag alone)
				ammoname    = weaponItem.ammoname,
				family      = family,
				loaded      = loaded,
				capacity    = throwable and loaded or getWeaponCapacity(weaponItem),
				ammoItem    = not throwable and loadedAmmoItem(weaponItem, metadata, family) or nil,
				ammoOptions = not throwable and ownedAmmoOptions(family, counts) or nil,

				-- The condition (the Condition bar) and the gunsmith's modifications
				condition        = math.max(0, math.min(100, tonumber(metadata.durability) or 100)),
				stats            = stats or {},
				damageMultiplier = multiplier or 1.0,

				-- The two hands
				held = held[slot] or false,
				drawn = held[slot] == true and wheelWeaponDrawn(slot, hash, Weapon.DualWield.HandForSlot(slot) or 0),
				equipped = isUsageFlag(used) or isUsageFlag(used2),
				hand = (Weapon.DualWield.HandForSlot(slot)) or 0,
				dualCapable = Weapon.DualWield.IsCompatible(hash) and true or false,
			}

		elseif weaponItem and (slotData.count or 0) > 0 then
			-- * The non-weapons - for the 'items' and 'horse' tabs in the wheel.
			--
			-- And no filtering here either: we export what is in the bag and the wheel decides what it shows
			-- (the consumable_/kit_/provision_ prefixes and the like in its config). So the server
			-- owner changes the wheel's list with no touching the bag.
			local image, imageUrl = wheelImage(weaponItem, slotData.metadata)
			state.items[#state.items + 1] = {
				slot     = tonumber(slot),
				name     = slotData.name,
				label    = weaponItem.label or slotData.name,
				image    = image,
				imageUrl = imageUrl,
				count    = math.max(0, math.floor(tonumber(slotData.count) or 0)),
				-- The bullets are shown under their weapon and not in the items tab.
				ammoFamily = weaponItem.ammoFamily,
				usable   = weaponItem.consume ~= nil or weaponItem.client ~= nil or nil,
			}
		end
	end

	-- A fixed order by the slot: any other order makes the wheel re-lay its icons between
	-- one opening and the next for no reason the player can see.
	table.sort(state.weapons, function(a, b) return a.slot < b.slot end)
	table.sort(state.items, function(a, b) return a.slot < b.slot end)

	return state
end)


--- /ammodebug - the two truths side by side: what the bag says and what the engine says.
---
--- It was built because the difference between them is the source of every confusion in this file: the engine has one
--- pool per bullet **type** and one store per **hash**, and the bag has a balance
--- per weapon copy. So when the two numbers differ, describing what is seen on the screen is not enough.
RegisterCommand('ammodebug', function()
	local ped = PlayerPedId()
	print('^3── w_inventory / ammo ───────────────────────────────^0')

	-- The very source applyAmmoSeparation computes from - not a second source that contradicts it.
	local hands = Weapon.HeldSlots()
	if #hands == 0 and currentWeapon and currentWeapon.slot then hands = { currentWeapon.slot } end

	if #hands == 0 then
		-- We print the three sources: which of them is empty is the answer, not 'no weapon in hand'.
		local dual, single = Weapon.HeldSources()
		print(('  no carried slot - hands registry=%d . single weapon=%s . currentWeapon=%s')
			:format(#dual, tostring(single),
				tostring(currentWeapon and currentWeapon.slot or nil)))
		-- The parentheses here are for the same reason: a call in the last argument's place spreads all its results,
		-- and zero results throws an error in tostring.
		local heldByEngine = (Citizen.InvokeNative(0x8425C5F057012DAB, ped))
		print(('  held by the engine = %s'):format(tostring(heldByEngine)))
	end

	for i = 1, #hands do
		local slot = tonumber(hands[i])
		local slotData = slot and PlayerData.inventory and PlayerData.inventory[slot]
		local weaponItem = slotData and Items[slotData.name]

		if slotData and weaponItem then
			local metadata = slotData.metadata or {}
			local ammoTypeHash = Weapon.AmmoTypeForSlot(slot)
			local _, clip = pcall(function()
				local _, n = GetAmmoInClip(ped, weaponItem.hash)
				return n
			end)
			local pool = ammoTypeHash ~= 0 and GetPedAmmoByType(ped, ammoTypeHash) or -1

			-- ! The parentheses around the call are necessary: HandForSlot falls off its end with no return
			-- when it does not find the slot, so it returns **zero values** and not nil. And nil is valid for tostring
			-- while nothing throws 'bad argument #1 (value expected)'. And the parentheses
			-- trim the result to one value (nil when empty).
			local hand = (Weapon.DualWield.HandForSlot(slot))

			print(('  [slot %s] %s  hand=%s'):format(tostring(slot), tostring(slotData.name),
				tostring(hand)))
			print(('     metadata : loaded=%s  capacity=%s  special type=%s')
				:format(tostring(metadata.ammo), tostring(getWeaponCapacity(weaponItem)),
					tostring(metadata.specialAmmo)))
			print(('     engine   : clip=%s  type pool=%s  (type=%s)')
				:format(tostring(clip), tostring(pool), tostring(ammoTypeHash)))

			-- * And every kind in the family has its own independent pool. The arrow family is five kinds,
			-- so a non-zero pool in another kind means an arrow that comes back after emptying - and that is
			-- what used to show in the wheel as a number we do not know.
			local family = weaponItem.ammoFamily
			local entries = family and AmmoTypes and AmmoTypes.GetAll
				and AmmoTypes.GetAll(family) or {}

			for e = 1, #entries do
				local name = entries[e].ammo
				local h = name and GetHashKey(name)
				local n = h and math.floor(tonumber(GetPedAmmoByType(ped, h)) or 0) or 0

				if n > 0 then
					print(('        ^1. %s = %d^0  (another kind in the family)'):format(tostring(name), n))
				end
			end
		end
	end

	-- * The pool is the reserve **outside** the store and not its total.
	-- A decisive measurement: a bow with a store of 1 and a pool of 0 - so had it included the store that would have been impossible.
	-- So the total = the pool + the stores, and the honest reserve is the pool itself.
	-- (The formula used to subtract so it came out negative and it called that phantom bullets.)
	local perType = {}

	for i = 1, #hands do
		local slot = tonumber(hands[i])
		local slotData = slot and PlayerData.inventory and PlayerData.inventory[slot]
		local weaponItem = slotData and Items[slotData.name]
		local ammoTypeHash = slot and Weapon.AmmoTypeForSlot(slot) or 0

		if weaponItem and ammoTypeHash ~= 0 then
			local ok, clip = pcall(function()
				local _, n = GetAmmoInClip(ped, weaponItem.hash)
				return n
			end)
			perType[ammoTypeHash] = (perType[ammoTypeHash] or 0)
				+ (ok and math.floor(tonumber(clip) or 0) or 0)
		end
	end

	-- What the bag says for this type - and it is the reference the engine is measured against.
	local owedByType = {}

	for i = 1, #hands do
		local slot = tonumber(hands[i])
		local slotData = slot and PlayerData.inventory and PlayerData.inventory[slot]
		local h = slot and Weapon.AmmoTypeForSlot(slot) or 0

		if slotData and h ~= 0 then
			owedByType[h] = (owedByType[h] or 0)
				+ math.max(0, math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
		end
	end

	for ammoTypeHash, chambered in pairs(perType) do
		local pool = math.floor(tonumber(GetPedAmmoByType(ped, ammoTypeHash)) or 0)
		local owed = owedByType[ammoTypeHash] or 0
		local engine = pool + chambered
		local extra = engine - owed

		print(('  type %s : clips=%d  pool=%d  => engine=%d . bag=%d %s')
			:format(tostring(ammoTypeHash), chambered, pool, engine, owed,
				extra <= 0 and '^2(matching)^0'
					or ('^1(%d extra - the engine keeps a chambered round)^0'):format(extra)))
	end

	-- For the diagnostics alone. Nothing reads from them in the display path nor in the engine - the bag's
	-- bullets are items consumed at reload time only.
	print('^3── the bullet stacks in the bag (diagnostics only) ──────────────^0')
	for _, slotData in pairs(PlayerData.inventory or {}) do
		local item = slotData and Items[slotData.name]
		if item and item.ammoFamily and not item.weapon then
			print(('  %s x%s   (family=%s  type=%s  box=%s)')
				:format(tostring(slotData.name), tostring(slotData.count),
					tostring(item.ammoFamily), tostring(item.ammoType), tostring(item.ammoUnpack)))
		end
	end
end, false)

--- /refilldebug - why the 'reload' button does not show in the weapon's menu.
---
--- * The button passes through three stations, and a fault at any of them looks the same on the screen: no button.
---   So the three are printed together instead of guessing which one broke:
---     1) The item's definition: does it have ammoname/throwable at all?
---     2) The button's registration: was item.buttons attached at load time?
---     3) The interface's payload: did the label survive into what is sent to React?
RegisterCommand('refilldebug', function()
	print('^3── w_inventory / refill ─────────────────────────────^0')
	print(('  locale(button_refill) = %s'):format(tostring(locale('button_refill'))))
	local total, named = 0, 0
	for key, def in pairs(Items) do
		total = total + 1
		if type(def) == 'table' and def.name == key then named = named + 1 end
	end
	print(("  the client's catalogue : %d item(s) . %d keyed by def.name"):format(total, named))
	print(('  direct check WEAPON_BOW = %s'):format(tostring(Items['WEAPON_BOW'] ~= nil)))

	if not PlayerData or not PlayerData.inventory then
		return print('^1  no bag loaded yet^0')
	end

	local found = 0
	for slot, slotData in pairs(PlayerData.inventory) do
		local item = slotData and slotData.name and Items[slotData.name]

		if slotData and slotData.name and not item then
			found = found + 1
			print(('  [slot %s] %s'):format(tostring(slot), tostring(slotData.name)))
			print("     ^1= the item is not defined in the client's catalogue (Items[name] = nil)^0")
			print('     ^1  so no buttons and no label and no picture reach the interface for this item^0')
		elseif item and item.weapon then
			found = found + 1
			local labels = {}
			for i = 1, #(item.buttons or {}) do
				labels[#labels + 1] = tostring(item.buttons[i].label)
			end

			print(('  [slot %s] %s'):format(tostring(slot), tostring(slotData.name)))
			print(('     definition : ammoname=%s  throwable=%s'):format(tostring(item.ammoname), tostring(item.throwable)))
			print(('     buttons : count=%d  [%s]'):format(#(item.buttons or {}), table.concat(labels, ' · ')))

			if #(item.buttons or {}) == 0 then
				print('     ^1= the button was not registered: the condition (item.ammoname or item.throwable) was not met^0')
			else
				print("     ^2= the button is registered in Lua - so the break is after it: the interface's payload or the name key^0")
			end
		end
	end

	if found == 0 then print('^1  no weapon in the bag^0') end
	print('^3─────────────────────────────────────────────────────^0')
end, false)




--- The ammunition types the player actually owns for this weapon (for the refill selection list).
--- It returns a list of { label, item, slot, count, ammo } for every owned type; a type held only
--- as a box points at the box's slot and names the loose round it opens into.
local function ownedAmmoTypes(weaponItem)
	local baseAmmo = weaponItem and weaponItem.ammoname and Items[weaponItem.ammoname]
	local family = baseAmmo and baseAmmo.ammoFamily
	if not family or not AmmoTypes then return {} end

	local owned = {}
	-- the library's language (the player's choice)
	local loc = shared.localeKey()

	-- * We go over **every** item name registered for every type, not the first defined name.
	-- One type may exist under two names (ammoarrownormal and ammo_arrow), and the first **defined**
	-- name used to be chosen then asked about in the bag - so if the player owned the other
	-- name the type showed as unowned, and the arrows disappeared from the reload list.
	for _, entry in ipairs(AmmoTypes.GetAll(family)) do
		local bestItem, bestSlot, bestCount
		local boxItem, boxSlot, boxRounds

		for i = 1, #entry.items do
			local name = entry.items[i]
			local def = Items[name]

			if def then
				local slotId = Inventory.GetSlotIdWithItem(name, nil, false)
				local sd = slotId and PlayerData.inventory[slotId]
				local count = sd and (sd.count or 0) or 0

				if def.ammoUnpack then
					-- * A box is not loaded as such, but it is this type's ammunition all the same: the
					--   shops sell boxes only, so skipping them told a player holding nothing else
					--   'no suitable ammo' for every weapon. It is offered under the loose round it opens
					--   into (the picker's 'current'/'preferred' compare that name); reloadWeapon opens it.
					if count > 0 and not boxSlot then
						boxItem, boxSlot = def.ammoUnpack, slotId
						boxRounds = count * math.max(1, math.floor(tonumber(def.ammocount) or 1))
					end
				elseif count > 0 and (not bestCount or count > bestCount) then
					bestItem, bestSlot, bestCount = name, slotId, count
				end
			end
		end

		-- Loose rounds first: a box is opened only when none of its type is left loose.
		if not bestItem and boxSlot then
			bestItem, bestSlot, bestCount = boxItem, boxSlot, boxRounds
		end

		if bestItem then
			local lbl = (loc == 'en' and entry.label_en) or entry.label or bestItem
			owned[#owned + 1] = {
				label = lbl, item = bestItem, slot = bestSlot,
				count = bestCount, ammo = entry.ammo,
			}
		end
	end

	return owned
end

-- ============================================================
-- The preferred bullet
--
-- * Right-click bookmarks a type for this weapon copy in the bag's ammunition picker.
--   Loading ammunition remains an explicit action in the picker.
--
-- * The key is the serial number and not the slot's number: moving the weapon between slots does not lose it
--   its preference, and two pistols of the same model each keep their own type. And a weapon with no serial
--   (old tools) falls back to the slot+the name, which is weaker but better than nothing.
--
-- * It is saved in KVP and not in the metadata: it is a local preference of the player's and not ownership, so it does not deserve
--   a transaction on the server nor a column in the database.
-- ============================================================
local preferredAmmo = {}
local PREFERRED_KVP = 'w_inventory:preferredAmmo:'

local function weaponIdentity(slotData)
	if type(slotData) ~= 'table' then return nil end
	local serial = slotData.metadata and slotData.metadata.serial
	if serial ~= nil and tostring(serial) ~= '' then return 'serial:' .. tostring(serial) end
	if slotData.slot and slotData.name then
		return ('slot:%s:%s'):format(tostring(slotData.slot), tostring(slotData.name))
	end
end

--- @return string? the preferred ammunition item's name for this copy
local function getPreferredAmmo(slotData)
	local key = weaponIdentity(slotData)
	if not key then return nil end

	local value = preferredAmmo[key]
	if value == nil then
		-- false means 'we read and there is no preference', so we do not hit KVP again every frame.
		value = GetResourceKvpString(PREFERRED_KVP .. key) or false
		preferredAmmo[key] = value
	end

	return value ~= false and value or nil
end

--- @param ammoName string? nil clears the preference
local function setPreferredAmmo(slotData, ammoName)
	local key = weaponIdentity(slotData)
	if not key then return false end

	if ammoName then
		preferredAmmo[key] = ammoName
		SetResourceKvp(PREFERRED_KVP .. key, ammoName)
	else
		preferredAmmo[key] = false
		DeleteResourceKvp(PREFERRED_KVP .. key)
	end

	return true
end

--- The right button in the picker: it pins the type, and pressing it on the pinned one clears it.
RegisterNUICallback('setPreferredAmmo', function(data, cb)
	local slot = data and tonumber(data.weaponSlot)
	local slotData = slot and PlayerData and PlayerData.inventory and PlayerData.inventory[slot]

	if not slotData then return cb({ ok = false }) end

	local wanted = type(data.item) == 'string' and data.item ~= '' and data.item or nil
	local current = getPreferredAmmo(slotData)

	setPreferredAmmo(slotData, wanted ~= current and wanted or nil)
	cb({ ok = true, preferred = getPreferredAmmo(slotData) })
end)


local reloadInProgress = {}
local reloadTransaction

---Flush the live client ammo balance before a reload/holster. The revision is
---server-checked so an older delayed packet can never overwrite newer ammo.
---@param weapon table
---@return boolean
local function persistHeldAmmo(weapon)
	if not weapon or not weapon.metadata or weapon.metadata.ammo == nil then return true end

	local deadline = GetGameTimer() + 2000
	while weapon._ammoPersistBusy and GetGameTimer() < deadline do Wait(0) end
	if weapon._ammoPersistBusy then return false end

	weapon._ammoPersistBusy = true
	local revision = math.floor(tonumber(weapon.metadata._ammoRevision) or 0) + 1
	local ammo = math.max(0, math.floor(tonumber(weapon.metadata.ammo) or 0))
	local called, ok, serverRevision = pcall(function()
		return lib.callback.await('w_inventory:updateWeapon', false,
			'ammo', ammo, weapon.slot, nil, revision)
	end)

	if called and ok == false and tonumber(serverRevision) then
		-- A dual-pool transfer may have advanced the server revision first.
		weapon.metadata._ammoRevision = tonumber(serverRevision)
		revision = math.floor(tonumber(serverRevision)) + 1
		called, ok, serverRevision = pcall(function()
			return lib.callback.await('w_inventory:updateWeapon', false,
				'ammo', ammo, weapon.slot, nil, revision)
		end)
	end

	if called then
		weapon.metadata._ammoRevision = tonumber(serverRevision) or (ok and revision)
			or weapon.metadata._ammoRevision
	end

	weapon._ammoPersistBusy = nil
	return called and ok == true
end


-- ── Tracing the reload ───────────────────────────────────────────────────────────
-- Every gate in reloadWeapon ends the transaction with a generic notification or in silence, so the failure looks
-- like one thing when it is ten. /ammotrace names the gate that stopped it.
local ammoTrace = false

RegisterCommand('ammotrace', function()
	ammoTrace = not ammoTrace
	print(("^2[w_inventory]^0 reload trace: %s - press 'reload' on the weapon now")
		:format(ammoTrace and 'on' or 'off'))
end, false)

local function rtrace(fmt, ...)
	if not ammoTrace then return end
	print('^3[reload]^0 ' .. (select('#', ...) > 0 and fmt:format(...) or fmt))
end

--- Opens a box of rounds (ammo_box_*) through the server's pack/unpack transaction - the very one
--- behind the box's right-click option - and returns the slot of the loose rounds it produced.
--- The server still loads loose rounds only (one item = one round), so unloading can never mint a box.
---@param boxSlot number
---@return number? slot
---@return string? reason
local function openAmmoBox(boxSlot)
	local box = PlayerData.inventory[boxSlot]
	local loose = box and Items[box.name] and Items[box.name].ammoUnpack
	if not loose then return nil, 'invalid' end

	local operationId = lib.callback.await('w_inventory:prepareAmmoPack', false, boxSlot)
	if not operationId then return nil, 'invalid' end

	local ok, reason = lib.callback.await('w_inventory:packAmmo', false, boxSlot, operationId)
	if not ok then return nil, reason end

	-- The server syncs the changed slots before it answers; the wait only covers a late packet.
	local deadline = GetGameTimer() + 1000
	local slot = Inventory.GetSlotIdWithItem(loose, nil, false)

	while not slot and GetGameTimer() < deadline do
		Wait(50)
		slot = Inventory.GetSlotIdWithItem(loose, nil, false)
	end

	return slot, not slot and 'invalid' or nil
end

--- Reloading a particular weapon from the bag's rounds: the 'reload' button in the bag's menu, the
--- wheel, and the game's reload key with the weapon in hand (reloadFromKey below).
--- It works with the weapon holstered, since the bow is holstered automatically when the arrows run out.
---@param weaponSlot number the weapon's slot in the bag
---@param forcedAmmoSlot? number a particular ammunition slot the React picker inside the bag returned
---@param quiet? boolean the reload key: no 'full' / 'no ammo' / 'loaded' toasts (the animation says it)
reloadWeapon = function(weaponSlot, forcedAmmoSlot, quiet)
    if NativeWeapons then return false, 'native_weapon_engine' end
	if reloadInProgress[weaponSlot] then rtrace('slot %s: a reload is under way', tostring(weaponSlot)) return end
	if not canUseItem(true) then rtrace('canUseItem = false (busy/dead/restricted)') return end

	local slotData = PlayerData.inventory[weaponSlot]

	if not slotData then rtrace('no item in slot %s', tostring(weaponSlot)) return end

	local weaponItem = Items[slotData.name]

	if not weaponItem or not weaponItem.weapon then rtrace('%s is not a weapon', tostring(slotData.name)) return end

	rtrace('slot %s = %s | ammoname=%s | family=%s | type=%s | loaded=%s',
		tostring(weaponSlot), tostring(slotData.name), tostring(weaponItem.ammoname),
		tostring(weaponItem.ammoFamily), tostring(weaponItem.ammoType),
		tostring(slotData.metadata and slotData.metadata.ammo))

	-- The projectiles (dynamite/molotov/axe/bolas): they have no ammunition store - 'loading/refilling' = equipping them in the hand
	-- with the whole stock if you own it (it is run from the 'reload' button in the bag).
	if weaponItem.throwable then
		if (slotData.count or 0) <= 0 then
			return Utils.Notify({ id = 'no_ammo', title = locale('ammo_title'), type = 'error', description = locale('no_ammo_for_weapon', weaponItem.label or '') })
		end
		if currentWeapon and currentWeapon.slot == weaponSlot then
			Citizen.InvokeNative(0xB282DC6EBD803C75, cache.ped, weaponItem.hash, slotData.count, true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
			local makePedReload = N_0x79e1e511ff7efb13
			makePedReload(cache.ped)
		else
			useSlot(weaponSlot)
		end
		return Utils.Notify({ title = locale('weapon_loaded_title'), type = 'success', description = ('%s: %d'):format(weaponItem.label or '', slotData.count) })
	end

	if not weaponItem.ammoname then rtrace('the weapon has no ammoname') return end

	if (slotData.metadata.durability or 100) <= 0 then
		return Utils.Notify({
			id = 'no_durability',
			type = 'error',
			description = locale('no_durability', weaponItem.label)
		})
	end

	-- Choosing the bullet type on refill: if the weapon accepts more than one type and you own more than one type,
	-- open the React picker inside the bag itself. One type = a fast path with no window.
	-- forcedAmmoSlot is the choice that came back from the interface or from a trusted integration.
	if not forcedAmmoSlot then
		local owned = ownedAmmoTypes(weaponItem)
		if #owned > 1 then
			local options = {}
			local currentAmmo = slotData.metadata.specialAmmo or weaponItem.ammoname
			local preferred = getPreferredAmmo(slotData)
			for i = 1, #owned do
				options[i] = {
					label = owned[i].label or owned[i].item,
					item = owned[i].item,
					slot = owned[i].slot,
					count = owned[i].count,
					active = owned[i].item == currentAmmo,
					-- The type bookmarked in the bag's ammunition picker.
					preferred = owned[i].item == preferred,
				}
			end

			SendNUIMessage({
				action = 'openAmmoPicker',
				data = {
					weaponSlot = weaponSlot,
					weaponName = slotData.name,
					weaponLabel = weaponItem.label or slotData.name,
					loaded = math.max(0, math.floor(tonumber(slotData.metadata.ammo) or 0)),
					capacity = getWeaponCapacity(weaponItem),
					options = options,
				}
			})
			return
		elseif #owned == 1 then
			forcedAmmoSlot = owned[1].slot
		end
	end

	local ammoSlotId = forcedAmmoSlot or findAmmoSlot(weaponItem.ammoname, slotData.metadata.specialAmmo)
	rtrace('bullet slot = %s (forced=%s)', tostring(ammoSlotId), tostring(forcedAmmoSlot))

	if not ammoSlotId then
		return Utils.Notify({
			id = 'no_ammo',
			title = locale('ammo_title'),
			type = 'error',
			description = locale('no_ammo_for_weapon', weaponItem.label or '')
		})
	end

	local ammoSlot = PlayerData.inventory[ammoSlotId]
    local ammoItem = ammoSlot and Items[ammoSlot.name]
    if not ammoItem or not ammoItem.ammo or ammoItem.ammoFamily ~= weaponItem.ammoFamily then
        if quiet then return end
        return Utils.Notify({id='no_ammo',title=locale('ammo_title'),type='error',
            description=locale('no_ammo_for_weapon',weaponItem.label or '')})
    end

	-- A box (the only form the shops sell) is opened first and the reload continues from its rounds.
	-- Refusing it here was the 'this is not its ammo' report: every weapon, every type.
	if ammoItem.ammoUnpack then
		reloadInProgress[weaponSlot] = true
		local openedSlot, reason = openAmmoBox(ammoSlotId)
		reloadInProgress[weaponSlot] = nil

		local opened = openedSlot and PlayerData.inventory[openedSlot]
		local openedItem = opened and Items[opened.name]
		rtrace('box %s opened -> slot %s (%s)', tostring(ammoSlot.name), tostring(openedSlot), tostring(reason))

		if not openedItem or openedItem.ammoUnpack or openedItem.ammoFamily ~= weaponItem.ammoFamily then
			return Utils.Notify({
				id = 'ammo_boxed',
				title = locale('ammo_title'),
				type = 'error',
				description = reason == 'weight' and locale('ammo_pack_weight') or locale('ammo_boxed')
			})
		end

		ammoSlotId, ammoSlot, ammoItem = openedSlot, opened, openedItem
	end

	local capacity = getWeaponCapacity(weaponItem)

	local special = ammoSlot.name ~= weaponItem.ammoname and ammoSlot.name or nil
	local oldSpecial = slotData.metadata.specialAmmo

	if reloadTransaction then return end
	reloadTransaction = weaponSlot
	reloadInProgress[weaponSlot] = true
	local equippedWeapon = currentWeapon and currentWeapon.slot == weaponSlot and currentWeapon or nil
	local liveWeapon = currentWeapon and currentWeapon.metadata and currentWeapon or nil

	local function finishReload()
		if liveWeapon then liveWeapon.reloadBusy = nil end
		reloadInProgress[weaponSlot] = nil
		if reloadTransaction == weaponSlot then reloadTransaction = nil end
	end

	if liveWeapon then
		liveWeapon.reloadBusy = true
		if not persistHeldAmmo(liveWeapon) then
			finishReload()
			return
		end
	end

	-- * The separation: every weapon is filled to its own store's capacity, and its balance is its own. We no longer add up
	-- the two hands' capacities nor move a pool between them - that used to make reloading the Navy load
	-- the Cattleman with it. ReassignAmmoPool stays only to correct this slot's balance from
	-- the engine when it is the only one of its type.
	local loaded = math.max(0, math.floor(tonumber(slotData.metadata.ammo) or 0))
	local poolSlots

	if Weapon.DualWield.HasSlot(weaponSlot) then
		local live = Weapon.ReassignAmmoPool(weaponSlot)
		if live == nil then
			finishReload()
			return
		end
		loaded = live
	end

	local missing = capacity - loaded
	rtrace('capacity=%d . loaded=%d . missing=%d', capacity, loaded, missing)

	if missing <= 0 then
		finishReload()
		if quiet then return end
		return Utils.Notify({
			id = 'weapon_full',
			title = locale('ammo_title'),
			type = 'info',
			description = locale('weapon_full', weaponItem.label or '')
		})
	end

	if loaded > 0 and special ~= oldSpecial then
		finishReload()
		return Utils.Notify({
			id = 'ammo_switch_loaded',
			title = locale('ammo_title'),
			type = 'error',
			description = locale('ammo_switch_loaded')
		})
	end

	local add = ammoSlot.count > missing and missing or ammoSlot.count
	rtrace('in the bag %s x%d => we will add %d', tostring(ammoSlot.name), ammoSlot.count, add)

	if add <= 0 then
		finishReload()
		return
	end

	-- * Holding the weapon in your hand makes persistHeldAmmo above advance the serial number on
	-- the server before this call. So if the advance does not reach slotData.metadata an old number is sent,
	-- and nextAmmoRevision refuses it by its `supplied <= current` condition - so
	-- 'the operation failed' shows although the ammunition is there and the weapon is sound. And this is why
	-- the fault was confined to the held weapon and not the holstered one.
	--
	-- The server returns its current number with the refusal for exactly this purpose, and persistHeldAmmo
	-- uses it to retry from the beginning. The absence of its counterpart here was the defect.
	local revision = math.floor(tonumber(slotData.metadata._ammoRevision) or 0) + 1
	local called, ok, serverRevision, linkedRevisions = pcall(function()
		return lib.callback.await('w_inventory:updateWeapon', false,
			'load', loaded + add, weaponSlot, special, revision, poolSlots)
	end)

	if called and ok == false and tonumber(serverRevision) then
		slotData.metadata._ammoRevision = tonumber(serverRevision)
		revision = math.floor(tonumber(serverRevision)) + 1
		called, ok, serverRevision, linkedRevisions = pcall(function()
			return lib.callback.await('w_inventory:updateWeapon', false,
				'load', loaded + add, weaponSlot, special, revision, poolSlots)
		end)
	end

	rtrace("the server's reply: called=%s ok=%s revision=%s",
		tostring(called), tostring(ok), tostring(serverRevision))

	if called and ok then slotData.metadata._ammoRevision = tonumber(serverRevision) or revision end
	finishReload()

	if not called or ok ~= true then
		-- The server's refusal used to pass silently, so the refill looked like it 'sometimes does not work' for no reason.
		-- We tell the player and correct our balance from the serial number the server returned,
		-- so the next attempt succeeds instead of being computed from an old balance.
		if tonumber(serverRevision) then
			slotData.metadata._ammoRevision = tonumber(serverRevision)
		end

		return Utils.Notify({
			id = 'reload_failed',
			title = locale('ammo_title'),
			type = 'error',
			description = locale('ammo_pack_failed')
		})
	end

	-- (The 'linked companion' sync was removed: the reload no longer covers a weapon other than the intended one.)

	-- The server before the reload: the result is fixed onto the weapon's copy in the bag always,
	-- whether it is in the player's hand or holstered. These lines used to be inside the 'in hand' branch only,
	-- so a holstered weapon was reloaded on the server while the client's copy stayed at zero - so it looked as if
	-- the refill 'sometimes loads and sometimes does not', and the unload-bullets button disappeared, and then
	-- the next reload failed because the difference was computed from an old balance.
	slotData.metadata.specialAmmo = special
	slotData.metadata.ammo = loaded + add

	if equippedWeapon then
		equippedWeapon.metadata.specialAmmo = special
		equippedWeapon.metadata.ammo = loaded + add
		equippedWeapon.metadata._ammoRevision = slotData.metadata._ammoRevision
	end

	-- The weapon in hand: we put the rounds into the character and play the reload animation
	if equippedWeapon or Weapon.DualWield.HasSlot(weaponSlot) then
		if ammoItem.ammoType then
			SetAmmoTypeForPedWeapon(cache.ped, weaponItem.hash, joaat(ammoItem.ammoType))
		end

		if oldSpecial ~= special then Weapon.ClearAmmoPool(weaponSlot) end
		local ammoType = ammoItem.ammoType and joaat(ammoItem.ammoType)

		-- * Resetting by the separation: the reserve = the sum of the carried weapons' balances, and every
		-- weapon's store = its own balance. So its companion does not pick up the rounds we loaded for it.
		if ammoType then
			Weapon.ApplyAmmoSeparation(ammoType)
		else
			AddAmmoToPed(cache.ped, weaponItem.hash, add)
		end
		Wait(100)

		-- * The loading concerns the weapon in question alone.
		--
		-- MAKE_PED_RELOAD is a task on the ped: it has no hand parameter and no weapon. So with two weapons
		-- in the hands it loads them both, and draws from the **type's** reserve - which after the separation is
		-- the sum of the two weapons' balances - so the companion's store fills with rounds accounted to this
		-- weapon, then the first shot returns it to its balance so the whole thing looks like a mess.
		--
		-- And the target weapon's store is already set in the line above, so the task adds nothing
		-- but the animation. When two weapons share the type we give up the animation and keep the separation:
		-- the engine has no loading for a particular hand.
		--
		-- The type is read from the weapon and not from the bullet item: the bullet item may not declare
		-- ammoType, so the guard falls silently and the task goes back to drawing the companion's bullets.
		local separationType = Weapon.AmmoTypeForSlot(weaponSlot)
		if separationType == 0 then separationType = ammoType or 0 end

		local sharingSlots = separationType ~= 0
			and Weapon.HeldSlotsForAmmo(separationType) or {}

		if #sharingSlots > 1 then
			Weapon.ApplyAmmoSeparation(separationType)
		else
			local isGun = IsWeaponAGun(weaponItem.hash)
			if isGun == true or isGun == 1 then
				local makePedReload = N_0x79e1e511ff7efb13
				makePedReload(cache.ped)
			end
			-- The clip was already filled above. The native owns its animation and
			-- movement; no detached loop may block jumping or rewrite a later loadout.
		end
	else
		-- * A holstered weapon: breaking the closed loop.
		--
		-- The block above is conditional on the weapon being in the hand, so a holstered one is reloaded in
		-- the metadata and nothing reaches the engine. And with the bow it becomes a loop with no way out:
		-- an empty bow in the engine is not drawn at all, and there is no way to get the arrows to
		-- the engine except by drawing it. So you reload and reload and the wheel reads zero forever.
		--
		-- We write its balance into its type's pool directly as long as the weapon is really on the body.
		local holsteredType = Weapon.AmmoTypeForSlot(weaponSlot)
		if holsteredType == 0 then
			holsteredType = ammoItem.ammoType and joaat(ammoItem.ammoType) or 0
		end

		-- ! And we do not touch a type a carried weapon shares: the separation of the carried ones is managed by
		-- applyAmmoSeparation from their balances, and a write from here corrupts its accounting.
		if holsteredType ~= 0
			and #Weapon.HeldSlotsForAmmo(holsteredType) == 0
			and HasPedGotWeapon(cache.ped, weaponItem.hash, 0, false) then
			SetAmmoTypeForPedWeapon(cache.ped, weaponItem.hash, holsteredType)
			SetPedAmmoByType(cache.ped, holsteredType, loaded + add)
			rtrace("holstered: %d written into the type's pool %s", loaded + add, tostring(holsteredType))
		else
			rtrace('holstered: the pool was not written (type=%s . carried=%d . on the body=%s)',
				tostring(holsteredType),
				holsteredType ~= 0 and #Weapon.HeldSlotsForAmmo(holsteredType) or -1,
				tostring(HasPedGotWeapon(cache.ped, weaponItem.hash, 0, false)))
		end
	end

	if quiet then return end

	Utils.Notify({
		title = locale('weapon_loaded_title'),
		type = 'success',
		description = ('%s: %d'):format(weaponItem.label or '', loaded + add)
	})
end

-- ── The game's reload key ───────────────────────────────────────────────────────
-- The owner (2026-11-08): with the weapon in hand and rounds for it in the bag, the reload key
-- reloads it from the bag; with no rounds, or the weapon not in hand, the key does nothing.
-- The engine's reload key stays disabled (client.tick); this reads the disabled key and runs the bag's
-- own reload transaction, so the server still checks the capacity and takes the rounds out of the bag.
-- 2026-11-08: a weapon holds more than its clip (Config.Ammo.Categories), the rest in the engine reserve;
-- with nothing to take from the bag, the key reloads a lone weapon's clip from those spare rounds.
local reloadFromKey

do
	local keyReloadUntil = 0

	--- The ammunition slot the key loads from: the loaded type first (another type is refused while
	--- rounds are in the weapon), then the type bookmarked in the bag's picker, then the first owned.
	---@return number? slot
	local function keyReloadAmmoSlot(slotData, weaponItem)
		local owned = ownedAmmoTypes(weaponItem)
		if #owned == 0 then return end

		local loaded = math.max(0, math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
		local current = slotData.metadata and slotData.metadata.specialAmmo or weaponItem.ammoname
		local preferred = getPreferredAmmo(slotData)
		local pick

		for i = 1, #owned do
			if owned[i].item == current then pick = owned[i] break end
		end

		if not pick and loaded > 0 then return end

		if not pick and preferred then
			for i = 1, #owned do
				if owned[i].item == preferred then pick = owned[i] break end
			end
		end

		return (pick or owned[1]).slot
	end

	reloadFromKey = function()
		if NativeWeapons or invOpen or invBusy or usingItem or reloadTransaction then return end

		local weapon = currentWeapon
		if not weapon or weapon.melee or weapon.throwable or not weapon.slot then return end
		if weapon.reloadBusy or weapon._ammoPersistBusy or IsPedReloading(cache.ped) or IsPedCuffed(cache.ped) then return end
		-- the wheel, the chat or any page holding the focus reads the key as its own
		local focused, paused = IsNuiFocused(), IsPauseMenuActive()
		if focused == true or focused == 1 or paused == true or paused == 1 then return end

		local now = GetGameTimer()
		if now < keyReloadUntil then return end
		keyReloadUntil = now + 600

		-- In the hand, not in the holster: RDR keeps a holstered weapon as the current one.
		local held = Citizen.InvokeNative(0x8425C5F057012DAB, cache.ped) -- _GET_PED_CURRENT_HELD_WEAPON
		if held ~= weapon.hash and not Weapon.DualWield.HasHash(held) then return end

		-- Two pistols in the hands: both are filled, one transaction each (reloadWeapon allows one at a time).
		local slots = Weapon.DualWield.Count() > 1 and Weapon.HeldSlots() or { weapon.slot }
		local jobs = {}

		for i = 1, #slots do
			local slotData = PlayerData.inventory and PlayerData.inventory[slots[i]]
			local weaponItem = slotData and Items[slotData.name]

			if weaponItem and weaponItem.weapon and weaponItem.ammoname and not weaponItem.throwable
				and math.max(0, math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
					< getWeaponCapacity(weaponItem) then
				local ammoSlot = keyReloadAmmoSlot(slotData, weaponItem)
				if ammoSlot then jobs[#jobs + 1] = slots[i] end
			end
		end

		if #jobs == 0 then
			-- Nothing to load from the bag. A lone weapon of its type whose clip is down reloads from its
			-- own spare rounds (the game's reload: it moves reserve -> clip, the total stays the balance).
			-- Two weapons sharing the type have no reserve (their clips are rewritten after every shot).
			local slotData = #slots == 1 and PlayerData.inventory and PlayerData.inventory[slots[1]]
			local weaponItem = slotData and Items[slotData.name]
			local typeHash = weaponItem and Weapon.AmmoTypeForSlot(slots[1]) or 0

			if typeHash ~= 0 and #Weapon.HeldSlotsForAmmo(typeHash) == 1 then
				local balance = math.max(0, math.floor(tonumber(slotData.metadata and slotData.metadata.ammo) or 0))
				local _, inClip = GetAmmoInClip(cache.ped, weaponItem.hash)

				if math.floor(tonumber(inClip) or 0) < math.min(balance, Weapon.ClipCapacity(weaponItem)) then
					N_0x79e1e511ff7efb13(cache.ped) -- _MAKE_PED_RELOAD
				end
			end

			return
		end

		CreateThread(function()
			for i = 1, #jobs do
				local slotData = PlayerData.inventory and PlayerData.inventory[jobs[i]]
				local weaponItem = slotData and Items[slotData.name]
				-- read again: the previous hand's reload may have opened a box or used the last rounds
				local ammoSlot = weaponItem and keyReloadAmmoSlot(slotData, weaponItem)
				if ammoSlot then reloadWeapon(jobs[i], ammoSlot, true) end
			end
		end)
	end
end

-- Reloading a weapon with a particular ammunition type the player owns (the bag's interface or a trusted integration).
-- It checks the ammunition's family and the ownership, then reuses the official reload flow (the server's authority).
exports('reloadWeaponWithAmmo', function(weaponSlot, ammoItemName)
	local slotData = PlayerData.inventory and PlayerData.inventory[weaponSlot]
	if not slotData then return false end

	local weaponItem = Items[slotData.name]
	if not weaponItem or not weaponItem.weapon or not weaponItem.ammoname then return false end

	-- A box is accepted: reloadWeapon opens it before loading.
	local ammoDef = Items[ammoItemName]
	if not ammoDef then return false end

	local weaponAmmo = Items[weaponItem.ammoname]
	local wfam = weaponAmmo and weaponAmmo.ammoFamily
	if not wfam or ammoDef.ammoFamily ~= wfam then return false end -- a mismatched family

	local ammoSlotId = Inventory.GetSlotIdWithItem(ammoItemName, nil, false)
	if not ammoSlotId then return false end -- the player does not own this type

	reloadWeapon(weaponSlot, ammoSlotId)
	return true
end)

--- Switching a particular weapon's bullet type - one complete transaction for the weapon wheel.
---
--- The bag's law refuses changing the type while the store holds rounds of another type
--- (`ammo_switch_loaded`). RDR2's wheel switches the type at once, so we do the equivalent here:
--- we unload the old rounds (they go back to the bag through the server) then we load the new
--- type. Both steps are on the server's authority so they produce no duping.
---
--- The bag stays the one that decides: the wheel sends the slot and the item's name only.
---@param weaponSlot number
---@param ammoItemName string
---@return boolean ok
---@return string? reason
local function switchWeaponAmmo(weaponSlot, ammoItemName)
    if NativeWeapons then return false, 'native_weapon_engine' end
	weaponSlot = tonumber(weaponSlot)
	local slotData = weaponSlot and PlayerData.inventory and PlayerData.inventory[weaponSlot]
	if not slotData then return false, 'invalid_weapon' end

	local weaponItem = Items[slotData.name]
	if not weaponItem or not weaponItem.weapon or not weaponItem.ammoname then
		return false, 'invalid_weapon'
	end

	-- A box is accepted: reloadWeapon opens it before loading.
	local ammoDef = Items[ammoItemName]
	if not ammoDef then return false, 'invalid_ammo' end

	local weaponAmmo = Items[weaponItem.ammoname]
	local family = weaponAmmo and weaponAmmo.ammoFamily
	if not family or ammoDef.ammoFamily ~= family then return false, 'wrong_family' end

	if not Inventory.GetSlotIdWithItem(ammoItemName, nil, false) then
		return false, 'no_ammo'
	end

	-- The type currently loaded: specialAmmo may be nil and that means the primary type.
	local loaded = math.max(0, math.floor(tonumber(slotData.metadata.ammo) or 0))
	local current = slotData.metadata.specialAmmo
	if current == nil then
		local default = AmmoTypes and AmmoTypes.GetDefault
			and AmmoTypes.GetDefault(family, function(n) return Items[n] ~= nil end)
		current = default and default.item or weaponItem.ammoname
	end

	-- A box is the type of the loose round it opens into.
	if current == (ammoDef.ammoUnpack or ammoItemName) then return true, 'already' end

	-- Unload first when it holds bullets of another type, otherwise the reload is refused.
	if loaded > 0 then
		if Weapon.DualWield.HasSlot(weaponSlot) then
			if Weapon.ReassignAmmoPool(weaponSlot) == nil then return false, 'busy' end
		end

		local ok, revision = lib.callback.await('w_inventory:removeAmmoFromWeapon', false, weaponSlot)
		if not ok then return false, 'unload_failed' end

		Weapon.ClearLoadedAmmo(weaponSlot, revision)
		slotData.metadata.ammo = 0
		slotData.metadata.specialAmmo = nil
		slotData.metadata._ammoRevision = tonumber(revision) or slotData.metadata._ammoRevision

		if weaponSlot == currentWeapon?.slot then
			currentWeapon.metadata.ammo = 0
			currentWeapon.metadata.specialAmmo = nil
			currentWeapon.metadata._ammoRevision = slotData.metadata._ammoRevision
		end
	end

	-- The slot is read after the unloading: the balance may have merged into another stack.
	local ammoSlotId = Inventory.GetSlotIdWithItem(ammoItemName, nil, false)
	if not ammoSlotId then return false, 'no_ammo' end

	reloadWeapon(weaponSlot, ammoSlotId)
	return true
end

exports('switchWeaponAmmo', switchWeaponAmmo)

--- The gunsmith's modifications for a weapon in a particular slot - for display in the weapon wheel.
--- It returns increases in points for every statistic and the real damage multiplier applied.
---@param weaponSlot number
---@return table? { stats = {...}, damageMultiplier = number }
exports('getWeaponModifiers', function(weaponSlot)
	local slotData = PlayerData.inventory and PlayerData.inventory[tonumber(weaponSlot)]
	if not slotData then return nil end

	local data = Items[slotData.name]
	if not data or not data.weapon then return nil end

	slotData.hash = slotData.hash or data.hash
	local stats, multiplier = Weapon.GetModifiers(slotData)

	return { stats = stats or {}, damageMultiplier = multiplier or 1.0 }
end)

-- The catalogue of a weapon's bullet types (for the display/the bullet switcher in the weapon wheel) - framework-neutral:
-- it works on vorp / rsg / qbr. It is defined here (client.lua is always loaded) so it is available to every
-- bag - the neutral AmmoTypes data + Items, with no dependence on any framework.
exports('getWeaponAmmoOptions', function(weaponName, cb)
	local family
	if type(weaponName) == 'string' then
		local w = Items[weaponName] or Items[weaponName:upper()]
		if w then
			if w.ammoname and Items[w.ammoname] then family = Items[w.ammoname].ammoFamily end
			family = family or w.ammoFamily
		end
		if not family and AmmoTypes and AmmoTypes.Families and AmmoTypes.Families[weaponName] then
			family = weaponName
		end
	end

	local out = {}
	if family and AmmoTypes and AmmoTypes.Families and AmmoTypes.Families[family] then
		-- the library's language (the player's choice), never a convar read here
		local loc = shared.localeKey()
		for _, entry in ipairs(AmmoTypes.Families[family]) do
			out[#out + 1] = {
				ammo = entry.ammo,
				label = (loc == 'en' and entry.label_en) or entry.label or entry.ammo,
				items = entry.items,
			}
		end
	end

	-- a callback from another resource is a funcref (callable table), not a Lua function
	if type(cb) == 'function' or (type(cb) == 'table' and getmetatable(cb) and getmetatable(cb).__call) then cb(out); return end
	return out
end)

local function registerCommands()
	RegisterCommand('steal', openNearbyInventory, false)

	--- The saddlebag of a horse registered to the player (the horseUUID state bag w_stables sets).
	---@param horse number
	local function openSaddlebag(horse)
		if not horse or horse == 0 or not DoesEntityExist(horse) or not NetworkGetEntityIsNetworked(horse) then return end

		local horseUUID = w.entity.getState(horse, 'horseUUID')

		-- a wild horse or a horse of another system has no saddlebag here
		if not horseUUID then return end

		local isOpen = Inventory.OpenSaddlebag(horse, horseUUID)

		if isOpen then
			currentInventory.entity = horse
		end
	end

	-- the storage prompt of a horse (modules/inventory/client.lua) opens through the same path
	client.openSaddlebag = openSaddlebag

	local function tryOpenInventory()
		if invOpen then
			return client.closeInventory()
		end

		if cache.mount then
			return openSaddlebag(cache.mount)
		end

		if cache.vehicle then
			return Inventory.OpenWagonStorage(cache.vehicle)
		end

		return client.openInventory()
	end

	local function tryOpenSecondaryInventory()
		if invOpen then
			return client.closeInventory()
		end

		if invBusy or not canOpenInventory() then
			Utils.Notify({
				id = 'inventory_player_access',
				type = 'error',
				description = locale(
					'inventory_player_access')
			})
			return
		end

		if StashTarget then
			return client.openInventory('stash', StashTarget)
		end

		if cache.mount then
			return openSaddlebag(cache.mount)
		end

		if cache.vehicle then
			return Inventory.OpenWagonStorage(cache.vehicle)
		end

		-- a wagon or another player's horse standing nearby is offered by the library prompt
		-- that follows it (Inventory.StartStoragePrompts), not by a key pressed at it
	end

	-- the bag key: the player's own bag, or the storage of the animal / wagon he sits on
	w.rawKeys.listen("I", function(pressed)
		if pressed then tryOpenInventory() end
	end)

	-- the secondary storage key: a stash another resource set as the target, or the storage
	-- of the animal / wagon he sits on
	w.rawKeys.listen("U", function(pressed)
		if pressed then tryOpenSecondaryInventory() end
	end)

	-- (The TAB listener for switching the hotbar was disabled: TAB is reserved for opening the w_weaponwheel weapon wheel.
	--  The numbers 1-5 for using the hotbar's slots stay working below.)
	-- w.rawKeys.listen("TAB", function(pressed)
	-- 	if pressed then
	-- 		if EnableWeaponWheel or invBusy or IsNuiFocused() or lib.progressActive() then return end
	-- 		SendNUIMessage({ action = 'toggleHotbar' })
	-- 	end
	-- end)

	for i = 1, 5 do
		w.rawKeys.listen(tostring(i), function(pressed)
			if pressed then
				if invOpen or invBusy or IsNuiFocused() or not invHotkeys then return end
				SendNUIMessage({ action = 'useHotbarSlot', slot = i - 1 })
			end
		end)
	end

	-- Refill is requested through the bag; R does not consume inventory ammunition.

	registerCommands = nil
end

function client.closeInventory(server)
	-- because somehow people are triggering this when the inventory isn't loaded
	-- and they're incapable of debugging, and I can't repro on a fresh install
	if not client.interval then return end

	if invOpen then
		invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		-- Force clear all animations/scenarios on close
		ClearPedTasks(PlayerPedId())
		-- compatibility events for the resources that listen to the framework inventory
		TriggerEvent('rsg-inventory:client:CloseInventory')
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(client.interval, 200)
		Wait(200)

		if invOpen ~= nil then return end

		if not server and currentInventory then
			TriggerServerEvent('w_inventory:closeInventory')
		end

		currentInventory = nil
		plyState.invOpen = false
		defaultInventory.coords = nil
		TriggerEvent("w_inventory:closed")
	end
end

RegisterNetEvent('w_inventory:closeInventory', client.closeInventory)
exports('closeInventory', client.closeInventory)

---@param data updateSlot[]
---@param weight number
local function updateInventory(data, weight)
	if not PlayerData or not PlayerData.inventory then return end
	local changes = {}
	---@type table<string, number>
	local itemCount = {}

	for i = 1, #data do
		local v = data[i]

		if not v.inventory or v.inventory == cache.serverId then
		v.inventory = 'player'
		local item = v.item

		if item and item.slot then
			if currentWeapon?.slot == item.slot then
				if item.metadata then
					local liveAmmo, liveDura
					if currentWeapon.timer and currentWeapon.metadata then
						liveAmmo = currentWeapon.metadata.ammo
						liveDura = currentWeapon.metadata.durability
					end
					currentWeapon.metadata = item.metadata
					if liveAmmo ~= nil then currentWeapon.metadata.ammo = liveAmmo; item.metadata.ammo = liveAmmo end
					if liveDura ~= nil then currentWeapon.metadata.durability = liveDura; item.metadata.durability = liveDura end
					TriggerEvent('w_inventory:currentWeapon', currentWeapon)
				else
					currentWeapon = Weapon.Disarm(currentWeapon, true)
				end
			end

			local curItem = PlayerData.inventory[item.slot]

			if curItem and curItem.name then
				itemCount[curItem.name] = (itemCount[curItem.name] or 0) - curItem.count
			end

			if item.count then
				itemCount[item.name] = (itemCount[item.name] or 0) + item.count
			end

			changes[item.slot] = item.count and item or false
			if not item.count then item.name = nil end
			PlayerData.inventory[item.slot] = item.name and item or nil
		end
	end
end

	SendNUIMessage({ action = 'refreshSlots', data = { items = data, itemCount = itemCount } })

	if PlayerData and PlayerData.weight and weight and weight ~= PlayerData.weight then client.setPlayerData('weight', weight) end

	for itemName, count in pairs(itemCount) do
		local item = Items(itemName)

		if item then
			item.count += count

			TriggerEvent('w_inventory:itemCount', item.name, item.count)

			if count < 0 then
				if item.client?.remove then
					item.client.remove(item.count)
				end
			elseif count > 0 then
				if item.client?.add then
					item.client.add(item.count)
				end
			end
		end
	end

	if PlayerData and PlayerData.inventory then
		client.setPlayerData('inventory', PlayerData.inventory)
	end
	TriggerEvent('w_inventory:updateInventory', changes)
end

RegisterNetEvent('w_inventory:updateSlots', function(items, weights)
	if source ~= '' and next(items) then updateInventory(items, weights) end
end)

RegisterNetEvent('w_inventory:inventoryReturned', function(data)
	if source == '' then return end
	Weapon.ClearAll(currentWeapon)
	currentWeapon = nil

	Utils.Notify({ description = locale('items_returned') })
	client.closeInventory()

	local num, items = 0, {}

	for _, slotData in pairs(data[1]) do
		num += 1
		items[num] = { item = slotData, inventory = cache.serverId }
	end

	updateInventory(items, data[3])
end)

RegisterNetEvent('w_inventory:inventoryConfiscated', function(message)
	if source == '' then return end
	if message then Utils.Notify({ description = locale('items_confiscated') }) end
	Weapon.ClearAll(currentWeapon)
	currentWeapon = nil

	client.closeInventory()

	local num, items = 0, {}

	for slot in pairs(PlayerData.inventory or {}) do
		num += 1
		items[num] = { item = { slot = slot }, inventory = cache.serverId }
	end

	updateInventory(items, 0)
end)

---@param point CPoint
local function nearbyDrop(point)
	if not point.instance or point.instance == currentInstance then
		-- the drop's mark: the game's glitter, a small arrow down at it (the owner 2026-10-23: w_lib 4.1.0 lib.glow, look 3)
		lib.glow.frame(point, 'arrow', point.coords, { look = 3, size = 0.4 })
	end
end

---@param point CPoint
-- [w_gunsmith drop-fix] switch it to false to build every drop with CreateObject
local ENABLE_WEAPON_DROP_FIX = true
local NativeItemAssets = require 'modules.items.native_assets'

local function onEnterDrop(point)
	if (not point.instance or point.instance == currentInstance) and not point.entity then
		local px, py, pz = point.coords.x, point.coords.y, point.coords.z
		local entity

		-- [w_gunsmith drop-fix] RDR3 weapon models (w_*) through CreateObject show disassembled (with no components).
		-- CreateWeaponObject builds a complete weapon with its default components, then we re-apply the player's saved customisation.
		if ENABLE_WEAPON_DROP_FIX and point.isWeapon and point.weaponHash and point.weaponHash ~= 0 then
			RequestWeaponAsset(point.weaponHash)
			local t = 0
			while not HasWeaponAssetLoaded(point.weaponHash) and t < 100 do t = t + 1; Wait(0) end
			-- CreateWeaponObject(weaponHash, ammo, x, y, z, showWorldModel=false, scale=1.0) - proven in w_gunsmith
			entity = Citizen.InvokeNative(0x9888652B8BA77F73, point.weaponHash, 0, px, py, pz, false, 1.0)
			if type(point.gunComps) == 'table' then
				for _, comp in pairs(point.gunComps) do
					if type(comp) == 'string' then
						local ch = GetHashKey(comp)
						local cm = Citizen.InvokeNative(0x59DE03442B6C9598, ch) -- GetWeaponComponentTypeModel
						if cm and cm ~= 0 then lib.requestModel(cm); SetModelAsNoLongerNeeded(cm) end
						Citizen.InvokeNative(0x74C9090FDD1BB48E, entity, ch, -1, true) -- give to the weapon OBJECT (-1)
					end
				end
			end
		else
			local model = NativeItemAssets.model(point.nativeItemHash, point.model or client.dropmodel)

			if not IsModelValid(model) and not IsModelInCdimage(model) then
				model = client.dropmodel or `p_bag01x`
			end

			local ok = pcall(lib.requestModel, model, 5000)
			if not ok or not HasModelLoaded(model) then
				model = client.dropmodel or `p_bag01x`
				local fallbackOk = pcall(lib.requestModel, model, 5000)
				if not fallbackOk or not HasModelLoaded(model) then return end
			end

			entity = CreateObject(model, px, py, pz, false, true, true)
			SetModelAsNoLongerNeeded(model)
		end

		if not entity or entity == 0 or not DoesEntityExist(entity) then return end

		if not point.isWeapon then
			local yaw = math.random(0, 359) + 0.0
			SetEntityHeading(entity, yaw)
		end

		PlaceObjectOnGroundProperly(entity)

		if point.isWeapon then
			local _, groundZ, normal = GetGroundZAndNormalFor_3dCoord(px, py, pz + 2.0)
			local yaw = math.random(0, 359) + 0.0

			if normal then
				local slopePitch = math.deg(math.atan(normal.y, normal.z))
				local slopeRoll  = -math.deg(math.atan(normal.x, normal.z))
				SetEntityRotation(entity, 90.0 + slopePitch, slopeRoll, yaw, 2, true)

				if groundZ and groundZ > 0.0 then
					SetEntityCoordsNoOffset(entity, px, py, groundZ + 0.03, false, false, false)
				end
			else
				SetEntityRotation(entity, 90.0, 0.0, yaw, 2, true)
			end
		end

		FreezeEntityPosition(entity, true)
		SetEntityCollision(entity, false, true)

		Citizen.InvokeNative(0x7DFB49BCDB73089A, entity, true)

		point.entity = entity
	end
end

local function onExitDrop(point)
	local entity = point.entity

	if entity then
		w.entity.delete(entity)
		point.entity = nil
	end
end

---Remove a drop's point, its prop and its prompt.
---@param point CPoint
local function removeDropPoint(point)
	if point.prompt then
		point.prompt.remove()
		point.prompt = nil
	end

	if point.entity then
		w.entity.delete(point.entity)
		point.entity = nil
	end

	point:remove()
end

local function createDrop(dropId, data)
	local point = lib.points.new({
		coords = data.coords,
		distance = 30,
		invId = dropId,
		instance = data.instance,
		model = data.model,
		nativeItemHash = data.nativeItemHash,
		isWeapon = data.isWeapon,
		weaponHash = data.weaponHash, -- [w_gunsmith drop-fix]
		gunComps = data.gunComps,     -- [w_gunsmith drop-fix]
	})

	if not data.noProp and (point.model or client.dropprops) then
		point.distance = 30
		point.radius = 30
		point.onEnter = onEnterDrop
		point.onExit = onExitDrop
	else
		point.nearby = nearbyDrop
	end

	-- the walk-up prompt: J opens the dropped bag next to the player's own
	point.prompt = w.prompt.at({
		coords = data.coords,
		distance = 1.5,
		title = false,
		prompts = {
			{
				key = 'J',
				label = locale('open_drop'),
				onComplete = function()
					if cache.vehicle then return end
					client.openInventory('drop', dropId)
				end,
			},
		},
		canInteract = function()
			if invOpen or invBusy or IsNuiFocused() then return false end
			if PlayerData.dead or IsPedCuffed(playerPed) then return false end
			return not point.instance or point.instance == currentInstance
		end,
	})

	client.drops[dropId] = point
end

RegisterNetEvent('w_inventory:createDrop', function(dropId, data, owner, slot)
	if client.drops then
		createDrop(dropId, data)
	end

	if owner == cache.serverId then
		disarmTrackedSlot(slot, true)

		if invOpen and #(GetEntityCoords(playerPed) - data.coords) <= 1 then
			if not cache.vehicle then
				client.openInventory('drop', dropId)
			else
				SendNUIMessage({
					action = 'setupInventory',
					data = {
						rightInventory = currentInventory,
						wornClothingCategories = getWornClothingCategories(),
						removedClothingCategories = {},
					}
				})
			end
		end
	end
end)

RegisterNetEvent('w_inventory:removeDrop', function(dropId)
	if client.drops then
		local point = client.drops[dropId]

		if point then
			client.drops[dropId] = nil
			removeDropPoint(point)
		end
	end
end)

---@type function?
local function setStateBagHandler(stateId)
	AddStateBagChangeHandler('invOpen', stateId, function(_, _, value)
		invOpen = value
	end)

	AddStateBagChangeHandler('invBusy', stateId, function(_, _, value)
		invBusy = value
	end)

	AddStateBagChangeHandler('canUseWeapons', stateId, function(_, _, value)
		if not value and (currentWeapon or Weapon.DualWield.Count() > 0) then
			Weapon.ClearAll(currentWeapon)
			currentWeapon = nil
		end
	end)

	AddStateBagChangeHandler('instance', stateId, function(_, _, value)
		currentInstance = value

		-- Iterate over known drops and remove any points in a different instance (ignoring no instance)
		for dropId, point in pairs(client.drops) do
			if point.instance then
				removeDropPoint(point)

				if point.instance == value then
					-- Recreate the drop using data from the old point
					createDrop(dropId, point)
				end
			end
		end
	end)

	AddStateBagChangeHandler('dead', stateId, function(_, _, value)
		Utils.WeaponWheel()
		PlayerData.dead = value
	end)

	AddStateBagChangeHandler('invHotkeys', stateId, function(_, _, value)
		invHotkeys = value
	end)

	setStateBagHandler = nil
end

-- Currency is owned by the framework bridge, not by the HUD. Keep the old HUD
-- event as a compatibility alias, but w_inventory also receives its own direct
-- updates and therefore stays correct when w_hud is not installed.
local function updateCurrency(playercash, playergold)
	if invOpen then
		SendNUIMessage({
			action = 'updateCurrency',
			cash = tonumber(playercash) or 0,
			gold = tonumber(playergold) or 0,
		})
	end
end

RegisterNetEvent('w_inventory:updateCurrency', updateCurrency)

-- VORP includes both balances in this native UI payload. Using it directly
-- removes the old one-second HUD polling delay.
RegisterNetEvent('vorp:updateUi', function(payload)
	if type(payload) == 'string' then
		local ok, decoded = pcall(json.decode, payload)
		payload = ok and decoded or nil
	end

	if type(payload) == 'table' then
		updateCurrency(payload.moneyquanty or payload.money, payload.goldquanty or payload.gold)
	end
end)

lib.onCache('seat', function(seat)
	if seat then
		local hasWeapon = GetCurrentPedVehicleWeapon(cache.ped)

		if hasWeapon then
			return Utils.WeaponWheel(true)
		end
	end

	Utils.WeaponWheel(false)
end)

lib.onCache('vehicle', function()
	if invOpen and (not currentInventory.entity or currentInventory.entity == cache.vehicle) then
		return client.closeInventory()
	end
end)

--- The 'ui_' entries of the loaded dictionary: what the NUI needs and nothing more.
local function buildUiLocales()
	local uiLocales = {}
	local locales = lib.getLocales()

	for k, v in pairs(locales) do
		if k:find('^ui_') then
			uiLocales[k] = v
		end
	end

	-- the few keys the page reads that do not carry the ui_ prefix
	uiLocales['$'] = locales['$']
	uiLocales.ammo_type = locales.ammo_type
	uiLocales.ammo_switch_loaded = locales.ammo_switch_loaded
	uiLocales.identification = locales.identification
	uiLocales.male = locales.male
	uiLocales.female = locales.female

	return uiLocales
end

--- Text direction of the NUI for the active language.
local function uiDirection()
	return shared.localeKey() == 'ar' and 'rtl' or 'ltr'
end

-- The player switched the language in /w_lib: reload our dictionary (ar/en only), re-pick the
-- item labels and button labels, and hand the NUI the new strings, language and direction.
AddEventHandler('w_lib:setLocale', function()
	w.locale(shared.localeKey())

	if shared.relocalizeItems then shared.relocalizeItems() end
	relabelItemButtons()

	-- blip names (shops, benches) are baked at creation: rebuild them with the new dictionary
	if shared.relocalizeCraftingBlips then shared.relocalizeCraftingBlips() end
	if PlayerData.loaded then Shops.refreshShops() end

	-- the walk-up prompts read the new dictionary
	Utils.RelabelPlaces()
	Inventory.RelabelStoragePrompt()

	if client.drops then
		for _, point in pairs(client.drops) do
			if point.prompt then point.prompt.setLabel('J', locale('open_drop')) end
		end
	end

	if not client.uiLoaded then return end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = shared.localeKey(),
			dir = uiDirection(),
			strings = buildUiLocales(),
			items = PlayerData.loaded and buildItemData() or nil,
		}
	})
end)

RegisterNetEvent('w_inventory:gatheringMaterial', function(key, row)
    if source ~= 65535 or type(row) ~= 'table' or row.name ~= key then return end
    require('modules.items.catalog').apply(Items, { [key] = row }, true, client.imagepath)
    shared.localizeItemData(Items[key])
    if PlayerData.loaded and client.uiLoaded then
        SendNUIMessage({ action = 'init', data = { items = buildItemData(), locale = shared.localeKey(),
            dir = uiDirection(), strings = buildUiLocales() } })
    end
end)

RegisterNetEvent('w_inventory:setPlayerInventory', function(currentDrops, inventory, weight, player)
	if source == '' then return end

    local catalog = require 'modules.items.catalog'
    local first = lib.callback.await('w_inventory:itemCatalog', false, 1)
    assert(type(first) == 'table' and type(first.items) == 'table', 'Native item catalog unavailable')
    catalog.apply(Items, first.items, true, client.imagepath)
    for page = 2, first.pages do
        local result = lib.callback.await('w_inventory:itemCatalog', false, page)
        assert(type(result) == 'table' and type(result.items) == 'table', 'Native item catalog page unavailable')
        catalog.apply(Items, result.items, true, client.imagepath)
    end
    -- the native rows arrive with their English label plus the label_ar/label_en sources:
    -- pick the player's language before the NUI catalogue (buildItemData) is built
    if shared.relocalizeItems then shared.relocalizeItems() end

	---@class PlayerData
	---@field inventory table<number, SlotWithItem?>
	---@field weight number
	PlayerData = player
	PlayerData.id = cache.playerId
	PlayerData.source = cache.serverId
    shared.playerslots = tonumber(player.slots) or shared.playerslots
    shared.playerweight = tonumber(player.maxWeight) or shared.playerweight
    defaultInventory.slots, defaultInventory.maxWeight = shared.playerslots, shared.playerweight
	PlayerData.maxWeight = shared.playerweight

	setmetatable(PlayerData, {
		__index = function(self, key)
			if key == 'ped' then
				return PlayerPedId()
			end
		end
	})

	if setStateBagHandler then setStateBagHandler(('player:%s'):format(cache.serverId)) end

	for _, v in pairs(Items --[[@as table<string, WClientItem>]]) do
		v.count = 0
	end

	for _, data in pairs(inventory) do
		local item = Items[data.name]

		if item then
			item.count += data.count
			local add = item.client?.add

			if add then
				add(item.count)
			end
		end
	end

	local ItemData = buildItemData()

	client.setPlayerData('inventory', inventory)
	client.setPlayerData('weight', weight)
	currentWeapon = nil
	Weapon.ClearAll(nil, true)

	client.drops = currentDrops

	for dropId, data in pairs(currentDrops) do
		createDrop(dropId, data)
	end

	while not client.uiLoaded do Wait(50) end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = shared.localeKey(),
			dir = uiDirection(),
			strings = buildUiLocales(),
			items = ItemData,
			leftInventory = {
				id = cache.playerId,
				slots = shared.playerslots,
				items = PlayerData.inventory,
				maxWeight = shared.playerweight,
			},
			imagepath = client.imagepath,
			wornClothingCategories = getWornClothingCategories(),
			removedClothingCategories = {},
		}
	})

	PlayerData.loaded = true
	restoreUsedWeapons()

	Utils.Notify({ description = locale('inventory_setup') })
	Shops.refreshShops()
	Inventory.Stashes()
	Inventory.Evidence()
	Inventory.StartStoragePrompts()

	if registerCommands then registerCommands() end

	TriggerEvent('w_inventory:updateInventory', PlayerData.inventory)

	client.interval = SetInterval(function()
		if invOpen == false then
			playerCoords = GetEntityCoords(playerPed)
		elseif invOpen == true then
			if not canOpenInventory() then
				client.closeInventory()
			else
				playerCoords = GetEntityCoords(playerPed)

				if currentInventory and not currentInventory.ignoreSecurityChecks then
					if currentInventory.type == 'otherplayer' then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)

						if not id or #(playerCoords - pedCoords) > 1.8 or not (client.hasGroup(shared.police) or canOpenTarget(ped)) then
							client.closeInventory()
							Utils.Notify({
								id = 'inventory_lost_access',
								type = 'error',
								description = locale(
									'inventory_lost_access')
							})
						else
							TaskTurnPedToFaceCoord(playerPed, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end
					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > (currentInventory.distance or 2.0) or canOpenTarget(playerPed)) then
						client.closeInventory()
						Utils.Notify({
							id = 'inventory_lost_access',
							type = 'error',
							description = locale(
								'inventory_lost_access')
						})
					end
				end
			end
		end
	end, 200)

	local playerId = cache.playerId
	local EnableKeys = client.enablekeys
	local DisableAllControlActions = DisableAllControlActions
	local HideHudAndRadarThisFrame = HideHudAndRadarThisFrame
	local EnableControlAction = EnableControlAction
	local DisablePlayerFiring = DisablePlayerFiring
	local DisableControlAction = DisableControlAction
	local IsPedShooting = IsPedShooting
	local IsControlJustReleased = IsControlJustReleased

	-- ── The shot, never the aim ────────────────────────────────────────────────────
	-- The owner (2026-11-08): "sometimes I cannot aim or scope, it gets stuck". DISABLE_PLAYER_FIRING
	-- inhibits every kind of combat in RDR3, the aim and the scope with it, and it ran on every frame a
	-- weapon was busy or empty: after each burst the ammo save waits for the server (seconds when the
	-- database is slow), during a reload, with an empty clip (the one-round rifles after every shot).
	-- Those states only need the trigger blocked, so they disable the attack inputs and leave the aim.
	local SHOT_CONTROLS = {
		`INPUT_ATTACK`, `INPUT_ATTACK2`, `INPUT_HORSE_ATTACK`, `INPUT_HORSE_ATTACK2`,
		`INPUT_VEH_ATTACK`, `INPUT_VEH_ATTACK2`, `INPUT_VEH_PASSENGER_ATTACK`,
	}
	local function blockShot()
		for i = 1, #SHOT_CONTROLS do DisableControlAction(0, SHOT_CONTROLS[i], true) end
	end

	-- A busy flag must never outlive its job: a callback that never answers (w_lib waits five minutes)
	-- or a thread that died left combat blocked until the weapon was re-equipped. Past these limits the
	-- block is dropped and the console says which flag was stuck.
	local COMBAT_BLOCK_MAX, WEAPON_BUSY_MAX = 15000, 10000
	local combatBlockSince, weaponBusySince

	client.tick = SetInterval(function()
		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()

			for i = 1, #EnableKeys do
				EnableControlAction(0, EnableKeys[i], true)
			end

			-- walking stays possible while the drop window is open
			if currentInventory.type == 'newdrop' then
				EnableControlAction(0, `INPUT_MOVE_LR`, true)
				EnableControlAction(0, `INPUT_MOVE_UD`, true)
			end
		else
			if invBusy then
				-- no mounting / boarding and no crouching while the bag is busy
				DisableControlAction(0, `INPUT_ENTER`, true)
				DisableControlAction(0, `INPUT_DUCK`, true)
			end

			if usingItem or invBusy == true then
				local now = GetGameTimer()
				combatBlockSince = combatBlockSince or now

				-- a long progress bar (crafting, eating) is a real job: it keeps the block
				if now - combatBlockSince < COMBAT_BLOCK_MAX or lib.progressActive() then
					DisablePlayerFiring(playerId, true)
				elseif combatBlockSince > 0 then
					combatBlockSince = -1 -- warned once for this stretch
					warn(('w_inventory: combat stayed blocked over %d s (usingItem=%s invBusy=%s); the block was dropped')
						:format(COMBAT_BLOCK_MAX // 1000, tostring(usingItem), tostring(invBusy)))
				end
			else
				combatBlockSince = nil
			end

			if IsPedCuffed(playerPed) then
				DisablePlayerFiring(playerId, true)
			end

			if currentWeapon and currentWeapon.timer then
				DisableControlAction(0, `INPUT_MELEE_ATTACK`, true)
				-- The engine's reload key is ours: reloadFromKey tops the weapon up from the bag (server-checked)
				-- or reloads a lone weapon's clip from its own spare rounds. The game still reloads an empty
				-- clip by itself from those spare rounds (applyAmmoSeparation keeps them in the reserve).
				DisableControlAction(0, `INPUT_RELOAD`, true)

				if IsDisabledControlJustPressed(0, `INPUT_RELOAD`) then reloadFromKey() end

				-- (The old 'ammunition pinning clamp' was removed: it used to pin GetAmmoInPedWeapon at metadata.ammo
				--  so it stopped the consumption gate detecting the shot (10<10 forever). The consumption is now by an edge counter below.)

				if currentWeapon.reloadBusy or currentWeapon._ammoPersistBusy then
					local now = GetGameTimer()
					weaponBusySince = weaponBusySince or now

					if now - weaponBusySince < WEAPON_BUSY_MAX then
						blockShot()
					else
						warn(('w_inventory: weapon in slot %s blocked its shot over %d s (reload=%s save=%s); cleared')
							:format(tostring(currentWeapon.slot), WEAPON_BUSY_MAX // 1000,
								tostring(currentWeapon.reloadBusy), tostring(currentWeapon._ammoPersistBusy)))
						currentWeapon.reloadBusy, currentWeapon._ammoPersistBusy = nil, nil
						-- a reload whose thread died never ran finishReload: the next one must not wait on it
						if reloadTransaction == currentWeapon.slot then
							reloadTransaction, reloadInProgress[currentWeapon.slot] = nil, nil
						end
						weaponBusySince = nil
					end
				else
					weaponBusySince = nil

					if (currentWeapon.metadata.durability or 100) <= 0 then
						DisablePlayerFiring(playerId, true)
					elseif client.aimedfiring and not currentWeapon.melee and not IsPlayerFreeAiming(playerId) then
						blockShot()
					end
				end

				-- Detecting the firing edge (every frame): in RDR3 the ammunition is pooled by type and
				-- GetAmmoInPedWeapon may not go down after the shot, so we rely on IsPedShooting's rising edge.
				local shootingNow = (not currentWeapon.melee) and IsPedShooting(playerPed) or false
				local shotEdge = shootingNow and not weaponWasShooting
				weaponWasShooting = shootingNow
				local shot = Weapon.ObserveFiring(currentWeapon, shootingNow, shotEdge)
				if shot and shot.weapon then currentWeapon = shot.weapon end

				local weaponAmmo = currentWeapon.metadata.ammo

				-- A safety net: stop the firing when the loaded ammunition runs out (the weapon is really empty).
				-- The trigger only: an empty weapon still aims and scopes, and R reloads it from the bag.
				if weaponAmmo == 0 and not Weapon.HasUsableHeldAmmo(currentWeapon)
					and not currentWeapon.melee and not currentWeapon.throwable then
					blockShot()
				end

				if not invBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					currentWeapon.timer = 0

					-- ObserveFiring already commits every shot with ammo/shot revisions;
					-- the server batches its save and flushes on disconnect. A second
					-- awaited snapshot here blocked the trigger after every burst.
					if weaponAmmo == nil and currentWeapon.metadata.durability then
						TriggerServerEvent('w_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
				elseif currentWeapon.throwable then
					if not invBusy and IsControlPressed(0, 0x07CE1E61) then
						invBusy = 1

						CreateThread(function()
							local weapon = currentWeapon

							while currentWeapon and (not IsPedWeaponReadyToShoot(cache.ped) or IsDisabledControlPressed(0, 0x07CE1E61)) and GetSelectedPedWeapon(playerPed) == weapon.hash do
								Wait(0)
							end

							if GetSelectedPedWeapon(playerPed) == weapon.hash then Wait(700) end

							while IsPedPlantingBomb(playerPed) do Wait(0) end

							-- Commit the throw before mutating the local weapon state. The old
							-- fire-and-forget event always removed the whole stack from the ped,
							-- even when the server rejected the request or more throwables remained.
							local called, removed = pcall(function()
								return lib.callback.await('w_inventory:updateWeapon', false,
									'throw', nil, weapon.slot)
							end)

							invBusy = false
							plyState:set('invBusy', false, false)

							if not called or removed ~= true then return end

							local remaining = math.max(0, math.floor(tonumber(weapon.count) or 1) - 1)
							weapon.count = remaining

							if remaining > 0 and currentWeapon == weapon then
								-- RDR3 may holster/remove the throwable entity after one use. Recreate
								-- it only when needed and force the authoritative remaining count.
								if not HasPedGotWeapon(playerPed, weapon.hash, 0, false) then
									Citizen.InvokeNative(0xB282DC6EBD803C75,
										playerPed, weapon.hash, remaining, true, 0)
								end

								SetPedAmmo(playerPed, weapon.hash, remaining)
								SetCurrentPedWeapon(playerPed, weapon.hash, true, 0, false, false)
								TriggerEvent('w_inventory:currentWeapon', weapon, 'equipped')
							else
								if currentWeapon == weapon then currentWeapon = nil end
								RemoveWeaponFromPed(playerPed, weapon.hash)
								TriggerEvent('w_inventory:currentWeapon')
							end
						end)
					end
				elseif currentWeapon.melee and IsControlJustReleased(0, 0x07CE1E61) and IsPedPerformingMeleeAction(playerPed) then
					currentWeapon.melee += 1
					currentWeapon.timer = GetGameTimer() + 200
				end
			end
		end
	end)

	plyState:set('invBusy', false, false)
	plyState:set('invOpen', false, false)
	plyState:set('invHotkeys', true, false)
	plyState:set('canUseWeapons', true, false)
	collectgarbage('collect')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if shared.resource == resourceName then
		client.onLogout()
	end
end)

RegisterNetEvent('w_inventory:viewInventory', function(left, right)
	if source == '' then return end

	plyState.invOpen = true

	SetInterval(client.interval, 100)
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)

	currentInventory = localizeInventory(right) or defaultInventory
	currentInventory.ignoreSecurityChecks = true
	currentInventory.type = 'inspect'
	left.items = PlayerData.inventory
	left.groups = PlayerData.groups

	SendNUIMessage({
		action = 'setupInventory',
		data = {
			leftInventory = left,
			rightInventory = currentInventory
		}
	})
end)

RegisterNUICallback('uiLoaded', function(_, cb)
	client.uiLoaded = true
	cb(1)
end)

RegisterNUICallback('getItemData', function(itemName, cb)
	cb(Items[itemName])
end)

-- Taking off or putting back on a piece of clothing (the library's component engine)
RegisterNUICallback('toggleCloth', function(command, cb)
	cb(1)
	local category = type(command) == 'string' and CommandToCategory[command]
	if not category then return end

	local ok, hash, data = pcall(w.component.getComponentEquiped, cache.ped, category)
	local currentlyWorn = ok and hash and hash ~= 0

	if currentlyWorn then
		-- Taking off: keep the component (hash and tints) so it can be put back on as it was
		lastRemovedClothes[category] = type(data) == 'table' and {
			hash = data.hash,
			palette = data.palette,
			tint0 = data.tint0,
			tint1 = data.tint1,
			tint2 = data.tint2,
		} or { hash = hash }
		pcall(w.component.remove, cache.ped, category)
	elseif lastRemovedClothes[category] then
		-- Putting back on
		local saved = lastRemovedClothes[category]
		lastRemovedClothes[category] = nil

		if saved.hash and saved.hash ~= 0 then
			pcall(w.component.apply, cache.ped, category, saved)
		end
	end

	SetTimeout(150, function()
		sendWornAndRemovedToNui()
	end)
end)

-- On opening the clothing tab: sending the list of what is worn + what was taken off (and can be put back on)
RegisterNUICallback('requestWornClothing', function(_, cb)
	cb(1)
	sendWornAndRemovedToNui()
end)

RegisterNUICallback('removeAmmo', function(slot, cb)
	local weaponSlot = tonumber(slot)
	if not weaponSlot then return cb(false) end

	-- Awaiting an inventory callback directly in a NUI handler is unreliable in
	-- CfxLua. A dedicated coroutine owns the complete unload transaction.
	cb(true)
	CreateThread(function()
		local slotData = PlayerData.inventory[weaponSlot]

		if not slotData or not slotData.metadata then return end

		if Weapon.DualWield.HasSlot(weaponSlot) then
			-- The engine's pool is the truth for a weapon in the hand (rounds were fired from it after the last
			-- save). ReassignAmmoPool reads it and fixes it on the server and on the bag's
			-- copy together, so the next check is on a real balance and not an old one.
			local liveAmmo = Weapon.ReassignAmmoPool(weaponSlot)
			if liveAmmo == nil then return end
		end

		-- The server is the reference; we only avoid the pointless call when the store is empty for certain.
		if (tonumber(slotData.metadata.ammo) or 0) <= 0 then return end

		local success, revision = lib.callback.await('w_inventory:removeAmmoFromWeapon', false, weaponSlot)

		if success then
			-- ClearLoadedAmmo skips the weapons that carry no ammoType, so we zero the bag's
			-- copy here too, otherwise the 'unload bullets' button stayed showing on an empty weapon.
			Weapon.ClearLoadedAmmo(weaponSlot, revision)
			slotData.metadata.ammo = 0
			slotData.metadata.specialAmmo = nil
			slotData.metadata._ammoRevision = tonumber(revision) or slotData.metadata._ammoRevision

			if weaponSlot == currentWeapon?.slot then
				currentWeapon.metadata.ammo = 0
				currentWeapon.metadata.specialAmmo = nil
				currentWeapon.metadata._ammoRevision = tonumber(revision)
					or currentWeapon.metadata._ammoRevision

				-- * A weapon emptied on purpose does not stay in the hand.
				--
				-- The engine chambers one round in every **drawn** weapon and does not accept zeroing it:
				-- we measured it on the Cattleman and the bow together - the store was written zero and read back 1.
				-- So a number the bag does not know shows in the game's wheel.
				--
				-- And there is no way to chase it in the engine, but its root is that the weapon is drawn.
				-- So we holster it: no weapon in the hand => no chambered round => the wheel reads
				-- zero like the bag. And it is the correct behaviour to begin with - whoever emptied his weapon
				-- on purpose has no reason to stay holding it empty.
				currentWeapon = Weapon.Disarm(currentWeapon, true)
			end
		end
	end)
end)

RegisterNUICallback('useItem', function(slot, cb)
	slot = tonumber(slot)
	local slotData = slot and PlayerData.inventory and PlayerData.inventory[slot]
	local itemData = slotData and Items[slotData.name]
	local handler = itemData and itemData.weapon and selectWeaponSlot or useSlot
	local success, err = pcall(handler, slot --[[@as number]])
	if not success and err then
		warn('^1SCRIPT ERROR in useItem NUI callback: ' .. tostring(err) .. '^0')
	end
	cb(1)
end)

local function giveItemToTarget(serverId, slotId, count)
	if type(slotId) ~= 'number' then return TypeError('slotId', 'number', type(slotId)) end
	if count and type(count) ~= 'number' then return TypeError('count', 'number', type(count)) end

	disarmTrackedSlot(slotId, true)

	Utils.PlayAnim(0, 'script_common@other@unapproved', 'door_deal_wait_buyer', 1.0, 1.0, 2000, 50, 0.0, 0, 0, 0)
	TriggerServerEvent('w_inventory:giveItem', slotId, serverId, count or 0)
end

exports('giveItemToTarget', giveItemToTarget)

local function isGiveTargetValid(ped, coords)
	if cache.vehicle and GetVehiclePedIsIn(ped, false) == cache.vehicle then
		return true
	end

	local entity = Utils.Raycast(1|2|4|8|16, coords + vec3(0, 0, 0.5), 0.2)

	return entity == ped and IsEntityVisible(ped)
end

RegisterNUICallback('giveItem', function(data, cb)
	cb(1)

	if client.giveplayerlist then
		local nearbyPlayers = lib.getNearbyPlayers(GetEntityCoords(playerPed), 3.0)
		local nearbyCount = #nearbyPlayers

		if nearbyCount == 0 then return end

		if nearbyCount == 1 then
			local option = nearbyPlayers[1]

			if not isGiveTargetValid(option.ped, option.coords) then return end

			return giveItemToTarget(GetPlayerServerId(option.id), data.slot, data.count)
		end

		local giveList, n = {}, 0

		for i = 1, #nearbyPlayers do
			local option = nearbyPlayers[i]

			if isGiveTargetValid(option.ped, option.coords) then
				local playerName = GetPlayerName(option.id)
				option.id = GetPlayerServerId(option.id)
				---@diagnostic disable-next-line: inject-field
				option.label = ('[%s] %s'):format(option.id, playerName)
				n += 1
				giveList[n] = option
			end
		end

		if n == 0 then return end

		lib.registerMenu({
			id = 'w_inventory:givePlayerList',
			title = locale('give_item'),
			options = giveList,
		}, function(selected)
			giveItemToTarget(giveList[selected].id, data.slot, data.count)
		end)

		return lib.showMenu('w_inventory:givePlayerList')
	end

	if cache.vehicle then
		local seats = GetVehicleMaxNumberOfPassengers(cache.vehicle) - 1

		if seats >= 0 then
			local passenger = GetPedInVehicleSeat(cache.vehicle, cache.seat - 2 * (cache.seat % 2) + 1)

			if passenger ~= 0 and IsEntityVisible(passenger) then
				return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger)), data.slot, data
					.count)
			end
		end

		return
	end

	local entity = Utils.Raycast(1|2|4|8|16, GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 3.0, 0.5), 0.2)

	if entity and IsPedAPlayer(entity) and IsEntityVisible(entity) and #(GetEntityCoords(playerPed, true) - GetEntityCoords(entity, true)) < 3.0 then
		return giveItemToTarget(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)), data.slot, data.count)
	end
end)

RegisterNUICallback('useButton', function(data, cb)
	useButton(data.id, data.slot)
	cb(1)
end)

-- Selection from the React ammo picker. The callback acknowledges the click
-- immediately; the reload transaction runs in its own coroutine because it
-- awaits the authoritative server validation and inventory mutation.
RegisterNUICallback('reloadWeapon', function(data, cb)
	local weaponSlot = type(data) == 'table' and tonumber(data.weaponSlot)
	local ammoSlot = type(data) == 'table' and tonumber(data.ammoSlot)

	if not weaponSlot or not ammoSlot then
		return cb(false)
	end

	cb(true)
	CreateThread(function()
		reloadWeapon(weaponSlot, ammoSlot)
	end)
end)

RegisterNUICallback('exit', function(_, cb)
	client.closeInventory()
	cb(1)
end)

lib.callback.register('w_inventory:startCrafting', function(id, recipe)
	recipe = CraftingBenches[id].items[recipe]

	return lib.progressCircle({
		label = locale('crafting_item', recipe.metadata?.label or Items[recipe.name].label),
		duration = recipe.duration or 3000,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'amb_misc@world_human_stand_waiting@female_a@idle_a',
			clip = 'idle_a',
		}
	})
end)

local swapActive = false

---Synchronise and validate all item movement between the NUI and server.
RegisterNUICallback('swapItems', function(data, cb)
	if swapActive or not invOpen or invBusy or usingItem then return cb(false) end

	swapActive = true

	if data.toType == 'newdrop' then
		if cache.vehicle or IsPedFalling(playerPed) then
			swapActive = false
			return cb(false)
		end

		local coords = GetEntityCoords(playerPed)

		if IsEntityInWater(playerPed) then
			local destination = vec3(coords.x, coords.y, -200)
			local handle = StartShapeTestLosProbe(coords.x, coords.y, coords.z, destination.x, destination.y,
				destination.z, 511, cache.ped, 4)

			while true do
				Wait(0)
				local retval, hit, endCoords = GetShapeTestResult(handle)

				if retval ~= 1 then
					if not hit then return end

					data.coords = vec3(endCoords.x, endCoords.y, endCoords.z + 1.0)

					break
				end
			end
		else
			data.coords = coords
		end
	end

	if currentInstance then
		data.instance = currentInstance
	end

	-- Moving an equipped weapon always takes it out of the player's hand, whether
	-- it leaves the inventory or just changes slot inside it.
	--
	-- This used to be gated on `fromType ~= toType`, so a move within the
	-- player's own inventory — which is exactly what dragging a weapon out of the
	-- hotbar row (slots 1-5) is — never disarmed. The server remapped the slot
	-- and the weapon stayed drawn, which reads as "I removed it from the shortcut
	-- and it is still in my hand".
	--
	-- disarmTrackedSlot is a no-op for a slot that is not equipped, so calling it
	-- unconditionally costs nothing for ordinary item moves.
	if data.fromType == 'player' then disarmTrackedSlot(data.fromSlot, true) end
	if data.toType == 'player' then disarmTrackedSlot(data.toSlot, true) end

	local success, response, weaponSlot, weaponSlotMap = lib.callback.await('w_inventory:swapItems', false, data)
	swapActive = false

	cb(success or false)

	if success then
		if weaponSlotMap then
			currentWeapon = Weapon.RemapUsageSlots(weaponSlotMap, currentWeapon)
		elseif weaponSlot and currentWeapon then
			currentWeapon.slot = weaponSlot
		end

		if response then
			updateInventory(response.items, response.weight)
		end

		if weaponSlotMap then Weapon.SyncUsage(currentWeapon) end
	elseif response then
		if type(response) == 'table' then
			SendNUIMessage({ action = 'refreshSlots', data = { items = response } })
		else
			Utils.Notify({ type = 'error', description = locale(response) })
		end
	end
end)


RegisterNUICallback('buyItem', function(data, cb)
	local originalFromSlot = data.fromSlot  -- save the original shop slot before data changes
	---@type boolean, false | { [1]: number, [2]: SlotWithItem, [3]: SlotWithItem | false, [4]: number}, NotifyProps
	local response, data, message = lib.callback.await('w_inventory:buyItem', 100, data)

	if data then
		updateInventory({
			{
				item = data[2],
				inventory = cache.serverId
			}
		}, data[4])

		-- We always refresh the shop's element in the interface after the purchase
		local shopItem = data[3]
		if shopItem and type(shopItem) == 'table' then
			-- The element still exists (a quantity > 0)
			SendNUIMessage({
				action = 'refreshSlots',
				data = {
					items = {
						{
							item = shopItem,
							inventory = 'shop'
						}
					}
				}
			})
		elseif originalFromSlot then
			-- A quantity of zero: we send an empty element to clear it from the interface
			SendNUIMessage({
				action = 'refreshSlots',
				data = {
					items = {
						{
							item = { slot = originalFromSlot, count = 0 },
							inventory = 'shop'
						}
					}
				}
			})
		end
	end

	if message then
		Utils.Notify(message)
	end

	cb(response)
end)

RegisterNUICallback('craftItem', function(data, cb)
	cb(true)

	local id, index = currentInventory.id, currentInventory.index

	for i = 1, data.count do
		local success, response = lib.callback.await('w_inventory:craftItem', 200, id, index, data.fromSlot, data
			.toSlot)

		if not success then
			if response then Utils.Notify({ type = 'error', description = locale(response or 'cannot_perform') }) end
			break
		end
	end

	if not currentInventory or currentInventory.type ~= 'crafting' then
		client.openInventory('crafting', { id = id, index = index })
	end
end)

lib.callback.register('w_inventory:getVehicleData', function(netid)
	local entity = NetworkGetEntityFromNetworkId(netid)

	if entity and entity ~= 0 and DoesEntityExist(entity) then
		-- a horse's saddlebag / a wagon's storage is sized from its model (data/vehicles.lua)
		return GetEntityModel(entity)
	end
end)





local unarmedStreak = 0

Citizen.CreateThread(function()
    if NativeWeapons then return end
	while true do
		Wait(100)

		if not PlayerData or not PlayerData.inventory then
			goto continue
		end

		-- Rockstar's weapon inspection animation intentionally transitions through
		-- temporary UNARMED states. The normal watchdog would answer each one with
		-- useSlot(), making the ped draw/holster forever. Inspection owns the weapon
		-- state until it exits, followed by a short native transition grace period.
		if activeWeaponInspection or GetGameTimer() < weaponWatchdogPauseUntil then
			unarmedStreak = 0
			goto continue
		end

		-- Native draw/reload animations briefly report UNARMED. Ignore those
		-- transitions and only act on a stable state for three consecutive polls.
		if usingItem or invBusy or Weapon.DualWield.Busy() or IsPedReloading(PlayerPedId())
			or currentWeapon and (currentWeapon.reloadBusy or currentWeapon._ammoPersistBusy) then
			unarmedStreak = 0
			goto continue
		end

		local currentHeldWeapon = Citizen.InvokeNative(0x8425C5F057012DAB, PlayerPedId())

		-- While the dual wield is being set up the hand flips for a moment; interacting with it here used to
		-- re-enter useSlot so it holstered what had just been equipped or drew another weapon.
		-- And the tracked two-hand weapons are no business of this watchdog to begin with.
		if currentHeldWeapon ~= unarmedHash and Weapon.DualWield.HasHash(currentHeldWeapon) then
			unarmedStreak = 0
			heldWeapon = currentHeldWeapon
			goto continue
		end

		if currentHeldWeapon ~= heldWeapon then
			if currentHeldWeapon == unarmedHash then
				unarmedStreak += 1
				if unarmedStreak < 3 then goto continue end

				if Weapon.DualWield.Count() == 0 and heldWeapon ~= nil and heldWeaponInfo ~= nil and currentWeapon ~= nil then
					-- Being holstered is not the same as being unequipped. RDR keeps the
					-- inventory/loadout weapon active while its object is on the body.
					-- Calling useSlot() here toggled that same slot off; the decorative
					-- hotbar then drew it again, producing an infinite draw/holster loop
					-- whenever a gunsmith component briefly rebuilt the weapon object.
					Weapon.CaptureStatus(currentWeapon)
				end

				heldWeapon = unarmedHash
				heldWeaponInfo = currentWeapon
				unarmedStreak = 0
			else
				unarmedStreak = 0
				if currentWeapon and currentWeapon.hash == currentHeldWeapon then
					heldWeapon = currentHeldWeapon
					heldWeaponInfo = PlayerData.inventory[currentWeapon.slot] or currentWeapon
					goto continue
				end

				local matches = {}
				for _, invItem in pairs(PlayerData.inventory) do
					if GetHashKey(invItem.name) == currentHeldWeapon then
						matches[#matches + 1] = invItem
					end
				end

				-- The base game reports only a weapon hash when a decorative holster
				-- copy is drawn. With identical twins there is no serial in that native
				-- result, so select deterministically by slot instead of whichever
				-- table entry pairs() happened to return. Inventory/wheel actions still
				-- carry the exact slot and can select either instance explicitly.
				table.sort(matches, function(a, b)
					return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
				end)

				local selected = matches[1]
				if selected then
					useSlot(selected.slot)
					heldWeapon = currentHeldWeapon
					heldWeaponInfo = selected
				end
			end
		elseif currentHeldWeapon ~= unarmedHash then
			unarmedStreak = 0
		end

		::continue::
	end
end)

local Inhotbar = {}

-- Managed body display owns independent cosmetic props for every bag slot.
-- Leave the native/default weapon entities entirely with the inventory.
local function wheelManagesBodyWeapons()
    if GetResourceState('w_wheel') ~= 'started' then return false end
    local ok, enabled = pcall(function() return exports.w_wheel:isWheelEnabled() end)
    return not ok or enabled ~= false
end

--- Stable per-instance key. Firearms always receive a unique serial from the
--- server; the slot fallback is only for non-serial legacy/tool weapons.
local function hotbarInstanceKey(item)
	local serial = item and item.metadata and item.metadata.serial
	if serial ~= nil and tostring(serial) ~= '' then return 'serial:' .. tostring(serial) end
	return ('slot:%s:%s'):format(tostring(item and item.slot or ''), tostring(item and item.name or ''))
end

local function findHotbarInstance(tracked)
	local trackedSerial = tracked and tracked.metadata and tracked.metadata.serial

	for _, item in pairs(PlayerData.inventory or {}) do
		if trackedSerial ~= nil and tostring(trackedSerial) ~= '' then
			if item.metadata and tostring(item.metadata.serial or '') == tostring(trackedSerial) then
				return item
			end
		elseif tracked and tonumber(item.slot) == tonumber(tracked.slot) and item.name == tracked.name then
			return item
		end
	end
end

--- The holster actually assigned to every pistol copy: [serial/slot key] = 2|3
local hotbarAttach = {}
local hotbarDetachPending = {}

local holsterCompsApplied = {}
--- When the wait for the switching animation began - to determine its cap (see the guard below)
local swapWaitStartedAt

--- The holstered weapon's attach point on the body (2 or 3 for the pistols, and others for the long guns).
--- We look it up by the model and not by the hotbarAttach table, since the table carries no value for the long
--- and melee weapons at all.
---@return number|nil
local function holsterAttachPoint(ped, weaponHash)
	local wanted = GetWeapontypeModel(weaponHash)
	if not wanted or wanted == 0 then return nil end

	-- * We skip 0 and 1 on purpose: they are the two hands. Were a matching weapon in your hand the search would come back
	-- with a hand point, so the gunsmith takes the hand path and runs SetCurrentPedWeapon - that is,
	-- it draws the weapon instead of decorating the holstered one. The decorative copy is never in a hand.
	for point = 2, 12 do
		local object = GetCurrentPedWeaponEntityIndex(ped, point)
		if object and object ~= 0 and DoesEntityExist(object)
			and GetEntityModel(object) == wanted then
			return point
		end
	end
end

--- The holstered weapon is given what can be put on it - **the parts with a model alone**.
---
--- ═══ The inverted contract: the holster is not engraved, it inherits ═══
---
--- The engine classifies the components into two kinds: a MOD that has a model so it is fitted onto the ped, and a DECORATION
--- (a tint/an etching) with no model whose only path is the GUID tree.
---
--- And engraving on the holster is a dead end, with three measured constraints:
---   1) The tree refuses the addition as long as the slot is occupied by a factory piece.
---   2) Emptying a particular slot is impossible: FITS_SLOT/HAS_SLOT come back empty for these
---      components, so RemoveWeaponComponentsInSlot returns zero on every call.
---   3) The only wholesale emptying available calls RemoveWeaponComponentFromPed on
---      (ped + hash) and not on the object, so it wipes the weapon from every one of its copies and the decorative
---      copy disappears from the holster.
---
--- * And the way out is that the third constraint itself is the solution: as long as the removal and the fitting are both on
--- (ped + hash), the holstered copy and the drawn weapon share the components by
--- construction. So we never customise the holster: the customisation happens in full with the weapon in the hand - and there
--- the wholesale stripping is safe because the drawn one is the very same copy and no second copy falls - then
--- the holstered copy inherits what settled on the hash.
---
--- So what is left to this function: the parts with a model, showing on the belt at once with no drawing.
--- And the gunsmith knows the difference itself: an attach point >= 2 means a parts pass with no tree.
local function applyHolsterComponents(key, weaponHash, item)
	if wheelManagesBodyWeapons() then return end
	local comps = item and item.metadata and item.metadata.gunComps
	if type(comps) ~= 'table' or not next(comps) then
		holsterCompsApplied[key] = nil
		return
	end

	-- * Fitting a component onto the ped pushes the engine to rebuild the weapon's entity. So if the fitting
	-- repeated periodically it became a holster/draw loop - and it is the very one that cost us in the gunsmith.
	-- The components' fingerprint guarantees one pass per customisation, and repeats it if it really changed.
	local parts = {}
	for category, component in pairs(comps) do
		parts[#parts + 1] = tostring(category) .. '=' .. tostring(component)
	end
	table.sort(parts)
	local signature = tostring(weaponHash) .. '|' .. table.concat(parts, ',')

	if holsterCompsApplied[key] == signature then return end
	holsterCompsApplied[key] = signature

	CreateThread(function()
		if wheelManagesBodyWeapons() then return end
		local ped = PlayerPedId()
		local point = holsterAttachPoint(ped, weaponHash)

		if point and GetResourceState('w_gunsmith') == 'started' then
			-- noStrip = true: the stripping works on (ped + hash) and not on the object, so it used to
			-- strip the weapon in every one of its copies and drop the decorative copy. And it is not needed
			-- here at all - there is no tree in the holster pass so no slot needs emptying.
			local called, applied = pcall(function()
				return exports.w_gunsmith:ApplyWeaponCustomization(comps, point, true)
			end)
			if called and applied ~= false then return end
		end

		-- A fallback: the gunsmith is stopped or the attach point was not found. We fit the parts
		-- with a model at least; the engravings need the GUID tree so they stay unapplied.
		if type(ApplyWeaponComponent) ~= 'function' then return end
		for _, component in pairs(comps) do
			if type(component) == 'string' and component ~= '' then
				pcall(ApplyWeaponComponent, ped, weaponHash, joaat(component))
			end
		end
	end)
end

--- A new decorative copy given to the body = a weapon built from scratch with its factory pieces.
--- So the GUID tree that carried the tint and the etching goes with it.
---
--- There is no avoiding this when the weapon really leaves the ped, but the gunsmith's stamp **must** be
--- invalidated then: its fingerprint stops a second pass with the same customisation, so had it stayed the next draw
--- would have come with no pass, and the weapon would have stayed bare in the hand and in the holster together. Invalidating it brings
--- the full pass back at the first draw, and from it the holstered copy inherits its engravings.
local function forgetCustomizationAfterRebuild()
	if GetResourceState('w_gunsmith') ~= 'started' then return end
	pcall(function() exports.w_gunsmith:ForgetWeaponCustomization() end)
end

--- Taking a hotbar weapon off the player's body *confirmedly*.
--- An RDR3 defect: RemoveWeaponFromPed removes the visible weapon only and leaves its record, so
--- HasPedGotWeapon stays true and the weapon stays drawable later (the shortcut's ghost: you take
--- the weapon out of the bag then press the slot's number so it is drawn from the holster). We wait for it to really go
--- with a time cap - the same pattern as modules/weapon/dualwield.lua. It returns true if it really went.
local function detachHotbarWeapon(hash)
	local ped = PlayerPedId()
	if not HasPedGotWeapon(ped, hash, 0, false) then return true end
	local deadline = GetGameTimer() + 600
	repeat
		RemoveWeaponFromPed(ped, hash)
		Wait(0)
	until not HasPedGotWeapon(ped, hash, 0, false) or GetGameTimer() >= deadline
	return not HasPedGotWeapon(ped, hash, 0, false)
end

-- Begin weapon-wheel legacy decoration ownership.
local function hotbarHashIsProtected(hash)
    if Weapon.DualWield.HasHash(hash) then return true end
    if currentWeapon and (currentWeapon.hash or GetHashKey(currentWeapon.name)) == hash then return true end
    for _, item in pairs(PlayerData and PlayerData.inventory or {}) do
        if item.name and (item.hash or GetHashKey(item.name)) == hash then
            local metadata = item.metadata or {}
            local used, used2 = metadata.used, metadata.used2
            if used == nil then used = item.used end
            if used2 == nil then used2 = item.used2 end
            if isUsageFlag(used) or isUsageFlag(used2) then return true end
        end
    end
    for hand = 0, 1 do
        local found, heldHash = GetCurrentPedWeapon(PlayerPedId(), true, hand, true)
        if (found == true or found == 1) and heldHash == hash then return true end
    end
    return false
end

local function forgetHotbarHash(hash)
    for key, item in pairs(Inhotbar) do
        if GetHashKey(item.name) == hash then
            Inhotbar[key], hotbarAttach[key], holsterCompsApplied[key] = nil, nil, nil
        end
    end
    hotbarDetachPending[hash] = nil
end

local function clearLegacyHotbarForWheel()
    local hashes = {}
    for _, item in pairs(Inhotbar) do hashes[GetHashKey(item.name)] = true end
    for hash in pairs(hotbarDetachPending) do hashes[hash] = true end
    for hash in pairs(hashes) do
        if hotbarHashIsProtected(hash) then
            -- A GUID draw already replaces decorations of its model. Forget
            -- stale decoration ownership rather than touching that native gun.
            forgetHotbarHash(hash)
        else
            local ped = PlayerPedId()
            if HasPedGotWeapon(ped, hash, 0, false) then RemoveWeaponFromPed(ped, hash) end
            if not HasPedGotWeapon(ped, hash, 0, false) then forgetHotbarHash(hash) end
        end
    end
end
-- End weapon-wheel legacy decoration ownership.

Citizen.CreateThread(function()
    if NativeWeapons then return end
	while true do
		Wait(1000) -- run once per second

		if not PlayerData or not PlayerData.inventory then
			goto continue
		end

        if wheelManagesBodyWeapons() then
            if not activeWeaponInspection and GetGameTimer() >= weaponWatchdogPauseUntil then
                clearLegacyHotbarForWheel()
            end
            goto continue
        end

		-- Do not add/remove decorative hotbar weapon entities while the native
		-- inspection task owns the held prop or while a draw/holster transaction
		-- is still settling.
		if activeWeaponInspection or GetGameTimer() < weaponWatchdogPauseUntil then
			goto continue
		end

		-- * And not during the holster/draw animation the game itself plays (TAB).
		--
		-- This thread takes the decorative copy off then gives it back. So if that happened while the animation
		-- was still running, the weapon disappeared from the hand in the middle of the animation then 'fell' into the holster.
		--
		-- ! The wait is **capped**. The first version was `~= 8 -> skip` with no cap,
		-- and the task's state does not always reach 8 (and that is why VORP put a cap around its own wait).
		-- So the thread stalled forever: no decorative copy, and the weapon disappeared from the holster
		-- and never came back. No guard with no cap after today.
		if GetScriptTaskStatus(PlayerPedId(), `SCRIPT_TASK_SWAP_WEAPON`, true) ~= 8 then
			swapWaitStartedAt = swapWaitStartedAt or GetGameTimer()
			if GetGameTimer() - swapWaitStartedAt < 1500 then goto continue end
		else
			swapWaitStartedAt = nil
		end

		----------------------------------------------------------------
		-- PASS 1: Remove items from Inhotbar if they're no longer valid
		----------------------------------------------------------------
		local rebuildHashes = {}
		for key, hotbarItem in pairs(Inhotbar) do
			local hash = GetHashKey(hotbarItem.name)

			-- Equipping an exact GUID instance removes every decorative copy of
			-- the same model. Forget their records now so both serials are rebuilt
			-- independently after the held pair is holstered again.
			if Weapon.DualWield.HasHash(hash) then
				Inhotbar[key] = nil
				hotbarAttach[key] = nil
				holsterCompsApplied[key] = nil
			else
				local actual = findHotbarInstance(hotbarItem)

				if not actual or not actual.slot or actual.slot > 5 then
					rebuildHashes[hash] = true
					Inhotbar[key] = nil
					hotbarAttach[key] = nil
					holsterCompsApplied[key] = nil
				else
					-- Keep the tracked reference current after a slot move.
					Inhotbar[key] = actual
				end
			end
		end

		-- RemoveWeaponFromPed is hash-wide. If one identical instance moved out,
		-- clear every decorative copy of that hash and rebuild the remaining
		-- serials below. Never run this while an exact GUID instance is held.
		for hash in pairs(rebuildHashes) do
			for key, tracked in pairs(Inhotbar) do
				if GetHashKey(tracked.name) == hash then
					Inhotbar[key] = nil
					hotbarAttach[key] = nil
					holsterCompsApplied[key] = nil
				end
			end

			hotbarDetachPending[hash] = true
		end

		for hash in pairs(hotbarDetachPending) do
			if not Weapon.DualWield.HasHash(hash) and detachHotbarWeapon(hash) then
				hotbarDetachPending[hash] = nil
			end
		end

		----------------------------------------------------------------
		-- PASS 2: showing the slots 1-5 weapons on the body.
		--
		-- The pistols have a fixed holster map by the slots' order: the first is a right
		-- holster (point 2) and the second a left one (point 3) - they do not change but by changing
		-- the order. The tracked two-hand weapons are managed by the dual-wield module alone.
		----------------------------------------------------------------
		local pistolAttach = {}

		do
			local guns = {}

			for _, invItem in pairs(PlayerData.inventory) do
				if invItem.slot and invItem.slot <= 5 and string.match(invItem.name, "WEAPON") then
					local h = GetHashKey(invItem.name)

					if IsWeaponOneHanded(h) == 1
						and not Weapon.DualWield.HasSlot(invItem.slot)
						and not Weapon.DualWield.HasHash(h) then
						guns[#guns + 1] = {
							slot = invItem.slot,
							hash = h,
							key = hotbarInstanceKey(invItem),
						}
					end
				end
			end

			table.sort(guns, function(a, b) return a.slot < b.slot end)

			for i = 1, math.min(2, #guns) do
				pistolAttach[guns[i].key] = i == 1 and 2 or 3
			end
		end

		for _, invItem in pairs(PlayerData.inventory) do
			if invItem.slot and invItem.slot <= 5 and string.match(invItem.name, "WEAPON")
				and not Weapon.DualWield.HasSlot(invItem.slot)
				and not Weapon.DualWield.HasHash(GetHashKey(invItem.name))
				and not hotbarDetachPending[GetHashKey(invItem.name)] then
				local weaponHash = GetHashKey(invItem.name)
				local key = hotbarInstanceKey(invItem)
				local oneHanded = IsWeaponOneHanded(weaponHash) == 1
				local desired
				if oneHanded then desired = pistolAttach[key] else desired = 0 end
				local present = HasPedGotWeapon(PlayerPedId(), weaponHash, 0, false)
				local needGive = not Inhotbar[key] or not present

				-- The pistols' order changed: it is taken off and put back in its new holster
				if oneHanded and present and hotbarAttach[key] ~= nil and hotbarAttach[key] ~= desired then
					if not detachHotbarWeapon(weaponHash) then
						hotbarDetachPending[weaponHash] = true
					end
					for trackedKey, tracked in pairs(Inhotbar) do
						if GetHashKey(tracked.name) == weaponHash then
							Inhotbar[trackedKey] = nil
							hotbarAttach[trackedKey] = nil
							holsterCompsApplied[trackedKey] = nil
						end
					end
					needGive = true
				end
				if hotbarDetachPending[weaponHash] then needGive = false end

				-- A third pistol or more with no holster for it: it stays in the bag with no display
				if needGive and (not oneHanded or desired ~= nil) then
					Inhotbar[key] = invItem

					-- * Here the copy is rebuilt, so its tree is lost and with it the tint
					-- and the etching. We invalidate the gunsmith's stamp so the full pass comes back at
					-- the first draw, so the copy inherits its engravings from the hash.
					if invItem.metadata and type(invItem.metadata.gunComps) == 'table'
						and next(invItem.metadata.gunComps) then
						forgetCustomizationAfterRebuild()
					end

					Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, 1, true)
					while not Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash) do
						Wait(50)
                        if wheelManagesBodyWeapons() then goto continue end
					end
                    -- The wheel can start while this asset request yields.
                    if wheelManagesBodyWeapons() then goto continue end

					if oneHanded then
						if desired == 3 then
							-- The visible left holster is necessary for the attach point 3
							Weapon.DualWield.EnsureOffhandHolster()
						end

						-- The RedEM pattern: a specified holster + multiple copies + bypassing the lock.
						-- ! ammoCount = 0 always: passing the weapon's balance here used to
						-- mint rounds into the type's pool with every display - the source of the duplication.
						-- The real balance is set by the equipping path from the metadata.
						Citizen.InvokeNative(0x5E3BDDBCB83F3D84, PlayerPedId(), weaponHash,
							0, false, true, desired, true, 0.5, 1.0, 752097756, true, 0.0, false)
					else
						Citizen.InvokeNative(0x5E3BDDBCB83F3D84, PlayerPedId(), weaponHash,
							0, 0, 1, 0, false, 0.5, 1.0, 752097756, 0, false, 0.0)
					end

					hotbarAttach[key] = oneHanded and desired or nil
					applyHolsterComponents(key, weaponHash, invItem)
				end
			end
		end

		::continue::
	end
end)

-- Auto-disarm when server detects melee weapon broke
RegisterNetEvent('w_inventory:weaponBroken', function(slot)
	local broken = slot and PlayerData.inventory and PlayerData.inventory[tonumber(slot)] or currentWeapon
	if broken then
		Utils.Notify({ type = 'error', description = locale('weapon_broke_repair') })
		currentWeapon = Weapon.Disarm(broken, true)
	end
end)

-- ════════════════════════════════════════════════════════════════════════════
-- /invdebug - why does 'use' not work on the items while it works on the weapons?
--
-- * The two paths really are different, and that is the cause of the confusion:
--     the weapons -> selectWeaponSlot   (they do not pass through canUseItem)
--     the items   -> useSlot -> canUseItem  <- a gate that, if closed, silences everything
--   and canUseItem returns false with no word, so it looks like 'I pressed and nothing happened'.
--   Here we print its conditions one by one.
-- ════════════════════════════════════════════════════════════════════════════
RegisterCommand('invdebug', function()
    local ped = cache.ped
    local function line(label, ok, detail)
        print(('%s %-32s %s'):format(ok and '^2[✓]^7' or '^1[✗]^7', label, detail or ''))
    end

    print('^3== w_inventory - ITEM USE DIAGNOSTIC =====================^0')

    line('PlayerData exists', PlayerData ~= nil)
    line('PlayerData.loaded', PlayerData and PlayerData.loaded == true,
        (PlayerData and PlayerData.loaded == true) and ''
        or '^1stuck at: while not client.uiLoaded - NUI never signalled ready^7')
    line('client.uiLoaded', client.uiLoaded == true,
        client.uiLoaded and '' or '^1NUI page never sent uiLoaded^7')
    line('not dead', not (PlayerData and PlayerData.dead))
    line('usingItem clear', not usingItem, usingItem and '^1stuck true - a previous use never finished^7' or '')
    line('invBusy clear', not invBusy, tostring(invBusy))
    line('no active progress bar', not lib.progressActive())
    line('not ragdolled', not IsPedRagdoll(ped))
    line('not falling', not IsPedFalling(ped))

    local canUse = not usingItem
        and PlayerData and PlayerData.loaded
        and not PlayerData.dead
        and not invBusy
        and not lib.progressActive()
        and not IsPedRagdoll(ped)
        and not IsPedFalling(ped)

    print('^3-- VERDICT ----------------------------------------------^0')
    line('canUseItem()', canUse and true or false,
        canUse and 'items are usable' or '^1items BLOCKED - first [x] above is the cause^7')
    print('^3════════════════════════════════════════════════════^0')
end, false)

-- ════════════════════════════════════════════════════════════════════════════
-- /usetest <slot> - where does the 'use an item' chain break?
--
-- * useSlot branches seven times before it reaches the server, and every wrong branch exits
--   in silence. And the server call itself is governed by a repeat guard (delay) that ignores the call
--   with no word. Here we print the chosen branch, then we call the server directly with no guard.
--
--   Usage:  /usetest 3     (the number of the slot holding the meat)
-- ════════════════════════════════════════════════════════════════════════════
RegisterCommand('usetest', function(_, args)
    local slot = tonumber(args[1])

    if not slot then
        return print('^3[usetest]^7 usage: /usetest <slot number>')
    end

    local item = PlayerData.inventory and PlayerData.inventory[slot]

    if not item then
        return print(('^1[usetest]^7 no item in slot %d'):format(slot))
    end

    local data = Items[item.name]

    if not data then
        return print(('^1[usetest]^7 "%s" is not in the inventory catalogue'):format(item.name))
    end

    print(('^3== usetest - "%s" in slot %d ===========================^0'):format(item.name, slot))

    -- The branch useSlot will really take
    local branch
    if item.metadata and item.metadata.container then branch = 'container -> opens a container'
    elseif data.export then branch = 'data.export -> calls an external export'
    elseif data.client and data.client.event then branch = ('client.event -> emits "%s"'):format(tostring(data.client.event))
    elseif data.effect then branch = 'data.effect -> internal function'
    elseif data.weapon then branch = 'weapon -> equips a weapon'
    elseif data.ammo then branch = 'ammo -> load into weapon'
    else branch = '^2useItem -> calls the server (this is what we want)^7' end

    print('   branch : ' .. branch)
    print(('   flags  : consume=%s close=%s allowArmed=%s weapon=%s ammo=%s')
        :format(tostring(data.consume), tostring(data.close), tostring(data.allowArmed),
            tostring(data.weapon), tostring(data.ammo)))

    -- * delay=false cancels the repeat guard, so the call is not ignored silently
    print('   calling the server directly...')

    local ok, result = pcall(function()
        return lib.callback.await('w_inventory:useItem', false, item.name, slot, item.metadata, true)
    end)

    if not ok then
        print('^1   server error: ^7' .. tostring(result))
    else
        print(('%s   server replied: %s')
            :format(result and '^2' or '^1', tostring(result)))
        print('^7   (check the server console - w_hud lines explain what happened)')
    end

    print('^3════════════════════════════════════════════════════^0')
end, false)

