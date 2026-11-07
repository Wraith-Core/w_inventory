if not lib then return end

-- Commercial builds do not query an unrelated upstream repository. A seller
-- may opt into update checks by setting their own "w_inventory:versionRepository".
local versionRepository = GetConvar('w_inventory:versionRepository', '')
if versionRepository ~= '' and GetConvar('inventory:versioncheck', 'true') == 'true' then
	lib.versionCheck(versionRepository)
end

require 'modules.bridge.server'

local TriggerEventHooks = require 'modules.hooks.server'
local db = require 'modules.mysql.server'
local Items = require 'modules.items.server'
local Inventory = require 'modules.inventory.server'
local Losses = require 'modules.losses.server'
db.setInventoryResolver(Inventory.GetPersistenceInventories)

require 'modules.crafting.server'
require 'modules.shops.server'

-- The one-time framework data importer (setup/import_framework.lua) is a manual tool and is not loaded here.

---@param player table
---@param data table?
--- player requires source, identifier, and name
--- optionally, it should contain jobs/groups, sex, and dateofbirth
local function initializePlayerInventory(player, data)
    local catalogDeadline = GetGameTimer() + 15000
    while not shared.ready do
        assert(GetGameTimer() < catalogDeadline, 'Native item catalog did not become ready; inventory load cancelled')
        Wait(0)
    end

    -- Finish a prior session before reading SQL, so a delayed disconnect save
    -- cannot overwrite the snapshot we are about to install.
    for _, previous in pairs(Inventory.GetPersistenceInventories()) do
        if previous.player and (previous.id == tonumber(player.source) or tostring(previous.owner) == tostring(player.identifier)) then
            if previous.id == tonumber(player.source) and tostring(previous.owner) == tostring(player.identifier) then return previous end
            if previous.id ~= tonumber(player.source) and GetPlayerEndpoint(previous.id) then
                error('Character already has an active inventory session')
            end
            assert(Inventory.Remove(previous), 'Previous inventory save failed; character load cancelled')
        end
    end
	if not data then
		data = db.loadPlayer(player.identifier)
	end

	-- story-only weapons (data/story_only_weapons.lua) are no longer items: they leave the bag here
	-- and the bag is saved without them (inv.changed below)
	local storyStripped
	data, storyStripped = Inventory.StripStoryOnly(data, ('the bag of %s'):format(tostring(player.identifier)))

	-- Cash is a UI/account proxy, never part of native item storage.
    if server.nativeCashBalance then
        local nativeRows = {}
        for _, row in pairs(data or {}) do
            if row.name ~= 'money' and row.name ~= 'gold' then nativeRows[#nativeRows + 1] = row end
        end
        local occupied = {}
        for _, row in ipairs(nativeRows) do occupied[tonumber(row.slot)] = true end
        local slot = 1
        while occupied[slot] do slot = slot + 1 end
        local cash = server.nativeCashBalance(tonumber(player.source))
        assert(cash ~= nil, 'Native character cash is not ready; inventory was not loaded')
        if cash > 0 then
            nativeRows[#nativeRows + 1] = { name = 'money', count = cash, slot = slot, metadata = {} }
        end
        data = nativeRows
    end
    local inventory = {}
	local totalWeight = 0

	if type(data) == 'table' then
		local ostime = os.time()

		for _, v in pairs(data) do
			if type(v) == 'number' or not v.count or not v.slot then
				if server.convertInventory then
					inventory, totalWeight = server.convertInventory(player.source, data)
					break
				else
					return error(('Inventory for player.%s (%s) contains invalid data. Ensure you have converted inventories to the correct format.'):format(player.source, GetPlayerName(player.source)))
				end
			else
				local item = Items(v.name)
				if not item then
                    error(('Native inventory definition missing for %s; character %s was not loaded or saved'):format(tostring(v.name), tostring(player.identifier)))
                end

				if item then
					v.metadata = Items.CheckMetadata(v.metadata or {}, item, v.name, ostime)
					local weight = Inventory.SlotWeight(item, v)
					totalWeight = totalWeight + weight

					local used = v.metadata.used == true or v.metadata.used == 1 or v.metadata.used == '1'
					local used2 = used and (v.metadata.used2 == true or v.metadata.used2 == 1 or v.metadata.used2 == '1') or false
					inventory[v.slot] = {
						name = item.name, label = item.label, weight = weight, slot = v.slot,
						count = v.count, description = item.description, metadata = v.metadata,
						stack = item.stack, close = item.close, used = used, used2 = used2
					}
				end
			end
		end
	end

	player.source = tonumber(player.source)
    local slots, maxWeight = shared.playerslots, shared.playerweight
    if server.inventoryLimits then slots, maxWeight = server.inventoryLimits(player.source) end
    for slot in pairs(inventory) do slots = math.max(slots, tonumber(slot) or 0) end
    local inv = Inventory.Create(player.source, player.name, 'player', slots, totalWeight, maxWeight, player.identifier, inventory)

	if inv then
		-- RSG: the players row (players.id) the bag belongs to. w_core may move the character to
		-- another number and hand the old one to someone else; the bag's saves name this row, so one
		-- still on its way never lands on the next holder (db.savePlayer)
		inv.ownerRow = shared.framework == 'rsg' and tonumber(player.id) or nil
		inv.player = server.setPlayerData(player)
		inv.player.ped = GetPlayerPed(player.source)
        inv.player.slots, inv.player.maxWeight = inv.slots, inv.maxWeight
        inv.nativeCashObserved = server.nativeCashBalance and Inventory.GetItemCount(inv, 'money') or nil
		if shared.framework ~= 'rsg' then
		Inventory.EnsureWeaponIdentities(inv, true)

		if Config.RestoreUsedWeapons == false then
			Inventory.SetWeaponUsageState(inv, {}, false, true)
		else
			Inventory.RebuildWeaponUsage(inv, true)
		end
		end

		if server.syncInventory then server.syncInventory(inv) end
		TriggerClientEvent('w_inventory:setPlayerInventory', player.source, Inventory.Drops, inventory, totalWeight, inv.player)

		if storyStripped > 0 then
			inv.changed = true
			TriggerClientEvent('w_inventory:notify', player.source, { type = 'inform', key = 'story_weapons_removed', args = { storyStripped } })
		end
	end
end
server.nativeOfflineLocks = {}
server.nativeLoadingOwners = {}
function server.setPlayerInventory(player, data)
    local owner = tostring(player.identifier)
    while server.nativeOfflineLocks[owner] do Wait(0) end
    if server.nativeLoadingOwners[owner] then return end
    server.nativeLoadingOwners[owner] = true
    local ok, result = xpcall(initializePlayerInventory, debug.traceback, player, data)
    server.nativeLoadingOwners[owner] = nil
    if not ok then error(result, 0) end
    return result
end
require 'modules.inventory.native_offline'
exports('setPlayerInventory', server.setPlayerInventory)
AddEventHandler('w_inventory:setPlayerInventory', server.setPlayerInventory)

---@param playerPed number
---@param coordinates vector3|vector3[]
---@param distance? number
---@return vector3|false
local function getClosestStashCoords(playerPed, coordinates, distance)
	local playerCoords = GetEntityCoords(playerPed)

	if not distance then distance = 10 end

	if type(coordinates) == 'table' then
		for i = 1, #coordinates do
			local coords = coordinates[i] --[[@as vector3]]

			if #(coords - playerCoords) < distance then
				return coords
			end
		end

		return false
	end

	return #(coordinates - playerCoords) < distance and coordinates
end

---@param source number
---@param invType string
---@param data? string|number|table
---@param ignoreSecurityChecks boolean?
---@return boolean|table|nil
---@return table?
--- May `left` go through the pockets of player `target`? A lawman may. Anyone else only while that
--- man is down or cuffed (the core's flags, kept on the server) or holds his hands up (his own
--- client's word, w_lib essentials -- his consent, so it is his to give).
---@param left table the searcher's inventory
---@param target number the searched player's server id
---@return boolean
local function canSearchPlayer(left, target)
	if server.hasGroup(left, shared.police) then return true end
	local ok, char = pcall(function() return exports.w_lib:FwGetCharacter(target) end)
	local meta = ok and type(char) == 'table' and (type(char.metadata) == 'table' and char.metadata or char) or {}
	if meta.isdead == true or meta.inlaststand == true or meta.ishandcuffed == true then return true end
	local state = Player(target).state
	return state.handsUp == true or state.isHandcuffed == true
end

--- May this client open a horse's saddlebag ('glove<horse id>') or a wagon's storage ('trunk<wagon
--- id>', 'trunktemp:<net id>') through this net id? The net id must be the animal or wagon w_stables
--- spawned for that very id (exports.w_stables:StorageNetIds -- never its state bags, which the
--- owning client can write) and stand within reach. Until 2026-10-14 any id opened with any net id:
--- every stabled horse and wagon could be emptied from anywhere by counting through the ids.
--- Checked twice in openInventory: before a storage is loaded through a net id, and on the resolved
--- inventory whatever the route (an id with no net id reaches an already loaded storage too).
---@param source number
---@param id any the inventory id
---@param netid any the net id the client sent (nil = none)
---@param invType string 'glovebox' | 'trunk' (the id's kind must agree with it)
---@return boolean
local function vehicleStorageAllowed(source, id, netid, invType)
	netid = tonumber(netid)
	if not netid then return false end
	id = tostring(id or '')
	local wantType = id:find('^glove') and 'glovebox' or id:find('^trunk') and 'trunk' or nil
	if not wantType or wantType ~= invType then return false end

	local entity = NetworkGetEntityFromNetworkId(netid)
	if not entity or entity == 0 or not DoesEntityExist(entity) then return false end
	local ped = GetPlayerPed(source)
	if not ped or ped == 0 or #(GetEntityCoords(entity) - GetEntityCoords(ped)) > 8.0 then return false end
	if GetEntityRoutingBucket(entity) ~= GetPlayerRoutingBucket(source) then return false end

	local temp = id:match('^trunktemp:(%d+)$')
	if temp then return tonumber(temp) == netid end

	local kind, key = id:match('^(glove)(%d+)$')
	if not kind then kind, key = id:match('^(trunk)(%d+)$') end
	if not kind or GetResourceState('w_stables') ~= 'started' then return false end
	local ok, ids = pcall(function() return exports.w_stables:StorageNetIds(kind, tonumber(key)) end)
	if not ok or type(ids) ~= 'table' then return false end
	for _, n in ipairs(ids) do
		if tonumber(n) == netid then return true end
	end
	return false
end

local function openInventory(source, invType, data, ignoreSecurityChecks)
	if Inventory.Lock then return false end

	local left = Inventory(source) --[[@as WInventory]]
	local right, closestCoords
	if not left or not left.player then return false end

    left:closeInventory(true)
	Inventory.CloseAll(left, source)

    if invType == 'player' and data == source then
        data = nil
    end

	if data then
        local isDataTable = type(data) == 'table'
		if invType == 'stash' then
			right = Inventory(data, left)
			if right == false then return false end
		elseif isDataTable then
			if data.netid then
				-- the id decides what it is (loadInventoryData reads 'glove' / 'trunk' from it), so the
				-- check keys on the id, not on the type the client claims
				local vid = tostring(data.id or '')
				if not ignoreSecurityChecks and (vid:find('^glove') or vid:find('^trunk'))
					and not vehicleStorageAllowed(source, vid, data.netid, invType) then return end
				data.type = invType
				right = Inventory(data)
			elseif invType == 'drop' then
				right = Inventory(data.id)
			else
				return
			end
		elseif invType == 'policeevidence' then
			if server.hasGroup(left, shared.police) then
				right = Inventory(('evidence-%s'):format(data))
			end
		elseif invType == 'container' then
			left.containerSlot = data --[[@as number]]
			data = left.items[data]

			if data then
				right = Inventory(data.metadata.container)

				if not right then
					right = Inventory.Create(data.metadata.container, data.label, invType, data.metadata.size[1], 0, data.metadata.size[2], false)
				end
			else left.containerSlot = nil end
		else right = Inventory(data) end

		if not right then return end

		-- ★ Whatever the route ('stash' with the id, no type with a net id...), a saddlebag or a wagon's
		--   storage opens only through its own animal or wagon, within reach (vehicleStorageAllowed)
		if not ignoreSecurityChecks and (right.type == 'glovebox' or right.type == 'trunk')
			and not vehicleStorageAllowed(source, right.id, isDataTable and data.netid or nil, right.type) then return end

		if not ignoreSecurityChecks and right.groups and not server.hasGroup(left, right.groups) then return end

		local hookPayload = {
			source = source,
			inventoryId = right.id,
			inventoryType = right.type,
		}

		if invType == 'container' then hookPayload.slot = left.containerSlot end
		if isDataTable and data.netid then hookPayload.netId = data.netid end

		if not TriggerEventHooks('openInventory', hookPayload) then return end

        if left == right then return end

		if right.player then
			if right.open then return end

			-- ★ The search of a player: the searcher's client checks that the man is down, cuffed or
			--   holding his hands up (canOpenTarget in client.lua), and the server took its word -- any
			--   player standing within 10 m could be emptied. The server now checks it itself.
			if not ignoreSecurityChecks and not canSearchPlayer(left, right.id) then return end

			local targetPed = GetPlayerPed(right.id)
			if not targetPed or targetPed == 0 then targetPed = right.player.ped end
			right.coords = not ignoreSecurityChecks and GetEntityCoords(targetPed) or nil
		end

		if not ignoreSecurityChecks and right.coords then
			-- a man is searched at arm's length (the client asks 1.8 m), a stash from its own reach
			closestCoords = getClosestStashCoords(left.player.ped, right.coords, right.player and 4.0 or nil)

			if not closestCoords then return end
		end

		left:openInventory(right)
	else
		left:openInventory(left)
	end

	-- Account currency (cash + gold) — framework-agnostic via w_lib (VORP char.money/char.gold,
	-- RSG cash/bloodmoney). Was rsg-core-only, which returned 0/0 on a VORP server and zeroed the
	-- money/gold display on every inventory open.
	local playerGold, playerCash = 0, 0
	if GetResourceState('w_lib') == 'started' then
		local okc, c = pcall(function() return exports.w_lib:FwGetMoney(source) end)
		local okg, g = pcall(function() return exports.w_lib:FwGetGold(source) end)
		playerCash = (okc and tonumber(c)) or 0
		playerGold = (okg and tonumber(g)) or 0
	end
	-- Sending the balance update event to the client the moment the bag/the stash is opened, to guarantee the freshest numbers are shown
	TriggerClientEvent('w_inventory:updateCurrency', source, playerCash, playerGold)

	return {
		id = left.id,
		label = left.label,
		type = left.type,
		slots = left.slots,
		weight = left.weight,
		maxWeight = left.maxWeight,
		playerGold = playerGold,
		playerCash = playerCash,
	}, right and {
		id = right.id,
		label = right.player and '' or right.label,
		type = right.player and 'otherplayer' or right.type,
		slots = right.slots,
		weight = right.weight,
		maxWeight = right.maxWeight,
		items = right.items,
		coords = closestCoords or right.coords,
		distance = right.distance
	}
end

---@param source number
---@param invType string
---@param data string|number|table
lib.callback.register('w_inventory:openInventory', function(source, invType, data)
	return openInventory(source, invType, data)
end)

lib.callback.register('w_inventory:getCurrency', function(source)
	local cash, gold = 0, 0

	if GetResourceState('w_lib') == 'started' then
		local cashOk, cashValue = pcall(function() return exports.w_lib:FwGetMoney(source) end)
		local goldOk, goldValue = pcall(function() return exports.w_lib:FwGetGold(source) end)
		cash = cashOk and tonumber(cashValue) or 0
		gold = goldOk and tonumber(goldValue) or 0
	end

	return cash, gold
end)

---@param playerId number
---@param invType string
---@param data string|number|table
exports('forceOpenInventory', function(playerId, invType, data)
	local left, right = openInventory(playerId, invType, data, true)

	if left and right then
		TriggerClientEvent('w_inventory:forceOpenInventory', playerId, left, right)
		return right.id
	end
end)

RegisterNetEvent('rsg-horses:server:openhorseinventory')
AddEventHandler('rsg-horses:server:openhorseinventory', function()
    local src = source
    -- ★ RSG's own horse script only: on this server w_stables owns the horses and their saddlebags,
    --   and nothing sends this event. Left open it registered 'horse_stash_<server id>' with no
    --   owner -- a stash anyone could open by guessing the id, and that passed to whoever held the
    --   same server id after a restart.
    if GetResourceState('w_stables') ~= 'missing' then return end
    -- A player having a stock means he is loaded, with no tie to a particular framework
    if not Inventory(src) then return end

    -- Define stash details
    local stashName = 'horse_stash_' .. src
    local label = 'horse_trunk_storage' -- dictionary key: the client translates it
    local maxWeight = 20000
    local maxSlots = 10

    -- Register the stash with w_inventory
    exports.w_inventory:RegisterStash(stashName, label, maxSlots, maxWeight)

    -- Open the stash for the player
    TriggerClientEvent('w_inventory:openInventory', src, 'stash', stashName)
end)

-- ============================================================
-- The RDR3 components catalogue on the server
-- It is needed here too because checking a component's validity is an authoritative decision
-- ============================================================
do
	local WeaponComponents = lib.load('data.weapon_components_RDR3')

	--- The component slots available for a weapon, like BARREL_ENGRAVING and GRIPSTOCK_TINT
	exports('GetWeaponComponents', function(weaponName)
		return WeaponComponents.GetComponents(weaponName)
	end)

	--- Checking that a component really belongs to this weapon
	exports('IsWeaponComponentValid', function(weaponName, component)
		return WeaponComponents.IsValid(weaponName, component)
	end)

	--- The slot a component belongs to, to replace the old part when fitting
	exports('GetWeaponComponentCategory', function(weaponName, component)
		for category, list in pairs(WeaponComponents.GetComponents(weaponName)) do
			for i = 1, #list do
				if list[i] == component then return category end
			end
		end
	end)
end

lib.callback.register('w_inventory:getItemCount', function(source, item, metadata, target)
	local inventory = target and Inventory(target) or Inventory(source)
	return (inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0
end)

-- The caller's own slot (modules/weapon/client.lua falls back to it when PlayerData is not loaded yet).
-- An unregistered name is answered with 'cb_invalid' by w_lib and the awaiting thread errors.
lib.callback.register('w_inventory:getItemBySlot', function(source, slot)
	local inventory = Inventory(source)
	slot = tonumber(slot)
	return inventory and slot and inventory.items[slot] or nil
end)

lib.callback.register('w_inventory:getInventory', function(source, id)
	local inventory = Inventory(id or source)
	return inventory and {
		id = inventory.id,
		label = inventory.label,
		type = inventory.type,
		slots = inventory.slots,
		weight = inventory.weight,
		maxWeight = inventory.maxWeight,
		owned = inventory.owner and true or false,
		items = inventory.items
	}
end)

RegisterNetEvent('w_inventory:usedItemInternal', function(slot)
    local inventory = Inventory(source)

    if not inventory then return end

    local item = inventory.usingItem

    if not item or item.slot ~= slot then
        ---@todo
        DropPlayer(inventory.id, 'sussy')

        return
    end

    TriggerEvent('w_inventory:usedItem', inventory.id, item.name, item.slot, next(item.metadata) and item.metadata)

    inventory.usingItem = nil
end)

---@param source number
---@param itemName string
---@param slot number?
---@param metadata { [string]: any }?
---@return table | boolean | nil
lib.callback.register('w_inventory:useItem', function(source, itemName, slot, metadata, noAnim)
	local inventory = Inventory(source) --[[@as WInventory]]

	if inventory.player then
		local item = Items(itemName)
		local data = item and (slot and inventory.items[slot] or Inventory.GetSlotWithItem(inventory, item.name, metadata, true))

		if not data then return end

		slot = data.slot
		local durability = data.metadata.durability --[[@as number|boolean|nil]]
		local consume = item.consume
		local label = data.metadata.label or item.label
		-- for the notifications: a custom label as it is, a catalogue item by name so the
		-- client shows its label in the player's language
		local labelArg = data.metadata.label or { item = item.name }

		if durability and consume then
			if durability > 100 then
				local ostime = os.time()

				if ostime > durability then
                    Items.UpdateDurability(inventory, data, item, 0)
					return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'no_durability', args = { labelArg } })
				elseif consume ~= 0 and consume < 1 then
					local degrade = (data.metadata.degrade or item.degrade) * 60
					local percentage = ((durability - ostime) * 100) / degrade

					if percentage < consume * 100 then
						return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'not_enough_durability', args = { labelArg } })
					end
				end
			elseif durability <= 0 then
				return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'no_durability', args = { labelArg } })
			elseif consume ~= 0 and consume < 1 and durability < consume * 100 then
				return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'not_enough_durability', args = { labelArg } })
			end

			if data.count > 1 and consume < 1 and consume > 0 and not Inventory.GetEmptySlot(inventory) then
				return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'cannot_use', args = { labelArg } })
			end
		end

		if item and data and data.count > 0 and data.name == item.name then
			data = {name=data.name, label=label, count=data.count, slot=slot, metadata=data.metadata, weight=data.weight}

			if item.ammo then
				if inventory.weapon then
					local weapon = inventory.items[inventory.weapon]

					if weapon and (weapon.metadata and weapon.metadata.durability or 0) > 0 then
						consume = nil
					end
				else return false end
			elseif consume then
				if data.count >= consume then
					local result = item.cb and item.cb('usingItem', item, inventory, slot)

					if result == false then return end

					if result ~= nil then
						data.server = result
					end
				else
					return TriggerClientEvent('w_inventory:notify', source, { type = 'error', key = 'item_not_enough', args = { { item = item.name } } })
				end
			elseif not item.weapon and server.UseItem then
                inventory.usingItem = data
				-- The usable-item registry of the bridge (RegisterUsableItem) and the framework's own
				-- item callbacks. A registered callback that errors is caught so the bag stays usable.
				return pcall(server.UseItem, source, data.name, data)
			end

			data.consume = consume

            ---@type boolean
			local success = lib.callback.await('w_inventory:usingItem', source, data, noAnim)

			if item.weapon then
				inventory.weapon = success and slot or nil
			end

			if not success then return end

            inventory.usingItem = data

			if consume and consume ~= 0 then
				data = inventory.items[data.slot]

				if not data then return end

				durability = consume ~= 0 and consume < 1 and data.metadata.durability --[[@as number | false]]

				if durability then
					if durability > 100 then
						local degrade = (data.metadata.degrade or item.degrade) * 60
						durability -= degrade * consume
					else
						durability -= consume * 100
					end

					if data.count > 1 then
						local emptySlot = Inventory.GetEmptySlot(inventory)

						if emptySlot then
							local newItem = Inventory.SetSlot(inventory, item, 1, table.deepclone(data.metadata), emptySlot)

							if newItem then
                                Items.UpdateDurability(inventory, newItem, item, durability)
							end
						end

						durability = 0
					else
                        Items.UpdateDurability(inventory, data, item, durability)
					end

					if durability <= 0 then
						durability = false
					end
				end

				if not durability then
					Losses.reason('used', Losses.actor(inventory), 'self')
					Inventory.RemoveItem(inventory.id, data.name, consume < 1 and 1 or consume, nil, data.slot)
				else
					inventory.changed = true

					if server.syncInventory then server.syncInventory(inventory) end
				end

				if item?.cb then
					item.cb('usedItem', item, inventory, data.slot)
				end
			end

			return true
		end
	end
