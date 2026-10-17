if not lib then return end

local shopTypes = {}
local shops = {}
local Utils = require 'modules.utils.client'

--- Map blip for a shop location, drawn by the library.
---@param blip { id: string | number, colour?: string, scale?: number }
---@param name string
---@param coords vector3
---@return integer | false
local function createBlip(blip, name, coords)
	return w.blip.create(coords, name, blip.id, nil, blip.colour or 'BLIP_MODIFIER_MP_COLOR_32', blip.scale)
end

for shopType, shopData in pairs(lib.load('data.shops') --[[@as table<string, WShop>]]) do
	shopTypes[shopType] = {
		name = shopData.name,
		groups = shopData.groups or shopData.jobs,
		blip = shopData.blip,
		label = shopData.label,
		icon = shopData.icon,
		locations = shopData.locations,
	}
end

--- The shop's name in the player's language: the data file gives a dictionary key (label)
--- or a plain name; locale() hands a plain name back untouched.
---@param shop { label?: string, name?: string }
---@param shopType string
---@return string
local function shopName(shop, shopType)
	return locale(shop.label or shop.name or shopType)
end

local function hasShopAccess(shop)
	return not shop.groups or client.hasGroup(shop.groups)
end

local function wipeShops()
	for i = 1, #shops do
		local shop = shops[i]

		if shop.remove then shop.remove() end

		if shop.blip then
			RemoveBlip(shop.blip)
		end
	end

	table.wipe(shops)
end

local function refreshShops()
	wipeShops()

	local id = 0

	for type, shop in pairs(shopTypes) do
		local blip = shop.blip

		if shop.locations and hasShopAccess(shop) then
			for i = 1, #shop.locations do
				local coords = shop.locations[i]
				id += 1

				-- the walk-up prompt: J opens the shop's page
				local place = Utils.Place({
					coords = coords,
					marker = { r = 242, g = 242, b = 242 }, -- paper: world marks are white, never a hue
					prompts = {
						{
							key = 'J',
							label = function() return locale('open_label', shopName(shop, type)) end,
							onComplete = function()
								client.openInventory('shop', { id = i, type = type })
							end,
						},
					},
				})

				place.blip = blip and createBlip(blip, shopName(shop, type), coords)
				shops[id] = place
			end
		end
	end
end

return {
	refreshShops = refreshShops,
	wipeShops = wipeShops,
}
