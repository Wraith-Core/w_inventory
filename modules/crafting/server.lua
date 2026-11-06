if not lib then return end

local CraftingBenches = {}
local Items = require 'modules.items.server'
local Inventory = require 'modules.inventory.server'
local Losses = require 'modules.losses.server'

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local recipes = data.items

	if recipes then
		for i = 1, #recipes do
			local recipe = recipes[i]
			local item = Items(recipe.name)

			if item then
				recipe.weight = item.weight
				recipe.slot = i
			else
				warn(('failed to setup crafting recipe (bench: %s, slot: %s) - item "%s" does not exist'):format(id, i, recipe.name))
			end

			for ingredient, needs in pairs(recipe.ingredients) do
				if needs < 1 then
					item = Items(ingredient)

					if item and not item.durability then
						item.durability = true
					end
				end
			end
		end

		-- benches are points (the prompt path); a zones list in the data file is ignored
		data.zones = nil

		CraftingBenches[id] = data
	end
end

for id, data in pairs(lib.load('data.crafting')) do createCraftingBench(id, data) end

---falls back to player coords if the bench has no points
---@param source number
---@param bench table
---@param index number
---@return vector3
local function getCraftingCoords(source, bench, index)
	if not bench.points then
		return GetEntityCoords(GetPlayerPed(source))
	end

	return bench.points[index]
end

lib.callback.register('w_inventory:openCraftingBench', function(source, id, index)
	local left, bench = Inventory(source), CraftingBenches[id]

	if not left then return end

	if bench then
		local groups = bench.groups
		local coords = getCraftingCoords(source, bench, index)

		if not coords then return end

		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		if left.open and left.open ~= source then
			local inv = Inventory(left.open) --[[@as WInventory]]

			-- Why would the player inventory open with an invalid target? Can't repro but whatever.
			if inv?.player then
				inv:closeInventory()
			end
		end

		left:openInventory(left)
	end

	return { label = left.label, type = left.type, slots = left.slots, weight = left.weight, maxWeight = left.maxWeight }
end)

local TriggerEventHooks = require 'modules.hooks.server'

