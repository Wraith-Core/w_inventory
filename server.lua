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

			right.coords = not ignoreSecurityChecks and GetEntityCoords(right.player.ped) or nil
		end

		if not ignoreSecurityChecks and right.coords then
			closestCoords = getClosestStashCoords(left.player.ped, right.coords)

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

-- command help comes from the dictionary (server language = the w_lib:locale convar)
lib.addCommand({'additem', 'giveitem'}, {
	help = locale('cmd_additem'),
	params = {
		{ name = 'target', type = 'playerId', help = locale('cmd_arg_target_receive') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_give'), optional = true },
		{ name = 'type', help = locale('cmd_arg_type_set'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item then
		local inventory = Inventory(args.target) --[[@as WInventory]]
		local count = args.count or 1
		local success, response = Inventory.AddItem(inventory, item.name, count, args.type and { type = tonumber(args.type) or args.type })

		if not success then
			return Citizen.Trace(('Failed to give %sx %s to player %s (%s)'):format(count, item.name, args.target, response))
		end

		source = Inventory(source) or { label = 'console', owner = 'console' }

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" gave %sx %s to "%s"'):format(source.label, count, item.name, inventory.label))
		end
	end
end)

lib.addCommand('removeitem', {
	help = locale('cmd_removeitem'),
	params = {
		{ name = 'target', type = 'playerId', help = locale('cmd_arg_target_remove') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_take') },
		{ name = 'type', help = locale('cmd_arg_type_match'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item and args.count > 0 then
		local inventory = Inventory(args.target) --[[@as WInventory]]
		local success, response = Inventory.RemoveItem(inventory, item.name, args.count, args.type and { type = tonumber(args.type) or args.type }, nil, true)

		if not success then
			return Citizen.Trace(('Failed to remove %sx %s from player %s (%s)'):format(args.count, item.name, args.target, response))
		end

		source = Inventory(source) or {label = 'console', owner = 'console'}

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" removed %sx %s from "%s"'):format(source.label, args.count, item.name, inventory.label))
		end
	end
end)

lib.addCommand('setitem', {
	help = locale('cmd_setitem'),
	params = {
		{ name = 'target', type = 'playerId', help = locale('cmd_arg_target_set') },
		{ name = 'item', type = 'string', help = locale('cmd_arg_item') },
		{ name = 'count', type = 'number', help = locale('cmd_arg_count_set'), optional = true },
		{ name = 'type', help = locale('cmd_arg_type_setitem'), optional = true },
	},
	restricted = 'group.admin',
}, function(source, args)
	local item = Items(args.item)

	if item then
		local inventory = Inventory(args.target) --[[@as WInventory]]
		local success, response = Inventory.SetItem(inventory, item.name, args.count or 0, args.type and { type = tonumber(args.type) or args.type })

		if not success then
			return Citizen.Trace(('Failed to set %s count to %sx for player %s (%s)'):format(item.name, args.count, args.target, response))
		end

		source = Inventory(source) or {label = 'console', owner = 'console'}

		if server.loglevel > 0 then
			lib.logger(source.owner, 'admin', ('"%s" set "%s" %s count to %sx'):format(source.label, inventory.label, item.name, args.count))
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

lib.addCommand('takeinv', {
	help = locale('cmd_takeinv'),
	params = {
		{ name = 'target', type = 'playerId', help = locale('cmd_arg_target_confiscate') },
	},
	restricted = 'group.admin',
}, function(source, args)
	Inventory.Confiscate(args.target)
end)

lib.addCommand({'restoreinv', 'returninv'}, {
	help = locale('cmd_restoreinv'),
	params = {
		{ name = 'target', type = 'playerId', help = locale('cmd_arg_target_restore') },
	},
	restricted = 'group.admin',
}, function(source, args)
	Inventory.Return(args.target)
end)

lib.addCommand('clearinv', {
	help = locale('cmd_clearinv'),
	params = {
		{ name = 'invId', help = locale('cmd_arg_inv_wipe') },
	},
	restricted = 'group.admin',
}, function(source, args)
	Inventory.Clear(tonumber(args.invId) or args.invId == 'me' and source or args.invId)
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
	Inventory.InspectInventory(source, tonumber(args.invId) or args.invId)
end)
