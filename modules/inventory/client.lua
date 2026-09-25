if not lib then return end

local Inventory = {}

local Utils = require 'modules.utils.client'

--- The saddlebag of a horse: the 'glovebox' inventory type, keyed by the horse's id in the
--- stables table (the horseUUID state bag w_stables sets on the ped).
---@param horse number
---@param horseUUID number | string
---@return boolean?
function Inventory.OpenSaddlebag(horse, horseUUID)
	if not horse or horse == 0 or not horseUUID or not DoesEntityExist(horse) or not NetworkGetEntityIsNetworked(horse) then return end

	local netId = NetworkGetNetworkIdFromEntity(horse)

	return client.openInventory('glovebox', { id = ('glove%s'):format(horseUUID), netid = netId })
end

--- The storage of a wagon: the 'trunk' inventory type. An owned wagon is keyed by the
--- wagonUUID state bag w_stables sets (its 'w_stables' tag id as the fallback), so the id
--- matches the owner's own ('trunk%d'):format(st.id); any other wagon gets a temporary store.
---@param entity number
---@return boolean?
function Inventory.OpenWagonStorage(entity)
	if not entity or entity == 0 or not DoesEntityExist(entity) or not NetworkGetEntityIsNetworked(entity) then return end

	local netId = NetworkGetNetworkIdFromEntity(entity)
	-- the id is floored to an integer: a float or string id would format a different container
	local stables = w.entity.getState(entity, 'w_stables')
	local wagonId = tonumber(w.entity.getState(entity, 'wagonUUID'))
		or (type(stables) == 'table' and stables.role == 'wagon' and tonumber(stables.id)) or nil
	if wagonId then wagonId = math.floor(wagonId) end
	local invId = ('trunk%s'):format(wagonId or ('temp:' .. netId))

	local coords = GetEntityCoords(entity)
	TaskTurnPedToFaceCoord(cache.ped, coords.x, coords.y, coords.z, 0)

	return client.openInventory('trunk', { id = invId, netid = netId, entityid = entity })
end

---@param search 'slots' | 1 | 'count' | 2
---@param item table | string
---@param metadata? table | string
function Inventory.Search(search, item, metadata)
	if not PlayerData.loaded then
		if not coroutine.running() then
			error('player inventory has not yet loaded.')
		end

		repeat Wait(100) until PlayerData.loaded
	end

	if item then
		if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end

		local items = #item
		local returnData = {}
		local firstKey
		for i = 1, items do
			local item = string.lower(item[i])
			if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
			local canonicalName = shared.resolveItemName(item)
			if i == 1 then firstKey = item end
			if search == 1 then returnData[item] = {}
			elseif search == 2 then returnData[item] = 0 end
			for _, v in pairs(PlayerData.inventory) do
				if v.name == canonicalName then
					if not v.metadata then v.metadata = {} end
					if not metadata or table.contains(v.metadata, metadata) then
						if search == 1 then returnData[item][#returnData[item]+1] = PlayerData.inventory[v.slot]
						elseif search == 2 then
							returnData[item] += v.count
						end
					end
				end
			end
		end
		if next(returnData) then return items == 1 and returnData[firstKey] or returnData end
	end
	return false
end
exports('Search', Inventory.Search)

exports('GetPlayerItems', function()
	return PlayerData.inventory
end)

exports('GetPlayerWeight', function()
	return PlayerData.weight
end)

exports('GetPlayerMaxWeight', function()
	return PlayerData.maxWeight
end)

local Items = require 'modules.items.client'

local function assertMetadata(metadata)
	if metadata and type(metadata) ~= 'table' then
		metadata = metadata and { type = metadata or nil }
	end

	return metadata
end

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem?
function Inventory.GetSlotWithItem(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as WClientItem?]]

	if not inventory or not item then return end

	metadata = assertMetadata(metadata)
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			return slotData
		end
	end
end