end)

-- ── admin commands on a player: the citizen id ──────────────────────────────
-- Staff name a player by his citizen id (players.citizenid: '12', a vanity '777', an old
-- 'OMG95204'), the one id that never changes; '#5' still names server id 5 on purpose and 'me'
-- the admin himself. A server id changes on every connection and, since the citizen id is plain
-- digits, the two collided: "/giveitem 12 bread" fed whoever held server id 12, or nobody.
-- w.citizen says who the id is and whether he is in play: in play, his live bag (as before);
-- offline, his saved bag through the library's offline inventory API (w_admin's path too).
-- The target argument carries no `type`: lib.addCommand's 'playerId' answers only a player in the
-- game (it refuses an offline citizen before the handler runs), and its 'string' refuses anything
-- tonumber() accepts, which is every citizen id.

--- A message for the admin who ran the command (already in his language), or the console.
---@param source integer
---@param text string
---@param kind? 'error' | 'success' | 'inform'
local function reply(source, text, kind)
	if source and source > 0 then
		TriggerClientEvent('w_inventory:notify', source, { type = kind or 'inform', description = text })
	else
		print(('[w_inventory] %s'):format(text))
	end
end

--- A dictionary message: the admin's client translates it, the console reads the server language.
---@param source integer
---@param kind 'error' | 'success' | 'inform'
---@param key string
local function say(source, kind, key, ...)
	if source and source > 0 then
		TriggerClientEvent('w_inventory:notify', source, { type = kind, key = key, args = { ... } })
	else
		print(('[w_inventory] %s'):format(locale(key, ...)))
	end
