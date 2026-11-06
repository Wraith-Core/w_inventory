if not lib then return end

local Inventory = {}

---@type table<any, WInventory>
local Inventories = {}

---@class WInventory
local WInventory = {}
WInventory.__index = WInventory

---Open a player's inventory, optionally with a secondary inventory.
---@param inv? inventory
function WInventory:openInventory(inv)
	if not self?.player then return end

	inv = Inventory(inv)

	if not inv then return end

	inv:set('open', true)
	inv.openedBy[self.id] = true
	self.open = inv.id

	TriggerEvent('w_inventory:openedInventory', self.id, inv.id)
end

---Close a player's inventory.
---@param noEvent? boolean
function WInventory:closeInventory(noEvent)
	if not self.player or not self.open then return end

	local inv = Inventory(self.open)

	if not inv then return end

	inv.openedBy[self.id] = nil
	inv:set('open', false)
	self.open = false
	self.currentShop = nil
	self.containerSlot = nil

	if not noEvent then
		TriggerClientEvent('w_inventory:closeInventory', self.id, true)
	end

	TriggerEvent('w_inventory:closedInventory', self.id, inv.id)
end

---@alias updateSlot { item: SlotWithItem | { slot: number }, inventory: string|number }

---Sync a player's inventory state.
---@param slots updateSlot[]
---@param weight { left?: number, right?: number } | number
function WInventory:syncSlotsWithPlayer(slots, weight)
	TriggerClientEvent('w_inventory:updateSlots', self.id, slots, weight)
end

---Sync an inventory's state with all player's accessing it.
---@param slots updateSlot[]
---@param syncOwner? boolean
function WInventory:syncSlotsWithClients(slots, syncOwner)
    if Inventory.SyncBearerCash then Inventory.SyncBearerCash(self) end
	for playerId in pairs(self.openedBy) do
		if self.id ~= playerId then
            local target = Inventories[playerId]

            if target then
			    TriggerClientEvent('w_inventory:updateSlots', playerId, slots, target.weight)
            end
		end
	end

	if syncOwner and self.player then
		TriggerClientEvent('w_inventory:updateSlots', self.id, slots, self.weight)
	end
end

local Vehicles = lib.load('data.vehicles')
local AmmoTypes = lib.load('data.ammo_types_RDR3')
local RegisteredStashes = {}

for _, stash in pairs(lib.load('data.stashes')) do
	RegisteredStashes[stash.name] = {
		name = stash.name,
		label = stash.label,
		owner = stash.owner,
		slots = stash.slots,
		maxWeight = stash.weight,
		groups = stash.groups or stash.jobs,
		coords = stash.coords
	}
end

---Atempts to lazily load inventory data from the database or create a new player-owned instance for "personal" stashes
---@param data table
---@param player table
---@return WInventory | false | nil
local function loadInventoryData(data, player)
	local source = source
	local inventory

	if not data.type and type(data.id) == 'string' then
		if data.id:find('^glove') then
			data.type = 'glovebox'
		elseif data.id:find('^trunk') then
			data.type = 'trunk'
		elseif data.id:find('^evidence-') then
			data.type = 'policeevidence'
		end
	end

	-- 'glovebox' is a horse's saddlebag ('glove<stable id>') and 'trunk' a wagon's storage
	-- ('trunk<wagon id>' or 'trunktemp:<net id>'); both need the living entity
	if data.type == 'trunk' or data.type == 'glovebox' then
		local storageId = data.id:sub(6)

		inventory = Inventories[data.id]

		if not inventory then
			if not data.netid then
				return shared.info('Failed to load horse/wagon storage (no network id was given).')
			end

			local entity = NetworkGetEntityFromNetworkId(data.netid)

			if not entity or entity == 0 then
				return shared.info('Failed to load horse/wagon storage (no entity exists with given netid).')
			end

			data.entityId = entity

			if not source then
				source = NetworkGetEntityOwner(entity)

				if not source then
					return shared.info('Failed to load horse/wagon storage (entity is unowned).')
				end
			end

			local model = lib.callback.await('w_inventory:getVehicleData', source, data.netid)
			local storage = Vehicles[data.type].models[model] or Vehicles[data.type].default

			inventory = Inventory.Create(data.id, ('ui_inv_%s'):format(data.type), data.type, storage[1], 0, storage[2], false, nil, nil, storageId)
		end
	elseif data.type == 'policeevidence' then
		inventory = Inventory.Create(data.id, 'police_evidence', data.type, 100, 0, 100000, false) -- key: the client translates it
	else
		local stash = RegisteredStashes[data.id]

		if stash then
			if stash.jobs then stash.groups = stash.jobs end
			if player and stash.groups and not server.hasGroup(player, stash.groups) then return end

			local owner

			if stash.owner then
				if stash.owner == true then
					owner = data.owner or player?.owner
				else
					owner = stash.owner
				end
			end

			inventory = Inventories[owner and ('%s:%s'):format(stash.name, owner) or stash.name]

			if not inventory then
				inventory = Inventory.Create(stash.name, stash.label or stash.name, 'stash', stash.slots, 0, stash.maxWeight, owner, nil, stash.groups)
				-- 2.0.6: a stash reloaded after its idle unload keeps the distance check of its registration
				if inventory then inventory.coords = stash.coords end
			end
		end
	end

	if data.netid then
        inventory.entityId = data.entityId or NetworkGetEntityFromNetworkId(data.netid)
		inventory.netid = data.netid
	end

	return inventory or false
end

local function awaitNativeTransfer(inv)
    if inv then
        local thread = coroutine.running()
        while inv.nativeTransfer and inv.nativeTransfer ~= thread do Wait(0) end
    end
    return inv
end

setmetatable(Inventory, {
    __call = function(self, inv, player)
        if not inv then return self end
        if type(inv) == 'table' then
            if inv.__index then return awaitNativeTransfer(inv) end
            return awaitNativeTransfer(not inv.owner and Inventories[inv.id] or loadInventoryData(inv, player))
        end
        return awaitNativeTransfer(Inventories[inv] or loadInventoryData({ id = inv }, player))
    end
})

---@cast Inventory +fun(inv: inventory, player?: inventory): WInventory|false|nil

---@param inv inventory
---@param owner? string | number
local function getInventory(inv, owner)
	if not inv then return Inventory end

	local type = type(inv)

	if type == 'table' or type == 'number' then
		return Inventory(inv)
	else
		return Inventory({ id = inv, owner = owner })
	end
end

exports('Inventory', getInventory)
exports('GetInventory', getInventory)

---@param inv inventory
---@param owner? string | number
---@return table?
exports('GetInventoryItems', function(inv, owner)
	return getInventory(inv, owner)?.items
end)

-- Resolve a currently loaded saddlebag (glovebox) / wagon storage (trunk) by its stables row id.
-- Administration tools must mutate the live inventory when it is open;
-- writing only to SQL would otherwise be overwritten by the next autosave.
exports('GetLoadedVehicleInventoryId', function(dbId, inventoryType)
	if inventoryType ~= 'trunk' and inventoryType ~= 'glovebox' then return end

	for _, inventory in pairs(Inventories) do
		if inventory.type == inventoryType and tostring(inventory.dbId) == tostring(dbId) then
			return inventory.id
		end
	end
end)

---@param inv inventory
---@param slotId number
---@return WInventory?
function Inventory.GetContainerFromSlot(inv, slotId)
	local inventory = Inventory(inv)
	local slotData = inventory and inventory.items[slotId]

	if not slotData then return end

	local container = Inventory(slotData.metadata.container)

	if not container then
		container = Inventory.Create(slotData.metadata.container, slotData.label, 'container', slotData.metadata.size[1], 0, slotData.metadata.size[2], false)
	end

	return container
end

exports('GetContainerFromSlot', Inventory.GetContainerFromSlot)

---@param inv? inventory
---@param ignoreId? number|false
function Inventory.CloseAll(inv, ignoreId)
	if not inv then
		for _, data in pairs(Inventories) do
			for playerId in pairs(data.openedBy) do
				local playerInv = Inventory(playerId)

				if playerInv then playerInv:closeInventory(true) end
			end
		end

		return TriggerClientEvent('w_inventory:closeInventory', -1, true)
	end

	inv = Inventory(inv) --[[@as WInventory?]]

	if not inv then return end

	for playerId in pairs(inv.openedBy) do
		local playerInv = Inventory(playerId)

		if playerInv and playerId ~= ignoreId then
            playerInv:closeInventory()
        end
	end
end

---@param inv inventory
---@param k string
---@param v any
function Inventory.Set(inv, k, v)
	inv = Inventory(inv) --[[@as WInventory]]

	if inv then
		if type(v) == 'number' then
			v = math.floor(v + 0.5)
		end

		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.player then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) and not next(inv.openedBy) then
					return Inventory.Remove(inv)
				else
					inv.time = os.time()
				end
			end

			if inv.player then
				inv.containerSlot = nil
			end
		elseif k == 'maxWeight' and v < 1000 then
			v *= 1000
		end

		inv[k] = v
	end
end

---@param inv inventory
---@param key string
function Inventory.Get(inv, key)
	inv = Inventory(inv) --[[@as WInventory]]
	if inv then
		return inv[key]
	end
end

---@class MinimalInventorySlot
---@field name string
---@field count number
---@field slot number
---@field metadata? table

---@param inv inventory
---@return MinimalInventorySlot[] items
local function minimal(inv)
	inv = Inventory(inv) --[[@as WInventory]]
	local inventory, count = {}, 0
	for k, v in pairs(inv.items) do
		if v.name and v.count > 0 then
			count += 1
			inventory[count] = {
				name = v.name,
				count = v.count,
				slot = k,
				metadata = next(v.metadata) and v.metadata or nil
			}
		end
	end
	return inventory
end

---@param inv inventory
---@param item table
---@param count number
---@param metadata any
---@param slot any
function Inventory.SetSlot(inv, item, count, metadata, slot)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv then return end

	local currentSlot = inv.items[slot]
    if currentSlot and currentSlot.name == item.name and item.stack and currentSlot.metadata then
        metadata = table.clone(metadata or {})
        metadata._vorp = currentSlot.metadata._vorp
        metadata._w_rsg = currentSlot.metadata._w_rsg
    end
	local newCount = currentSlot and currentSlot.count + count or count
	local newWeight = currentSlot and inv.weight - currentSlot.weight or inv.weight

	if currentSlot and newCount < 1 then
		TriggerClientEvent('w_inventory:itemNotify', inv.id, { currentSlot, 'ui_removed', currentSlot.count })
		currentSlot = nil
	else
		-- On stacking: we keep the older (worse) item's quality so the player cannot exploit stacking to renew the quality
		local finalMetadata = metadata
		if inv.items[slot] and inv.items[slot].metadata then
			local oldMeta = inv.items[slot].metadata
			if oldMeta.durability and metadata.durability then
				finalMetadata = table.clone(metadata)
				finalMetadata.durability = math.min(oldMeta.durability, metadata.durability)
				if oldMeta.degrade then
					finalMetadata.degrade = oldMeta.degrade
				end
			end
		end
		currentSlot = {name = item.name, label = item.label, weight = item.weight, slot = slot, count = newCount, description = item.description, metadata = finalMetadata, stack = item.stack, close = item.close}
		local slotWeight = Inventory.SlotWeight(item, currentSlot)
		currentSlot.weight = slotWeight
		newWeight += slotWeight

		TriggerClientEvent('w_inventory:itemNotify', inv.id, { currentSlot, count < 0 and 'ui_removed' or 'ui_added', math.abs(count) })
	end

	inv.weight = newWeight
	inv.items[slot] = currentSlot
	inv.changed = true

	return currentSlot
end

local Items = require 'modules.items.server'
local Losses = require 'modules.losses.server' -- 2026-11-06: the loss journal (w_losses)
require('modules.inventory.economy')(Inventory, Inventories, Items)

CreateThread(function()
    Inventory.accounts = server.accounts
    TriggerEvent('w_inventory:loadInventory', Inventory)
end)

function Inventory.GetAccountItemCounts(inv)
    inv = Inventory(inv)

    if not inv then return end

    local accounts = table.clone(server.accounts)

	for _, v in pairs(inv.items) do
		if accounts[v.name] then
			accounts[v.name] += v.count
		end
	end

    return accounts
end

---@param item table
---@param slot table
function Inventory.SlotWeight(item, slot, ignoreCount)
    if item.nativeSource == 'vorp' or item.nativeSource == 'rsg' then
        local unit = item.weight or 0
        if item.nativeSource == 'vorp' and slot.metadata and tonumber(slot.metadata.weight) then
            unit = tonumber(slot.metadata.weight) * 1000
        end
        return unit * (ignoreCount and 1 or slot.count or 1)
    end
	local weight = ignoreCount and item.weight or item.weight * (slot.count or 1)

	if not slot.metadata then slot.metadata = {} end

	if item.ammoname and slot.metadata.ammo then
		local ammoWeight = Items(item.ammoname)?.weight

		if ammoWeight then
			weight += (ammoWeight * slot.metadata.ammo)
		end
	end

	if slot.metadata.weight then
		weight += ignoreCount and slot.metadata.weight or (slot.metadata.weight * (slot.count or 1))
	end

	return weight
end

---@param items table
function Inventory.CalculateWeight(items)
	local weight = 0
	for _, v in pairs(items) do
		local item = Items(v.name)
		if item then
			weight = weight + Inventory.SlotWeight(item, v)
		end
	end
	return weight
end

-- This should be handled by frameworks, but sometimes isn't or is exploitable in some way.
local activeIdentifiers = {}

local function hasActiveInventory(playerId, owner)
	local activePlayer = activeIdentifiers[owner]

	if activePlayer then
        if activePlayer == playerId then
            -- Same player loading again (e.g., character switch) – clean up and allow re-creation
            local inventory = Inventory(activePlayer)
            if inventory then
                Inventory.CloseAll(inventory)
                if not Inventory.Remove(inventory) then return true end
                Wait(100)
            end
            activeIdentifiers[owner] = playerId
            return false
        end

		local inventory = Inventory(activePlayer)

		if inventory then
			local endpoint = GetPlayerEndpoint(activePlayer)

			if endpoint then
				DropPlayer(playerId, ("Character identifier '%s' is already active."):format(owner))

				return true
			end

			Inventory.CloseAll(inventory)
			if not Inventory.Remove(inventory) then return true end
			Wait(100)
		end
	end

	activeIdentifiers[owner] = playerId
end

---Manually clear an inventory state tied to the given identifier.
---Temporary workaround until somebody actually gives me info.
-- RegisterCommand('clearActiveIdentifier', function(source, args)
--     ---Server console only.
--     if source ~= 0 then return end

-- 	local activePlayer = activeIdentifiers[args[1]] or activeIdentifiers[tonumber(args[1])]
--     local inventory = activePlayer and Inventory(activePlayer)

--     if not inventory then return end

--     local endpoint = GetPlayerEndpoint(activePlayer)

--     if endpoint then
--         DropPlayer(activePlayer, 'Kicked')

--     end

--     Inventory.CloseAll(inventory)
--     db.savePlayer(inventory.owner, json.encode(inventory:minimal()))
--     Inventory.Remove(inventory)
-- end, true)

---@param id string|number
---@param label string|nil
---@param invType string
---@param slots number
---@param weight number
---@param maxWeight number
---@param owner string | number | boolean
---@param items? table
---@param dbId? string | number
---@return WInventory?
--- This should only be utilised internally!
--- To create a stash, please use `exports.w_inventory:RegisterStash` instead.
function Inventory.Create(id, label, invType, slots, weight, maxWeight, owner, items, groups, dbId)
	if invType == 'player' and hasActiveInventory(id, owner) then return end

	local self = {
		id = id,
		label = label or id,
		type = invType,
		slots = slots,
		weight = weight,
		maxWeight = maxWeight or shared.playerweight,
		owner = owner,
		items = type(items) == 'table' and items,
		open = false,
		set = Inventory.Set,
		get = Inventory.Get,
		minimal = minimal,
		time = os.time(),
		groups = groups,
		openedBy = {},
        dbId = dbId
	}

	if invType == 'drop' or invType == 'temp' then
		self.datastore = true
	else
		self.changed = false

		if invType ~= 'glovebox' and invType ~= 'trunk' then
			self.dbId = id

			if invType ~= 'player' and owner and type(owner) ~= 'boolean' then
				self.id = ('%s:%s'):format(self.id, owner)
			end
		end
	end

	if not items then
		self.items, self.weight = Inventory.Load(self.dbId, invType, owner)
	elseif weight == 0 and next(items) then
		self.weight = Inventory.CalculateWeight(items)
	end

	Inventories[self.id] = setmetatable(self, WInventory)
    Inventory.SyncBearerCash(self)
    if self.type ~= 'player' then Inventory.ReflectCash(self) end
	return Inventories[self.id]
end

---@param inv inventory
function Inventory.Remove(inv)
	inv = Inventory(inv) --[[@as WInventory]]

	if inv then
        -- already dropped by Inventory.Forget (a character purge): an old reference must not
        -- unindex a new inventory loaded under the same id since
        if inv.purged then return true end
        if shared.framework == 'vorp' and (inv.type == 'drop' or inv.type == 'temp') then
            if inv.nativeTransfer or Inventory.HasForeignSlotTransfer and Inventory.HasForeignSlotTransfer(inv) then return false end
            inv.nativeTransfer = coroutine.running()
            local ok, result = pcall(db.disposeNativeTransient, inv)
            inv.nativeTransfer = nil
            if not ok or result ~= true then
                warn(('Native temporary inventory cleanup failed for %s: %s'):format(tostring(inv.id), tostring(result)))
                return false
            end
        end
        if not inv.datastore and inv.changed then
            if not Inventory.Save(inv) then return false end
            if inv.changed and (not Inventory.Save(inv) or inv.changed) then return false end
        end
		if inv.type == 'drop' then
			TriggerClientEvent('w_inventory:removeDrop', -1, inv.id)
			Inventory.Drops[inv.id] = nil
		elseif inv.player then
			activeIdentifiers[inv.owner] = nil
		end

        for playerId in pairs(inv.openedBy) do
            if inv.id ~= playerId then
                local target = Inventories[playerId]

                if target then
                    target:closeInventory()
                end
            end
        end

		Inventories[inv.id] = nil
        return true
	end
end

exports('RemoveInventory', Inventory.Remove)

--- Drop a loaded inventory WITHOUT saving it (PurgeCharacter, server_purge.lua): its rows are
--- being deleted, so a save here, or a later one through a reference someone still holds, would
--- bring them back (`purged` makes Inventory.Save refuse). Viewers are closed while it is still
--- indexed: closing looks the inventory up by id, and a missing id would load it again from SQL.
--- Refuses (false) while a transfer runs on it: that thread still owns the rows.
function Inventory.Forget(inv)
    if type(inv) ~= 'table' or Inventories[inv.id] ~= inv then return false end
    if type(inv.nativeTransfer) == 'thread' then return false end
    -- a recovery token (a lost market / custody reply) belongs to the character being purged
    inv.nativeTransfer, inv.purged, inv.changed = nil, true, false
    if inv.player and inv.open then
        -- detached by hand: closeInventory would wait on the other inventory's own transfer
        local other = Inventories[inv.open]
        if other and other.openedBy then other.openedBy[inv.id] = nil end
        inv.open = false
    end
    for playerId in pairs(inv.openedBy) do
        local viewer = Inventories[playerId]
        if viewer and viewer ~= inv then viewer:closeInventory() end
    end
    if inv.player and activeIdentifiers[inv.owner] == inv.id then activeIdentifiers[inv.owner] = nil end
    Inventories[inv.id] = nil
    return true
end

