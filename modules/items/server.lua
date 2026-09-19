if not lib then return end

local Items = {}
local ItemList = require 'modules.items.shared' --[[@as table<string, WServerItem>]]
local Utils = require 'modules.utils.server'
local AmmoTypes = lib.load('data.ammo_types_RDR3')

TriggerEvent('w_inventory:itemList', ItemList)

Items.containers = require 'modules.items.containers'

---@param _ table?
---@param name string?
---@return table?
local function getItem(_, name)
    if not name then return ItemList end

	if type(name) ~= 'string' then return end

    name = name:lower()

    if name:sub(0, 7) == 'weapon_' then
        name = name:upper()
    end

    return ItemList[name]
end

setmetatable(Items --[[@as table]], {
	__call = getItem
})

---@cast Items +fun(itemName: string): WServerItem
---@cast Items +fun(): table<string, WServerItem>

-- Support both names
exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

local Inventory

--- Fetching the items table in batches - one huge batch provokes oxmysql's warning
--- (oversized result set) with more than a thousand items
local function fetchAllItems()
	local all, offset = {}, 0

	while true do
		local ok, rows = pcall(MySQL.query.await, 'SELECT * FROM items ORDER BY id LIMIT 900 OFFSET ?', { offset })

		if not ok then return nil, false end

		rows = rows or {}

		for i = 1, #rows do
			all[#all + 1] = rows[i]
		end

		if #rows < 900 then break end

		offset = offset + 900
	end

	return all, true
end

local Catalog = require 'modules.items.catalog'
local nativeCatalog, catalogNames = {}, {}

local function nativeVorpWeapons()
    local source = LoadResourceFile('vorp_inventory', 'config/weapons.lua')
        or LoadResourceFile(shared.resource, 'data/native_vorp_weapons.lua')
    assert(source, 'Native VORP weapon definitions are missing')
    local env = setmetatable({ SHARED_DATA = {} }, { __index = _G })
    local chunk, err = load(source, '@native_vorp_weapons', 't', env)
    assert(chunk, err)
    chunk()
    return assert(env.SHARED_DATA.WEAPONS, 'Invalid VORP weapon definitions')
end

function Items.CatalogPage(page)
    local result = {}
    page = math.max(1, math.floor(tonumber(page) or 1))
    for index = (page - 1) * 200 + 1, math.min(page * 200, #catalogNames) do
        local name = catalogNames[index]
        result[name] = nativeCatalog[name]
    end
    return { items = result, total = #catalogNames, pages = math.ceil(#catalogNames / 200) }
end

lib.callback.register('w_inventory:itemCatalog', function(_, page)
    local deadline = GetGameTimer() + 15000
    while not shared.ready do
        assert(GetGameTimer() < deadline, 'Native item catalog unavailable')
        Wait(0)
    end
    return Items.CatalogPage(page)
end)

CreateThread(function()
    Inventory = require 'modules.inventory.server'
    local definitions, weapons
    if shared.framework == 'vorp' then
        local success
        definitions, success = fetchAllItems()
        assert(success, 'Unable to load the native VORP items table')
        weapons = nativeVorpWeapons()
    elseif shared.framework == 'rsg' then
        local core = exports['rsg-core']:GetCoreObject()
        definitions, weapons = core.Shared.Items, core.Shared.Weapons
    elseif shared.framework == 'qbr' then
        definitions = exports['qbr-core']:GetItems()
    else
        error('Unsupported native inventory framework: ' .. tostring(shared.framework))
    end
    nativeCatalog = Catalog.build(shared.framework, definitions, weapons, ItemList, shared.backend)
    if shared.framework == 'vorp' then
        local source = LoadResourceFile('vorp_inventory', 'config/ammo.lua')
            or LoadResourceFile(shared.resource, 'data/native_vorp_ammo.lua')
        local env = setmetatable({ SHARED_DATA = {} }, { __index = _G })
        assert(load(assert(source), '@native_vorp_ammo', 't', env))()
        local caps = assert(env.SHARED_DATA.MAX_AMMO_BELT, 'Missing VORP gunbelt limits')
        local entries = {}
        for family, types in pairs(AmmoTypes.Families) do
            for _, entry in ipairs(types) do entries[entry.ammo] = { family = family, entry = entry } end
        end
        local mapping = {}
        for ammoType, capacity in pairs(caps) do
            local name = '__vorp_belt_' .. ammoType:lower()
            local match = entries[ammoType]
            local original = match and match.entry.items[2]
            local label = match and match.entry.label_en or ammoType
            nativeCatalog[name] = { name = name, label = label, description = '', nativeSource = 'vorp',
                label_en = match and match.entry.label_en or nil, label_ar = match and (match.entry.label_ar or match.entry.label) or nil,
                nativeGunbelt = ammoType, nativeType = 'gunbelt', gunbeltLimit = capacity,
                weight = 0, stack = true, close = false, usable = true, canRemove = false,
                ammo = true, ammoType = ammoType, ammoFamily = match and match.family, ammocount = 1,
                client = { image = (original or ammoType) .. '.png' } }
            mapping[ammoType] = name
        end
        require('modules.mysql.vorp').configureGunbelt(mapping)
    end
    -- the local money definition keeps its bilingual sources (i18n) once localised
    local money = ItemList.money and (ItemList.money.i18n or ItemList.money) or {}
    nativeCatalog.money = {
        name = 'money', label = money.label_en or (type(money.label) == 'string' and money.label) or 'Money',
        label_ar = money.label_ar, label_en = money.label_en,
        weight = 0, stack = true, close = false, nativeCurrency = true,
        nativeSource = shared.framework, nativeType = 'currency', usable = false,
        client = { image = 'money.png' },
    }
    if type(money.label) == 'table' then
        nativeCatalog.money.label = money.label.en or 'Money'
        nativeCatalog.money.label_ar = nativeCatalog.money.label_ar or money.label.ar
    end
    Catalog.apply(ItemList, nativeCatalog, false)
    -- pick the server language (w_lib:locale) for the rows the native catalogue replaced
    shared.relocalizeItems()
    for name in pairs(nativeCatalog) do catalogNames[#catalogNames + 1] = name end
    table.sort(catalogNames)
    shared.info(('Loaded %d live %s definitions; local item files were not rewritten'):format(#catalogNames, shared.framework))
    shared.ready = true
end)

local function GenerateText(num)
	local str
	repeat str = {}
		for i = 1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local function GenerateSerial(text)
	if text and text:len() > 3 then
		return text
	end

	return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

-- The default expiry duration for items (in minutes) = 3 days
local DEFAULT_DEGRADE_MINUTES = 4320

-- The items exempt from expiry (money and accounts and permanent tools)
local DECAY_EXCLUDED_ITEMS = {
	['money'] = true,
	['cash'] = true,
	['money_clip'] = true,
	['blood_money_clip'] = true,
	['handcraft_kit'] = true,
}

local function setItemDurability(item, metadata)
    if item.nativeSource then return metadata end
	local degrade = item.degrade

	if degrade then
		metadata.durability = os.time()+(degrade * 60)
		metadata.degrade = degrade
	elseif item.durability then
		metadata.durability = 100
	elseif not item.weapon and not DECAY_EXCLUDED_ITEMS[item.name] then
		-- Applying an automatic expiry (3 days) to every item that is not a weapon and not money
		metadata.durability = os.time()+(DEFAULT_DEGRADE_MINUTES * 60)
		metadata.degrade = DEFAULT_DEGRADE_MINUTES
	end

	return metadata
end

local TriggerEventHooks = require 'modules.hooks.server'

---@param inv inventory
---@param item WServerItem
---@param metadata any
---@param count number
---@return table, number
---Generates metadata for new items being created through AddItem, buyItem, etc.
function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	if not item.weapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end
	if not count then count = 1 end

    if item.nativeCurrency then return {}, count end
    if item.nativeSource == 'vorp' and not item.weapon and item.defaultMetadata then
        local merged = Catalog.copy(item.defaultMetadata)
        for key, value in pairs(type(metadata) == 'table' and metadata or {}) do merged[key] = value end
        metadata = merged
    end
    if item.nativeSource == 'vorp' and not item.weapon then
        metadata = type(metadata) == 'table' and metadata or {}
        if not item.nativeGunbelt and not metadata._vorp then
            metadata._vorp = { kind = 'item', degradation = item.maxDegradation > 0 and os.time() or 0,
                percentage = item.maxDegradation > 0 and 100 or 0, durability = item.nativeDurability or 0 }
        end
        local response = TriggerEventHooks('createItem', { inventoryId = inv and inv.id, metadata = metadata, item = item, count = count })
        return type(response) == 'table' and response or metadata, item.stack and count or math.min(count, 1)
    end

    if item.nativeSource == 'rsg' or item.nativeSource == 'qbr' then
        metadata = type(metadata) == 'table' and metadata or {}
        if item.nativeType == 'weapon' then
            metadata.serie = metadata.serie or GenerateSerial()
            if metadata.quality == nil then metadata.quality = 100 end
        end
        if item.nativeDefinition and (tonumber(item.nativeDefinition.decay) or 0) > 0 then
            if metadata.quality == nil then metadata.quality = 100 end
            metadata.lastUpdate = metadata.lastUpdate or os.time()
        end
        local response = TriggerEventHooks('createItem', { inventoryId = inv and inv.id, metadata = metadata, item = item, count = count })
        return type(response) == 'table' and response or metadata, item.stack and count or math.min(count, 1)
    end

	---@cast metadata table<string, any>

	if item.weapon then
		if type(metadata) ~= 'table' then metadata = {} end
        if item.nativeSource == 'vorp' and item.nativeDefinition and item.nativeDefinition.NoSerialNumber then
            metadata.serial, metadata.registered = nil, false
        end
		if not metadata.durability then metadata.durability = 100 end
		if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
		if not metadata.components then metadata.components = {} end
		if not item.nativeSource and not metadata.weaponExpiry then metadata.weaponExpiry = os.time() + (7 * 24 * 60 * 60) end

		if metadata.registered ~= false and metadata.ammo then
			local registered = type(metadata.registered) == 'string' and metadata.registered or inv?.player?.name
			metadata.registered = registered
			metadata.serial = GenerateSerial(metadata.serial)
		end
	else
		local container = Items.containers[item.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container.size
		elseif not next(metadata) then
			if item.name == 'identification' then
				count = 1
				local sexKey = inv.player.sex and 'male' or 'female'
				metadata = {
					type = inv.player.name,
					-- the key + arguments let the interface render it in the player's language;
					-- the plain text (server language) stays for any other reader of the metadata
					descriptionKey = 'identification',
					descriptionArgs = { sexKey, inv.player.dateofbirth },
					description = locale('identification', locale(sexKey), inv.player.dateofbirth)
				}
			end
		end

		if not metadata.durability then
			metadata = setItemDurability(ItemList[item.name], metadata)
		end
	end

	if count > 1 and not item.stack then
		count = 1
	end

	local response = TriggerEventHooks('createItem', {
		inventoryId = inv and inv.id,
		metadata = metadata,
		item = item,
		count = count,
	})

	if type(response) == 'table' then
		metadata = response
	end

	-- Apply the same validation to newly created rows as database-loaded rows.
	-- This keeps weapon component hashes, ammo identity and revisions canonical
	-- before the first save instead of waiting for a resource restart.
	metadata = Items.CheckMetadata(type(metadata) == 'table' and metadata or {}, item, item.name, os.time())

	if metadata.imageurl and Utils.IsValidImageUrl then
		if Utils.IsValidImageUrl(metadata.imageurl) then
			Utils.DiscordEmbed('Valid image URL', ('Created item "%s" (%s) with valid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 65280)
		else
			Utils.DiscordEmbed('Invalid image URL', ('Created item "%s" (%s) with invalid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 16711680)
			metadata.imageurl = nil
		end
	end

	return metadata, count
end

---@param metadata table<string, any>
---@param item WServerItem
---@param name string
---@param ostime number
---Validate (and in some cases convert) item metadata when an inventory is being loaded.
function Items.CheckMetadata(metadata, item, name, ostime)

    if item.nativeSource == 'rsg' or item.nativeSource == 'qbr' then
        return metadata -- native info/quality/serie are loaded without conversion or defaults
    end
    if item.nativeSource == 'wcore' and item.weapon then
        -- Keep identities/condition from rows created while the RSG facade was active.
        if metadata.serial == nil then metadata.serial = metadata.serie end
        if metadata.durability == nil and tonumber(metadata.quality) then
            metadata.durability = math.max(0, math.min(100, tonumber(metadata.quality)))
        end
    end
	if metadata.bag then
		metadata.container = metadata.bag
		metadata.size = Items.containers[name]?.size or {5, 1000}
		metadata.bag = nil
	end

	local durability = metadata.durability

	if durability then
		if durability < 0 or durability > 100 and ostime >= durability then
			metadata.durability = 0
		end
	else
		metadata = setItemDurability(item, metadata)
	end

	if item.weapon then
		-- Checking a weapon's expiry (7 days with no use)
		if not item.nativeSource and not metadata.weaponExpiry then
			metadata.weaponExpiry = ostime + (7 * 24 * 60 * 60) -- 7 days
		elseif not item.nativeSource and ostime >= metadata.weaponExpiry then
			metadata.durability = 0 -- the weapon expired (it was not used for 7 days)
		end

		if type(metadata.components) == 'table' then
			local components, seen = {}, {}

			for _, component in pairs(metadata.components) do
				local normalized

				if type(component) == 'number' and component == component and component ~= 0 then
					normalized = math.floor(component)
				elseif type(component) == 'string' and tonumber(component) then
					normalized = math.floor(tonumber(component))
				elseif item.nativeSource == 'vorp' and type(component) == 'string' and component:sub(1, 10) == 'COMPONENT_' then
					normalized = joaat(component)
				elseif type(component) == 'string' and component:sub(1, 10) == 'COMPONENT_' then
					-- a gunsmith part by name (COMPONENT_*): kept as it is
					normalized = component
				end

				if normalized and not seen[normalized] then
					seen[normalized] = true
					components[#components + 1] = normalized
				end
			end

			metadata.components = components
		elseif metadata.components ~= nil then
			metadata.components = {}
		end

		if metadata.serial and item.throwable then
			metadata.serial = nil
		end

		local rawStatus = type(metadata.weaponStatus) == 'table' and metadata.weaponStatus
			or type(metadata.status) == 'table' and metadata.status or {}
		local durabilityPercent = math.max(0, math.min(100, tonumber(metadata.durability) or 100))

		local function statusValue(value, fallback)
			value = tonumber(value)
			if not value or value ~= value then value = fallback end
			return math.max(0.0, math.min(1.0, value))
		end

		local conditionLoss = (100 - durabilityPercent) / 100
		metadata.weaponStatus = {
			degradation = statusValue(rawStatus.degradation, conditionLoss),
			damage = statusValue(rawStatus.damage, conditionLoss),
			dirt = statusValue(rawStatus.dirt, 0.0),
			soot = statusValue(rawStatus.soot, 0.0),
		}
		metadata.status = nil

		if item.ammoname then
			metadata.ammo = math.max(0, math.min(500, math.floor(tonumber(metadata.ammo) or 0)))
			metadata._ammoRevision = math.max(0, math.floor(tonumber(metadata._ammoRevision) or 0))

			local special = metadata.specialAmmo
			if special ~= nil and type(special) ~= 'string' then
				metadata.specialAmmo = nil
			elseif type(special) == 'string' and AmmoTypes then
				local entry = AmmoTypes.Resolve(item.ammoFamily or item.ammoname, special, function(name)
					return ItemList[name] ~= nil
				end)

				-- Store one canonical item id. The base ammo is represented by nil,
				-- matching the client reload path and avoiding false type switches.
				metadata.specialAmmo = entry and entry.item ~= item.ammoname and entry.item or nil
			end
		elseif metadata.specialAmmo and type(metadata.specialAmmo) ~= 'string' then
			metadata.specialAmmo = nil
		end
	end

	return metadata
end

---Update item durability, and call `Inventory.RemoveItem` if it was removed from decay.
---@param inv WInventory
---@param slot SlotWithItem
---@param item WServerItem
---@param value? number
---@param ostime? number
---@return boolean? removed
function Items.UpdateDurability(inv, slot, item, value, ostime)
    if item and item.nativeSource == 'rsg' then
        local updated, quality, delete = require('modules.items.rsg_decay').update(slot.metadata, item.nativeDefinition, ostime)
        if updated then inv.changed = true end
        if delete and quality and quality <= 0 then return Inventory.RemoveItem(inv, slot.name, slot.count, nil, slot.slot) end
        return false
    end
    if item and item.nativeSource then
        -- Native expired/broken items remain native rows. Their owner decides
        -- whether use is allowed and whether consumption removes the item.
        if value ~= nil then
            slot.metadata.durability = value
            inv.changed = true
        end
        return false
    end
    local durability = slot.metadata.durability or value

    if not durability then return end

    if value then
        durability = value
    elseif ostime and durability > 100 and ostime >= durability then
        durability = 0
    end

    -- Deleting the item if it has expired (every item, the expired weapons included)
    if durability == 0 then
        return Inventory.RemoveItem(inv, slot.name, slot.count, nil, slot.slot)
    end

    if slot.metadata.durability == durability then return end

    inv.changed = true
    slot.metadata.durability = durability

    inv:syncSlotsWithClients({
        {
            item = slot,
            inventory = inv.id
        }
    }, true)
end

local function Item(name, cb)
	local item = ItemList[name]

	if item and not item.cb then
		item.cb = cb
	end
end

-----------------------------------------------------------------------------------------------
-- Serverside item functions
-----------------------------------------------------------------------------------------------

-- Item('bread', function(event, item, inventory, slot, data)
-- 	if event == 'usingItem' then
-- 		if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 0 then
-- 			-- returning false here cancels the item use
-- 			return { inventory.label, event }
-- 		end
-- 	elseif event == 'usedItem' then
-- 		print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))
-- 	elseif event == 'buying' then
-- 		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
-- 	end
-- end)

-----------------------------------------------------------------------------------------------

-- Weapon Repair Kit: repairs the currently equipped weapon
Item('weapon_repair_kit', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		if not inventory.weapon then
			TriggerClientEvent('w_inventory:notify', inventory.id, { type = 'error', key = 'repair_hold_weapon' })
			return false
		end

		local weapon = inventory.items[inventory.weapon]

		if not weapon or not weapon.metadata then
			return false
		end

		if (weapon.metadata.durability or 100) >= 100 then
			TriggerClientEvent('w_inventory:notify', inventory.id, { type = 'error', key = 'repair_not_needed' })
			return false
		end

		return true
	elseif event == 'usedItem' then
		if inventory.weapon then
			local weapon = inventory.items[inventory.weapon]

			if weapon and weapon.metadata then
				weapon.metadata.durability = 100

				inventory:syncSlotsWithClients({
					{
						item = weapon,
						inventory = inventory.id
					}
				}, true)

				TriggerClientEvent('w_inventory:notify', inventory.id, { type = 'success', key = 'repair_success' })

				if server.syncInventory then server.syncInventory(inventory) end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------

return Items
