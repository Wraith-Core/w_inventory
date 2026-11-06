if not lib then return end

local Items = require 'modules.items.server'
local Inventory = require 'modules.inventory.server'
local Losses = require 'modules.losses.server'
local Shops = {}

---@class WShopItem
---@field slot number
---@field weight number

local function setupShopItems(id, shopType, shopName, groups)
	local shop = id and Shops[shopType][id] or Shops[shopType] --[[@as WShop]]

	for i = 1, shop.slots do
		local slot = shop.items[i]

		if slot.grade and not groups then
			slot.grade = nil
		end

		local Item = Items(slot.name)

		if Item then
			-- Resolving the price from prices.lua through w_economy if a priceKey exists
			local resolvedPrice = slot.price or 0
			if slot.priceKey and GetResourceState('w_economy') == 'started' then
				local bpPrice = exports.w_economy:GetActionPrice(slot.priceKey)
				if bpPrice and bpPrice > 0 then
					resolvedPrice = bpPrice
				end
			end

			---@type WShopItem
			slot = {
				name = Item.name,
				slot = i,
				weight = Item.weight,
				count = slot.count,
				price = (server.randomprices and (not slot.currency or slot.currency == 'money')) and
					(math.ceil(resolvedPrice * (math.random(80, 120) / 100))) or resolvedPrice,
				metadata = slot.metadata,
				license = slot.license,
				currency = slot.currency,
				grade = slot.grade
			}

			if slot.metadata then
				slot.weight = Inventory.SlotWeight(Item, slot, true)
			end

			shop.items[i] = slot
		end
	end
end

---@param shopType string
---@param properties WShop
local function registerShopType(shopType, properties)
	if properties.locations then
		Shops[shopType] = properties
	else
		Shops[shopType] = {
			-- a dictionary key when the data file gives one: the client shows it in the player's language
			label = properties.label or properties.name,
			id = shopType,
			groups = properties.groups or properties.jobs,
			items = properties.inventory,
			slots = #properties.inventory,
			type = 'shop',
		}

		setupShopItems(nil, shopType, properties.name, properties.groups or properties.jobs)
	end
end

---@param shopType string
---@param id number
local function createShop(shopType, id)
	local shop = Shops[shopType]

	if not shop then return end

	local coords = shop.locations?[id]

	if not coords then return end

	local groups = shop.groups or shop.jobs

	---@type WShop
	shop[id] = {
		label = shop.label or shop.name,
		id = shopType .. ' ' .. id,
		groups = groups,
		items = table.clone(shop.inventory),
		slots = #shop.inventory,
		type = 'shop',
		coords = coords,
	}

	setupShopItems(id, shopType, shop.name, groups)

	return shop[id]
end

for shopType, shopDetails in pairs(lib.load('data.shops')) do
	registerShopType(shopType, shopDetails)
end

---@param shopType string
---@param shopDetails WShop
exports('RegisterShop', function(shopType, shopDetails)
	registerShopType(shopType, shopDetails)
end)

lib.callback.register('w_inventory:openShop', function(source, data)
	local left, shop = Inventory(source)

	if not left then return end

	if data then
		shop = Shops[data.type]

		if not shop then return end

		if not shop.items then
			shop = (data.id and shop[data.id] or createShop(data.type, data.id))

			if not shop then return end
		end

		---@cast shop WShop

		if shop.groups then
			local group = server.hasGroup(left, shop.groups)
			if not group then return end
		end

		if type(shop.coords) == 'vector3' and #(GetEntityCoords(GetPlayerPed(source)) - shop.coords) > 10 then
			return
		end

		---@diagnostic disable-next-line: assign-type-mismatch
		left:openInventory(left)
		left.currentShop = shop.id
	end

	-- Returning the cash and gold balances to be shown in the shop's interface + sending the refresh event to the client
	local playerGold, playerCash = 0, 0
	local goldPriceMultiplier = tonumber(GetConvar('inventory:goldPriceMultiplier', '1')) or 1
	-- framework-agnostic via w_lib (was rsg-core-only → 0/0 on VORP)
	if GetResourceState('w_lib') == 'started' then
		local okc, c = pcall(function() return exports.w_lib:FwGetMoney(source) end)
		local okg, g = pcall(function() return exports.w_lib:FwGetGold(source) end)
		playerCash = (okc and tonumber(c)) or 0
		playerGold = (okg and tonumber(g)) or 0
	end
	if GetResourceState('w_economy') == 'started' then
		local ok, multiplier = pcall(function() return exports.w_economy:GetGoldPriceMultiplier() end)
		if ok and tonumber(multiplier) then goldPriceMultiplier = tonumber(multiplier) end
	end
	TriggerClientEvent('w_inventory:updateCurrency', source, playerCash, playerGold)

	local leftPayload = {
		label = left.label,
		type = left.type,
		slots = left.slots,
		weight = left.weight,
		maxWeight = left.maxWeight,
		playerGold = playerGold,
		playerCash = playerCash,
		goldPriceMultiplier = goldPriceMultiplier,
	}
	return leftPayload, shop
end)