exports('GetSlotWithItem', Inventory.GetSlotWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number?
function Inventory.GetSlotIdWithItem(itemName, metadata, strict)
	return Inventory.GetSlotWithItem(itemName, metadata, strict)?.slot
end

exports('GetSlotIdWithItem', Inventory.GetSlotIdWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem[]?
function Inventory.GetSlotsWithItem(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as WClientItem?]]

	if not inventory or not item then return end


	metadata = assertMetadata(metadata)
	local response = {}
	local n = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			n += 1
			response[n] = slotData
		end
	end

	return response
end

exports('GetSlotsWithItem', Inventory.GetSlotsWithItem)

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number[]?
function Inventory.GetSlotIdsWithItem(itemName, metadata, strict)
	local items = Inventory.GetSlotsWithItem(itemName, metadata, strict)

	if items then
		---@cast items +number[]
		for i = 1, #items do
			items[i] = items[i].slot
		end

		return items
	end
end

---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number
function Inventory.GetItemCount(itemName, metadata, strict)
	local inventory = PlayerData.inventory
	local item = Items(itemName) --[[@as WClientItem?]]

	if not inventory or not item then return 0 end

	if not metadata then
		return item.count
	end


	metadata = assertMetadata(metadata)
	local count = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			count += slotData.count
		end
	end

	return count
end

exports('GetItemCount', Inventory.GetItemCount)


---The walk-up prompt of a police evidence locker: E opens it.
---@param coords vector3
---@return WPlace
local function evidencePlace(coords)
	return Utils.Place({
		coords = coords,
		marker = { r = 242, g = 242, b = 242 }, -- paper: world marks are white, never a hue
		prompts = {
			{
				key = 'E',
				label = function() return locale('open_police_evidence') end,
				onComplete = function() client.openInventory('policeevidence') end,
			},
		},
	})
end

Inventory.Evidence = setmetatable(lib.load('data.evidence'), {
	__call = function(self)
		for _, evidence in pairs(self) do
			if evidence.place then
				evidence.place.remove()
				evidence.place = nil
			end

			if client.hasGroup(shared.police) and evidence.coords then
				evidence.place = evidencePlace(evidence.coords)
			end
		end
	end
})

---The stash's name in the player's language: the data file gives a dictionary key, or a
---'<key> <number>' pair (numbered lockers); a plain name comes back untouched.
---@param label string?
---@return string?
local function stashName(label)
	if type(label) ~= 'string' then return nil end

	local prefix, number = label:match('^(%S+) (%d+)$')

	if not prefix then return locale(label) end

	local text = locale(prefix)

	return text:find('%%') and locale(prefix, number) or ('%s %s'):format(text, number)
end

---The walk-up prompt of a stash: E opens it.
---@param stash { name: string, label?: string, coords: vector3 }
---@return WPlace
local function stashPlace(stash)
	return Utils.Place({
		coords = stash.coords,
		marker = { r = 242, g = 242, b = 242 }, -- paper: world marks are white, never a hue
		prompts = {
			{
				key = 'E',
				label = function()
					local name = stashName(stash.label)
					return name and locale('open_label', name) or locale('open_stash')
				end,
				onComplete = function() client.openInventory('stash', { id = stash.name }) end,
			},
		},
	})
end

Inventory.Stashes = setmetatable(lib.load('data.stashes'), {
	__call = function(self)
		for _, stash in pairs(self) do
			if stash.jobs then stash.groups = stash.jobs end

			if stash.place then
				stash.place.remove()
				stash.place = nil
			end

			if (not stash.groups or client.hasGroup(stash.groups)) and stash.coords then
				stash.place = stashPlace(stash)
			end
		end
	end
})

---Drop every stash / evidence prompt (the player logged out).
function Inventory.WipePlaces()
	for _, stash in pairs(Inventory.Stashes) do
		if stash.place then
			stash.place.remove()
			stash.place = nil
		end
	end

	for _, evidence in pairs(Inventory.Evidence) do
		if evidence.place then
			evidence.place.remove()
			evidence.place = nil
		end
	end
end

-- ============================================================
-- Nearby storage: the saddlebag of a horse that is not the player's own (w_stables offers
-- its own prompt on that one) and the storage of a wagon. The library prompt follows the
-- closest one; U opens it. While mounted or seated the bag key opens the storage instead.
-- ============================================================
local storagePrompt   -- { entity: number, rec: table } | nil
local storageScan = false

local function clearStoragePrompt()
	if not storagePrompt then return end

	storagePrompt.rec.remove()
	storagePrompt = nil
end

---Another player's stables entity: it carries w_stables' tag (set by that server on spawn) and
---the tag names an owner who is not us. No tag, or no owner in it, is "unknown", not "foreign":
---the player's own horse wears its tag a few frames after it spawns, and in that gap it used to
---read as foreign and get this prompt on top of w_stables' own rows.
---@param entity number
---@param role 'horse' | 'wagon' | 'draft'
---@return boolean
local function isForeignStablesEntity(entity, role)
	if not entity or entity == 0 or not DoesEntityExist(entity) or not NetworkGetEntityIsNetworked(entity) then return false end

	local stables = w.entity.getState(entity, 'w_stables')
	if type(stables) ~= 'table' or stables.owner == nil or stables.owner == cache.serverId then return false end
	if role == 'wagon' then return stables.role == 'wagon' end
	return stables.role ~= 'wagon'
end

