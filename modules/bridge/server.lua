---@todo separate module into smaller submodules to handle each framework
---starting to get bulky

function server.hasGroup(inv, group)
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
	if not player.groups then
		warn(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

local Inventory = require 'modules.inventory.server'

-- Framework-independent usable item registry.
--
-- The inventory runs on VORP, RSG and QBR, therefore CreateUseableItem must
-- never exist only inside one framework adapter.  w_lib and third-party
-- resources can register here regardless of the detected core; the active
-- framework handler remains a fallback for items registered in the core.
local bridgeUsableItems = {}

--- * A forward declaration: the exports below compare against it, and its actual definition comes after them.
--- Without it that comparison read an empty global and so always lied.
local bridgeUseItem

--- Is `v` callable?
---
--- ★ A function passed across a resource boundary does NOT arrive as a
---   function: the runtime wraps it into a *funcref* — a table carrying `__call`.
---   So `type(cb) == 'function'` is true only for callbacks registered from
---   inside w_inventory itself, and every external resource was rejected
---   with a bare `false` — no error, no log. That is why nothing any other
---   resource registered ever fired.
---
---   w_lib already guards against this (modules/callback/server.lua, isCallable).
local function isCallable(v)
	local t = type(v)

	if t == 'function' then return true end

	return t == 'table' and getmetatable(v) ~= nil and getmetatable(v).__call ~= nil
end

local function registerBridgeUsable(item, callback)
	if type(item) ~= 'string' or item == '' or not isCallable(callback) then
		return false
	end

	item = shared.resolveItemName and shared.resolveItemName(item) or item
	bridgeUsableItems[item] = callback
	return true
end

exports('CreateUseableItem', registerBridgeUsable)
exports('CreateUsableItem', registerBridgeUsable)
exports('RegisterUsableItem', registerBridgeUsable)

exports('UnregisterUsableItem', function(item)
	item = shared.resolveItemName and shared.resolveItemName(item) or item
	bridgeUsableItems[item] = nil
	return true
end)

-- * Reading the registry for diagnostics.
--
--   Without this the question 'is my item really registered?' had no answer: the registration prints its success,
--   but nobody can verify that the name settled in the registry that server.UseItem
--   reads - and the two may be different tables if the module is loaded more than once.
exports('IsUsableItemRegistered', function(item)
	item = shared.resolveItemName and shared.resolveItemName(item) or item
	return bridgeUsableItems[item] ~= nil
end)

exports('GetUsableItemNames', function()
	local names = {}
	for item in pairs(bridgeUsableItems) do names[#names + 1] = item end
	table.sort(names)
	return names
end)

-- * Which copy of server.UseItem is the effective one?
--   VORP's own compat.lua defines a copy as well and says it 'replaces' this one,
--   so if it is loaded after us the registry above lost all its precedence and every item we registered went silent.
exports('WhichUseItemHandler', function()
	return server.UseItem == bridgeUseItem and 'bridge (shared registry)' or 'framework (compat)'
end)

function server.playerDropped(source)
	local inv = Inventory(source) --[[@as WInventory]]

	if inv?.player then
		inv:closeInventory()
		Inventory.Remove(inv)
	end
end

local success, result = pcall(lib.load, ('modules.bridge.%s.server'):format(shared.framework))

if not success then
    lib.print.error(result)
    lib = nil
    return
end

-- Every framework adapter may provide its own server.UseItem implementation
-- (for native core registrations). Keep it as a fallback, while registrations
-- made directly against w_inventory always take precedence.
local frameworkUseItem = server.UseItem

function bridgeUseItem(source, itemName, data)
	itemName = shared.resolveItemName and shared.resolveItemName(itemName) or itemName
	local callback = bridgeUsableItems[itemName]

	if callback then
		return callback(source, data)
	end

	if frameworkUseItem then
		return frameworkUseItem(source, itemName, data)
	end
end

server.UseItem = bridgeUseItem

-- * The precedence guard.
--
--   modules/bridge/vorp/compat.lua defines server.UseItem too and says explicitly
--   that it 'replaces the copy in server.lua'. So whenever it is loaded after us - in any module
--   order - the whole public item registry was lost: every resource that registered an item through
--   RegisterUsableItem had its item go silent with no error and no message.
--
--   Instead of depending on the load order, we check after it settles and take the precedence back
--   while keeping the framework's copy as a fallback (bridgeUseItem reads it itself).
CreateThread(function()
	Wait(0) -- after every module has finished loading

	if server.UseItem ~= bridgeUseItem then
		frameworkUseItem = server.UseItem
		server.UseItem = bridgeUseItem

		print('^3[w_inventory]^7 restored bridge usable-item registry priority (framework bridge had replaced it)')
	end
end)

if server.convertInventory then exports('ConvertItems', server.convertInventory) end