--- A loaded inventory follows its character to another citizen id (w_core Reassign /
--- TransferNumber, server_purge.lua): the rows were renamed in the database, so this copy is
--- indexed and saved under the new key (`id`, `owner`, `dbId`), or its next save would write the
--- character's items back under the old number, over whoever holds it next. A bag keeps its id
--- (the server id) and changes its owner. Never yields: the two moves of a transfer fire back to
--- back, and the second must find the first done. The viewers of a stash are detached by hand
--- (their client holds the old id, and closeInventory would wait on a transfer running on it).
--- A copy left at the new key (the number was clean: nothing of it saved) is dropped first.
function Inventory.Rekey(inv, id, owner, dbId)
    if type(inv) ~= 'table' or Inventories[inv.id] ~= inv then return false end
    -- counted: a save on its way tells a move from any other change of its owner (Inventory.Save)
    inv.moves = (inv.moves or 0) + 1
    if inv.player then
        if activeIdentifiers[inv.owner] == inv.id then
            activeIdentifiers[inv.owner] = nil
            activeIdentifiers[owner] = inv.id
        end
        inv.owner = owner
        return true
    end
    local occupant = Inventories[id]
    if occupant and occupant ~= inv and not Inventory.Forget(occupant) then return false end
    for playerId in pairs(inv.openedBy) do
        local viewer = Inventories[playerId]
        if viewer and viewer ~= inv and viewer.open == inv.id then
            viewer.open, viewer.currentShop, viewer.containerSlot = false, nil, nil
            TriggerClientEvent('w_inventory:closeInventory', playerId, true)
            TriggerEvent('w_inventory:closedInventory', playerId, inv.id)
        end
    end
    inv.openedBy, inv.open = {}, false
    -- its last save may have landed just after the rename (a new row under the old key, the next
    -- holder's to inherit): taken back if it is still exactly that, and the content is written
    -- again under the new key
    local staleKey, staleValue = inv.savedKey, inv.savedValue
    if staleKey then CreateThread(function() pcall(db.dropStaleStash, staleKey, staleValue) end) end
    inv.savedKey, inv.savedValue, inv.changed = nil, nil, true
    Inventories[inv.id] = nil
    inv.id, inv.owner, inv.dbId = id, owner, dbId
    Inventories[id] = inv
    return true
end

function Inventory.GetPersistenceInventories()
    return Inventories
end

local function persistentRows(inv)
    local rows = {}
    for slot, row in pairs(inv.items) do
        if not Items.UpdateDurability(inv, row, Items(row.name), nil, os.time()) then
            rows[#rows + 1] = { name = row.name, count = row.count, slot = slot, metadata = row.metadata }
        end
    end
    table.sort(rows, function(a, b) return a.slot < b.slot end)
    return #rows > 0 and json.encode(rows) or nil
end

function Inventory.Save(inv)
    inv = Inventory(inv)
    -- purged: its character was deleted (Inventory.Forget); saving would recreate its rows
    if not inv or inv.datastore or inv.purged then return false end
    local data = persistentRows(inv)
    -- the key this save is sent under: the character may move to another number while it is on
    -- its way (w_core Reassign / TransferNumber; server_purge.lua re-keys the copy)
    local sentId, sentOwner, sentMoves = inv.id, inv.owner, inv.moves
    -- A save can yield; compare the final snapshot before clearing dirty state.
    -- (a stash save on RSG also answers the key and the value it wrote)
    local ok, result, sentKey, sentValue = pcall(function()
        -- the bag names its players row (ownerRow): a save still in flight when the character
        -- moved can then never land on the next holder of the number
        if inv.player then return db.savePlayer(inv.owner, data, inv.items, inv.ownerRow)
        elseif inv.type == 'trunk' then return db.saveTrunk(inv.dbId, data)
        elseif inv.type == 'glovebox' then return db.saveGlovebox(inv.dbId, data)
        else return db.saveStash(inv.owner, inv.dbId, data, inv.items) end
    end)
    if not ok or result ~= true then
        inv.changed = true
        warn(('Inventory save failed for %s: %s'):format(tostring(inv.id), tostring(result)))
        return false
    end
    -- only a move (Rekey) to another key counts: registerStash may also reset a loaded stash's
    -- owner, and taking back what this save wrote would then delete the row it just saved
    if inv.moves ~= sentMoves and (inv.id ~= sentId or inv.owner ~= sentOwner) then
        -- moved while this save was on its way: it may have reached the old key after the rename
        -- (a bag's row guard wrote nothing; a stash's upsert made a new row there, taken back
        -- here), so the content is written again under the new one
        if sentKey then pcall(db.dropStaleStash, sentKey, sentValue) end
        inv.changed = true
        return true
    end
    -- what this copy last wrote, and where: Rekey takes it back from the old key if it landed
    -- after the rename (the save returned before the move was announced)
    inv.savedKey, inv.savedValue = sentKey, sentValue
    -- Native storage may attach allocated IDs during commit, so comparing the
    -- exact original JSON would mark a successful first save dirty indefinitely.
    -- A second save is safe; never clear mutations which happened while yielding.
    inv.changed = persistentRows(inv) ~= data
    return true
end

---@param inv inventory
---@param invType string
---@param items? table
---@return table returnData, number totalWeight
local function generateItems(inv, invType, items)
	if not items then
		items = {}
	end

	local returnData, totalWeight = table.create(#items, 0), 0
	for i = 1, #items do
		local v = items[i]
		local item = Items(v[1])
		if not item then
			warn('unable to generate', v[1], 'item does not exist')
		else
			local metadata, count = Items.Metadata(inv, item, v[3] or {}, v[2])
			local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			returnData[i] = {name = item.name, label = item.label, weight = weight, slot = i, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		end
	end

	return returnData, totalWeight
end

---@param id string|number
---@param invType string
---@param owner string | number | boolean
function Inventory.Load(id, invType, owner)
    if not invType then return end

	local result

    if invType == 'trunk' or invType == 'glovebox' then
        result = id and (invType == 'trunk' and db.loadTrunk(id) or db.loadGlovebox(id))
        result = result and result[invType]
	elseif id then
		result = db.loadStash(owner or '', id)
	end

	local returnData, weight = {}, 0

	if result and type(result) == 'string' then
		result = json.decode(result)
	end

	if result then
		local ostime = os.time()

		for _, v in pairs(result) do
			local item = Items(v.name)
            if not item and (shared.framework == 'vorp' or shared.framework == 'rsg') then
                error(('Native inventory definition missing for %s; container %s was not loaded or saved')
                    :format(tostring(v.name), tostring(id)))
            end
			if item then
				v.metadata = Items.CheckMetadata(v.metadata or {}, item, v.name, ostime)
				local slotWeight = Inventory.SlotWeight(item, v)
				weight += slotWeight
				returnData[v.slot] = {name = item.name, label = item.label, weight = slotWeight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end

	return returnData, weight
end

local function assertMetadata(metadata)
	if metadata and type(metadata) ~= 'table' then
		metadata = metadata and { type = metadata or nil }
	end

	return metadata
end

---@param inv inventory
---@param item table | string
---@param metadata? any
---@param returnsCount? boolean
---@return table | number | nil
function Inventory.GetItem(inv, item, metadata, returnsCount)
	if type(item) ~= 'table' then item = Items(item) end

	if item then
		item = returnsCount and item or table.clone(item)
		inv = Inventory(inv) --[[@as WInventory]]
		local count = 0

		if inv then
			local ostime = os.time()
			metadata = assertMetadata(metadata)

			for _, v in pairs(inv.items) do
				if v.name == item.name and (not metadata or table.contains(v.metadata, metadata)) and not Items.UpdateDurability(inv, v, item, nil, ostime) then
                    count += v.count
				end
			end
		end

		if returnsCount then return count else
			item.count = count
			return item
		end
	end
end
exports('GetItem', Inventory.GetItem)

---@param fromInventory any
---@param toInventory any
---@param slot1 number
---@param slot2 number
function Inventory.SwapSlots(fromInventory, toInventory, slot1, slot2)
	local fromSlot = fromInventory.items[slot1] and table.clone(fromInventory.items[slot1]) or nil
	local toSlot = toInventory.items[slot2] and table.clone(toInventory.items[slot2]) or nil

	if fromSlot then fromSlot.slot = slot2 end
	if toSlot then toSlot.slot = slot1 end

	fromInventory.items[slot1], toInventory.items[slot2] = toSlot, fromSlot
	fromInventory.changed, toInventory.changed = true, true

	return fromSlot, toSlot
end
exports('SwapSlots', Inventory.SwapSlots)

function Inventory.ContainerWeight(container, metaWeight, playerInventory)
	playerInventory.weight -= container.weight
	container.weight = Items(container.name).weight
	container.weight += metaWeight
	container.metadata.weight = metaWeight
	playerInventory.weight += container.weight
end

---@param inv inventory
---@param item table | string
---@param count number
---@param metadata? table
function Inventory.SetItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end

	if item and count >= 0 then
		inv = Inventory(inv) --[[@as WInventory]]

		if inv then
			inv.changed = true
			local itemCount = Inventory.GetItem(inv, item.name, metadata, true) --[[@as number]]

			if count > itemCount then
				count -= itemCount
				return Inventory.AddItem(inv, item.name, count, metadata)
			elseif count <= itemCount then
				itemCount -= count
				return Inventory.RemoveItem(inv, item.name, itemCount, metadata)
			end
		end
	end
end
exports('SetItem', Inventory.SetItem)

local weaponUsageSavePending = {}
local RDR_DUAL_CAPABLE

local function usageFlag(value)
	return value == true or value == 1 or value == '1'
end

--- Remove runtime equip flags from a weapon that changes inventory ownership.
--- Customization, serial, ammunition, and condition metadata are preserved.
---@param slotData table?
---@return boolean changed
local function clearWeaponUsage(slotData)
    if shared.nativeRsgWeapons then return false end
	if type(slotData) ~= 'table' or not slotData.name then return false end

	local item = Items(slotData.name)
	if not item or not item.weapon then return false end

	local metadata = slotData.metadata or {}
	local changed = usageFlag(metadata.used) or usageFlag(metadata.used2)
		or metadata.weaponHand ~= nil or usageFlag(slotData.used) or usageFlag(slotData.used2)

	metadata.used = false
	metadata.used2 = false
	metadata.weaponHand = nil
	slotData.metadata = metadata
	slotData.used = false
	slotData.used2 = false

	return changed
end

local function scheduleWeaponUsageSave(inv)
	if inv.datastore or weaponUsageSavePending[inv.id] then return end

	weaponUsageSavePending[inv.id] = true
	SetTimeout(250, function()
		weaponUsageSavePending[inv.id] = nil
		local current = Inventory(inv.id)
		if current and current.changed then Inventory.Save(current) end
	end)
end

local function generateWeaponSerial()
	local letters = {}
	for i = 1, 3 do letters[i] = string.char(math.random(65, 90)) end
	return ('%06d%s%06d'):format(math.random(100000, 999999), table.concat(letters),
		math.random(100000, 999999))
end

--- Guarantee a unique persistent identity for every firearm instance in one
--- player inventory. Existing unique custom serials are never changed.
---@param inv inventory
---@param quiet? boolean
---@param incomingSlots? table<number, boolean> slots newly entering this inventory
---@return integer repaired
function Inventory.EnsureWeaponIdentities(inv, quiet, incomingSlots)
    if shared.nativeRsgWeapons then return false end
	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.player then return 0 end

	local existing, incoming, slots, seen, changed = {}, {}, {}, {}, {}
	for slot in pairs(inv.items) do
		slot = tonumber(slot)
		local target = incomingSlots and incomingSlots[slot] and incoming or existing
		target[#target + 1] = slot
	end
	table.sort(existing)
	table.sort(incoming)
	for i = 1, #existing do slots[#slots + 1] = existing[i] end
	for i = 1, #incoming do slots[#slots + 1] = incoming[i] end

	for i = 1, #slots do
		local slotData = inv.items[slots[i]]
		local item = slotData and Items(slotData.name)

		if item and item.weapon and not item.throwable and item.ammoname
            and not (item.nativeDefinition and item.nativeDefinition.NoSerialNumber) then
			slotData.metadata = slotData.metadata or {}
			local serial = slotData.metadata.serial
			serial = serial ~= nil and tostring(serial) or ''

			if serial == '' or seen[serial] then
				repeat serial = generateWeaponSerial() until not seen[serial]
				slotData.metadata.serial = serial
				changed[#changed + 1] = { item = slotData }
			end

			seen[serial] = slotData.slot
		end
	end

	if #changed > 0 then
		inv.changed = true
		if not quiet then inv:syncSlotsWithPlayer(changed, inv.weight) end
		scheduleWeaponUsageSave(inv)
	end

	return #changed
end
exports('EnsureWeaponIdentities', Inventory.EnsureWeaponIdentities)

local function usageRow(slotData, hand, dual)
	local metadata = slotData.metadata or {}
	return {
		slot = slotData.slot,
		hand = hand,
		name = slotData.name,
		hash = Items(slotData.name).hash,
		serial = metadata.serial,
		used = true,
		used2 = dual and hand == 0 or false,
	}
end

--- Return the authoritative, per-instance hand state.
---@param inv inventory
---@return table? state
function Inventory.GetWeaponUsageState(inv)
	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.player then return end

	local primary, secondary, fallback

	for _, slotData in pairs(inv.items) do
		local item = slotData and Items(slotData.name)
		local metadata = slotData and slotData.metadata or {}

		if item and item.weapon and usageFlag(metadata.used or slotData.used) then
			local savedHand = tonumber(metadata.weaponHand)
			if (usageFlag(metadata.used2 or slotData.used2) or savedHand == 0) and not primary then
				primary = slotData
			elseif (savedHand == nil or savedHand == 1) and not secondary then
				secondary = slotData
			end
		end
	end

	if not primary and inv.weapon then
		local slotData = inv.items[tonumber(inv.weapon)]
		local item = slotData and Items(slotData.name)
		if item and item.weapon then fallback = slotData end
	end

	local hands = {}

	if primary and secondary and primary.slot ~= secondary.slot then
		hands[1] = usageRow(primary, 0, true)
		hands[2] = usageRow(secondary, 1, true)
	elseif primary or secondary or fallback then
		hands[1] = usageRow(primary or secondary or fallback, 0, false)
	end

	return {
		count = #hands,
		hands = hands,
		primary = hands[1] and hands[1].slot or nil,
	}
end
exports('GetWeaponUsageState', Inventory.GetWeaponUsageState)

--- Validate and persist a full replacement of the equipped hand state.
--- Client requests use strict serial matching, while trusted server exports may
--- omit serials. At most two unique weapon slots and two unique hands are valid.
---@param inv inventory
---@param state table
---@param strictSerial? boolean
---@param quiet? boolean
---@return boolean success
---@return table? normalized
function Inventory.SetWeaponUsageState(inv, state, strictSerial, quiet)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.player or type(state) ~= 'table' then return false end

	local requested = type(state.hands) == 'table' and state.hands or state
	local rows, bySlot, byHand = {}, {}, {}
	local rawCount = 0

	for key, row in pairs(requested) do
		rawCount += 1
		if rawCount > 2 or type(key) ~= 'number' or type(row) ~= 'table' then return false end

		local slot = tonumber(row.slot)
		local hand = tonumber(row.hand)
		if not slot or slot % 1 ~= 0 or slot < 1 or (hand ~= 0 and hand ~= 1) then return false end
		if bySlot[slot] or byHand[hand] then return false end

		local slotData = inv.items[slot]
		local item = slotData and Items(slotData.name)
		if not slotData or not item or not item.weapon then return false end

		local serial = slotData.metadata and slotData.metadata.serial
		if strictSerial and serial ~= nil and tostring(row.serial or '') ~= tostring(serial) then
			return false
		end

		local parsed = { slotData = slotData, item = item, slot = slot, hand = hand }
		rows[#rows + 1] = parsed
		bySlot[slot] = parsed
		byHand[hand] = parsed
	end

	if #rows == 1 and not byHand[0] then return false end
	if #rows == 2 and (not byHand[0] or not byHand[1]) then return false end
	if #rows == 2 then
		if not RDR_DUAL_CAPABLE then return false end
		for i = 1, #rows do
			if not RDR_DUAL_CAPABLE[rows[i].item.hash] then return false end
		end
	end

	local changed = {}
	local isDual = #rows == 2

	for slotKey, slotData in pairs(inv.items) do
		local item = slotData and Items(slotData.name)

		if item and item.weapon then
			local row = bySlot[tonumber(slotData.slot) or tonumber(slotKey)]
			local used = row ~= nil
			local used2 = used and isDual and row.hand == 0 or false
			local hand = used and row.hand or nil
			local metadata = slotData.metadata or {}
			local dirty = usageFlag(metadata.used) ~= used
				or usageFlag(metadata.used2) ~= used2
				or tonumber(metadata.weaponHand) ~= hand
				or usageFlag(slotData.used) ~= used
				or usageFlag(slotData.used2) ~= used2

			metadata.used = used
			metadata.used2 = used2
			metadata.weaponHand = hand
			slotData.metadata = metadata
			slotData.used = used
			slotData.used2 = used2

			if dirty then changed[#changed + 1] = { item = slotData } end
		end
	end

	local hands = {}
	if byHand[0] then hands[#hands + 1] = usageRow(byHand[0].slotData, 0, isDual) end
	if byHand[1] then hands[#hands + 1] = usageRow(byHand[1].slotData, 1, isDual) end

	inv.weapon = byHand[0] and byHand[0].slot or nil
	inv.weaponUsage = { count = #hands, hands = hands, primary = inv.weapon }

	if #changed > 0 then
		inv.changed = true

		if not quiet then
			inv:syncSlotsWithPlayer(changed, inv.weight)
			if server.syncInventory then server.syncInventory(inv) end
		end

		scheduleWeaponUsageSave(inv)
	end

	if not quiet then
		TriggerEvent('w_inventory:weaponUsageChanged', inv.id, inv.weaponUsage)
	end

	return true, inv.weaponUsage
end
exports('SetWeaponUsageState', function(inv, state)
	return Inventory.SetWeaponUsageState(inv, state, false, false)
end)

--- Rebuild persisted flags after character load and remove stale third weapons.
---@param inv inventory
---@param quiet? boolean
function Inventory.RebuildWeaponUsage(inv, quiet)
	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.player then return false end

	local primary, secondary
	local slots = {}
	for slot in pairs(inv.items) do slots[#slots + 1] = tonumber(slot) end
	table.sort(slots)

	for i = 1, #slots do
		local slotData = inv.items[slots[i]]
		local item = slotData and Items(slotData.name)
		local metadata = slotData and slotData.metadata or {}

		if item and item.weapon and usageFlag(metadata.used or slotData.used) then
			local savedHand = tonumber(metadata.weaponHand)
			if (usageFlag(metadata.used2 or slotData.used2) or savedHand == 0) and not primary then
				primary = slotData
			elseif (savedHand == nil or savedHand == 1) and not secondary then
				secondary = slotData
			end
		end
	end

	local requested = {}
	if primary and secondary and primary.slot ~= secondary.slot then
		requested[1] = { slot = primary.slot, hand = 0, serial = primary.metadata and primary.metadata.serial }
		requested[2] = { slot = secondary.slot, hand = 1, serial = secondary.metadata and secondary.metadata.serial }
	elseif primary or secondary then
		local single = primary or secondary
		requested[1] = { slot = single.slot, hand = 0, serial = single.metadata and single.metadata.serial }
	end

	return Inventory.SetWeaponUsageState(inv, requested, false, quiet == true)
end

---@param inv inventory
function Inventory.GetEquippedWeapons(inv)
	inv = Inventory(inv) --[[@as WInventory]]
	local state = inv and Inventory.GetWeaponUsageState(inv)
	local weapons = {}

	for i = 1, #(state and state.hands or {}) do
		local hand = state.hands[i]
		local slotData = inv.items[hand.slot]
		if slotData then weapons[#weapons + 1] = slotData end
	end

	return weapons
end
exports('GetEquippedWeapons', Inventory.GetEquippedWeapons)

---@param slotData table?
---@return boolean
function Inventory.IsWeaponUsed(slotData)
	if type(slotData) ~= 'table' then return false end
	local item = slotData.name and Items(slotData.name)
	local metadata = slotData.metadata or {}
	return item and item.weapon and usageFlag(metadata.used or slotData.used) or false
end

---@param inv inventory
function Inventory.GetCurrentWeapon(inv)
	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.player then return end

	local state = Inventory.GetWeaponUsageState(inv)
	local slot = state and state.primary or inv.weapon
	local weapon = slot and inv.items[slot]

	if weapon and Items(weapon.name).weapon then return weapon end
	inv.weapon = nil
end
exports('GetCurrentWeapon', Inventory.GetCurrentWeapon)

---@param inv inventory
---@param slotId number
---@return table? item
function Inventory.GetSlot(inv, slotId)
	inv = Inventory(inv) --[[@as WInventory]]
	local slot = inv and inv.items[slotId]

	if slot and not Items.UpdateDurability(inv, slot, Items(slot.name), nil, os.time()) then
        return slot
	end
end
exports('GetSlot', Inventory.GetSlot)

---@param inv inventory
---@param slotId number
function Inventory.SetDurability(inv, slotId, durability)
	inv = Inventory(inv) --[[@as WInventory]]
	local slot = inv and inv.items[slotId]

	if not slot then return end

    Items.UpdateDurability(inv, slot, Items(slot.name), durability)

    if inv.player and server.syncInventory then
        server.syncInventory(inv)
    end
end
exports('SetDurability', Inventory.SetDurability)

local Utils = require 'modules.utils.server'

---@param inv inventory
---@param slotId number
---@param metadata { [string]: any }
function Inventory.SetMetadata(inv, slotId, metadata)
	inv = Inventory(inv) --[[@as WInventory]]
	local slot = inv and inv.items[slotId]

	if not slot then return end

    local item = Items(slot.name)
    if not item then return end

    local previousMetadata = slot.metadata or {}
    local previousImage = previousMetadata.imageurl
    local previousDurability = previousMetadata.durability
    local previousWeight = tonumber(slot.weight) or Inventory.SlotWeight(item, slot)
    local nextMetadata = type(metadata) == 'table' and table.clone(metadata) or { type = metadata or nil }
    nextMetadata = Items.CheckMetadata(nextMetadata, item, slot.name, os.time())
    nextMetadata._vorp = previousMetadata._vorp
    nextMetadata._w_rsg = previousMetadata._w_rsg

	-- used/used2 are authoritative runtime ownership flags, not ordinary item
	-- metadata. A customization/durability update must never equip a holstered
	-- twin or copy the other hand's state. Only SetWeaponUsageState may change
	-- these fields for a loaded player inventory.
	if item.weapon and shared.framework ~= 'rsg' then
		if inv.player then
			if (nextMetadata.serial == nil or tostring(nextMetadata.serial) == '')
				and previousMetadata.serial ~= nil then
				nextMetadata.serial = previousMetadata.serial
			end

			local used = usageFlag(previousMetadata.used or slot.used)
			local used2 = used and usageFlag(previousMetadata.used2 or slot.used2) or false
			nextMetadata.used = used
			nextMetadata.used2 = used2
			nextMetadata.weaponHand = used and tonumber(previousMetadata.weaponHand) or nil
			slot.used = used
			slot.used2 = used2
		else
			nextMetadata.used = false
			nextMetadata.used2 = false
			nextMetadata.weaponHand = nil
			slot.used = false
			slot.used2 = false
		end
	end

    if nextMetadata.imageurl and nextMetadata.imageurl ~= previousImage and Utils.IsValidImageUrl then
        if Utils.IsValidImageUrl(nextMetadata.imageurl) then
            Utils.DiscordEmbed('Valid image URL', ('Updated item "%s" (%s) with valid url in "%s".\n%s\nid: %s\nowner: %s'):format(nextMetadata.label or slot.label, slot.name, inv.label, nextMetadata.imageurl, inv.id, inv.owner), nextMetadata.imageurl, 65280)
        else
            Utils.DiscordEmbed('Invalid image URL', ('Updated item "%s" (%s) with invalid url in "%s".\n%s\nid: %s\nowner: %s'):format(nextMetadata.label or slot.label, slot.name, inv.label, nextMetadata.imageurl, inv.id, inv.owner), nextMetadata.imageurl, 16711680)
            nextMetadata.imageurl = nil
        end
    end

    local requestedDurability = nextMetadata.durability
    slot.metadata = nextMetadata
	if item.weapon and inv.player and shared.framework ~= 'rsg' then
		local identitySlot = tonumber(slot.slot) or tonumber(slotId)
		if identitySlot then Inventory.EnsureWeaponIdentities(inv, true, { [identitySlot] = true }) end
	end

    -- Let the normal durability path perform destructive expiry, but retain
    -- every other metadata field from this update.
    if requestedDurability ~= nil and requestedDurability ~= previousDurability then
        slot.metadata.durability = previousDurability

        if Items.UpdateDurability(inv, slot, item, requestedDurability) then
            return true
        end
    end

    slot.weight = Inventory.SlotWeight(item, slot)
    inv.weight = math.max(0, (tonumber(inv.weight) or 0) - previousWeight + slot.weight)
    inv.changed = true

    inv:syncSlotsWithClients({
        {
            item = slot,
            inventory = inv.id
        }
    }, true)

    if inv.player and server.syncInventory then
        server.syncInventory(inv)
    end

    return true
end

exports('SetMetadata', Inventory.SetMetadata)

---@param inv inventory
---@param slots number
function Inventory.SetSlotCount(inv, slots)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv then return end
	if type(slots) ~= 'number' then return end

	inv.changed = true
	inv.slots = slots

	if inv.player then
        TriggerClientEvent('w_inventory:refreshSlotCount', inv.id, {inventoryId = inv.id, slots = inv.slots})
    end

    for playerId in pairs(inv.openedBy) do
        if playerId ~= inv.id then
            TriggerClientEvent('w_inventory:refreshSlotCount', playerId, {inventoryId = inv.id, slots = inv.slots})
        end
	end
end

exports('SetSlotCount', Inventory.SetSlotCount)

---@param inv inventory
---@param maxWeight number
function Inventory.SetMaxWeight(inv, maxWeight)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv then return end
	if type(maxWeight) ~= 'number' then return end

	inv.maxWeight = maxWeight

    if inv.player then
        TriggerClientEvent('w_inventory:refreshMaxWeight', inv.id, {inventoryId = inv.id, maxWeight = inv.maxWeight})
    end

    for playerId in pairs(inv.openedBy) do
        if playerId ~= inv.id then
            TriggerClientEvent('w_inventory:refreshMaxWeight', playerId, {inventoryId = inv.id, maxWeight = inv.maxWeight})
        end
	end
end

exports('SetMaxWeight', Inventory.SetMaxWeight)

-- Comparing metadata while ignoring degrade only (because every item gets a different timestamp)
-- We compare durability so a half-quality item does not merge with a full-quality one
local function metadataMatchForStack(meta1, meta2)
    local aNative, bNative = meta1 and meta1._vorp, meta2 and meta2._vorp
    if aNative and bNative then
        for _, key in ipairs({ 'degradation', 'percentage', 'durability' }) do
            if aNative[key] ~= bNative[key] then return false end
        end
    end
	if not meta1 or not meta2 then return meta1 == meta2 end
	-- A copy without degrade only (we let durability be compared)
	local a, b = {}, {}
	for k, v in pairs(meta1) do
		if k ~= 'degrade' and k ~= 'durability' and k ~= '_vorp' and k ~= '_w_rsg' then a[k] = v end
	end
	for k, v in pairs(meta2) do
		if k ~= 'degrade' and k ~= 'durability' and k ~= '_vorp' and k ~= '_w_rsg' then b[k] = v end
	end
	return table.matches(a, b)
end

-- The maximum per stack (50 for an ordinary item, 10000 for money)
local MAX_STACK_DEFAULT = 50
local MAX_STACK_MONEY = 10000

-- The items counted as money, which have a higher limit
local MONEY_ITEMS = {
	['money'] = true,
	['cash'] = true,
	['money_clip'] = true,
	['blood_money_clip'] = true,
}

local function GetMaxStack(itemName)
    if shared.framework == 'rsg' or shared.framework == 'vorp' then return math.huge end
	if MONEY_ITEMS[itemName] then
		return MAX_STACK_MONEY
	end
	return MAX_STACK_DEFAULT
end

---@param inv inventory
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot? number
---@param cb? fun(success?: boolean, response: string|SlotWithItem|nil)
---@return boolean? success, string|SlotWithItem|nil response
function Inventory.AddItem(inv, item, count, metadata, slot, cb)
    if type(item) ~= 'table' then item = Items(item) end
    if (shared.framework == 'vorp' or shared.framework == 'rsg') and item
        and item.nativeSource ~= (shared.backend == 'wcore' and 'wcore' or shared.framework)
        and item.name ~= 'money' and item.name ~= 'gold' then
        return false, 'not_in_native_catalog'
    end

	if not item then return false, 'invalid_item' end
    -- 2026-11-04: a story-mode weapon RedM online never loads is never given (shops, loot, admin give)
    if item.storyOnly then return false, 'story_only_weapon' end

	inv = Inventory(inv) --[[@as WInventory]]

	if not inv?.slots then return false, 'invalid_inventory' end
    if item.nativeGunbelt and not inv.player then return false, 'gunbelt_is_character_ammo' end
    if item.name == 'gold' then return false, 'gold_is_account_currency' end
    if item.name == 'money' or item.name == 'cash' then
        count = tonumber(count)
        if not count or count <= 0 then return false, 'invalid_count' end
        return Inventory.ChangeCash(inv, count)
    end

	local toSlot, slotMetadata, slotCount
	local success, response = false
	if item.name ~= 'money' and item.name ~= 'cash' then
		count = math.floor(count + 0.5)
	end
	metadata = assertMetadata(metadata)

	if slot then
		local slotData = inv.items[slot]
		slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata and table.clone(metadata) or {}, count)

		if not slotData then
			-- An empty slot - we only use it if the amount fits
			if item.stack and slotCount > GetMaxStack(item.name) then
				-- More than the limit, we let it go to the distribution below
			else
				toSlot = slot
			end
		elseif item.stack and slotData.name == item.name and metadataMatchForStack(slotData.metadata, slotMetadata) then
			if slotData.count + slotCount <= GetMaxStack(item.name) then
				toSlot = slot
			end
			-- If it exceeds the limit, we let it go to the distribution below
		end
	end

	if not toSlot then
		local items = inv.items
		slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata and table.clone(metadata) or {}, count)

		if item.stack then
			-- Distributing the items over several slots (a maximum of MAX_STACK per slot)
			local remaining = slotCount
			local slots = {}

			-- First: we fill the existing stacks that hold the same item
			for i = 1, inv.slots do
				if remaining <= 0 then break end
				local slotData = items[i]

					if slotData and slotData.name == item.name and metadataMatchForStack(slotData.metadata, slotMetadata) then
					local canAdd = GetMaxStack(item.name) - slotData.count
					if canAdd > 0 then
						local adding = math.min(canAdd, remaining)
						slots[#slots + 1] = { slot = i, count = adding, metadata = slotMetadata }
						remaining = remaining - adding
					end
				end
			end

			-- Second: we use empty slots for the rest
			for i = 1, inv.slots do
				if remaining <= 0 then break end
				if not items[i] then
					local adding = math.min(GetMaxStack(item.name), remaining)
					slots[#slots + 1] = { slot = i, count = adding, metadata = slotMetadata }
					remaining = remaining - adding
				end
			end

			if remaining <= 0 then
				if #slots == 1 then
					toSlot = slots[1].slot
					slotCount = slots[1].count
				else
					toSlot = slots
				end
			end
		else
			-- Items that do not stack: every unit takes a slot of its own
			for i = 1, inv.slots do
				local slotData = items[i]

				if not slotData then
					if not toSlot then toSlot = {} end

					toSlot[#toSlot + 1] = { slot = i, count = slotCount, metadata = slotMetadata }

					if count == slotCount then
						break
					end

					count -= 1
					slotMetadata, slotCount = Items.Metadata(inv.id, item, metadata and table.clone(metadata) or {}, count)
				end
			end
		end
	end

	if not toSlot then return false, 'inventory_full' end

	inv.changed = true

	local invokingResource = server.loglevel > 1 and GetInvokingResource()
	local toSlotType = type(toSlot)

	if toSlotType == 'number' then
		Inventory.SetSlot(inv, item, slotCount, slotMetadata, toSlot)
		if item.weapon and inv.player then
			clearWeaponUsage(inv.items[toSlot])
			Inventory.EnsureWeaponIdentities(inv, true, { [toSlot] = true })
		end

		if inv.player and server.syncInventory then
			server.syncInventory(inv)
		end

		inv:syncSlotsWithClients({
			{
				item = inv.items[toSlot],
				inventory = inv.id
			}
		}, true)

		if invokingResource then
			lib.logger(inv.owner, 'addItem', ('"%s" added %sx %s to "%s"'):format(invokingResource, count, item.name, inv.label))
		end

		success = true
		response = inv.items[toSlot]
	elseif toSlotType == 'table' then
		local added = 0

		for i = 1, #toSlot do
			local data = toSlot[i]
			added += data.count
			Inventory.SetSlot(inv, item, data.count, data.metadata, data.slot)
			toSlot[i] = { item = inv.items[data.slot], inventory = inv.id }
		end

		if item.weapon and inv.player then
			local incomingSlots = {}
			for i = 1, #toSlot do
				clearWeaponUsage(toSlot[i].item)
				incomingSlots[toSlot[i].item.slot] = true
			end
			Inventory.EnsureWeaponIdentities(inv, true, incomingSlots)
		end

		if inv.player and server.syncInventory then
			server.syncInventory(inv)
		end

		inv:syncSlotsWithClients(toSlot, true)

		if invokingResource then
			lib.logger(inv.owner, 'addItem', ('"%s" added %sx %s to "%s"'):format(invokingResource, added, item.name, inv.label))
		end

		for i = 1, #toSlot do
			toSlot[i] = toSlot[i].item
		end

		success = true
		response = toSlot
	end

	if cb then
		return cb(success, response)
	end

	return success, response
end

exports('AddItem', Inventory.AddItem)

local Cart = require 'modules.inventory.cart'
local function cartPlan(inv, lines)
    return Cart.plan(inv, lines, {
        item = Items, copy = table.deepclone, metadata = Items.Metadata,
        matches = metadataMatchForStack, maxStack = GetMaxStack,
        weight = Inventory.SlotWeight, count = Inventory.GetItemCount,
        allowed = function(item)
            return shared.framework ~= 'vorp' and shared.framework ~= 'rsg'
                or item.nativeSource == (shared.backend == 'wcore' and 'wcore' or shared.framework)
                or item.name == 'money' or item.name == 'gold'
        end,
        weapon = function(bag, item, count)
            return not bag.player or not server.canCarryNativeWeapon or server.canCarryNativeWeapon(bag, item, count)
        end,
    })
end

require('modules.inventory.market_claim')(Inventory, Inventories, Items, cartPlan, db)

exports('CanCarryItems', function(inv, lines)
    local plan, reason = cartPlan(Inventory(inv), lines)
    return plan ~= nil, reason
end)

exports('AddItems', function(inv, lines)
    inv = Inventory(inv)
    local plan, reason = cartPlan(inv, lines)
    if not plan then return false, reason end
    if Inventories[inv.id] ~= inv then return false, 'invalid_inventory' end
    -- No yield between the last capacity check and this complete state change.
    inv.items, inv.weight, inv.changed = plan.items, plan.weight, true
    local ok, err = pcall(function()
        Inventory.EnsureWeaponIdentities(inv, true, plan.changed)
        local updates = {}
        for slot in pairs(plan.changed) do
            local row = inv.items[slot]
            updates[#updates+1] = {item=row, inventory=inv.id}
            TriggerClientEvent('w_inventory:itemNotify', inv.id, {row, 'ui_added', plan.additions[slot]})
        end
        if inv.player and server.syncInventory then server.syncInventory(inv) end
        inv:syncSlotsWithClients(updates, true)
    end)
    -- Delivery already committed: a notification failure must never trigger a refund.
    if not ok then lib.print.error('Cart delivered, inventory publication failed: '..tostring(err)) end
    return true
end)

---@param inv inventory
---@param search string|number slots|1, count|2
---@param items table | string
---@param metadata? table | string
function Inventory.Search(inv, search, items, metadata)
	if items then
		inv = Inventory(inv) --[[@as WInventory]]

		if inv then
			inv = inv.items

			if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
			if type(items) == 'string' then items = {items} end

			metadata = assertMetadata(metadata)
			local itemCount = #items
			local returnData = {}
			local firstKey

			for i = 1, itemCount do
				local item = string.lower(items[i])
				if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
				local canonicalName = shared.resolveItemName(item)
				if i == 1 then firstKey = item end

				if search == 1 then
					returnData[item] = {}
				elseif search == 2 then
					returnData[item] = 0
				end

				for _, v in pairs(inv) do
					if v.name == canonicalName then
						if not v.metadata then v.metadata = {} end

						if not metadata or table.contains(v.metadata, metadata) then
							if search == 1 then
								returnData[item][#returnData[item]+1] = inv[v.slot]
							elseif search == 2 then
								returnData[item] += v.count
							end
						end
					end
				end
			end

			if next(returnData) then return itemCount == 1 and returnData[firstKey] or returnData end
		end
	end

	return false
end
exports('Search', Inventory.Search)

---@param inv inventory
---@param item table | string
---@param metadata? table
function Inventory.GetItemSlots(inv, item, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if not item then return end

	inv = Inventory(inv) --[[@as WInventory]]
	if not inv?.slots then return end

	local totalCount, slots, emptySlots = 0, {}, inv.slots

	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == item.name then
			if metadata and v.metadata == nil then
				v.metadata = {}
			end
			if not metadata or table.matches(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end

	return slots, totalCount, emptySlots
end
exports('GetItemSlots', Inventory.GetItemSlots)

---@param inv inventory
---@param item table | string
---@param count integer
---@param metadata? table | string
---@param slot? number
---@param ignoreTotal? boolean
---@return boolean? success, string? response
function Inventory.RemoveItem(inv, item, count, metadata, slot, ignoreTotal)
	local lossReason = Losses.take() -- set by the caller just before this call (modules/losses/server.lua)
	if type(item) ~= 'table' then item = Items(item) end

	if not item then return false, 'invalid_item' end
	-- Gold is an accounting currency only: withdrawing/dropping/giving it from the bag is blocked
	if item.name == 'gold' then return false, 'gold_is_account_currency' end

	if item.name ~= 'money' and item.name ~= 'cash' then
		count = math.floor(count + 0.5)
	end

	if count > 0 then
		inv = Inventory(inv) --[[@as WInventory]]

		if not inv?.slots then return false, 'invalid_inventory' end
        if item.name == 'money' or item.name == 'cash' then return Inventory.ChangeCash(inv, -count) end

		metadata = assertMetadata(metadata)
		local itemSlots, totalCount = Inventory.GetItemSlots(inv, item, metadata)

		if not itemSlots then return false end

		if totalCount and count > totalCount then
			if not ignoreTotal then return false, 'not_enough_items' end

			count = totalCount
		end

		local lossSnap = Losses.snapshot(inv, itemSlots, slot)
		local removed, total, slots = 0, count, {}
		local removedUsageSlots = {}
		local function rememberUsage(slotId, slotData)
			if Inventory.IsWeaponUsed(slotData) then removedUsageSlots[tonumber(slotId)] = true end
		end

		if slot and itemSlots[slot] then
			rememberUsage(slot, inv.items[slot])
			removed = count
			Inventory.SetSlot(inv, item, -count, inv.items[slot].metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					rememberUsage(k, inv.items[k])
					if v == count then
						TriggerClientEvent('w_inventory:itemNotify', inv.id, { inv.items[k], 'ui_removed', v })

						removed = total
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						Inventory.SetSlot(inv, item, -count, inv.items[k].metadata, k)
						slots[#slots+1] = inv.items[k] or k
						removed = total
						count = v - count
					else
						TriggerClientEvent('w_inventory:itemNotify', inv.id, { inv.items[k], 'ui_removed', v })

						removed = removed + v
						count = count - v
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = k
					end
				else break end
			end
		end

		if removed > 0 then
			inv.changed = true
			Losses.afterRemove(inv, lossSnap, lossReason, GetInvokingResource())

			if next(removedUsageSlots) and inv.player then
				for usedSlot in pairs(removedUsageSlots) do
					TriggerClientEvent('w_inventory:disarmSlot', inv.id, usedSlot, true)
				end
				Inventory.RebuildWeaponUsage(inv, false)
			end

			if inv.player and server.syncInventory then
				server.syncInventory(inv)
			end

			local array = table.create(#slots, 0)

			for k, v in pairs(slots) do
				array[k] = {item = type(v) == 'number' and { slot = v } or v, inventory = inv.id}
			end

			inv:syncSlotsWithClients(array, true)

			local invokingResource = server.loglevel > 1 and GetInvokingResource()

			if invokingResource then
				lib.logger(inv.owner, 'removeItem', ('"%s" removed %sx %s from "%s"'):format(invokingResource, removed, item.name, inv.label))
			end

			return true
		end
	end

	return false, 'not_enough_items'
end
exports('RemoveItem', Inventory.RemoveItem)

---@param inv inventory
---@param item table | string
---@param count number
---@param metadata? table | string
function Inventory.CanCarryItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
    if item and item.storyOnly then return false end -- never carried new (a shop asks this before it charges)

	if item then
		inv = Inventory(inv) --[[@as WInventory]]

		if inv then
            if item.weapon and server.canCarryNativeWeapon and not server.canCarryNativeWeapon(inv, item, count) then return false end
            if inv.player and item.nativeSource == 'vorp' then
                local limit = item.gunbeltLimit or item.limit or -1
                if limit >= 0 and Inventory.GetItemCount(inv, item.name) + (tonumber(count) or 1) > limit then return false end
            end
			local itemSlots, _, emptySlots = Inventory.GetItemSlots(inv, item, type(metadata) == 'table' and metadata or { type = metadata or nil })

			if not itemSlots then return end

			local weight = metadata and metadata.weight or item.weight

			if next(itemSlots) or emptySlots > 0 then
				if not count then count = 1 end
				if not item.stack and emptySlots < count then return false end
				if weight == 0 then return true end

				local newWeight = inv.weight + (weight * count)

				if newWeight > inv.maxWeight then
					return false
				end

				return true
			end
		end
	end
end
exports('CanCarryItem', Inventory.CanCarryItem)

---@param inv inventory
---@param item table | string
function Inventory.CanCarryAmount(inv, item)
    if type(item) ~= 'table' then item = Items(item) end
	inv = Inventory(inv) --[[@as WInventory]]

    if inv and item then
		local availableWeight = inv.maxWeight - inv.weight
		return math.floor(availableWeight / item.weight)
    end
end

exports('CanCarryAmount', Inventory.CanCarryAmount)

---@param inv inventory
---@param weight number
function Inventory.CanCarryWeight(inv, weight)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv then return end

	local availableWeight = inv.maxWeight - inv.weight
	local canHold = availableWeight >= weight
	return canHold, availableWeight
end
exports('CanCarryWeight', Inventory.CanCarryWeight)

---@param inv inventory
---@param firstItem string
---@param firstItemCount number
---@param testItem string
---@param testItemCount number
function Inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv then return end

	local firstItemData = Inventory.GetItem(inv, firstItem)
	local testItemData = Inventory.GetItem(inv, testItem)

	if firstItemData and testItemData and firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
end
exports('CanSwapItem', Inventory.CanSwapItem)

---Mostly for internal use, but deprecated.
---@param name string
---@param count number
---@param metadata { [string]: any }
---@param slot number
RegisterServerEvent('w_inventory:removeItem', function(name, count, metadata, slot)
	Losses.reason('discarded', Losses.actor(Inventory(source)), 'self')
	Inventory.RemoveItem(source, name, count, metadata, slot)
end)

Inventory.Drops = {}

---@param prefix string?
---@return string
local function generateInvId(prefix)
	while true do
		local invId = ('%s-%s'):format(prefix or 'drop', math.random(100000, 999999))

		if not Inventories[invId] then return invId end

		Wait(0)
	end
end

local function CustomDrop(prefix, items, coords, slots, maxWeight, instance, model)
	local dropId = generateInvId()
	local inventory = Inventory.Create(dropId, ('%s %s'):format(prefix, dropId:gsub('%D', '')), 'drop', slots or shared.playerslots, 0, maxWeight or shared.playerweight, false, {})

	if not inventory then return end

	inventory.items, inventory.weight = generateItems(inventory, 'drop', items)
	inventory.coords = coords
	Inventory.Drops[dropId] = {
		coords = inventory.coords,
		instance = instance,
		model = model,
		createdAt = os.time(),
	}

	TriggerClientEvent('w_inventory:createDrop', -1, dropId, Inventory.Drops[dropId])

    return dropId
end

AddEventHandler('w_inventory:customDrop', CustomDrop)
exports('CustomDrop', CustomDrop)

exports('CreateDropFromPlayer', function(playerId)
	local playerInventory = Inventories[playerId]

	if not playerInventory or not next(playerInventory.items) then return end

	local dropId = generateInvId()
	local inventory = Inventory.Create(dropId, ('ui_drop %s'):format(dropId:gsub('%D', '')), 'drop', playerInventory.slots, playerInventory.weight, playerInventory.maxWeight, false, table.clone(playerInventory.items))

	if not inventory then return end

	local coords = GetEntityCoords(GetPlayerPed(playerId))
	inventory.coords = vec3(coords.x, coords.y, coords.z-0.2)
	Inventory.Drops[dropId] = {
		coords = inventory.coords,
		instance = Player(playerId).state.instance,
		createdAt = os.time(),
	}

	Inventory.Clear(playerInventory)
	TriggerClientEvent('w_inventory:createDrop', -1, dropId, Inventory.Drops[dropId])

	return dropId
end)

local TriggerEventHooks = require 'modules.hooks.server'

---@class SwapSlotData
---@field count number
---@field fromSlot number
---@field toSlot number
---@field instance any
---@field fromType string
---@field toType string
---@field coords? vector3

local WeaponWorldModels = {
	['WEAPON_REVOLVER_CATTLEMAN']            = 'w_revolver_cattleman01',
	['WEAPON_REVOLVER_CATTLEMAN_MEXICAN']    = 'w_revolver_cattleman02',
	['WEAPON_REVOLVER_DOUBLEACTION_GAMBLER'] = 'w_revolver_doubleaction04',
	['WEAPON_REVOLVER_DOUBLEACTION']         = 'w_revolver_doubleaction01',
	['WEAPON_REVOLVER_SCHOFIELD']            = 'w_revolver_schofield01',
	['WEAPON_REVOLVER_LEMAT']                = 'w_revolver_lemat01',
	['WEAPON_REVOLVER_NAVY']                 = 'w_revolver_navy01',
	['WEAPON_REVOLVER_NAVY_CROSSOVER']       = 'w_revolver_navy02',
	['WEAPON_PISTOL_VOLCANIC']               = 'w_pistol_volcanic01',
	['WEAPON_PISTOL_M1899']                  = 'w_pistol_m189902',
	['WEAPON_PISTOL_MAUSER']                 = 'w_pistol_mauser01',
	['WEAPON_PISTOL_SEMIAUTO']               = 'w_pistol_semiauto01',
	['WEAPON_REPEATER_CARBINE']              = 'w_repeater_carbine01',
	['WEAPON_REPEATER_WINCHESTER']           = 'w_repeater_winchester01',
	['WEAPON_REPEATER_HENRY']                = 'w_repeater_henry01',
	['WEAPON_REPEATER_EVANS']                = 'w_repeater_evans01',
	['WEAPON_RIFLE_VARMINT']                 = 'w_rifle_springfield01',
	['WEAPON_RIFLE_SPRINGFIELD']             = 'w_rifle_springfield01',
	['WEAPON_RIFLE_BOLTACTION']              = 'w_rifle_boltaction01',
	['WEAPON_RIFLE_ELEPHANT']                = 'w_rifle_elephant01',
	['WEAPON_SHOTGUN_DOUBLEBARREL']          = 'w_shotgun_doublebarrel01',
	['WEAPON_SHOTGUN_DOUBLEBARREL_EXOTIC']   = 'w_shotgun_doublebarrel02',
	['WEAPON_SHOTGUN_SAWEDOFF']              = 'w_shotgun_sawed01',
	['WEAPON_SHOTGUN04']                     = 'w_shotgun_repeating01',
	['WEAPON_SHOTGUN05']                     = 'w_shotgun_pumpaction01',
	['WEAPON_SHOTGUN_SEMIAUTO']              = 'w_shotgun_semiauto01',
	['WEAPON_SHOTGUN_PUMP']                  = 'w_shotgun_pumpaction01',
	['WEAPON_SHOTGUN_REPEATING']             = 'w_shotgun_repeating01',
	['WEAPON_SNIPERRIFLE_ROLLINGBLOCK']      = 'w_rifle_rollingblock01',
	['WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC'] = 'w_rifle_rollingblock02',
	['WEAPON_SNIPERRIFLE_CARCANO']           = 'w_rifle_carcano01',
	['WEAPON_BOW']                           = 'w_sp_bowarrow',
	['WEAPON_BOW_IMPROVED']                  = 'w_bow_improved01',
	['WEAPON_LASSO']                         = 'w_melee_lasso01',
	['WEAPON_LASSO_REINFORCED']              = 'w_melee_lasso02',
	['WEAPON_MELEE_KNIFE']                   = 'w_melee_knife01',
	['WEAPON_MELEE_KNIFE_JAWBONE']           = 'w_melee_knife02',
	['WEAPON_MELEE_HAMMER']                  = 'w_melee_hammer02',
	['WEAPON_MELEE_CLEAVER']                 = 'w_melee_knife03',
	['WEAPON_MELEE_KNIFE_MINER']             = 'w_melee_knife16',
	['WEAPON_MELEE_KNIFE_VAMPIRE']           = 'w_melee_knife17',
	['WEAPON_MELEE_TORCH']                   = 'w_melee_torch01',
	['WEAPON_MELEE_HATCHET']                 = 'w_melee_hatchet01',
	['WEAPON_MELEE_MACHETE']                 = 'w_melee_machete01',
	['WEAPON_MELEE_LANTERN']                 = 'w_throw_lantern01',
	['WEAPON_MELEE_DAVY_LANTERN']            = 'w_throw_lantern01',
	['WEAPON_MELEE_LANTERN_ELECTRIC']        = 'w_throw_lantern01',
	['WEAPON_MELEE_MACHETE_COLLECTOR']       = 'w_melee_machete03',
	['WEAPON_MELEE_KNIFE_TRADER']            = 'w_melee_knife22',
	['WEAPON_MELEE_KNIFE_HORROR']            = 'w_melee_knife23',
	['WEAPON_MELEE_KNIFE_RUSTIC']            = 'w_melee_knife24',
	['WEAPON_MELEE_LANTERN_HALLOWEEN']       = 'w_throw_lantern01',
	['WEAPON_MELEE_MACHETE_HORROR']          = 'w_melee_machete04',
	['WEAPON_MOONSHINEJUG_MP']               = 'p_bottlemoonshine01x',
	['WEAPON_THROWN_DYNAMITE']               = 'w_throw_dynamite01',
	['WEAPON_THROWN_MOLOTOV']                = 'w_throw_molotov01',
	['WEAPON_THROWN_THROWING_KNIVES']         = 'w_melee_knife02',
	['WEAPON_THROWN_TOMAHAWK']               = 'w_melee_tomahawk01',
	['WEAPON_THROWN_TOMAHAWK_ANCIENT']        = 'w_melee_tomahawk02',
	['WEAPON_THROWN_BOLAS']                  = 'w_melee_lasso01',
	['WEAPON_THROWN_POISONBOTTLE']            = 'w_throw_poisonbottle01',
	['WEAPON_THROWN_BOLAS_HAWKMOTH']          = 'w_melee_lasso01',
	['WEAPON_THROWN_BOLAS_IRONSPIKED']        = 'w_melee_lasso01',
	['WEAPON_THROWN_BOLAS_INTERTWINED']       = 'w_melee_lasso01',
	['WEAPON_KIT_BINOCULARS_IMPROVED']       = 'w_binoculars01x',
	['WEAPON_KIT_BINOCULARS']                = 'w_binoculars01x',
	['WEAPON_FISHINGROD']                    = 'w_melee_fishingpole02',
	['WEAPON_KIT_CAMERA']                    = 'w_camerabox01x',
	['WEAPON_KIT_CAMERA_ADVANCED']           = 'w_camerabox01x',
	['WEAPON_KIT_METAL_DETECTOR']            = 'w_electricfielddetector01',
}

pcall(function()
	local mapContent = LoadResourceFile(GetCurrentResourceName(), 'data/weapon_world_models_mapping.lua')
	if mapContent then
		local fn = load(mapContent)
		if fn then
			local loaded = fn()
			if type(loaded) == 'table' then
				for k, v in pairs(loaded) do
					WeaponWorldModels[k] = v
				end
			end
		end
	end
end)

local DropPropFallbacks = {
	water           = 'p_bottlebeer01x',
	bandage         = 'p_bandage01x',
	firstaid        = 'p_bandagebox01x',
	fieldbandage    = 'p_bandage01x',
	canteen25       = 'p_canteen01x',
	canteen50       = 'p_canteen01x',
	canteen75       = 'p_canteen01x',
	canteen100      = 'p_canteen01x',
	horse_reviver   = 'p_bottleblack01x',
	horse_brush     = 'p_brush01x',
	horse_lantern   = 'p_oillantern01x',
	lockpick        = 'p_lockpick01x',
	handcuffs       = 'p_cs_cuffs01x',
	kit_gun_oil     = 's_gunoil01x',
	screwdriver     = 'p_screwdriver01x',
	paper           = 'p_letter01x',
	camera          = 'w_camerabox01x',
	goldbar         = 'p_ingot_gold01x',
	gold_bar        = 'p_ingot_gold01x',
	gold_nugget     = 'p_goldnugget01x',
	money           = 'p_moneystack03x',
	money_clip      = 'p_moneystack03x',
	blood_money_clip = 'p_moneystack01x',
	sugarcube       = 'p_sugarcube01x',
	feather         = 'p_feather01x',
	stew            = 'p_bowl03x',
	birdpost        = 'p_letter01x',
	animal_heart    = 'p_heartanimal01x',
	moonshine       = 'p_bottlemoonshine01x',
	beer            = 'p_bottlebeer01x',
	whiskey         = 'p_bottlewhiskey01x',
	cigarette       = 'p_cigarette01x',
	cigar           = 'p_cigar01x',
	tobacco         = 'p_tobaccotin01x',
	dynamite        = 'p_dynamite01x',
	copper          = 'p_ingot_copper01x',
	silver          = 'p_ingot_silver01x',
	perfect_pelt    = 'p_cs_pelt_coyote',
	good_pelt       = 'p_cs_pelt_coyote',
	poor_pelt       = 'p_cs_pelt_coyote',
	rope            = 'p_ropecoil01x',
}

local DropPropKeywords = {
	{ 'ammoarrow', 's_interact_arrow01x' },
	{ 'arrow',     's_interact_arrow01x' },
	{ 'ammo_box',  'p_ammobox01x' },
	{ 'ammo',      'p_ammobox01x' },
	{ 'satchel',   'p_satchel01x' },
	{ 'scope',     'w_binoculars01x' },
	{ 'fish',      'p_fish01x' },
	{ 'pelt',      'p_cs_pelt_coyote' },
	{ 'bait',      'p_baitcheese01x' },
	{ 'lure',      'p_finisdfishlure01x' },
	{ 'spinner',   'p_finisdfishlure01x' },
	{ 'key',       'p_key01x' },
}

local function resolveDropProp(itemName, itemData)
	if itemData and itemData.weapon then
		-- Equip uses a weapon type; the ground asset uses a physical model.
		return itemData.worldModel or WeaponWorldModels[itemData.weaponType or itemName] or 'p_bag01x'
	end
	if itemData?.prop and type(itemData.prop) == 'string' then return itemData.prop end
	if itemData?.model and type(itemData.model) == 'string' then return itemData.model end
	if itemData?.client?.model and type(itemData.client.model) == 'string' then return itemData.client.model end
	if itemData?.client?.prop and type(itemData.client.prop) == 'string' then return itemData.client.prop end

	if WeaponWorldModels[itemName] then return WeaponWorldModels[itemName] end

	if DropPropFallbacks[itemName] then return DropPropFallbacks[itemName] end

	if itemName:match('^p_') or itemName:match('^s_') or itemName:match('^w_') then
		return itemName
	end

	for _, kw in ipairs(DropPropKeywords) do
		if itemName:find(kw[1]) then return kw[2] end
	end

	return 'p_bag01x'
end

---@param source number
---@param playerInventory WInventory
---@param fromData SlotWithItem?
---@param data SwapSlotData
local function dropItem(source, playerInventory, fromData, data)
    if not fromData then return end
    if Items(fromData.name) and Items(fromData.name).nativeGunbelt then return false end

	-- A second guard: this function deducts from playerInventory exclusively, so it is not run unless
	-- the row passed is the very row of that slot. Any other source = duping.
	if playerInventory.items[data.fromSlot] ~= fromData then return end

    if fromData.name == 'gold' then return false end
    if fromData.name == 'money' or fromData.name == 'cash' then
        if not TriggerEventHooks('swapItems', {source=source, fromInventory=playerInventory.id, fromSlot=fromData,
            fromType='player', toInventory='newdrop', toSlot=data.toSlot, toType='drop', count=data.count, action='move'}) then return false end
        local dropId = generateInvId('drop')
        local drop = Inventory.Create(dropId, ('ui_drop %s'):format(dropId:gsub('%D','')), 'drop', shared.playerslots, 0, shared.playerweight, false, {})
        if not drop then return false end
        if not Inventory.TransferCash(playerInventory, drop, data.count) then Inventory.Remove(drop); return false end
        drop.coords = data.coords
        Inventory.Drops[dropId] = {coords=data.coords, instance=data.instance, model=joaat('p_moneystack03x'), createdAt=os.time()}
        TriggerClientEvent('w_inventory:createDrop', -1, dropId, Inventory.Drops[dropId], playerInventory.open and source, data.fromSlot)
        return true, {weight=playerInventory.weight, items={}}
    end

	local toData = table.clone(fromData)
	local wasUsed = Inventory.IsWeaponUsed(fromData)
	toData.metadata = type(toData.metadata) == 'table' and table.clone(toData.metadata) or {}
	toData.slot = data.toSlot
	toData.count = data.count
	toData.weight = Inventory.SlotWeight(Items(toData.name), toData)
	clearWeaponUsage(toData)

    if toData.weight > shared.playerweight then return end

	if not TriggerEventHooks('swapItems', {
		source = source,
		fromInventory = playerInventory.id,
		fromSlot = fromData,
		fromType = playerInventory.type,
		toInventory = 'newdrop',
		toSlot = data.toSlot,
		toType = 'drop',
		count = data.count,
        action = 'move',
	}) then return end

    fromData.count -= data.count
    fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)

    if fromData.count < 1 then
        fromData = nil
    else
        toData.metadata = table.clone(toData.metadata)
    end

	local slot = data.fromSlot
	playerInventory.weight -= toData.weight
	playerInventory.items[slot] = fromData
	-- loss journal: written as soon as the bag gave it up (a drop that fails to be created can be given back)
	Losses.record(playerInventory, toData.name, toData.count, toData.metadata, 'drop', Losses.actor(playerInventory), 'ground')

	if wasUsed then
		TriggerClientEvent('w_inventory:disarmSlot', playerInventory.id, slot, true)
		Inventory.RebuildWeaponUsage(playerInventory, false)
	end

	local itemData = Items(toData.name)
	local prop = resolveDropProp(toData.name, itemData)
	local dropId = generateInvId('drop')
	local inventory = Inventory.Create(dropId, ('ui_drop %s'):format(dropId:gsub('%D', '')), 'drop', shared.playerslots, toData.weight, shared.playerweight, false, {[data.toSlot] = toData})

	if not inventory then return end
	inventory.coords = data.coords
	local isWeaponDrop = itemData.weapon == true or WeaponWorldModels[toData.name] ~= nil
	local propHash = type(prop) == 'number' and prop or joaat(prop)
	-- [w_gunsmith drop-fix] carry the weapon's hash + its customisation (gunComps) to the client so it builds a fully customised weapon on the ground
	Inventory.Drops[dropId] = {coords = inventory.coords, instance = data.instance, model = propHash, nativeItemHash = not isWeaponDrop and itemData.nativeHash or nil, isWeapon = isWeaponDrop or nil, weaponHash = isWeaponDrop and (itemData.hash or joaat(toData.name)) or nil, gunComps = (isWeaponDrop and toData.metadata and toData.metadata.gunComps) or nil, createdAt = os.time()}
	Inventory.Drops[dropId].noProp = itemData.noDropModel or nil

	TriggerClientEvent('w_inventory:createDrop', -1, dropId, Inventory.Drops[dropId], playerInventory.open and source, slot)

	playerInventory.changed = true

	if server.loglevel > 0 then
		lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, toData.name, playerInventory.label, dropId))
	end

	if server.syncInventory then server.syncInventory(playerInventory) end

	return true, {
		weight = playerInventory.weight,
		items = {
			{
				item = fromData or { slot = data.fromSlot },
				inventory = playerInventory.id
			}
		}
	}
end


local activeSlots = {}

function Inventory.HasForeignSlotTransfer(inv)
    local prefix, current = tostring(inv.id) .. ':', coroutine.running()
    for ref, thread in pairs(activeSlots) do
        if ref:sub(1, #prefix) == prefix and thread ~= current then return true end
    end
    return false
end

--- A lawman on duty: in a police job (inventory:police, the same check as searching a bag and the
--- evidence lockers) and on duty by the core's own job record. VORP keeps no duty record, so there
--- the job alone counts.
---@param source number
---@param inv table the actor's inventory
---@return boolean
local function lawOnDuty(source, inv)
	if not server.hasGroup(inv, shared.police) then return false end
	if shared.framework == 'vorp' then return true end
	local ok, core = pcall(server.GetPlayerFromId, source)
	local job = ok and type(core) == 'table' and type(core.PlayerData) == 'table' and core.PlayerData.job
	return type(job) == 'table' and job.onduty == true
end

---@param source number
---@param data SwapSlotData
lib.callback.register('w_inventory:swapItems', function(source, data)
	if type(data) ~= 'table' then return end
	-- ★ NaN fails every comparison, so `count < 1` let it through and every clamp after it too
	--   (`data.count > fromData.count`, math.min): two stacks merged with 0/0 became NaN, and a NaN
	--   stack then handed out any count asked of it. Infinity is refused for the same reason.
	local count = data.count
	if type(count) ~= 'number' or count ~= count or count == math.huge or count < 1 then return end
	-- ★ A slot is a whole number from 1 up. A string slot ("1") was stored under a string key, and the
	--   save's table.sort then threw comparing it with the numbers, which stopped the save loop for
	--   every inventory after it.
	--   toSlot 0 is the container buttons' "wherever it fits" ("store in" / "take out"), resolved below.
	for _, key in ipairs({ 'fromSlot', 'toSlot' }) do
		local slot = data[key]
		local least = key == 'toSlot' and 0 or 1
		if type(slot) ~= 'number' or slot ~= slot or slot < least or slot % 1 ~= 0 or slot > 1000 then return end
		data[key] = math.tointeger(slot)
	end

	local playerInventory = Inventory(source)

	if not playerInventory then return end

	local toInventory = (data.toType == 'player' and playerInventory) or Inventory(playerInventory.open)
	local fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)

	if not fromInventory or not toInventory then
		playerInventory:closeInventory()
		return
	end

    if data.toType == 'inspect' or data.fromType == 'inspect' then return end

	-- the container buttons send toSlot 0: the slot that takes this item (its stack, else the first
	-- empty one). It used to land in a slot 0 of its own, outside every slot the page draws.
	if data.toSlot == 0 then
		local moving = fromInventory.items[data.fromSlot]
		data.toSlot = moving and Inventory.GetSlotForItem(toInventory, moving.name, moving.metadata) or nil
		if not data.toSlot then return false end
	end

	local fromRef = ('%s:%s'):format(fromInventory.id, data.fromSlot)
	local toRef = ('%s:%s'):format(toInventory.id, data.toSlot)

	if activeSlots[fromRef] or activeSlots[toRef] then
		return false, {
			{
				item = toInventory.items[data.toSlot] or { slot = data.toSlot },
				inventory = toInventory.id
			},
			{
				item = fromInventory.items[data.fromSlot] or { slot = data.fromSlot },
				inventory = fromInventory.id
			}
		}
	end

	local sameInventory = fromInventory.id == toInventory.id
	local fromOtherPlayer = fromInventory.player and fromInventory ~= playerInventory
	local toOtherPlayer = toInventory.player and toInventory ~= playerInventory
	local toData = toInventory.items[data.toSlot]

	if not sameInventory and (fromInventory.type == 'policeevidence' or (toInventory.type == 'policeevidence' and toData)) then
		local group, rank = server.hasGroup(playerInventory, shared.police)

		if not group or server.evidencegrade > rank then
			return false, 'evidence_cannot_take'
		end
	end

	activeSlots[fromRef] = coroutine.running()
	activeSlots[toRef] = coroutine.running()

	local _ <close> = defer(function()
		activeSlots[fromRef] = nil
		activeSlots[toRef] = nil
	end)

	if toInventory and (data.toType == 'newdrop' or fromInventory ~= toInventory or data.fromSlot ~= data.toSlot) then
		local fromData = fromInventory.items[data.fromSlot]

		if not fromData then
			return false, {
				{
					item = { slot = data.fromSlot },
					inventory = fromInventory.id
				},
				{
					item = toData or { slot = data.toSlot },
					inventory = toInventory.id
				}
			}
		end

        if not sameInventory then
            local fromItem = Items(fromData.name)
            local toItem = toData and Items(toData.name)
            if fromItem and fromItem.nativeGunbelt or toItem and toItem.nativeGunbelt then return false end
        end
        if data.count > fromData.count then
            data.count = fromData.count
        end

        if data.toType == 'newdrop' then
            -- * Dropping on the ground is allowed from the player's own bag only.
            --
            -- dropItem always deducts from playerInventory, while fromData may come
            -- from another open store (a bag on the ground, say). So dragging an item **from a bag
            -- lying there** into the drop zone used to: create a new bag with a copy of it, then
            -- deduct from a slot in the player's bag that has nothing to do with it - so the original stayed in
            -- the source bag and a second item was born. Outright duping, and it corrupts the player's slot.
            if fromInventory ~= playerInventory or fromInventory.type ~= 'player' then
                return false, 'cannot_perform'
            end

            return dropItem(source, playerInventory, fromData, data)
        end

        if not sameInventory and fromData and (fromData.name == 'money' or fromData.name == 'cash' or fromData.name == 'gold'
            or toData and (toData.name == 'money' or toData.name == 'cash' or toData.name == 'gold')) then
            if fromData.name == 'gold' or toData and toData.name ~= fromData.name then return false, 'cannot_perform' end
            if fromData.name ~= 'money' and fromData.name ~= 'cash' then return false, 'cannot_perform' end
            -- ★ Cash leaves another player's bag only in a lawman's hands. A searched bag (hands up,
            --   cuffed, down) let anyone drag the whole cash row out, past w_policejob's robbery cap
            --   (RobPlayer: a share of it, a ceiling, a cooldown). Lawmen on duty seize as before.
            if fromOtherPlayer and not lawOnDuty(source, playerInventory) then
                return false, server.hasGroup(playerInventory, shared.police) and 'cash_seize_off_duty' or 'cash_rob_only'
            end
            if not TriggerEventHooks('swapItems', {source=source, fromInventory=fromInventory.id, fromSlot=fromData,
                fromType=fromInventory.type, toInventory=toInventory.id, toSlot=toData or data.toSlot,
                toType=toInventory.type, count=data.count, action='move'}) then return false end
            local ok, reason = Inventory.TransferCash(fromInventory, toInventory, data.count)
            return ok, ok and {weight=playerInventory.weight, items={}} or reason
        end

		if fromData then
			local fromWeaponWasUsed = not sameInventory and fromInventory.player
				and Inventory.IsWeaponUsed(fromData) or false
			local toWeaponWasUsed = not sameInventory and toInventory.player
				and Inventory.IsWeaponUsed(toData) or false

            if fromData.metadata.container and toInventory.type == 'container' then return false end
            if toData and toData.metadata.container and fromInventory.type == 'container' then return false end

			local container, containerItem = (not sameInventory and playerInventory.containerSlot) and (fromInventory.type == 'container' and fromInventory or toInventory)

			if container then
				containerItem = playerInventory.items[playerInventory.containerSlot]
			end

			local hookPayload = {
				source = source,
				fromInventory = fromInventory.id,
				fromSlot = fromData,
				fromType = fromInventory.type,
				toInventory = toInventory.id,
				toSlot = toData or data.toSlot,
				toType = toInventory.type,
				count = data.count,
			}

			if toData and ((toData.name ~= fromData.name) or not toData.stack or (not metadataMatchForStack(toData.metadata, fromData.metadata)) or toData.count >= GetMaxStack(fromData.name)) then
				-- Swap items
				local toWeight = not sameInventory and (toInventory.weight - toData.weight + fromData.weight) or 0
				local fromWeight = not sameInventory and (fromInventory.weight + toData.weight - fromData.weight) or 0
				hookPayload.action = 'swap'

				if not sameInventory then
					if (toWeight <= toInventory.maxWeight and fromWeight <= fromInventory.maxWeight) then
						if not TriggerEventHooks('swapItems', hookPayload) then return end

						if containerItem then
							local toContainer = toInventory.type == 'container'
							local whitelist = Items.containers[containerItem.name]?.whitelist
							local blacklist = Items.containers[containerItem.name]?.blacklist
							local checkItem = toContainer and fromData.name or toData.name

							if (whitelist and not whitelist[checkItem]) or (blacklist and blacklist[checkItem]) then
								return
							end

							Inventory.ContainerWeight(containerItem, toContainer and toWeight or fromWeight, playerInventory)
						end

						if fromOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', fromInventory.id, { fromData, 'ui_removed', fromData.count })
							TriggerClientEvent('w_inventory:itemNotify', fromInventory.id, { toData, 'ui_added', toData.count })
						elseif toOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', toInventory.id, { fromData, 'ui_added', fromData.count })
							TriggerClientEvent('w_inventory:itemNotify', toInventory.id, { toData, 'ui_removed', toData.count })
							TriggerClientEvent('w_inventory:notify', toInventory.id, {
								type = 'success',
								key = 'received_from_player', args = { fromData.count, { item = fromData.name }, GetPlayerName(source) }
							})
						end

						fromInventory.weight = fromWeight
						toInventory.weight = toWeight
						toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot) --[[@as table]]

						if server.loglevel > 0 then
							lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s" for %sx %s'):format(fromData.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id, toData.count, toData.name))
						end
					else return false, 'cannot_carry' end
				else
					if not TriggerEventHooks('swapItems', hookPayload) then return end

					toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)
				end

			elseif toData and toData.name == fromData.name and metadataMatchForStack(toData.metadata, fromData.metadata) then
				-- Stack items (max per slot based on item type)
				data.count = math.min(data.count, GetMaxStack(toData.name) - toData.count)
				hookPayload.count = data.count
				toData.count += data.count
				fromData.count -= data.count
				local toSlotWeight = Inventory.SlotWeight(Items(toData.name), toData)
				local totalWeight = toInventory.weight - toData.weight + toSlotWeight

				if fromInventory.type == 'container' or sameInventory or totalWeight <= toInventory.maxWeight then
					hookPayload.action = 'stack'

					if not TriggerEventHooks('swapItems', hookPayload) then
						toData.count -= data.count
						fromData.count += data.count
						return
					end

					local fromSlotWeight = Inventory.SlotWeight(Items(fromData.name), fromData)
					toData.weight = toSlotWeight

					if not sameInventory then
						fromInventory.weight = fromInventory.weight - fromData.weight + fromSlotWeight
						toInventory.weight = totalWeight

						if container then
							Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toInventory.weight or fromInventory.weight, playerInventory)
						end

						if fromOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', fromInventory.id, { fromData, 'ui_removed', data.count })
						elseif toOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', toInventory.id, { toData, 'ui_added', data.count })
							TriggerClientEvent('w_inventory:notify', toInventory.id, {
								type = 'success',
								key = 'received_from_player', args = { data.count, { item = toData.name }, GetPlayerName(source) }
							})
						end

						if server.loglevel > 0 then
							lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id))
						end
					end

					fromData.weight = fromSlotWeight
				else
					toData.count -= data.count
					fromData.count += data.count
					return false, 'cannot_carry'
				end
			elseif data.count <= fromData.count then
				-- Move item to an empty slot
				toData = table.clone(fromData)
				toData.count = data.count
				toData.slot = data.toSlot
				toData.weight = Inventory.SlotWeight(Items(toData.name), toData)

				if fromInventory.type == 'container' or sameInventory or (toInventory.weight + toData.weight <= toInventory.maxWeight) then
					hookPayload.action = 'move'

					if not TriggerEventHooks('swapItems', hookPayload) then return end

					if not sameInventory then
						local toContainer = toInventory.type == 'container'

						if container then
							if toContainer and containerItem then
								local whitelist = Items.containers[containerItem.name]?.whitelist
								local blacklist = Items.containers[containerItem.name]?.blacklist

								if (whitelist and not whitelist[fromData.name]) or (blacklist and blacklist[fromData.name]) then
									return
								end
							end
						end

						fromInventory.weight -= toData.weight
						toInventory.weight += toData.weight

						if container then
							Inventory.ContainerWeight(containerItem, toContainer and toInventory.weight or fromInventory.weight, playerInventory)
						end

						if fromOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', fromInventory.id, { fromData, 'ui_removed', data.count })
						elseif toOtherPlayer then
							TriggerClientEvent('w_inventory:itemNotify', toInventory.id, { fromData, 'ui_added', data.count })
							TriggerClientEvent('w_inventory:notify', toInventory.id, {
								type = 'success',
								key = 'received_from_player', args = { data.count, { item = fromData.name }, GetPlayerName(source) }
							})
						end

						if server.loglevel > 0 then
							lib.logger(playerInventory.owner, 'swapSlots', ('%sx %s transferred from "%s" to "%s"'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id))
						end
					end

					fromData.count -= data.count
					fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)

					if fromData.count > 0 then
						toData.metadata = table.clone(toData.metadata)
					end
				else return false, 'cannot_carry_other' end
			end

			if fromData and fromData.count < 1 then fromData = nil end

			---@type updateSlot[]
			local items = {}

			if fromInventory.player and not fromOtherPlayer then
				if toInventory.type == 'container' and containerItem then
					items[#items + 1] = {
						item = containerItem,
						inventory = playerInventory.id
					}
				end
			end

			if toInventory.player and not toOtherPlayer then
				if fromInventory.type == 'container' and containerItem then
					items[#items + 1] = {
						item = containerItem,
						inventory = playerInventory.id
					}
				end
			end

			if not sameInventory then
				-- Equip state belongs to a character, never to a stash/drop/recipient.
				-- Clear only used/used2; serial and per-instance customization travel
				-- with the physical weapon unchanged.
				clearWeaponUsage(fromData)
				clearWeaponUsage(toData)
			end

			fromInventory.items[data.fromSlot] = fromData
			toInventory.items[data.toSlot] = toData

			if fromInventory.changed ~= nil then fromInventory.changed = true end
			if toInventory.changed ~= nil then toInventory.changed = true end

			-- loss journal: an item that left a player's bag for ANOTHER player's hands (given, taken from
			-- him while down/searched/robbed, or by a lawman). Moving one's own items into a stash is not a loss.
			if not sameInventory and (fromOtherPlayer or toOtherPlayer) then
				local actor = Losses.actor(playerInventory)
				local taker = server.hasGroup(playerInventory, shared.police) and 'police' or 'taken'
				local moved = hookPayload.action == 'swap' and toData or hookPayload.fromSlot
				local movedCount = hookPayload.action == 'swap' and (toData and toData.count) or data.count
				if fromInventory.player and moved then
					Losses.record(fromInventory, moved.name, movedCount, moved.metadata,
						fromOtherPlayer and taker or 'give', fromOtherPlayer and actor or Losses.actor(toInventory), tostring(toInventory.id))
				end
				-- a swap also sends the other slot's item back the other way
				if hookPayload.action == 'swap' and fromData and toInventory.player then
					Losses.record(toInventory, fromData.name, fromData.count, fromData.metadata,
						toOtherPlayer and taker or 'give', toOtherPlayer and actor or Losses.actor(fromInventory), tostring(fromInventory.id))
				end
			end

			if sameInventory and fromInventory.player then
				-- Slot numbers changed but the exact weapon instances and hands did not.
				Inventory.RebuildWeaponUsage(fromInventory, false)
			else
				if fromWeaponWasUsed then
					TriggerClientEvent('w_inventory:disarmSlot', fromInventory.id, data.fromSlot, true)
				end

				if toWeaponWasUsed then
					TriggerClientEvent('w_inventory:disarmSlot', toInventory.id, data.toSlot, true)
				end

				if fromInventory.player then
					Inventory.EnsureWeaponIdentities(fromInventory, true, { [data.fromSlot] = true })
					Inventory.RebuildWeaponUsage(fromInventory, false)
				end
				if toInventory.player then
					Inventory.EnsureWeaponIdentities(toInventory, true, { [data.toSlot] = true })
					Inventory.RebuildWeaponUsage(toInventory, false)
				end
			end

            CreateThread(function()
                if sameInventory then
                    fromInventory:syncSlotsWithClients({
                        {
                            item = fromInventory.items[data.toSlot] or { slot = data.toSlot },
                            inventory = fromInventory.id
                        },
                        {
                            item = fromInventory.items[data.fromSlot] or { slot = data.fromSlot },
                            inventory = fromInventory.id
                        }
                    }, true)
                else
                    toInventory:syncSlotsWithClients({
                        {
                            item = toInventory.items[data.toSlot] or { slot = data.toSlot },
                            inventory = toInventory.id
                        }
                    }, true)

                    fromInventory:syncSlotsWithClients({
                        {
                            item = fromInventory.items[data.fromSlot] or { slot = data.fromSlot },
                            inventory = fromInventory.id
                        }
                    }, true)
                end
            end)

			local resp

			if next(items) then
				resp = { weight = playerInventory.weight, items = items }
			end

			if server.syncInventory then
				if fromInventory.player then
					server.syncInventory(fromInventory)
				end

				if toInventory.player and not sameInventory then
					server.syncInventory(toInventory)
				end
			end

			local weaponSlot = sameInventory and fromInventory.weapon or nil

			local weaponSlotMap = sameInventory and {
				[data.fromSlot] = data.toSlot,
				[data.toSlot] = data.fromSlot,
			} or nil

			return containerItem and containerItem.weight or true, resp, weaponSlot, weaponSlotMap
		end
	end
end)

-- Move confiscated items through the same native stores, committing both sides
-- before publishing the new player inventory. Cash and gunbelt ammo stay with
-- their core-owned accounts; neither is an ordinary confiscatable item.
local function nativeCustody(inv, returning)
    if not inv or not inv.player then return false, 'invalid_inventory' end
    if inv.nativeTransfer then return false, 'inventory_busy' end
    local prefix = tostring(inv.id) .. ':'
    for ref in pairs(activeSlots) do
        if ref:sub(1, #prefix) == prefix then return false, 'inventory_busy' end
    end
    Inventory.CloseAll(inv)
    inv:closeInventory()
    inv.nativeTransfer = coroutine.running()
    local ok, result, reason = xpcall(function()
        -- Allocate any new native IDs before copying an item into custody.
        if not Inventory.Save(inv) then return false, 'save_failed' end
        local name = '__w_confiscated'
        local stored = Inventory.Load(name, 'stash', inv.owner)
        local playerRows, stashRows = {}, {}
        local taken = {} -- loss journal: what goes into custody (written once it is saved)
        local function append(rows, item, keepSlot)
            local copy = json.decode(json.encode(item))
            local slot = keepSlot and tonumber(copy.slot) or nil
            if not slot or rows[slot] then
                slot = 1
                while rows[slot] do slot = slot + 1 end
            end
            copy.slot = slot
            if shared.framework == 'vorp' and Items(copy.name).weapon then
                copy.used, copy.used2 = false, false
                copy.metadata.used, copy.metadata.used2 = false, false
            end
            rows[slot] = copy
        end
        if returning then
            if not next(stored) then return false, 'nothing_confiscated' end
            for _, row in pairs(inv.items) do append(playerRows, row, true) end
            for _, row in pairs(stored) do append(playerRows, row, false) end
        else
            for _, row in pairs(stored) do append(stashRows, row, true) end
            for _, row in pairs(inv.items) do
                local item = assert(Items(row.name), 'Unknown native confiscation item')
                if item.nativeCurrency or item.nativeGunbelt or row.name == 'money' or row.name == 'gold' then
                    append(playerRows, row, true)
                else
                    append(stashRows, row, false)
                    taken[#taken + 1] = row
                end
            end
        end
        if not db.saveNativeTransfer(inv.owner, name, json.encode(playerRows), json.encode(stashRows)) then
            return false, 'native_transfer_failed'
        end
        for _, row in ipairs(taken) do
            Losses.record(inv, row.name, row.count, row.metadata, 'confiscated', GetInvokingResource() or 'w_inventory', name)
        end
        inv.items, inv.weight, inv.changed = playerRows, Inventory.CalculateWeight(playerRows), false
        inv.weapon, inv.weaponUsage = nil, { count = 0, hands = {}, primary = nil }
        for slot in pairs(playerRows) do inv.slots = math.max(inv.slots, slot) end
        inv.player.slots = inv.slots
        -- Commit and memory publication are complete before external callbacks.
        inv.nativeTransfer = nil
        if returning then
            TriggerClientEvent('w_inventory:inventoryReturned', inv.id, { playerRows, inv.weight, inv.weight })
        else
            TriggerClientEvent('w_inventory:inventoryConfiscated', inv.id, true)
            local updates = {}
            for _, row in pairs(playerRows) do updates[#updates + 1] = { item = row, inventory = inv.id } end
            if #updates > 0 then inv:syncSlotsWithClients(updates, true) end
        end
        if server.syncInventory then server.syncInventory(inv) end
        return true
    end, debug.traceback)
    inv.nativeTransfer = nil
    if not ok then warn(result); return false, result end
    return result, reason
end

function Inventory.Confiscate(source)
    local inv = Inventories[source]
    if shared.framework == 'vorp' or shared.framework == 'rsg' then return nativeCustody(inv, false) end

	if inv?.player then
		Inventory.SetWeaponUsageState(inv, {}, false, true)
		db.saveStash(inv.owner, inv.owner, json.encode(minimal(inv)))
		table.wipe(inv.items)
		inv.weight = 0
		inv.changed = true
		inv.weapon = nil
		inv.weaponUsage = { count = 0, hands = {}, primary = nil }

		TriggerClientEvent('w_inventory:inventoryConfiscated', inv.id)

		if server.syncInventory then server.syncInventory(inv) end
	end
end
exports('ConfiscateInventory', Inventory.Confiscate)

function Inventory.Return(source)
    local inv = Inventories[source]
    if shared.framework == 'vorp' or shared.framework == 'rsg' then return nativeCustody(inv, true) end

	if not inv?.player then return end

	local items = MySQL.scalar.await('SELECT data FROM w_inventory WHERE name = ?', { inv.owner })

    if not items then return end

	MySQL.update.await('DELETE FROM w_inventory WHERE name = ?', { inv.owner })

    items = json.decode(items)
    local inventory, totalWeight = {}, 0

    if table.type(items) == 'array' then
        for i = 1, #items do
            local data = items[i]
            if type(data) == 'number' then break end

            local item = Items(data.name)

            if item then
                local weight = Inventory.SlotWeight(item, data)
                totalWeight = totalWeight + weight
                inventory[data.slot] = {name = data.name, label = item.label, weight = weight, slot = data.slot, count = data.count, description = item.description, metadata = data.metadata, stack = item.stack, close = item.close}
            end
        end
    end

    inv.changed = true
    inv.weight = totalWeight
    inv.items = inventory
	Inventory.EnsureWeaponIdentities(inv, true)
	Inventory.RebuildWeaponUsage(inv, true)

    TriggerClientEvent('w_inventory:inventoryReturned', source, { inventory, totalWeight })

    if server.syncInventory then server.syncInventory(inv) end
end

exports('ReturnInventory', Inventory.Return)

---@param inv inventory
---@param keep? string | string[] an item or list of items to ignore while clearing items
function Inventory.Clear(inv, keep)
	inv = Inventory(inv) --[[@as WInventory]]

	if not inv or not next(inv.items) then return end

	if inv.player then
		Inventory.SetWeaponUsageState(inv, {}, false, true)
		TriggerClientEvent('w_inventory:clearWeapons', inv.id)
	end

	local updateSlots = {}
	local newWeight = 0
	local inc = 0
	local lossSnap = Losses.snapshot(inv, inv.items)

	if keep then
		local keptItems = {}
		local keepType = type(keep)

		if keepType == 'string' then
			for slot, v in pairs(inv.items) do
				if v.name == keep then
					keptItems[v.slot] = v
					newWeight += v.weight
				elseif updateSlots then
					inc += 1
					updateSlots[inc] = { item = { slot = slot }, inventory = inv.id }
				end
			end
		elseif keepType == 'table' and table.type(keep) == 'array' then
			for slot, v in pairs(inv.items) do
				for i = 1, #keep do
					if v.name == keep[i] then
						keptItems[v.slot] = v
						newWeight += v.weight
						goto foundItem
					end
				end

				if updateSlots then
					inc += 1
					updateSlots[inc] = { item = { slot = slot }, inventory = inv.id }
				end

				::foundItem::
			end
		end

		table.wipe(inv.items)
		inv.items = keptItems
	else
		if updateSlots then
			for slot in pairs(inv.items) do
				inc += 1
				updateSlots[inc] = { item = { slot = slot }, inventory = inv.id }
			end
		end

		table.wipe(inv.items)
	end

	inv.weight = newWeight
	inv.changed = true
	Losses.afterRemove(inv, lossSnap, { how = 'cleared', place = GetInvokingResource() or 'w_inventory' }, GetInvokingResource())
    Inventory.ReflectCash(inv)

	inv:syncSlotsWithClients(updateSlots, true)

	if not inv.player then
		if inv.open then
			local playerInv = Inventory(inv.open)

			if not playerInv then return end

			playerInv:closeInventory()
		end

		inv:openInventory(inv)

		return
	end

	if server.syncInventory then server.syncInventory(inv) end

	inv.weapon = nil
	inv.weaponUsage = { count = 0, hands = {}, primary = nil }
end

exports('ClearInventory', Inventory.Clear)

---@param inv inventory
---@return integer?
function Inventory.GetEmptySlot(inv)
	local inventory = Inventory(inv)

	if not inventory then return end

	local items = inventory.items

	for i = 1, inventory.slots do
		if not items[i] then
			return i
		end
	end
end

exports('GetEmptySlot', Inventory.GetEmptySlot)

---@param inv inventory
---@param itemName string
---@param metadata any
function Inventory.GetSlotForItem(inv, itemName, metadata)
	local inventory = Inventory(inv)
	local item = Items(itemName) --[[@as WServerItem?]]

	if not inventory or not item then return end

	metadata = assertMetadata(metadata)
	local items = inventory.items
	local emptySlot

	for i = 1, inventory.slots do
		local slotData = items[i]

		if item.stack and slotData and slotData.name == item.name and slotData.count < GetMaxStack(item.name) and metadataMatchForStack(slotData.metadata, metadata) then
			return i
		elseif not item.stack and not slotData and not emptySlot then
			emptySlot = i
		end
	end

	return emptySlot
end

exports('GetSlotForItem', Inventory.GetSlotForItem)

---@param inv inventory
---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem?
function Inventory.GetSlotWithItem(inv, itemName, metadata, strict)
	local inventory = Inventory(inv)
	local item = Items(itemName) --[[@as WServerItem?]]

	if not inventory or not item then return end

	metadata = assertMetadata(metadata)
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory.items) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
            if not Items.UpdateDurability(inventory, slotData, item, nil, os.time()) then
                return slotData
            end
		end
	end
end

exports('GetSlotWithItem', Inventory.GetSlotWithItem)

---@param inv inventory
---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number?
function Inventory.GetSlotIdWithItem(inv, itemName, metadata, strict)
	return Inventory.GetSlotWithItem(inv, itemName, metadata, strict)?.slot
end

exports('GetSlotIdWithItem', Inventory.GetSlotIdWithItem)

---@param inv inventory
---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return SlotWithItem[]?
function Inventory.GetSlotsWithItem(inv, itemName, metadata, strict)
	local inventory = Inventory(inv)
	local item = Items(itemName) --[[@as WServerItem?]]

	if not inventory or not item then return end

	metadata = assertMetadata(metadata)
	local response = {}
	local n = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory.items) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
            if not Items.UpdateDurability(inventory, slotData, item, nil, os.time()) then
                n += 1
                response[n] = slotData
            end
		end
	end

	return response
end

exports('GetSlotsWithItem', Inventory.GetSlotsWithItem)

---@param inv inventory
---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number[]?
function Inventory.GetSlotIdsWithItem(inv, itemName, metadata, strict)
	local items = Inventory.GetSlotsWithItem(inv, itemName, metadata, strict)

	if items then
		---@cast items +number[]
		for i = 1, #items do
			items[i] = items[i].slot
		end

		return items
	end
end

exports('GetSlotIdsWithItem', Inventory.GetSlotIdsWithItem)

---@param inv inventory
---@param itemName string
---@param metadata? any
---@param strict? boolean Strictly match metadata properties, otherwise use partial matching.
---@return number
function Inventory.GetItemCount(inv, itemName, metadata, strict)
	local inventory = Inventory(inv)
	local item = Items(itemName) --[[@as WServerItem?]]

	if not inventory or not item then return 0 end

	metadata = assertMetadata(metadata)
	local count = 0
	local tablematch = strict and table.matches or table.contains

	for _, slotData in pairs(inventory.items) do
		if slotData and slotData.name == item.name and (not metadata or tablematch(slotData.metadata, metadata)) then
			count += slotData.count
		end
	end

	return count
end

exports('GetItemCount', Inventory.GetItemCount)

---@alias InventorySaveData { [1]: MinimalInventorySlot, [2]: string | number, [3]: string | number | nil }

---@param inv WInventory
---@param buffer table
---@param time integer
---@return integer?
---@return InventorySaveData?
local isSaving = false
local inventoryClearTime = GetConvarInt('inventory:cleartime', 5) * 60

local function saveInventories(clearInventories)
    if isSaving then return false end
    isSaving = true
    local ok, err = xpcall(function()
        for _, inv in pairs(Inventories) do
            if not inv.datastore and inv.changed then Inventory.Save(inv) end
        end
        if clearInventories then
            local now = os.time()
            for _, inv in pairs(Inventories) do
                if not inv.open and not inv.player and not inv.changed then
                    if inv.type == 'glovebox' or inv.type == 'trunk' then
                        if NetworkGetEntityFromNetworkId(inv.netid) ~= inv.entityId then Inventory.Remove(inv) end
                    elseif now - inv.time >= inventoryClearTime then Inventory.Remove(inv) end
                end
            end
        end
    end, debug.traceback)
    isSaving = false
    if not ok then lib.print.error(err) end
    return ok
end

lib.cron.new('*/5 * * * *', function()
    saveInventories(true)
end)

function Inventory.SaveInventories(lock, clearInventories)
	Inventory.Lock = lock or nil

	Inventory.CloseAll()
    saveInventories(clearInventories)
end

AddEventHandler('playerDropped', function()
	server.playerDropped(source)

	if GetNumPlayerIndices() == 0 then
		Inventory.SaveInventories(false, true)
	end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	Inventory.SaveInventories(true, false)
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining ~= 60 then return end

	Inventory.SaveInventories(true, true)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == shared.resource then
		Inventory.SaveInventories(true, false)
	end
end)

RegisterServerEvent('w_inventory:closeInventory', function()
	local inventory = Inventories[source]

	if inventory?.open then
		local secondary = Inventories[inventory.open]

		if secondary then
			secondary:closeInventory()
		end

		inventory:closeInventory(true)
	end
end)

RegisterServerEvent('w_inventory:giveItem', function(slot, target, count)
	local fromInventory = Inventories[source]
	local toInventory = Inventories[target]

	-- ★ NaN passed `count <= 0` and `data.count < count`: the receiver got a NaN copy, the giver's
	--   RemoveItem(NaN) failed, and nothing rolled the copy back (see swapItems)
	count = tonumber(count)
	if not count or count ~= count or count == math.huge or count == -math.huge then return end
	if count <= 0 then count = 1 end
	if not fromInventory then return end

	if toInventory?.player then
		local data = fromInventory.items[slot]

		if not data then return end

		local item = Items(data.name)

		if not item or data.count < count or not Inventory.CanCarryItem(toInventory, item, count, data.metadata) or #(GetEntityCoords(fromInventory.player.ped) - GetEntityCoords(toInventory.player.ped)) > 15 then
			return TriggerClientEvent('w_inventory:notify', fromInventory.id, { type = 'error', key = 'cannot_give', args = { count, data.metadata?.label or { item = data.name } } })
		end

		local toSlot = Inventory.GetSlotForItem(toInventory, data.name, data.metadata)
		local fromRef = ('%s:%s'):format(fromInventory.id, slot)
		local toRef = ('%s:%s'):format(toInventory.id, toSlot)

		if activeSlots[fromRef] or activeSlots[toRef] then
			return TriggerClientEvent('w_inventory:notify', fromInventory.id, { type = 'error', key = 'cannot_give', args = { count, data.metadata?.label or { item = data.name } } })
		end

		activeSlots[fromRef] = coroutine.running()
		activeSlots[toRef] = coroutine.running()

		local _ <close> = defer(function()
			activeSlots[fromRef] = nil
			activeSlots[toRef] = nil
		end)

		if TriggerEventHooks('swapItems', {
			source = fromInventory.id,
			fromInventory = fromInventory.id,
			fromType = fromInventory.type,
			toInventory = toInventory.id,
			toType = toInventory.type,
			count = data.count,
			action = 'give',
			fromSlot = data,
		}) then
            if item.name == 'gold' then return end
            if item.name == 'money' or item.name == 'cash' then Inventory.TransferCash(fromInventory, toInventory, count); return end
			---@todo manually call swapItems or something?
			if Inventory.AddItem(toInventory, item, count, data.metadata, toSlot) then
				Losses.reason('give', Losses.actor(toInventory), 'player')
				if Inventory.RemoveItem(fromInventory, item, count, data.metadata, slot) then
					if server.loglevel > 0 then
						-- the receiver is picked by proximity (his server id); the log names him by his
						-- citizen id (the bag's owner), which still means him after he reconnects
						lib.logger(fromInventory.owner, 'giveItem', ('"%s" gave %sx %s to "%s" (%s)'):format(fromInventory.label, count, data.name, toInventory.label, toInventory.owner))
					end

					return
				end
			end
		end

		return TriggerClientEvent('w_inventory:notify', fromInventory.id, { type = 'error', key = 'cannot_give', args = { count, data.metadata?.label or { item = data.name } } })
	end
end)

local function nextAmmoRevision(metadata, supplied)
	local current = math.max(0, math.floor(tonumber(metadata._ammoRevision) or 0))
	supplied = tonumber(supplied)

	if supplied then
		supplied = math.max(0, math.floor(supplied))
		if supplied <= current then return nil, current end
		return supplied, current
	end

	-- Backward compatibility for integrations that do not send a revision.
	return current + 1, current
end

local function weaponAmmoIdentity(slotData, item)
	local special = slotData.metadata and slotData.metadata.specialAmmo
	local specialItem = type(special) == 'string' and Items(special) or nil
	local family = item.ammoFamily or item.ammoname
	local identity = specialItem and specialItem.ammoType

	if not identity and special ~= nil and family then
		local resolved = AmmoTypes.Resolve(family, special, function(name)
			return Items(name) ~= nil
		end)
		identity = resolved and resolved.ammo

		if not identity and type(special) == 'string'
			and special:lower() == tostring(family):lower() then
			local default = AmmoTypes.GetDefault(family)
			identity = default and default.ammo
		elseif not identity and type(special) == 'string' and special:upper():find('^AMMO_') then
			identity = special:upper()
		end
	end

	-- Unknown/stale metadata must not turn an otherwise normal revolver round
	-- into a fake ammo type. Fall back to the weapon's canonical native type.
	identity = identity or item.ammoType or item.ammoname

	return identity and tostring(identity):lower()
end

-- Weapon fire can be frequent, so persist it in one short debounced batch per
-- player instead of issuing a database query for every round. Disconnect and
-- shutdown handlers still save immediately through Inventory.Remove/SaveAll.
local weaponShotSavePending = {}

local function scheduleWeaponShotSave(inventory)
	local inventoryId = inventory.id

	if weaponShotSavePending[inventoryId] then return end
	weaponShotSavePending[inventoryId] = true

	SetTimeout(10000, function()
		weaponShotSavePending[inventoryId] = nil

		local current = Inventory(inventoryId)
		if current and current.changed then
			Inventory.Save(current)
		end
	end)
end

---Commit observed fire. Ammo and shot revisions make this idempotent even when
---a holster/reload callback overtakes the fire event on the network.
---This operation can only decrease ammunition and condition.
RegisterNetEvent('w_inventory:recordWeaponShot', function(firedSlot, ownerSlot,
	reportedAmmo, ammoRevision, shotRevision)
	local inventory = Inventory(source)
	if not inventory then return end

	firedSlot, ownerSlot = tonumber(firedSlot), tonumber(ownerSlot)
	if not firedSlot or not ownerSlot then return end

	local fired = inventory.items[firedSlot]
	local owner = inventory.items[ownerSlot]
	if not fired or not owner or not fired.metadata or not owner.metadata then return end

	local firedItem = Items(fired.name)
	local ownerItem = Items(owner.name)
	if not firedItem or not ownerItem or not firedItem.weapon or not ownerItem.weapon then return end

	local firedFamily = firedItem.ammoFamily or firedItem.ammoname
	local ownerFamily = ownerItem.ammoFamily or ownerItem.ammoname
	if not firedFamily or firedFamily ~= ownerFamily then return end

	-- Both references must belong to the authoritative hand state. A client may
	-- choose the matching ammo-pool owner for an identical pair, but it cannot
	-- debit a holstered inventory row or another unrelated weapon.
	local usage = Inventory.GetWeaponUsageState(inventory)
	local held = {}
	for i = 1, #(usage and usage.hands or {}) do
		held[tonumber(usage.hands[i].slot)] = true
	end
	if not held[firedSlot] or not held[ownerSlot] then return end

	-- The exact hand entity may fire another loaded AMMO_* pool when two
	-- identical weapon hashes are dual-wielded. VORP supports this and resolves
	-- the live type from that entity. Both rows are still server-authoritative,
	-- equipped, and in the same ammo family; this operation can only subtract,
	-- so requiring both metadata rows to advertise the same type would reject a
	-- legitimate shot without adding any security.

	local ammo = math.max(0, math.floor(tonumber(owner.metadata.ammo) or 0))
	local currentAmmoRevision = math.max(0, math.floor(tonumber(owner.metadata._ammoRevision) or 0))
	local currentShotRevision = math.max(0, math.floor(tonumber(fired.metadata._shotRevision) or 0))
	local previousOwnerWeight = tonumber(owner.weight) or Inventory.SlotWeight(ownerItem, owner)
	local previousFiredWeight = firedSlot ~= ownerSlot
		and (tonumber(fired.weight) or Inventory.SlotWeight(firedItem, fired)) or 0
	local shotCount = 1

	if shotRevision ~= nil then
		shotRevision = tonumber(shotRevision)
		if not shotRevision or shotRevision ~= shotRevision then return end
		shotRevision = math.max(0, math.floor(shotRevision))
		if shotRevision <= currentShotRevision then return end

		shotCount = shotRevision - currentShotRevision
		-- A legitimate client can only have a tiny in-flight burst. Reject large
		-- jumps rather than allowing a forged packet to destroy a weapon.
		if shotCount > 10 then return end
	else
		shotRevision = currentShotRevision + 1
	end

	reportedAmmo = tonumber(reportedAmmo)
	ammoRevision = tonumber(ammoRevision)

	if reportedAmmo ~= nil then
		if reportedAmmo ~= reportedAmmo then return end
		reportedAmmo = math.max(0, math.floor(reportedAmmo))
		if reportedAmmo > ammo then return end
	end

	if ammoRevision ~= nil then
		if ammoRevision ~= ammoRevision then return end
		ammoRevision = math.max(0, math.floor(ammoRevision))
	end

	-- If this event arrives first, commit its exact one-way decrease. If a
	-- newer persist callback already committed the same/later balance, leave
	-- ammo untouched and still apply the once-only weapon wear below.
	if ammoRevision and ammoRevision > currentAmmoRevision then
		local expected = math.max(0, ammo - shotCount)
		if reportedAmmo ~= expected then return end
		owner.metadata.ammo = reportedAmmo
		owner.metadata._ammoRevision = ammoRevision
	elseif not ammoRevision then
		if ammo < shotCount then return end
		owner.metadata.ammo = ammo - shotCount
		owner.metadata._ammoRevision = currentAmmoRevision + 1
	end

	fired.metadata._shotRevision = shotRevision
	fired.metadata.durability = math.max(0,
		(tonumber(fired.metadata.durability) or 100)
		- (math.max(0, tonumber(firedItem.durability) or 0) * shotCount))
	fired.metadata.weaponExpiry = os.time() + (7 * 24 * 60 * 60)

	owner.weight = Inventory.SlotWeight(ownerItem, owner)
	inventory.weight = math.max(0, (tonumber(inventory.weight) or 0) - previousOwnerWeight + owner.weight)

	if firedSlot ~= ownerSlot then
		fired.weight = Inventory.SlotWeight(firedItem, fired)
		inventory.weight = math.max(0, inventory.weight - previousFiredWeight + fired.weight)
	end

	inventory.changed = true
	scheduleWeaponShotSave(inventory)

	if fired.metadata.durability == 0 then
		TriggerClientEvent('w_inventory:weaponBroken', inventory.id, firedSlot)
	end
end)

local RDR_WEAPON_CAPACITY = {
	[`WEAPON_REVOLVER_CATTLEMAN`] = 6,
	[`WEAPON_REVOLVER_CATTLEMAN_MEXICAN`] = 6,
	[`WEAPON_REVOLVER_CATTLEMAN_JOHN`] = 6,
	[`WEAPON_REVOLVER_CATTLEMAN_PIG`] = 6,
	[`WEAPON_REVOLVER_DOUBLEACTION`] = 6,
	[`WEAPON_REVOLVER_DOUBLEACTION_GAMBLER`] = 6,
	[`WEAPON_REVOLVER_DOUBLEACTION_EXOTIC`] = 6,
	[`WEAPON_REVOLVER_DOUBLEACTION_MICAH`] = 6,
	[`WEAPON_REVOLVER_SCHOFIELD`] = 6,
	[`WEAPON_REVOLVER_SCHOFIELD_CALLOWAY`] = 6,
	[`WEAPON_REVOLVER_SCHOFIELD_GOLDEN`] = 6,
	[`WEAPON_REVOLVER_LEMAT`] = 9,
	[`WEAPON_REVOLVER_NAVY`] = 6,
	[`WEAPON_REVOLVER_NAVY_CROSSOVER`] = 6,
	[`WEAPON_PISTOL_VOLCANIC`] = 8,
	[`WEAPON_PISTOL_M1899`] = 8,
	[`WEAPON_PISTOL_MAUSER`] = 10,
	[`WEAPON_PISTOL_MAUSER_DRUNK`] = 10,
	[`WEAPON_PISTOL_SEMIAUTO`] = 8,
	[`WEAPON_REPEATER_CARBINE`] = 7,
	[`WEAPON_REPEATER_WINCHESTER`] = 14,
	[`WEAPON_REPEATER_HENRY`] = 16,
	[`WEAPON_REPEATER_EVANS`] = 26,
	[`WEAPON_RIFLE_VARMINT`] = 14,
	[`WEAPON_RIFLE_SPRINGFIELD`] = 1,
	[`WEAPON_RIFLE_BOLTACTION`] = 5,
	[`WEAPON_RIFLE_ELEPHANT`] = 2,
	[`WEAPON_SHOTGUN_DOUBLEBARREL`] = 2,
	[`WEAPON_SHOTGUN_DOUBLEBARREL_EXOTIC`] = 2,
	[`WEAPON_SHOTGUN_SAWEDOFF`] = 2,
	[`WEAPON_SHOTGUN04`] = 5,
	[`WEAPON_SHOTGUN05`] = 5,
	[`WEAPON_SHOTGUN_SEMIAUTO`] = 5,
	[`WEAPON_SHOTGUN_PUMP`] = 5,
	[`WEAPON_SHOTGUN_REPEATING`] = 6,
	[`WEAPON_SNIPERRIFLE_ROLLINGBLOCK`] = 1,
	[`WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC`] = 1,
	[`WEAPON_SNIPERRIFLE_CARCANO`] = 6,
	-- The bow does not pass through here: weaponCapacity settles it from Config.Ammo.BowCap before
	-- asking this table. The two entries were kept matching the cap so a later reader is not misled.
	[`WEAPON_BOW`] = 25,
	[`WEAPON_BOW_IMPROVED`] = 25,
}

RDR_DUAL_CAPABLE = {
	[`WEAPON_REVOLVER_CATTLEMAN`] = true,
	[`WEAPON_REVOLVER_CATTLEMAN_MEXICAN`] = true,
	[`WEAPON_REVOLVER_CATTLEMAN_JOHN`] = true,
	[`WEAPON_REVOLVER_CATTLEMAN_PIG`] = true,
	[`WEAPON_REVOLVER_CATTLEMAN_HIGHROLLER`] = true,
	[`WEAPON_REVOLVER_DOUBLEACTION`] = true,
	[`WEAPON_REVOLVER_DOUBLEACTION_EXOTIC`] = true,
	[`WEAPON_REVOLVER_DOUBLEACTION_GAMBLER`] = true,
	[`WEAPON_REVOLVER_DOUBLEACTION_MICAH`] = true,
	[`WEAPON_REVOLVER_SCHOFIELD`] = true,
	[`WEAPON_REVOLVER_SCHOFIELD_GOLDEN`] = true,
	[`WEAPON_REVOLVER_SCHOFIELD_CALLOWAY`] = true,
	[`WEAPON_REVOLVER_LEMAT`] = true,
	[`WEAPON_REVOLVER_NAVY`] = true,
	[`WEAPON_REVOLVER_NAVY_CROSSOVER`] = true,
	[`WEAPON_PISTOL_VOLCANIC`] = true,
	[`WEAPON_PISTOL_M1899`] = true,
	[`WEAPON_PISTOL_MAUSER`] = true,
	[`WEAPON_PISTOL_MAUSER_DRUNK`] = true,
	[`WEAPON_PISTOL_SEMIAUTO`] = true,
	[`WEAPON_SHOTGUN_SAWEDOFF`] = true,
}

-- The magazine cap - the very rule the client reads from the shared config.lua.
-- ! Their disagreeing means the reload is refused with no reason visible to the player.
local AMMO_CLIP_CAP = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.ClipCap) or 10))
local AMMO_BOW_CAP  = math.max(1, math.floor(tonumber(Config.Ammo and Config.Ammo.BowCap) or 25))

local function weaponCapacity(item)
	local hash = item and item.hash

	if hash == `WEAPON_BOW` or hash == `WEAPON_BOW_IMPROVED` then
		return AMMO_BOW_CAP
	end

	local configured = math.max(1, math.floor(tonumber(item and item.clipSize)
		or RDR_WEAPON_CAPACITY[hash] or AMMO_CLIP_CAP))

	return math.min(configured, AMMO_CLIP_CAP)
end

--- Require a two-slot ammo transaction to match the exact server-authoritative
--- used/used2 pair. Single-slot operations remain valid for holstered weapons.
---@param inventory WInventory
---@param slots table<number, boolean>
---@return boolean
local function isEquippedWeaponPair(inventory, slots)
	local state = Inventory.GetWeaponUsageState(inventory)
	if not state or state.count ~= 2 or type(state.hands) ~= 'table' then return false end

	local matched = 0
	for i = 1, #state.hands do
		local slot = tonumber(state.hands[i].slot)
		if not slot or not slots[slot] then return false end
		matched += 1
	end

	return matched == 2
end

local function validateReloadPool(inventory, primarySlot, primaryItem, poolSlots)
	local rows, seen = {}, {}
	local primaryFamily = primaryItem.ammoFamily or primaryItem.ammoname
	local primaryIdentity = weaponAmmoIdentity(inventory.items[primarySlot], primaryItem)

	if type(poolSlots) ~= 'table' then poolSlots = { primarySlot } end
	if #poolSlots < 1 or #poolSlots > 2 then return end

	for i = 1, #poolSlots do
		local slot = tonumber(poolSlots[i])
		if not slot or seen[slot] then return end
		seen[slot] = true

		local slotData = inventory.items[slot]
		local item = slotData and Items(slotData.name)
		if not slotData or not item or not item.weapon then return end
		if (item.ammoFamily or item.ammoname) ~= primaryFamily then return end
		if weaponAmmoIdentity(slotData, item) ~= primaryIdentity then return end
		if #poolSlots > 1 and (not RDR_DUAL_CAPABLE[primaryItem.hash]
			or not RDR_DUAL_CAPABLE[item.hash]) then return end

		rows[#rows + 1] = { slotData = slotData, item = item }
	end

	if not seen[primarySlot] then return end
	if #poolSlots == 2 and not isEquippedWeaponPair(inventory, seen) then return end

	local capacity = 0
	for i = 1, #rows do capacity = capacity + weaponCapacity(rows[i].item) end
	return capacity, rows
end

local function updateWeapon(source, action, value, slot, specialAmmo, ammoRevision, poolSlots)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
	local inventory = Inventories[source]

	if not inventory then return end

	if not action then
		return Inventory.SetWeaponUsageState(inventory, {}, false, false)
	end

	if action == 'equip' then
		slot = tonumber(slot)
		local equipped = slot and inventory.items[slot]
		local equippedItem = equipped and Items(equipped.name)

		if not equipped or not equippedItem or not equippedItem.weapon then return false end
		return Inventory.SetWeaponUsageState(inventory, {
			{ slot = slot, hand = 0, serial = equipped.metadata and equipped.metadata.serial }
		}, false, false)
	end

	local valueType = type(value)

	do
		if not slot then slot = inventory.weapon end
		local weapon = inventory.items[slot]

		if weapon and weapon.metadata then
			local item = Items(weapon.name)

			if not item.weapon then
				inventory.weapon = nil
				return
			end

			local previousWeight = tonumber(weapon.weight) or Inventory.SlotWeight(item, weapon)
			local additionalChanged = {}
			local linkedRevisions = {}

			local revision, currentRevision

			-- The reload rejections below all reach the player as one opaque
			-- "operation failed". Naming the cause under a convar turns the next
			-- report into a fact instead of a guess.
			--   setr w_inventory:ammodebug 1
			local function rejectLoad(reason, detail)
				if GetConvarInt('w_inventory:ammodebug', 0) == 1 then
					print(('^3[w_inventory/reload]^0 rejected: %s%s (action=%s slot=%s value=%s)')
						:format(reason, detail and (' — ' .. detail) or '',
							tostring(action), tostring(slot), tostring(value)))
				end
				return false, currentRevision
			end

			if action == 'load' or action == 'ammo' then
				revision, currentRevision = nextAmmoRevision(weapon.metadata, ammoRevision)
				if not revision then
					return rejectLoad('stale revision',
						('sent %s, server at %s'):format(tostring(ammoRevision), tostring(currentRevision)))
				end

				if type(value) ~= 'number' or value ~= value then return rejectLoad('value not a number') end
				value = math.floor(value)
				if value < 0 or value > 500 then return rejectLoad('value out of range') end
			end

			if action == 'status' then
				if valueType ~= 'table' then return false end

				local currentStatus = type(weapon.metadata.weaponStatus) == 'table'
					and weapon.metadata.weaponStatus or {}
				local function statusValue(field)
					local currentValue = tonumber(currentStatus[field]) or 0.0
					currentValue = math.max(0.0, math.min(1.0, currentValue))
					local nextValue = tonumber(value[field])
					if not nextValue or nextValue ~= nextValue then return currentValue end

					-- Client observations may only make a weapon dirtier. Cleaning is a
					-- separate server-authoritative transaction that consumes Gun Oil.
					nextValue = math.max(0.0, math.min(1.0, nextValue))
					return math.max(currentValue, nextValue)
				end

				weapon.metadata.weaponStatus = {
					degradation = statusValue('degradation'),
					damage = statusValue('damage'),
					dirt = statusValue('dirt'),
					soot = statusValue('soot'),
				}
				weapon.metadata.status = nil
			elseif action == 'load' and (weapon.metadata.durability or 0) > 0 then
				local ammoname = Items(weapon.name).ammoname
				local diff = value - math.max(0, math.floor(tonumber(weapon.metadata.ammo) or 0))
				local maxCapacity, reloadPool = validateReloadPool(inventory, weapon.slot, item, poolSlots)

				if not maxCapacity or value > maxCapacity then
					return rejectLoad('over capacity',
						('want %s, capacity %s'):format(tostring(value), tostring(maxCapacity)))
				end
				if diff <= 0 or diff > maxCapacity then
					return rejectLoad('bad diff',
						('want %s, stored %s, diff %s, capacity %s'):format(
							tostring(value), tostring(weapon.metadata.ammo), tostring(diff), tostring(maxCapacity)))
				end

				-- After the unification in items/shared.lua, ammoname became a real item name,
				-- and the catalogue's key is kept in ammoFamily. And specialAmmo may carry
				-- the bullet type or the item's name directly, and Resolve accepts both, so it deducts
				-- the type the player really loaded and not always the primary type.
				local function itemExists(name) return Items(name) ~= nil end

				local family = item.ammoFamily or ammoname
				local ammo = ammoname

				local entry = AmmoTypes.Resolve(family, specialAmmo, itemExists)
                -- A supplied item/type must belong to this weapon. Never consume a
                -- different default round while recording an incompatible selected type.
                if specialAmmo ~= nil and specialAmmo ~= false and not entry then return false, currentRevision end

				if entry then
					ammo = entry.item
				elseif not Items(ammo) then
					entry = AmmoTypes.GetDefault(family, itemExists)
					ammo = entry and entry.item
				end

				if not ammo then return false, currentRevision end

				local ammoItem = Items(ammo)

				-- Boxed bullets are not loaded; the box must be opened first
				if not ammoItem or not ammoItem.ammo or ammoItem.ammoFamily ~= family or ammoItem.ammoUnpack then return false, currentRevision end

				-- The frameworks that define every type as a separate item (VORP) do not set metadata.type,
				-- so passing specialAmmo as a filter makes the deduction fail
				local removeMeta = specialAmmo

				if ammoItem.ammoFamily then removeMeta = nil end

				-- ReassignAmmoPool has already moved the full balance to the selected
				-- slot. Every linked peer must therefore be empty before any rounds
				-- are consumed, keeping this operation transactional.
				for i = 1, #(reloadPool or {}) do
					local linked = reloadPool[i]
					if linked.slotData.slot ~= weapon.slot
						and (tonumber(linked.slotData.metadata.ammo) or 0) > 0 then
						return false, currentRevision
					end
				end

				-- Every loadable item = one round
				Losses.reason('skip') -- the rounds stay in his own weapon
				if not Inventory.RemoveItem(inventory, ammo, diff, removeMeta) then return false, currentRevision end

				weapon.metadata.ammo = value
				weapon.metadata.specialAmmo = specialAmmo
				weapon.metadata._ammoRevision = revision
				weapon.weight = Inventory.SlotWeight(item, weapon)

				-- A held pair represented one old engine pool. Change every linked
				-- zero-balance weapon to the selected type atomically, so the client
				-- and server continue to agree on the new shared pool.
				for i = 1, #(reloadPool or {}) do
					local linked = reloadPool[i]
					if linked.slotData.slot ~= weapon.slot then
						linked.slotData.metadata.specialAmmo = specialAmmo
						linked.slotData.metadata._ammoRevision =
							math.floor(tonumber(linked.slotData.metadata._ammoRevision) or 0) + 1
						linkedRevisions[linked.slotData.slot] = linked.slotData.metadata._ammoRevision
						additionalChanged[#additionalChanged + 1] = { item = linked.slotData }
					end
				end
			elseif action == 'throw' then
				if not item.throwable then return false end
				Losses.reason('thrown', Losses.actor(inventory), 'self')
				if not Inventory.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot) then return false end
			elseif action == 'ammo' then
				if value <= (tonumber(weapon.metadata.ammo) or 0) then
					weapon.metadata.ammo = value
					weapon.weight = Inventory.SlotWeight(item, weapon)
					-- Renewing the 7-day timer on use
					weapon.metadata.weaponExpiry = os.time() + (7 * 24 * 60 * 60)
				else
					return false, currentRevision
				end

				weapon.metadata._ammoRevision = revision
			elseif action == 'melee' then
				value = tonumber(value)
				if not value or value ~= value or value <= 0 or value > 100 then return false end
				weapon.metadata.durability = (tonumber(weapon.metadata.durability) or 100)
					- ((Items(weapon.name).durability or 1) * math.floor(value))
				-- Renewing the 7-day timer on use
				weapon.metadata.weaponExpiry = os.time() + (7 * 24 * 60 * 60)
			elseif action ~= 'throw' then
				return false
			end

            if (weapon.metadata.durability or 0) < 0 then
                weapon.metadata.durability = 0
            end

			-- Removing the weapon automatically when it breaks (firearm or melee)
			if weapon.metadata.durability == 0 then
				TriggerClientEvent('w_inventory:weaponBroken', inventory.id, weapon.slot)
			end

			if action ~= 'throw' then
				weapon.weight = Inventory.SlotWeight(item, weapon)
				inventory.weight = math.max(0, (tonumber(inventory.weight) or 0) - previousWeight + weapon.weight)
				inventory.changed = true

				local changed = { { item = weapon } }
				for i = 1, #additionalChanged do changed[#changed + 1] = additionalChanged[i] end
				inventory:syncSlotsWithPlayer(changed, inventory.weight)
			end

			if server.syncInventory then server.syncInventory(inventory) end

			return true, weapon.metadata._ammoRevision, linkedRevisions
		end
	end
end

local maintenanceLocks = {}
local maintenanceFields = { 'degradation', 'damage', 'dirt', 'soot' }

local function weaponMaintenanceConfig()
	local configured = Config and Config.WeaponMaintenance or {}
	return {
		enabled = configured.enabled ~= false,
		item = type(configured.item) == 'string' and configured.item or 'kit_gun_oil',
		consume = math.max(1, math.floor(tonumber(configured.consume) or 1)),
		restoreCondition = math.max(1, math.min(100, tonumber(configured.restoreCondition) or 100)),
		cleanDuration = math.max(800, math.floor(tonumber(configured.cleanDuration) or 2800)),
		dirtyThreshold = math.max(0.0, math.min(1.0, tonumber(configured.dirtyThreshold) or 0.01)),
	}
end

local function normalizedWeaponStatus(metadata, observed)
	local current = type(metadata.weaponStatus) == 'table' and metadata.weaponStatus or {}
	local status = {}

	for i = 1, #maintenanceFields do
		local field = maintenanceFields[i]
		local currentValue = tonumber(current[field]) or 0.0
		currentValue = math.max(0.0, math.min(1.0, currentValue))

		local observedValue = type(observed) == 'table' and tonumber(observed[field]) or nil
		if observedValue and observedValue == observedValue then
			-- A client can report game-engine wear, but it cannot report a lower
			-- value to clean a weapon without the maintenance transaction.
			observedValue = math.max(0.0, math.min(1.0, observedValue))
			currentValue = math.max(currentValue, observedValue)
		end

		status[field] = currentValue
	end

	return status
end

local function exactMaintenanceWeapon(inventory, slot, name, serial)
	slot = tonumber(slot)
	if not slot or slot % 1 ~= 0 then return nil end

	local weapon = inventory.items[slot]
	local item = weapon and Items(weapon.name)
	if not weapon or not item or not item.weapon or not weapon.metadata then return nil end
	if type(name) ~= 'string' or weapon.name ~= name then return nil end

	local storedSerial = weapon.metadata.serial or weapon.metadata.serial_number
	if storedSerial ~= nil then
		if serial == nil or tostring(storedSerial) ~= tostring(serial) then return nil end
	elseif serial ~= nil then
		return nil
	end

	return weapon, item
end

local function maintenanceState(inventory, weapon, config)
	local status = normalizedWeaponStatus(weapon.metadata)
	local condition = math.max(0, math.min(100, tonumber(weapon.metadata.durability) or 100))
	local worst = 0.0

	for i = 1, #maintenanceFields do
		worst = math.max(worst, status[maintenanceFields[i]])
	end

	local oil = Items(config.item)
	local oilCount = oil and Inventory.GetItemCount(inventory, config.item) or 0
	local broken = condition <= 0
	local needsCleaning = not broken
		and (condition < config.restoreCondition or worst > config.dirtyThreshold)

	return {
		condition = math.floor(condition * 10 + 0.5) / 10,
		degradation = status.degradation,
		damage = status.damage,
		dirt = status.dirt,
		soot = status.soot,
		cleanliness = math.floor((1.0 - math.max(status.dirt, status.soot)) * 1000 + 0.5) / 10,
		needsCleaning = needsCleaning,
		broken = broken,
		canClean = needsCleaning and oilCount >= config.consume,
		cleanDuration = config.cleanDuration,
		cleaningItem = {
			name = config.item,
			label = oil and oil.label or config.item,
			count = oilCount,
			required = config.consume,
			image = config.item .. '.png',
		},
	}
end

local function inspectMaintenanceState(source, slot, name, serial, observed)
	local inventory = Inventory(source)
	local config = weaponMaintenanceConfig()
	if not inventory or not config.enabled then return { ok = false, reason = 'disabled' } end

	local weapon = exactMaintenanceWeapon(inventory, slot, name, serial)
	if not weapon then return { ok = false, reason = 'invalid_weapon' } end

	local merged = normalizedWeaponStatus(weapon.metadata, observed)
	weapon.metadata.weaponStatus = merged
	weapon.metadata.status = nil
	inventory.changed = true

	return { ok = true, state = maintenanceState(inventory, weapon, config) }
end

lib.callback.register('w_inventory:getWeaponMaintenance', inspectMaintenanceState)

local function cleanMaintenanceWeapon(source, slot, name, serial, observed)
	local inventory = Inventory(source)
	local config = weaponMaintenanceConfig()
	if not inventory or not config.enabled then return { ok = false, reason = 'disabled' } end

	local weapon, item = exactMaintenanceWeapon(inventory, slot, name, serial)
	if not weapon then return { ok = false, reason = 'invalid_weapon' } end

	weapon.metadata.weaponStatus = normalizedWeaponStatus(weapon.metadata, observed)
	weapon.metadata.status = nil

	local state = maintenanceState(inventory, weapon, config)
	if state.broken then return { ok = false, reason = 'broken', state = state } end
	if not state.needsCleaning then return { ok = false, reason = 'not_needed', state = state } end
	if not state.canClean then return { ok = false, reason = 'missing_oil', state = state } end

	Losses.reason('used', Losses.actor(inventory), 'gun_oil')
	local removed = Inventory.RemoveItem(inventory, config.item, config.consume)
	if not removed then
		state = maintenanceState(inventory, weapon, config)
		return { ok = false, reason = 'missing_oil', state = state }
	end

	local previousWeight = tonumber(weapon.weight) or Inventory.SlotWeight(item, weapon)
	weapon.metadata.durability = config.restoreCondition
	weapon.metadata.weaponStatus = { degradation = 0.0, damage = 0.0, dirt = 0.0, soot = 0.0 }
	weapon.metadata.weaponExpiry = os.time() + (7 * 24 * 60 * 60)
	weapon.weight = Inventory.SlotWeight(item, weapon)
	inventory.weight = math.max(0, (tonumber(inventory.weight) or 0) - previousWeight + weapon.weight)
	inventory.changed = true
	inventory:syncSlotsWithPlayer({ { item = weapon } }, inventory.weight)

	if server.syncInventory then server.syncInventory(inventory) end
	if Inventory.Save then pcall(Inventory.Save, inventory) end

	return {
		ok = true,
		reason = 'cleaned',
		state = maintenanceState(inventory, weapon, config),
	}
end

lib.callback.register('w_inventory:cleanWeapon', function(source, slot, name, serial, observed)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
	if maintenanceLocks[source] then return { ok = false, reason = 'busy' } end
	maintenanceLocks[source] = true

	-- Always release the per-player transaction lock, even if an integration
	-- hook raises. A failed hook must not leave maintenance blocked until restart.
	local ok, response = xpcall(cleanMaintenanceWeapon, function(err)
		return tostring(err)
	end, source, slot, name, serial, observed)
	maintenanceLocks[source] = nil

	if not ok then
		print(('[w_inventory] weapon maintenance transaction failed for source %s: %s')
			:format(tostring(source), response))
		return { ok = false, reason = 'server_error' }
	end

	return response
end)

AddEventHandler('playerDropped', function()
	maintenanceLocks[source] = nil
end)

--- Setting the ammunition balance for several weapon slots at once.
---
--- It is needed for carrying two identical weapons: RDR3 stores the ammunition per weapon hash and not per
--- item, so the two weapons are forced to share one pool. We gather it into one slot and zero
--- the other - so the balance is not counted twice and none of it is lost.
---@param source number
---@param updates table<number, number> [slot] = ammo
---@return table<number, number>|false revisions
lib.callback.register('w_inventory:syncDualAmmo', function(source, updates)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
	local inventory = Inventory(source)

	if not inventory or type(updates) ~= 'table' then return false end

	local changed, rows, count = {}, {}, 0
	local currentTotal, requestedTotal, ammoFamily, ammoIdentity = 0, 0

	for slot, ammo in pairs(updates) do
		count += 1
		if count > 2 then return false end

		slot = tonumber(slot)
		ammo = tonumber(ammo)

		if not slot or not ammo or ammo ~= ammo then return false end
		ammo = math.floor(ammo)
		if ammo < 0 or ammo > 500 then return false end

		local slotData = inventory.items[slot]

		if slotData then
			local item = Items(slotData.name)

			if item and item.weapon then
				local family = item.ammoFamily or item.ammoname
				if not family or (ammoFamily and family ~= ammoFamily) then return false end
				ammoFamily = family

				-- A family contains normal, express, high-velocity and explosive
				-- rounds. Dual-wield redistribution is only valid for the exact
				-- live RDR ammo type; otherwise a forged request could silently
				-- convert one special-ammo type into another.
				local identity = weaponAmmoIdentity(slotData, item)
				if not identity then return false end

				if ammoIdentity and identity ~= ammoIdentity then return false end
				ammoIdentity = identity
				currentTotal += math.max(0, math.floor(tonumber(slotData.metadata.ammo) or 0))
				requestedTotal += ammo
				rows[#rows + 1] = { slotData = slotData, ammo = ammo }
			else
				return false
			end
		else
			return false
		end
	end

	if #rows == 0 or requestedTotal > currentTotal then return false end

	if #rows == 2 then
		local slots = {}
		for i = 1, #rows do slots[tonumber(rows[i].slotData.slot)] = true end
		if not isEquippedWeaponPair(inventory, slots) then return false end
	end

	local revisions = {}

	for i = 1, #rows do
		local row = rows[i]
		local slotData = row.slotData
		local item = Items(slotData.name)
		local previousWeight = tonumber(slotData.weight) or Inventory.SlotWeight(item, slotData)
		slotData.metadata.ammo = row.ammo
		slotData.metadata._ammoRevision = math.floor(tonumber(slotData.metadata._ammoRevision) or 0) + 1
		slotData.weight = Inventory.SlotWeight(item, slotData)
		inventory.weight = math.max(0, (tonumber(inventory.weight) or 0) - previousWeight + slotData.weight)
		revisions[slotData.slot] = slotData.metadata._ammoRevision
		changed[i] = { item = slotData }
	end

	inventory:syncSlotsWithPlayer(changed, inventory.weight)
	inventory.changed = true

	if server.syncInventory then server.syncInventory(inventory) end

	return revisions
end)

--- Packing single bullets into boxes, or opening a box into single bullets.
--- The server alone verifies and converts; the client only asks for the slot.
---@param source number
---@param slot number
---@return boolean success, string? reason, number? amount
local AmmoExchange = require('modules.inventory.ammo_exchange').new({
    inventory = Inventory,
    item = Items,
    now = GetGameTimer,
    encode = json.encode,
    weight = Inventory.SlotWeight,
    maxStack = GetMaxStack,
    matches = metadataMatchForStack,
    metadata = function(inv, item) return (Items.Metadata(inv.id, item, {}, 1)) end,
    error = function(err) warn('Ammo conversion failed: ' .. tostring(err)) end,
    publish = function(inv, plan, original, output, operationId)
        local updates = {}
        for slot in pairs(plan.changes) do updates[#updates + 1] = { item = inv.items[slot] or { slot = slot }, inventory = inv.id } end
        inv:syncSlotsWithClients(updates, true)
        TriggerClientEvent('w_inventory:itemNotify', inv.id, { original, 'ui_removed', plan.removed })
        TriggerClientEvent('w_inventory:itemNotify', inv.id, { { name = output.name, label = output.label }, 'ui_added', plan.added })
        if inv.player and server.syncInventory then server.syncInventory(inv) end
        if server.loglevel > 0 then
            lib.logger(inv.owner, 'ammoExchange', ('%s %s: %d %s -> %d %s'):format(operationId, plan.kind,
                plan.removed, original.name, plan.added, output.name))
        end
    end,
})
lib.callback.register('w_inventory:prepareAmmoPack', function(source, slot)
    if shared.nativeRsgWeapons then return nil end
    return AmmoExchange.prepare(source, slot)
end)
lib.callback.register('w_inventory:packAmmo', function(source, slot, operationId)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
    return AmmoExchange.execute(source, slot, operationId)
end)
AddEventHandler('playerDropped', function() AmmoExchange.clear(source) end)

lib.callback.register('w_inventory:setWeaponUsageState', function(source, state)
	return Inventory.SetWeaponUsageState(source, state, true, false)
end)

lib.callback.register('w_inventory:updateWeapon', updateWeapon)

RegisterNetEvent('w_inventory:updateWeapon', function(action, value, slot, specialAmmo, ammoRevision, poolSlots)
	updateWeapon(source, action, value, slot, specialAmmo, ammoRevision, poolSlots)
end)

lib.callback.register('w_inventory:removeAmmoFromWeapon', function(source, slot)
    if shared.nativeRsgWeapons then return false, 'native_weapon_engine' end
	local inventory = Inventory(source)

	if not inventory then return end

	local slotData = inventory.items[slot]

	if not slotData or not slotData.metadata.ammo or slotData.metadata.ammo < 1 then return end

	local item = Items(slotData.name)

	if not item or not item.ammoname then return end

	-- We give back the item that was really loaded. In the frameworks that define every type as a separate item
	-- (VORP), specialAmmo carries the item's name, so returning it as metadata produces a deformed
	-- stack of the primary type that does not merge with the player's bullets.
	local special = slotData.metadata.specialAmmo
	local ammoName, metadata = item.ammoname, nil

	if type(special) == 'string' and Items(special)?.ammoFamily then
		ammoName = special
	elseif special then
		metadata = { type = special }
	end

	local ammoItem = Items(ammoName)
	if not ammoItem or ammoItem.ammoUnpack then return end

	-- Every loadable ammo item is one physical round. Boxes are deliberately
	-- rejected above and must be unpacked first, so unloading can never round a
	-- partial box up and mint ammunition.
	local itemsToReturn = math.max(0, math.floor(tonumber(slotData.metadata.ammo) or 0))
	local previousWeight = tonumber(slotData.weight) or Inventory.SlotWeight(item, slotData)

	if itemsToReturn > 0 and Inventory.AddItem(inventory, ammoName, itemsToReturn, metadata) then
		slotData.metadata.ammo = 0
		slotData.metadata.specialAmmo = nil
		slotData.metadata._ammoRevision = math.floor(tonumber(slotData.metadata._ammoRevision) or 0) + 1
		slotData.weight = Inventory.SlotWeight(item, slotData)
		inventory.weight = math.max(0,
			(tonumber(inventory.weight) or 0) - previousWeight + slotData.weight)
		inventory.changed = true

		inventory:syncSlotsWithPlayer({
			{ item = slotData }
		}, inventory.weight)

		if server.syncInventory then server.syncInventory(inventory) end

		return true, slotData.metadata._ammoRevision
	end
end)

local function checkStashProperties(properties)
	local name, slots, maxWeight, coords in properties

	if type(name) ~= 'string' then
		error(('received %s for stash name (expected string)'):format(type(name)))
	end

	if type(slots) ~= 'number' then
		error(('received %s for stash slots (expected number)'):format(type(slots)))
	end

	if type(maxWeight) ~= 'number' then
		error(('received %s for stash maxWeight (expected number)'):format(type(maxWeight)))
	end

	if coords then
		local typeof = type(coords)

		if typeof ~= 'vector3' then
			if typeof == 'table' and table.type(coords) ~= 'array' then
				coords = vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
			else
				if table.type(coords) == 'array' then
					for i = 1, #coords do
						coords[i] = vec3(coords[i].x, coords[i].y, coords[i].z)
					end
				else
					error(('received %s for stash coords (expected vector3 or array of vector3)'):format(typeof))
				end
			end
		end
	end

	return name, slots, maxWeight, coords
end

---@param name string stash identifier when loading from the database
---@param label string display name when inventory is open
---@param slots number
---@param maxWeight number
---@param owner? string|number|boolean
---@param groups? table<string, number>
---@param coords? vector3|table<vector3>
--- For simple integration with other resources that want to create valid stashes.
--- This needs to be triggered before a player can open a stash.
--- ```
--- Owner sets the stash permissions.
--- string: can only access the stash linked to the owner (usually player identifier)
--- true: each player has a unique stash, but can request other player's stashes
--- nil: always shared
---
--- groups: { ['police'] = 0 }
--- ```
local function registerStash(name, label, slots, maxWeight, owner, groups, coords)
	name, slots, maxWeight, coords = checkStashProperties({
		name = name,
		slots = slots,
		maxWeight = maxWeight,
		coords = coords,
	})

	local curStash = RegisteredStashes[name]

	if curStash then
		---@todo creating proper stash classes with inheritence would simplify updating data
		---i.e. all stashes with the same type share groups, maxweight, slots, dbid, etc.
		---only label, owner, weight, coords, and items really need to vary
		for _, stash in pairs(Inventories) do
			if stash.type == 'stash' and stash.dbId == name then
				stash.label = label or stash.label
				stash.owner = (owner and owner ~= true) and stash.owner or owner
				stash.slots = slots or stash.slots
				stash.maxWeight = maxWeight or stash.maxWeight
				stash.groups = groups or stash.groups
				stash.coords = coords or stash.coords
			end
		end
	end

	RegisteredStashes[name] = {
		name = name,
		label = label,
		owner = owner,
		slots = slots,
		maxWeight = maxWeight,
		groups = groups,
		coords = coords
	}
end

exports('RegisterStash', registerStash)

-- Read-only catalogue for centralized administration and compatibility
-- bridges. Returning a sanitized copy keeps the internal registry private and
-- also exposes empty stashes that do not have a database row yet.
exports('GetRegisteredStashes', function()
	local stashes = {}

	for id, stash in pairs(RegisteredStashes) do
		stashes[id] = {
			name = stash.name or id,
			label = stash.label or stash.name or id,
			owner = stash.owner,
			slots = stash.slots,
			maxWeight = stash.maxWeight,
		}
	end

	return stashes
end)

--- Drop the registrations `match(name)` picks: a deleted character's own stashes, whose name
--- carries its id ('policestash_<id>', 'stable_<key>_<id>'; PurgeCharacter, server_purge.lua).
--- Left here, a reader of GetRegisteredStashes would load the purged stash again and its next
--- save would bring the row back under the number. A per-player definition (owner = true, such as
--- 'policelocker') is shared by everyone and is never dropped. Opening the stash registers it
--- again (the RSG bridge's OpenInventory). Returns how many were dropped.
---@param match fun(name: string): boolean
---@return integer
function Inventory.ForgetRegisteredStashes(match)
	local dropped = 0

	for name, stash in pairs(RegisteredStashes) do
		-- assigning nil to a visited key is allowed while traversing
		if stash.owner ~= true and match(name) then
			RegisteredStashes[name] = nil
			dropped = dropped + 1
		end
	end

	return dropped
end

--- The registrations of a character that moved to another citizen id (w_core Reassign /
--- TransferNumber, server_purge.lua): `rename(name)` gives the new name of one named after the
--- old number ('policestash_<id>', 'stable_<key>_<id>'; nil = not its own), and one owned by the
--- old number (owner = '<id>') is owned by the new one. The rows moved the same way: left here, a
--- reader of GetRegisteredStashes would open the old name, which is the next holder's by then.
--- A per-player definition (owner = true) is shared by everyone and never renamed.
---@param rename fun(name: string): string?
---@return integer moved
function Inventory.MoveRegisteredStashes(rename, old, new)
	local renames, moved = {}, 0

	for name, stash in pairs(RegisteredStashes) do
		if stash.owner ~= nil and stash.owner ~= true and stash.owner ~= false and tostring(stash.owner) == old then
			stash.owner = new
			moved = moved + 1
		end
		local to = stash.owner ~= true and rename(name)
		if to and to ~= name then renames[name] = to end
	end

	-- applied after the traversal: adding keys while traversing is not allowed
	for name, to in pairs(renames) do
		local stash = RegisteredStashes[name]
		RegisteredStashes[name] = nil
		stash.name = to
		RegisteredStashes[to] = stash
		moved = moved + 1
	end

	return moved
end

---@param properties TemporaryStashProperties
function Inventory.CreateTemporaryStash(properties)
	properties.name = generateInvId('temp')

	local name, slots, maxWeight, coords = checkStashProperties(properties)
	local inventory = Inventory.Create(name, properties.label, 'temp', slots, 0, maxWeight, properties.owner, {}, properties.groups)

	if not inventory then return end

	inventory.items, inventory.weight = generateItems(inventory, 'drop', properties.items)
	inventory.coords = coords

	return inventory.id
end

exports('CreateTemporaryStash', Inventory.CreateTemporaryStash)

function Inventory.InspectInventory(playerId, invId)
	local inventory = invId ~= playerId and Inventory(invId)
	local playerInventory = Inventory(playerId)

	if playerInventory and inventory then
		playerInventory:openInventory(inventory)
		TriggerClientEvent('w_inventory:viewInventory', playerId, playerInventory, inventory)
	end
end

exports('InspectInventory', Inventory.InspectInventory)

-- ================================================================
-- The drops' expiry system
-- Deleting the drops after one hour
-- The money goes to the server's safe (money_safe)
-- ================================================================
local DROP_EXPIRY_SECONDS = 3600 -- one hour
local DROP_CHECK_INTERVAL = 300000 -- 5 minutes in milliseconds

-- Expiry returns the existing escrow balance; it never credits money from item metadata.
local function expireDrop(dropId)
    local inv = Inventories[dropId]
    if not inv or not Inventory.ReclaimCash(inv) then return false end
    return Inventory.Remove(dropId) == true
end

-- Clearing every existing drop when the resource starts
CreateThread(function()
	Wait(5000) -- wait 5 seconds after the resource starts
	local now = os.time()
	for dropId, dropData in pairs(Inventory.Drops) do
		if not dropData.createdAt then
			dropData.createdAt = now
		end
	end
	lib.print.info(('[w_inventory] set creation time for %d existing drops'):format(#Inventory.Drops or 0))
end)

-- A periodic check to delete the expired drops
CreateThread(function()
	while true do
		Wait(DROP_CHECK_INTERVAL)
		local now = os.time()
		local expiredDrops = {}

		for dropId, dropData in pairs(Inventory.Drops) do
			local createdAt = dropData.createdAt or 0
			if (now - createdAt) >= DROP_EXPIRY_SECONDS then
				table.insert(expiredDrops, dropId)
			end
		end

		local removed = 0
        for _, dropId in ipairs(expiredDrops) do
            if expireDrop(dropId) then removed = removed + 1 end
        end

		if removed > 0 then
			lib.print.info(('[w_inventory] deleted %d expired drops'):format(removed))
		end
	end
end)

return Inventory