---A horse another player registered. The player's own horse is asked of w_stables directly as
---well: its rows (mount, saddlebag, hitch) are that resource's, and this prompt must not sit on
---the same animal and win the corner.
---@param ped number
---@return boolean
local function isForeignSaddlebagHorse(ped)
	if not isForeignStablesEntity(ped, 'horse') then return false end
	if not w.entity.getState(ped, 'horseUUID') then return false end

	if GetResourceState('w_stables') == 'started' then
		local ok, mine = pcall(function() return exports.w_stables:IsMyHorse(ped) end)
		if ok and mine == true then return false end
	end

	return true
end

---The closest ped / vehicle within `radius` that passes `accept`. w.getClosestPed takes no
---filter, so the scan is done here: a boat, a train or a stranger's dog must never carry a
---saddlebag prompt.
---@param pool 'CPed' | 'CVehicle'
---@param coords vector3
---@param radius number
---@param accept fun(entity: number): boolean
---@return number? entity
---@return vector3? coords
local function closestAccepted(pool, coords, radius, accept)
	local best, bestCoords, bestDist = nil, nil, radius
	for _, entity in ipairs(GetGamePool(pool)) do
		if entity ~= cache.ped then
			local at = GetEntityCoords(entity)
			local d = #(coords - at)
			if d < bestDist and accept(entity) then
				best, bestCoords, bestDist = entity, at, d
			end
		end
	end
	return best, bestCoords
end

---Mirrors the guard of the storage key: no open bag, no page holding the keyboard, the bag
---not busy, the player neither down nor cuffed, and standing (not seated or mounted).
local function storageCanInteract()
	local state = LocalPlayer.state

	if state.invOpen or state.invBusy or IsNuiFocused() then return false end
	if PlayerData.dead or IsPedCuffed(cache.ped) then return false end

	return not cache.vehicle and not cache.mount
end

---@param entity number
---@param kind 'trunk' | 'glovebox'
local function showStoragePrompt(entity, kind)
	local rec = w.prompt.atEntity(entity, {
		distance = 2.5,
		title = false,
		prompts = {
			{
				key = 'U',
				label = locale(kind == 'trunk' and 'open_wagon_storage' or 'open_saddlebag'),
				onComplete = function()
					if kind == 'trunk' then
						return Inventory.OpenWagonStorage(entity)
					end

					if client.openSaddlebag then return client.openSaddlebag(entity) end

					if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
						Inventory.OpenSaddlebag(entity, w.entity.getState(entity, 'horseUUID'))
					end
				end,
			},
		},
		canInteract = storageCanInteract,
	})

	storagePrompt = { entity = entity, kind = kind, rec = rec }
end

---Start following the closest wagon / foreign horse with the storage prompt.
function Inventory.StartStoragePrompts()
	if storageScan then return end

	storageScan = true

	CreateThread(function()
		while storageScan do
			local target, kind

			if PlayerData.loaded and not cache.vehicle and not cache.mount and not LocalPlayer.state.invOpen then
				local coords = GetEntityCoords(cache.ped)
				-- only another player's wagon (its w_stables tag says so): not a boat, not a train,
				-- not our own wagon -- w_stables draws that one's storage row itself
				local wagon, wagonCoords = closestAccepted('CVehicle', coords, 4.0, function(veh)
					return isForeignStablesEntity(veh, 'wagon')
				end)
				local horse, horseCoords = closestAccepted('CPed', coords, 4.0, isForeignSaddlebagHorse)

				if wagon and horse then
					if #(coords - wagonCoords) <= #(coords - horseCoords) then horse = nil else wagon = nil end
				end

				if wagon and NetworkGetEntityIsNetworked(wagon) then
					target, kind = wagon, 'trunk'
				elseif horse and NetworkGetEntityIsNetworked(horse) then
					target, kind = horse, 'glovebox'
				end
			end

			if storagePrompt and (storagePrompt.entity ~= target or not DoesEntityExist(storagePrompt.entity)) then
				clearStoragePrompt()
			end

			if target and not storagePrompt then
				showStoragePrompt(target, kind)
			end

			Wait(500)
		end

		clearStoragePrompt()
	end)
end

function Inventory.StopStoragePrompts()
	storageScan = false
	clearStoragePrompt()
end

---The dictionary was reloaded: the prompt is rebuilt with the new label on the next scan.
function Inventory.RelabelStoragePrompt()
	clearStoragePrompt()
end

RegisterNetEvent('w_inventory:refreshMaxWeight', function(data)
    if data.inventoryId == cache.serverId then
        PlayerData.maxWeight = data.maxWeight
    end

	SendNUIMessage({
		action = 'refreshSlots',
		data = {
			weightData = {
				inventoryId = data.inventoryId,
				maxWeight = data.maxWeight
			}
		}
	})
end)

RegisterNetEvent('w_inventory:refreshSlotCount', function(data)
	SendNUIMessage({
		action = 'refreshSlots',
		data = {
			slotsData = {
				inventoryId = data.inventoryId,
				slots = data.slots
			}
		}
	})
end)

return Inventory