end

--- The player a command names, or nil after telling the admin why not.
---@param source integer
---@param value string the id as typed
---@param inPlay? boolean the command needs him in the game
---@return table|nil target (w.citizen target: citizenid, source when online, online, name)
local function commandTarget(source, value, inPlay)
	local target, reason, offline
	if inPlay then
		target, reason, offline = w.citizen.requireOnline(value, { self = source })
	else
		target, reason = w.citizen.resolve(value, { self = source })
	end
	if target then return target end
	local text = w.citizen.reasonText(reason, source > 0 and source or nil)
	if offline then text = ('%s: %s'):format(w.citizen.label(offline), text) end
	reply(source, text, 'error')
end

--- The live bag of a player in play (nil, after telling the admin, while it is not loaded yet).
---@param source integer
---@param target table
---@return WInventory|nil
local function liveInventory(source, target)
	local inventory = Inventory(target.source)
	if inventory and inventory.player then return inventory --[[@as WInventory]] end
	reply(source, w.citizen.reasonText('not_found', source > 0 and source or nil), 'error')
end

--- Who ran the command, for the log.
local function adminOf(source)
	return Inventory(source) or { label = 'console', owner = 'console' }
end

--- How many of an item an offline character holds, from his saved bag; nil when the bag could not
--- be read. A failed read is not 0: /setitem would then add the whole count on top of what he has.
---@param citizenid string
---@param item table
---@return integer|nil
---@return string|nil why
local function offlineCount(citizenid, item)
	local ok, items, weapons = pcall(function() return exports.w_lib:FwGetOfflineInventory(citizenid) end)
	if not ok then return nil, tostring(items) end
	if type(items) ~= 'table' then return nil, 'failed' end
	-- the rows carry the framework's own name (nativeName) where it differs from ours
	local names = { [item.name:lower()] = true }
	if type(item.nativeName) == 'string' then names[item.nativeName:lower()] = true end
	local total = 0
	for _, list in ipairs({ items or {}, weapons or {} }) do
		for _, row in pairs(list) do
			if type(row) == 'table' and type(row.name) == 'string' and names[row.name:lower()] then
				total += tonumber(row.count) or 0
			end
		end
	end
	return math.floor(total)
