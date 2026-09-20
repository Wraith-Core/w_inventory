local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

local ItemList = {}
local isServer = IsDuplicityVersion()
local ItemAliases = lib.load('data.item_aliases')

-- Translate only names from the recent catalog migration. Existing saved stacks
-- keep their quantities/metadata and acquire the canonical name when loaded.
function shared.resolveItemName(name)
    if type(name) ~= 'string' then return name end
    name = name:lower()
    if name:sub(1, 7) == 'weapon_' then return name:upper() end
    return ItemAliases[name] or name
end

-- The language comes from the library (shared.localeKey(): the player's choice on the
-- client, the server convar on the server); the data files carry ar/en variants.
local function activeLocale()
	return shared.localeKey()
end

local function hasArabic(value)
	return type(value) == 'string' and value:find('[\216-\219][\128-\191]') ~= nil
end

local function humanizeItemName(name)
	local value = tostring(name or 'item')
		:gsub('^WEAPON_', '')
		:gsub('^weapon_', '')
		:gsub('[_%-]+', ' ')
		:lower()

	return (value:gsub('(%a)([%w]*)', function(first, rest)
		return first:upper() .. rest
	end))
end

local function localizedField(data, field, fallback, allowNil)
	local lang = activeLocale()
	local explicit = data[field .. '_' .. lang]

	if type(explicit) == 'string' and explicit ~= '' then
		return explicit
	end

	local value = data[field]

	if type(value) == 'table' then
		local selected = value[lang]

		if type(selected) == 'string' and selected ~= '' then
			return selected
		end

		if lang == 'ar' and type(value.en) == 'string' then
			return value.en
		end

		return allowNil and nil or fallback
	end

	if type(value) == 'string' and value ~= '' then
		-- Imported server packs are often Arabic-only. English commercial builds
		-- must never leak Arabic labels; use a stable name-derived fallback.
		if lang == 'en' and hasArabic(value) then
			return allowNil and fallback or fallback
		end

		return value
	end

	return allowNil and nil or fallback
end

-- The bilingual sources are kept on the item (i18n) so the client can pick the other
-- language when the player switches it live (relocalize below).
local i18nFields = { 'label', 'label_ar', 'label_en', 'description', 'description_ar', 'description_en' }

--- Does the row (or its i18n snapshot) carry a second language at all?
local function hasI18nSource(data)
	return type(data.label) == 'table' or type(data.description) == 'table'
		or data.label_ar ~= nil or data.label_en ~= nil
		or data.description_ar ~= nil or data.description_en ~= nil
end

-- The sources are snapshotted (data.i18n) BEFORE label/description get overwritten, so
-- a later switch still finds the English and the Arabic text.
local function localizeItemData(data)
	local fallback = humanizeItemName(data.name)

	if not data.i18n then
		local source = {}

		for i = 1, #i18nFields do
			local field = i18nFields[i]
			source[field] = data[field]
		end

		data.i18n = source
	end

	local source = data.i18n
	data.label = localizedField(source, 'label', fallback, false)
	-- an explicitly empty description stays empty (native rows), otherwise the label
	data.description = localizedField(source, 'description', source.description == '' and '' or data.label, true)
end

--- Re-pick label/description of every item in the active language. Rows replaced by
--- the framework's native catalogue (nativeSource) take part as soon as they carry a
--- second language (label_ar / label_en / ... copied by Catalog.build); a native row
--- without one keeps its catalogue label untouched.
local function relocalizeItems()
	for _, item in pairs(ItemList) do
		if type(item) == 'table' then
			if item.i18n then
				if not item.nativeSource or hasI18nSource(item.i18n) then
					localizeItemData(item)
				end
			elseif item.nativeSource and hasI18nSource(item) then
				localizeItemData(item)
			end
		end
	end
end

-- client.lua runs it from its 'w_lib:setLocale' handler (after the dictionary reloaded);
-- both sides run it once more right after Catalog.apply landed the native catalogue.
shared.relocalizeItems = relocalizeItems
shared.localizeItemData = localizeItemData

local function setImagePath(path)
    if path then
        return path:match('^[%w]+://') and path or ('%s/%s'):format(client.imagepath, path)
    end
end

---@param data WItem
local function newItem(data)
	localizeItemData(data)
	data.weight = data.weight or 0

	if data.close == nil then
		data.close = true
	end

	if data.stack == nil then
		data.stack = true
	end

	local clientData, serverData = data.client, data.server
	---@cast clientData -nil
	---@cast serverData -nil

	if not data.consume and (clientData and (clientData.status or clientData.usetime or clientData.export) or serverData?.export) then
		data.consume = 1
	end

	-- Default 7-day decay for all items (except currency and permanent tools)
	if not data.degrade and data.name ~= 'money' and data.name ~= 'money_clip' and data.name ~= 'blood_money_clip' and data.name ~= 'dollar' and data.name ~= 'blood_dollar' and data.name ~= 'cent' and data.name ~= 'blood_cent' and data.name ~= 'handcraft_kit' then
		data.degrade = 10080 -- 7 days (in minutes)
	end

	if data.degrade and data.decay == nil then
		data.decay = true
	end

	if clientData?.model then
		data.model = data.model or clientData.model
	end

	if clientData?.prop then
		data.prop = data.prop or clientData.prop
	end

	if data.model and not data.prop then
		data.prop = data.model
	end

	if data.prop and not data.model then
		data.model = data.prop
	end

	if isServer then
        ---@cast data WServerItem
        serverData = data.server
		data.client = nil

		if not data.durability then
			if data.degrade or (data.consume and data.consume ~= 0 and data.consume < 1) then
				data.durability = true
			end
		end

        if not serverData then goto continue end

        if serverData.export then
            data.cb = useExport(string.strsplit('.', serverData.export))
        end
	else
        ---@cast data WClientItem
        clientData = data.client
		data.server = nil
		data.count = 0

        if not clientData then goto continue end

        if clientData.export then
            data.export = useExport(string.strsplit('.', clientData.export))
        end

        clientData.image = setImagePath(clientData.image)

        if clientData.propTwo then
            clientData.prop = clientData.prop and { clientData.prop, clientData.propTwo } or clientData.propTwo
            clientData.propTwo = nil
        end
	end

    ::continue::
	ItemList[data.name] = data