local function craftItem(source, id, index, recipeId, toSlot)
	local left, bench = Inventory(source), CraftingBenches[id]

	if not left then return end

	if bench then
		local groups = bench.groups
		local coords = getCraftingCoords(source, bench, index)

		if not coords then return false end
		if groups and not server.hasGroup(left, groups) then return end
		if #(GetEntityCoords(GetPlayerPed(source)) - coords) > 10 then return end

		local recipe = bench.items[recipeId]

		if recipe then
			local tbl, num = {}, 0

			for name in pairs(recipe.ingredients) do
				num += 1
				tbl[num] = name
			end

			local craftedItem = Items(recipe.name)
			local craftCount = (type(recipe.count) == 'number' and recipe.count) or (table.type(recipe.count) == 'array' and math.random(recipe.count[1], recipe.count[2])) or 1
			local newWeight = left.weight + (craftedItem.weight + (recipe.metadata?.weight or 0)) * craftCount
			---@todo new iterator or something to accept a map
			local items = Inventory.Search(left, 'slots', tbl) or {}
			table.wipe(tbl)

			for name, needs in pairs(recipe.ingredients) do
				local slots = items[name] or items

				for i = 1, #slots do
					local slot = slots[i]

					if needs == 0 then
						if not slot.metadata.durability or slot.metadata.durability > 0 then
							break
						end
					elseif needs < 1 then
						local item = Items(name)
						local durability = slot.metadata.durability

						if durability and durability >= needs * 100 then
							if durability > 100 then
								local degrade = (slot.metadata.degrade or item.degrade) * 60
								local percentage = ((durability - os.time()) * 100) / degrade

								if percentage >= needs * 100 then
									tbl[slot.slot] = needs
									break
								end
							else
								tbl[slot.slot] = needs
								break
							end
						end
					elseif needs <= slot.count then
						local itemWeight = slot.weight / slot.count
						newWeight = (newWeight - slot.weight) + (slot.count - needs) * itemWeight
						tbl[slot.slot] = needs
						break
					else
						tbl[slot.slot] = slot.count
						newWeight -= slot.weight
						needs -= slot.count
					end

					if needs == 0 then break end
					-- Player does not have enough items (ui should prevent crafting if lacking items, so this shouldn't trigger)
					if needs > 0 and i == #slots then return end
				end
			end

			if newWeight > left.maxWeight then
				return false, 'cannot_carry'
			end

			if not TriggerEventHooks('craftItem', {
				source = source,
				benchId = id,
				benchIndex = index,
				recipe = recipe,
				toInventory = left.id,
				toSlot = toSlot,
			}) then return false end

            local duration = tonumber(recipe.duration) or 3000
            if duration ~= duration or duration < 0 or duration > 3600000 then return false end
            local expected = {}
            for slot in pairs(tbl) do
                local item = left.items[slot]
                if not item then return false end
                expected[slot] = { name = item.name, metadata = json.encode(item.metadata or {}) }
            end
            local startedAt = GetGameTimer()
            local success = lib.callback.await('w_inventory:startCrafting', source, id, recipeId)
            -- A client progress bar is presentation, never proof that the recipe's time elapsed.
            if success and GetGameTimer() - startedAt < duration then return false end
            if Inventory(source) ~= left or not getCraftingCoords(source, bench, index)
                or #(GetEntityCoords(GetPlayerPed(source)) - getCraftingCoords(source, bench, index)) > 10
                or (groups and not server.hasGroup(left, groups)) then return false end
            for slot, original in pairs(expected) do
                local item = left.items[slot]
                if not item or item.name ~= original.name or json.encode(item.metadata or {}) ~= original.metadata then return false end
                if tbl[slot] >= 1 and item.count < tbl[slot] then return false end
            end

			if success then
				for name, needs in pairs(recipe.ingredients) do
                    if Inventory.GetItem(left, name, nil, true) < math.max(needs, 1) then return false end
                    if needs == 0 then
                        local usable = false
                        for _, slot in pairs(Inventory.Search(left, 'slots', name) or {}) do
                            local durability=slot.metadata and slot.metadata.durability
                            if not durability or (durability<=100 and durability>0) or durability>os.time() then usable = true break end
                        end
                        if not usable then return false end
                    end
				end

				for slot, count in pairs(tbl) do
					local invSlot = left.items[slot]

					if not invSlot then return end

					if count < 1 then
						local item = Items(invSlot.name)
						local durability = invSlot.metadata.durability or 100

						if durability > 100 then
							local degrade = (invSlot.metadata.degrade or item.degrade) * 60
							durability -= degrade * count
						else
							durability -= count * 100
						end

						if invSlot.count > 1 then
							local emptySlot = Inventory.GetEmptySlot(left)

							if emptySlot then
								local newItem = Inventory.SetSlot(left, item, 1, table.deepclone(invSlot.metadata), emptySlot)

								if newItem then
                                    Items.UpdateDurability(left, newItem, item, durability < 0 and 0 or durability)
								end
							end

							invSlot.count -= 1
						else
                            Items.UpdateDurability(left, invSlot, item, durability < 0 and 0 or durability)
						end
					else
						if invSlot then Losses.reason('craft', Losses.actor(left), 'crafting') end
						local removed = invSlot and Inventory.RemoveItem(left, invSlot.name, count, nil, slot)
						-- Failed to remove item (inventory state unexpectedly changed?)
						if not removed then return end
					end
				end

				Inventory.AddItem(left, craftedItem, craftCount, recipe.metadata or {}, craftedItem.stack and toSlot or nil)
			end

			return success
		end
	end
end

local craftingBusy, lastCraft = {}, {}
lib.callback.register('w_inventory:craftItem', function(source, id, index, recipeId, toSlot)
    local now = GetGameTimer()
    if craftingBusy[source] or (lastCraft[source] and now - lastCraft[source] < 500) then return false end
    if type(recipeId) ~= 'number' or recipeId % 1 ~= 0 or recipeId < 1 then return false end
    if toSlot ~= nil and (type(toSlot) ~= 'number' or toSlot % 1 ~= 0 or toSlot < 1 or toSlot > 1000) then return false end
    craftingBusy[source], lastCraft[source] = true, now
    local result = table.pack(pcall(craftItem, source, id, index, recipeId, toSlot))
    craftingBusy[source] = nil
    if not result[1] then print('^1[w_inventory] Craft request failed safely^0'); return false end
    return table.unpack(result, 2, result.n)
end)
AddEventHandler('playerDropped', function() craftingBusy[source], lastCraft[source] = nil, nil end)
