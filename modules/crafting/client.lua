if not lib then return end

local CraftingBenches = {}
local Items = require 'modules.items.client'
local Utils = require 'modules.utils.client'

-- every bench blip with the data it was built from, so a language switch can rebuild it
local benchBlips = {}

---@param coords vector3
---@param blip { id: string | number, colour?: string, scale?: number }
---@param label string? a dictionary key (or a plain name) from the data file
---@return integer | false
local function createBenchBlip(coords, blip, label)
	return w.blip.create(coords, locale(label or 'crafting_bench'), blip.id, nil, blip.colour, blip.scale)
end

---@param id number
---@param data table
local function createCraftingBench(id, data)
	CraftingBenches[id] = {}
	local recipes = data.items

	if recipes then
		data.slots = #recipes

		for i = 1, data.slots do
			local recipe = recipes[i]
			local item = Items[recipe.name]

			if item then
				recipe.weight = item.weight
				recipe.slot = i
			else
				warn(('failed to setup crafting recipe (bench: %s, slot: %s) - item "%s" does not exist'):format(id, i, recipe.name))
			end
		end

		local blip = data.blip

		-- the prompt path is the only interaction: a bench is a point (its zones list is ignored)
		data.zones = nil

		if data.points then
			for i = 1, #data.points do
				local coords = data.points[i]

				-- the walk-up prompt: J opens the bench's recipes
				Utils.Place({
					coords = coords,
					marker = { r = 242, g = 242, b = 242 }, -- paper: world marks are white, never a hue
					prompts = {
						{
							key = 'J',
							label = function() return locale('open_crafting_bench') end,
							onComplete = function()
								client.openInventory('crafting', { id = id, index = i })
							end,
						},
					},
				})

				if blip then
					benchBlips[#benchBlips + 1] = {
						handle = createBenchBlip(coords, blip, data.label),
						coords = coords,
						blip = blip,
						label = data.label,
					}
				end
			end
		end

		CraftingBenches[id] = data
	end
end

for id, data in pairs(lib.load('data.crafting')) do createCraftingBench(id, data) end

--- Blip names are baked at creation: client.lua calls this after a language switch, once
--- the dictionary is reloaded.
function shared.relocalizeCraftingBlips()
	for i = 1, #benchBlips do
		local entry = benchBlips[i]

		if entry.handle then RemoveBlip(entry.handle) end
		entry.handle = createBenchBlip(entry.coords, entry.blip, entry.label)
	end
end

return CraftingBenches