--- The price as a message argument: '$1,000' for cash, '1,000 <item label>' for any other
--- currency (the label is picked on the client in the player's language).
---@param currency string
---@param price number
---@return string | { item: string, text: string }
local function priceArg(currency, price)
	if currency == 'money' then
		return ('%s%s'):format(locale('$'), math.groupdigits(price))
	end

	return { item = currency, text = math.groupdigits(price) .. ' %s' }
end

--- The same arguments as plain text for the server log (server language).
---@param args any[]
---@return any[]
local function plainArgs(args)
	local out = table.clone(args)

	for i = 1, #out do
		local arg = out[i]

		if type(arg) == 'table' and arg.item then
			local label = Items(arg.item)?.label or arg.item
			out[i] = arg.text and arg.text:format(label) or label
		end
	end

	return out
end

local function canAffordItem(inv, currency, price)
	local canAfford = price >= 0 and Inventory.GetItem(inv, currency, false, true) >= price

	-- a dictionary key + arguments: the client formats it in the player's language
	return canAfford or {
		type = 'error',
		key = 'cannot_afford',
		args = { priceArg(currency, price) }
	}
end

local function removeCurrency(inv, currency, price)
	Inventory.RemoveItem(inv, currency, price)
end

local function goldPriceFromCash(price)
	if GetResourceState('w_economy') == 'started' then
		local ok, converted = pcall(function() return exports.w_economy:GetGoldPriceFromCash(price) end)
		if ok and tonumber(converted) then return math.max(0, tonumber(converted)) end
	end

	local multiplier = tonumber(GetConvar('inventory:goldPriceMultiplier', '1')) or 1
	return math.max(0, math.ceil(price * multiplier))
end

local TriggerEventHooks = require 'modules.hooks.server'
local purchaseLocks = {}

local function isRequiredGrade(grade, rank)
	if type(grade) == "table" then
		for i = 1, #grade do
			if grade[i] == rank then
				return true
			end
		end
		return false
	else
		return rank >= grade
	end
end

lib.callback.register('w_inventory:buyItem', function(source, data)
	if type(data) ~= 'table' then return false end

	if data.toType == 'player' then
		local requestedCount = tonumber(data.count or 1)
		local fromSlot = tonumber(data.fromSlot)

		if not requestedCount or requestedCount ~= requestedCount or requestedCount < 1
			or requestedCount > 100000 or not fromSlot or fromSlot < 1 or fromSlot % 1 ~= 0 then
			return false, false, { type = 'error', key = 'buy_amount' }
		end

		data.count = math.floor(requestedCount)
		data.fromSlot = fromSlot

		if purchaseLocks[source] then
			return false, false, { type = 'error', key = 'inventory_in_use' }
		end

		purchaseLocks[source] = true
		local _ <close> = defer(function() purchaseLocks[source] = nil end)

		local count = data.count

		local playerInv = Inventory(source)

		if not playerInv or not playerInv.currentShop then return end

		local shopType, shopId = playerInv.currentShop:match('^(.-) (%d-)$')

		if not shopType then shopType = playerInv.currentShop end

		if shopId then shopId = tonumber(shopId) end

		local shop = shopId and Shops[shopType][shopId] or Shops[shopType]
		local fromData = shop.items[data.fromSlot]
		-- Normalising toSlot to a number to guarantee the key matches the items table (Lua tells 5 and "5" apart)
		local toSlot = tonumber(data.toSlot) or data.toSlot
		if not toSlot or toSlot < 1 or toSlot > playerInv.slots then
			toSlot = 1
		end
		local toData = playerInv.items[toSlot]

		if fromData then
			if fromData.count then
				if fromData.count == 0 then
					return false, false, { type = 'error', key = 'shop_nostock' }
				elseif data.count > fromData.count then
					data.count = fromData.count
				end
			end

			if fromData.license and server.hasLicense and not server.hasLicense(playerInv, fromData.license) then
				return false, false, { type = 'error', key = 'item_unlicensed' }
			end

			if fromData.grade then
				local _, rank = server.hasGroup(playerInv, shop.groups)
				if not isRequiredGrade(fromData.grade, rank) then
					return false, false, { type = 'error', key = 'stash_lowgrade' }
				end
			end

			local currency = fromData.currency or 'money'
			local price = (tonumber(fromData.price) or 0) * count
			local fromItem = Items(fromData.name)
			if not fromItem or price < 0 or price ~= price then return false end

			local result = fromItem.cb and fromItem.cb('buying', fromItem, playerInv, data.fromSlot, shop)
			if result == false then return false end

			-- Generate proper metadata (durability, serial, ammo for weapons) via Items.Metadata
			local metadata = fromData.metadata and table.clone(fromData.metadata) or {}
			metadata, count = Items.Metadata(playerInv.id, fromItem, metadata, count)

			-- An empty slot: there is no item or the item has no name (for instance { slot = 5 } from the interface)
			local slotEmpty = (toData == nil) or (type(toData) == 'table' and (not toData.name or toData.name == ''))
			local toItem = (toData and toData.name and toData.name ~= '') and Items(toData.name) or nil
			local canStack = (toItem and fromItem.name == toItem.name and fromItem.stack and table.matches(toData.metadata or {}, metadata))
			-- If the chosen slot is unsuitable: when buying with cash/gold we look for the first valid slot (empty or a stack of the same item)
			if (not slotEmpty and not canStack) and currency == 'money' then
				for i = 1, playerInv.slots do
					local sd = playerInv.items[i]
					local empty = (sd == nil) or (type(sd) == 'table' and (not sd.name or sd.name == ''))
					local st = (sd and sd.name and sd.name ~= '') and Items(sd.name) or nil
					local stackOk = (st and fromItem.name == st.name and fromItem.stack and table.matches(sd.metadata or {}, metadata))
					if empty or stackOk then
						toSlot = i
						toData = sd
						slotEmpty = empty
						canStack = stackOk
						break
					end
				end
			end
			if slotEmpty or canStack then
				local purchaseWeight = Inventory.SlotWeight(fromItem, {
					name = fromItem.name,
					count = count,
					metadata = metadata,
				})
				local newWeight = playerInv.weight + purchaseWeight

				if newWeight > playerInv.maxWeight then
					return false, false, { type = 'error', key = 'cannot_carry' }
				end

				-- Cash remains the inventory account item (and is synchronised by the
				-- active framework bridge). Gold is charged through w_lib directly.
				local chosen = (data.paymentCurrency == 'gold' or data.paymentCurrency == 'cash') and
				data.paymentCurrency or 'cash'
				local paymentSource = currency == 'money' and chosen or nil
				local deductedAmount = price

				if paymentSource == 'gold' then
					deductedAmount = goldPriceFromCash(price)
					local ok, balance = pcall(function() return exports.w_lib:FwGetGold(source) end)
					if not ok or (tonumber(balance) or 0) < deductedAmount then
						return false, false, { type = 'error', key = 'cannot_afford_gold', args = { math.groupdigits(deductedAmount) } }
					end
				else
					local canAfford = canAffordItem(playerInv, currency, price)
					if canAfford ~= true then
						return false, false, canAfford
					end
				end

				if not TriggerEventHooks('buyItem', {
						source = source,
						shopType = shopType,
						shopId = shopId,
						toInventory = playerInv.id,
						toSlot = toSlot,
						itemName = fromData.name,
						metadata = metadata,
						count = count,
						price = fromData.price,
						totalPrice = price,
						currency = paymentSource == 'gold' and 'gold' or currency,
						paymentSource = paymentSource,
					}) then
					return false
				end

				if paymentSource == 'gold' then
					local ok, removed = pcall(function()
						return exports.w_lib:FwRemoveCurrency(source, 1, deductedAmount)
					end)
					if not ok or removed ~= true then return false end
				else
					Losses.reason('shop', Losses.actor(playerInv), 'shop')
					if not Inventory.RemoveItem(playerInv, currency, price) then return false end
				end

				Inventory.SetSlot(playerInv, fromItem, count, metadata, toSlot)
				playerInv.weight = newWeight

				if fromData.count then
					shop.items[data.fromSlot].count = fromData.count - count
				end

				if server.syncInventory then server.syncInventory(playerInv) end

				local okCash, cash = pcall(function() return exports.w_lib:FwGetMoney(source) end)
				local okGold, gold = pcall(function() return exports.w_lib:FwGetGold(source) end)
				TriggerClientEvent('w_inventory:updateCurrency', source,
					okCash and tonumber(cash) or 0, okGold and tonumber(gold) or 0)

				-- the notification is a key + arguments: the client formats it in the player's language
				local messageKey, messageArgs
				if paymentSource == 'gold' then
					messageKey, messageArgs = 'purchased_with_gold', { math.groupdigits(deductedAmount) }
				elseif paymentSource == 'cash' then
					messageKey, messageArgs = 'purchased_with_cash', { math.groupdigits(price) }
				else
					-- 'Purchased %s %s for %s%s': the price fills the third slot, the fourth stays empty
					messageKey, messageArgs = 'purchased_for', { count, metadata?.label or { item = fromItem.name },
						priceArg(currency, price), '' }
				end

				if server.loglevel > 0 then
					if server.loglevel > 1 or (tonumber(fromData.price) or 0) >= 500 then
						-- the log line stays in the server's language
						local message = locale(messageKey, table.unpack(plainArgs(messageArgs), 1, #messageArgs))
						lib.logger(playerInv.owner, 'buyItem', ('"%s" %s'):format(playerInv.label, message:lower()),
							('shop:%s'):format(shop.label))
					end
				end

				return true,
					{ toSlot, playerInv.items[toSlot], shop.items[data.fromSlot].count and shop.items[data.fromSlot],
						playerInv.weight }, { type = 'success', key = messageKey, args = messageArgs }
			end

			return false, false, { type = 'error', key = 'unable_stack_items' }
		end
	end
end)

server.shops = Shops