end

local thrownUnits = lib.load('data.thrown_units')
for type, data in pairs(lib.load(string.format('data.weapons_%s', "RDR3"))) do
	for k, v in pairs(data) do
		v.name = k
		localizeItemData(v)
		v.close = type == 'Ammo' and true or false
        v.weight = v.weight or 0

		if type == 'Weapons' then
			---@cast v WWeapon
			v.worldModel = v.model -- physical asset; never the weapon type passed to equip natives
			v.model = k
			v.hash = joaat(k)
			v.stack = v.throwable and true or false
			v.durability = v.durability or 0.05
			v.weapon = true
		else
			v.stack = true
		end

		v[type == 'Ammo' and 'ammo' or 'weapon'] = true
        if type == 'Ammo' and shared.backend == 'wcore' and thrownUnits[k] then
            v.weaponType, v.throwableUnit = thrownUnits[k], true
            v.weapon, v.throwable, v.stack = true, true, true
            v.model, v.hash = v.weaponType, joaat(v.weaponType)
            v.ammoname = nil -- this stack itself is the quantity, never loaded from a second stack
        end

		if isServer then v.client = nil else
			v.count = 0
			v.server = nil
			local clientData = v.client

			if clientData?.image then
                clientData.image = setImagePath(clientData.image)
			end
		end

		ItemList[k] = v
	end
end

for k, v in pairs(lib.load('data.items')) do
	v.name = k
	local success, response = pcall(newItem, v)

    if not success then
        warn(('An error occurred while creating item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(k, response))
    end
end

-- ============================================================
-- Unifying the ammunition names between the frameworks
--
-- weapons_RDR3.lua declares ammoname with a family key (ammo_revolver), while
-- the player's actual items come from the framework's database - and in VORP its name is
-- ammorevolvernormal. So the reload button finds nothing and the loading does not work.
--
-- Also the data.items loop writes over Weapons.Ammo's items so they lose ammo=true.
--
-- Here we fix both, relying on data/ammo_types_RDR3.lua which carries
-- every name of a type, so the server works on VORP and RSG with no edit.
-- ============================================================
do
	local AmmoTypes = lib.load('data.ammo_types_RDR3')

	local function itemExists(name)
		return ItemList[name] ~= nil
	end

	-- 1. Labelling every ammunition item that really exists, and saving its family and its bullet type.
	--    We go over all the type's names and not the first alone, because the shops sell the box
	--    (ammo_box_*) while the crafting produces the single one - and both must work.
	for ammoname, entries in pairs(AmmoTypes.Families) do
		for i = 1, #entries do
			local entry = entries[i]
			local single, boxed

			for n = 1, #entry.items do
				local name = entry.items[n]
				local item = ItemList[name]

				if item then
					local isBox = name:find('^ammo_box_') ~= nil

					item.ammo = true
					item.close = true
					item.stack = true
					item.ammoFamily = ammoname
					item.ammoType = entry.ammo

					-- The box uses its catalog rounds_per_item_rp, and the single item is one round.
					-- The boxes are not loaded; they are opened first with the right button.
					item.ammocount = isBox and (item.ammocount or 20) or 1
					-- Arrow bundles have no verified physical asset in the supplied catalog.
					-- Keep a collectible ground marker instead of depicting them as a cartridge box.
					if isBox and ammoname == 'ammo_arrow' and not item.model then item.noDropModel = true end

					if isBox then boxed = boxed or name else single = single or name end
				end
			end

			-- Linking the single one to its box, so the packing and opening options show on the right button
			if single and boxed then
				ItemList[single].ammoPack = boxed
				ItemList[boxed].ammoUnpack = single
			end
		end
	end

	-- 2. Pointing every weapon at the item name that really exists, while keeping the family's key
	--    because ammoname after the swap is no longer a key in the catalogue
	for _, item in pairs(ItemList) do
		if item.weapon and item.ammoname then
			local family = item.ammoname
			local entry = AmmoTypes.GetDefault(family, itemExists)

			if entry and ItemList[entry.item] then
				item.ammoFamily = family
				item.ammoname = entry.item
				-- The bullet type in the game (AMMO_XXX). It is needed because ammoname became an item's
				-- name, and hashing it does not give the type hash the RDR3 natives expect.
				item.ammoType = entry.ammo
			end
		end
	end
end

ItemList.cash = ItemList.money

return ItemList