end

--- Change an offline character's saved bag: count > 0 adds, count < 0 removes. Tells the admin
--- and writes the log line; true when the bag was changed.
---@param source integer
---@param target table
---@param item table
---@param count integer
---@return boolean
local function changeOfflineBag(source, target, item, count)
	if count == 0 then return true end
	local fn = count > 0 and 'FwAddItemOffline' or 'FwRemoveItemOffline'
	local called, ok, err = pcall(function() return exports.w_lib[fn](exports.w_lib, target.citizenid, item.name, math.abs(count)) end)
	if not called or not ok then
		-- the bridge's own reason ('Item not found', 'Character is online', ...) or the error
		local why = called and (err or 'failed') or ok
		say(source, 'error', 'cmd_offline_failed', w.citizen.label(target), tostring(why))
		return false
	end
	say(source, 'success', 'cmd_offline_done', w.citizen.label(target))
	if server.loglevel > 0 then
		local admin = adminOf(source)
		lib.logger(admin.owner, 'admin', ('"%s" %s %sx %s %s "%s" (offline)'):format(admin.label,
			count > 0 and 'gave' or 'removed', math.abs(count), item.name, count > 0 and 'to' or 'from', w.citizen.label(target)))
	end
	return true
end

-- command help comes from the dictionary (server language = the w_lib:locale convar)
lib.addCommand({'additem', 'giveitem'}, {
	help = locale('cmd_additem'),
	params = {
		{ name = 'target', help = locale('cmd_arg_target_receive') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_give'), optional = true },
		{ name = 'type', help = locale('cmd_arg_type_set'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item then
		local target = commandTarget(source, args.target)
		if not target then return end
		local count = args.count or 1

		if not target.online then
			-- a saved bag has no metadata filter: the "type" is set on a live item only
			if args.type then return say(source, 'error', 'cmd_offline_type') end
			-- rounded as the live AddItem does. A count below 1 is refused: the signed change below
			-- would turn "/giveitem 777 bread -5" into taking five away
			local amount = math.floor(count + 0.5)
			if amount < 1 then return say(source, 'error', 'ui_invalid_amount') end
			return changeOfflineBag(source, target, item, amount)
		end

		local inventory = liveInventory(source, target)
		if not inventory then return end
		local success, response = Inventory.AddItem(inventory, item.name, count, args.type and { type = tonumber(args.type) or args.type })

		if not success then
			return Citizen.Trace(('Failed to give %sx %s to player %s (%s)'):format(count, item.name, w.citizen.label(target), response))
		end

		source = adminOf(source)

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" gave %sx %s to "%s"'):format(source.label, count, item.name, w.citizen.label(target)))
		end
	end
end)

lib.addCommand('removeitem', {
	help = locale('cmd_removeitem'),
	params = {
		{ name = 'target', help = locale('cmd_arg_target_remove') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_take') },
		{ name = 'type', help = locale('cmd_arg_type_match'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item and args.count > 0 then
		local target = commandTarget(source, args.target)
		if not target then return end

		if not target.online then
			if args.type then return say(source, 'error', 'cmd_offline_type') end
			-- a fraction that rounds to nothing is told, not "done" with nothing taken
			local amount = math.floor(args.count + 0.5)
			if amount < 1 then return say(source, 'error', 'ui_invalid_amount') end
			return changeOfflineBag(source, target, item, -amount)
		end

		local inventory = liveInventory(source, target)
		if not inventory then return end
		Losses.reason('admin', source > 0 and Losses.actor(Inventory(source)) or 'console', 'command')
		local success, response = Inventory.RemoveItem(inventory, item.name, args.count, args.type and { type = tonumber(args.type) or args.type }, nil, true)

		if not success then
			return Citizen.Trace(('Failed to remove %sx %s from player %s (%s)'):format(args.count, item.name, w.citizen.label(target), response))
		end

		source = adminOf(source)

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" removed %sx %s from "%s"'):format(source.label, args.count, item.name, w.citizen.label(target)))
		end
	end
end)

lib.addCommand('setitem', {
	help = locale('cmd_setitem'),
	params = {
		{ name = 'target', help = locale('cmd_arg_target_set') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_set'), optional = true },
		{ name = 'type', help = locale('cmd_arg_type_setitem'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item then
		local target = commandTarget(source, args.target)
		if not target then return end

		if not target.online then
			if args.type then return say(source, 'error', 'cmd_offline_type') end
			local want = math.max(0, math.floor(args.count or 0))
			local have, why = offlineCount(target.citizenid, item)
			if not have then
				return say(source, 'error', 'cmd_offline_unreadable', w.citizen.label(target), tostring(why))
			end
			return changeOfflineBag(source, target, item, want - have)
		end

		local inventory = liveInventory(source, target)
		if not inventory then return end
		local success, response = Inventory.SetItem(inventory, item.name, args.count or 0, args.type and { type = tonumber(args.type) or args.type })

		if not success then
			return Citizen.Trace(('Failed to set %s count to %sx for player %s (%s)'):format(item.name, args.count, w.citizen.label(target), response))
		end

		source = adminOf(source)

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" set "%s" %s count to %sx'):format(source.label, w.citizen.label(target), item.name, args.count))
		end
	end
end)

lib.addCommand('clearevidence', {
	help = locale('cmd_clearevidence'),
	params = {
		{ name = 'locker', type = 'number', help = locale('cmd_arg_locker') },
	},
}, function(source, args)
	if not server.isPlayerBoss then return end

	local inventory = Inventory(source)
	local group, grade = server.hasGroup(inventory, shared.police)
	local hasPermission = group and server.isPlayerBoss(source, group, grade)

    if hasPermission then
        local name = ('evidence-%s'):format(args.locker)
        if shared.framework == 'vorp' or shared.framework == 'rsg' then
            local evidence = Inventory(name)
            if not evidence then return end
            Inventory.Clear(evidence)
            return Inventory.Save(evidence)
        end
        MySQL.query('DELETE FROM w_inventory WHERE name = ?', { name })
    end
end)

-- Confiscation moves the live bag into custody and back, and the player's client closes and
-- redraws it: he has to be in play. An offline character is refused by name.
lib.addCommand('takeinv', {
	help = locale('cmd_takeinv'),
	params = {
		{ name = 'target', help = locale('cmd_arg_target_confiscate') },
	},
	restricted = 'group.admin',
}, function(source, args)
	local target = commandTarget(source, args.target, true)
	if target then Inventory.Confiscate(target.source) end
end)

lib.addCommand({'restoreinv', 'returninv'}, {
	help = locale('cmd_restoreinv'),
	params = {
		{ name = 'target', help = locale('cmd_arg_target_restore') },
	},
	restricted = 'group.admin',
}, function(source, args)
	local target = commandTarget(source, args.target, true)
	if target then Inventory.Return(target.source) end
end)

--- /clearinv and /viewinv take a player or any other inventory (a stash, 'glove12', 'evidence-3').
--- A citizen id, '#5' and 'me' name a player; any other text is an inventory id. A stash whose
--- name also reads as a citizen id ('12', 'ABC12345') is still found by that name when no
--- character holds it. Before, any number was a server id: a citizen id hit another player.
---@param source integer
---@param value string
---@return table|nil target a player (w.citizen target)
---@return string|nil inventoryId any other inventory
local function inventoryArg(source, value)
	value = tostring(value or '')
	local kind = w.citizen.parse(value)
	if not kind then return nil, value end
	local target, reason = w.citizen.resolve(value, { self = source })
	if target then return target end
	if kind == 'citizen' and reason == 'not_found' and Inventory(value) then return nil, value end
	reply(source, w.citizen.reasonText(reason, source > 0 and source or nil), 'error')
end

lib.addCommand('clearinv', {
	help = locale('cmd_clearinv'),
	params = {
		{ name = 'invId', help = locale('cmd_arg_inv_wipe') },
	},
	restricted = 'group.admin',
}, function(source, args)
	local target, invId = inventoryArg(source, args.invId)
	if invId then return Inventory.Clear(invId) end
	if not target then return end
	if target.online then return Inventory.Clear(target.source) end

	-- offline: his saved bag is emptied in one write (native_offline.lua, action 'clear')
	local called, ok, err = pcall(function()
		return exports.w_inventory:MutateNativeOfflineInventory(target.citizenid, 'clear')
	end)
	if not called or not ok then
		local why = called and (err or 'failed') or ok
		return say(source, 'error', 'cmd_offline_failed', w.citizen.label(target), tostring(why))
	end
	say(source, 'success', 'cmd_offline_done', w.citizen.label(target))
	if server.loglevel > 0 then
		local admin = adminOf(source)
		lib.logger(admin.owner, 'admin', ('"%s" cleared the bag of "%s" (offline)'):format(admin.label, w.citizen.label(target)))
	end
end)

lib.addCommand('saveinv', {
	help = locale('cmd_saveinv'),
	params = {
		{ name = 'lock', help = locale('cmd_arg_lock'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	Inventory.SaveInventories(args.lock == 'true', false)
end)

lib.addCommand('viewinv', {
	help = locale('cmd_viewinv'),
	params = {
		{ name = 'invId', help = locale('cmd_arg_inv_inspect') },
	},
	restricted = 'group.admin',
}, function(source, args)
	local target, invId = inventoryArg(source, args.invId)
	if invId then return Inventory.InspectInventory(source, invId) end
	if not target then return end
	if target.online then return Inventory.InspectInventory(source, target.source) end

	-- offline: a read-only copy of his saved bag. Nothing is opened on the server, so the view
	-- cannot move an item (a swap needs an inventory the server has open for this admin).
	local viewer = Inventory(source)
	if not viewer or not viewer.player then return end
	-- a saved bag the codec refuses (a malformed row) raises: the admin is told, not left waiting
	local loaded, rows = pcall(db.loadPlayer, target.citizenid)
	if not loaded then
		return say(source, 'error', 'cmd_offline_unreadable', w.citizen.label(target), tostring(rows))
	end
	local items, weight = {}, 0
	for _, row in pairs(rows or {}) do
		local item = type(row) == 'table' and tonumber(row.slot) and Items(row.name)
		if item then
			local slotWeight = Inventory.SlotWeight(item, row)
			weight += slotWeight
			items[row.slot] = {
				name = item.name, label = item.label, weight = slotWeight, slot = row.slot, count = row.count,
				description = item.description, metadata = row.metadata or {}, stack = item.stack, close = item.close,
			}
		end
	end
	viewer:closeInventory(true)
	say(source, 'inform', 'cmd_offline_view', w.citizen.label(target))
	TriggerClientEvent('w_inventory:viewInventory', source, viewer, {
		id = ('offline:%s'):format(target.citizenid),
		label = w.citizen.label(target),
		type = 'inspect',
		slots = shared.playerslots,
		weight = weight,
		maxWeight = shared.playerweight,
		items = items,
	})
end)
