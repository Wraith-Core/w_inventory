-- Native framework definitions are data, never executable client callbacks.
-- Normalize a detached copy so core tables and local W definitions stay intact.
local Catalog = {}

local function copy(value, seen)
    local kind = type(value)
    if kind == 'string' or kind == 'number' or kind == 'boolean' then return value end
    if kind ~= 'table' then return nil end
    seen = seen or {}
    if seen[value] then return nil end
    seen[value] = true
    local out = {}
    for key, child in pairs(value) do
        if type(key) == 'string' or type(key) == 'number' then out[key] = copy(child, seen) end
    end
    seen[value] = nil
    return out
end
Catalog.copy = copy

local function flag(value, fallback)
    if value == nil then return fallback end
    return value == true or value == 1 or value == '1' or value == 'true'
end

function Catalog.name(name)
    name = tostring(name or '')
    return name:sub(1, 7):lower() == 'weapon_' and name:upper() or name:lower()
end

local weaponFields = { 'model', 'hash', 'ammoname', 'ammoFamily', 'ammoType',
    'throwable', 'durability', 'group', 'anim', 'weapon', 'component', 'tint', 'ammo', 'ammocount' }

local function baseDefinition(name, fallback)
    local out = { name = name, native = true }
    -- Retain technical weapon data only, not W consumable effects/expiry/labels.
    for _, key in ipairs(weaponFields) do out[key] = copy(fallback and fallback[key]) end
    return out
end

-- Bilingual sources the localiser (modules/items/shared.lua) understands. They ride on
-- the row next to the English label/description so every player gets his own language.
local i18nFields = { 'label_ar', 'label_en', 'description_ar', 'description_en' }

local function text(value)
    return type(value) == 'string' and value ~= '' and value or nil
end

--- English text of a definition field: a plain string or a { en = ..., ar = ... } table.
local function english(value, fallback)
    if type(value) == 'table' then return text(value.en) or fallback end
    return text(value) or fallback
end

--- Copy label_ar / label_en / description_ar / description_en from the native definition
--- (a table-valued label/description { en, ar } is spread into the same fields). A weapon
--- definition (core.Shared.Weapons) fills what the item definition leaves empty.
function Catalog.i18n(row, raw, weapon)
    for _, key in ipairs(i18nFields) do
        local value = text(raw[key]) or (weapon and text(weapon[key]))
        if value then row[key] = value end
    end
    local sources = { label = raw.label, description = raw.description or raw.desc }
    if weapon then
        sources.label = type(sources.label) == 'table' and sources.label or (type(weapon.label) == 'table' and weapon.label) or sources.label
        sources.description = type(sources.description) == 'table' and sources.description
            or (type(weapon.description) == 'table' and weapon.description) or sources.description
    end
    for field, value in pairs(sources) do
        if type(value) == 'table' then
            for lang, entry in pairs(value) do
                if (lang == 'ar' or lang == 'en') and text(entry) and row[field .. '_' .. lang] == nil then
                    row[field .. '_' .. lang] = entry
                end
            end
        end
    end
    return row
end

function Catalog.build(framework, definitions, nativeWeapons, fallback, backend)
    assert(type(definitions) == 'table', 'Native item definitions are unavailable')
    local out = {}
    local weaponByName = {}
    for _, entry in pairs(nativeWeapons or {}) do
        if type(entry) == 'table' and type(entry.name) == 'string' then
            weaponByName[Catalog.name(entry.name)] = copy(entry)
        end
    end
    for index, raw in pairs(definitions) do
        if type(raw) == 'table' then
            local originalName = framework == 'vorp' and (raw.item or raw.name) or (raw.name or index)
            -- a story-mode weapon RedM online never loads is never an item (data/story_only_weapons.lua)
            if type(originalName) == 'string' and originalName ~= '' and not shared.isStoryOnlyWeapon(originalName) then
                local name = Catalog.name(originalName)
                local row = backend == 'wcore' and copy(fallback and fallback[name]) or nil
                row = row or baseDefinition(name, fallback and fallback[name])
                row.name = name
                row.nativeSource, row.nativeName = backend == 'wcore' and 'wcore' or framework, originalName
                row.nativeDefinition = copy(raw)
                local defaults = raw.metadata
                if type(defaults) == 'string' and defaults ~= '' then
                    local ok, parsed = pcall(json.decode, defaults)
                    defaults = ok and parsed or nil
                end
                row.defaultMetadata = type(defaults) == 'table' and copy(defaults) or nil
                row.nativeType = raw.type or (row.weapon and 'weapon' or 'item')
                row.nativeWeapon = weaponByName[name]
                -- English source (a { en, ar } table is flattened); the localiser picks later
                row.label = english(raw.label, originalName)
                row.description = english(raw.desc, nil) or english(raw.description, '')
                Catalog.i18n(row, raw, row.nativeWeapon)
                row.weight = math.max(0, tonumber(raw.weight) or 0)
                if framework == 'vorp' then
                    row.weight = math.floor(row.weight * 1000)
                    row.limit = tonumber(raw.limit) or -1
                    row.stack = row.limit ~= 1
                    row.close = flag(raw.closeonuse, true)
                    row.usable = flag(raw.usable, false)
                    row.canRemove = flag(raw.can_remove, true)
                    row.group = raw.groupId or raw.group or row.group
                    row.rarity, row.instruction = raw.rarityId, raw.instructions
                    row.nativeDurability = tonumber(raw.durability) or 0
                    row.useExpired = flag(raw.useExpired, false)
                    row.maxDegradation = tonumber(raw.degradation or raw.maxDegradation) or 0
                    row.deleteOnUse = flag(raw.deleteOnUse, false)
                else
                    row.weapon = raw.type == 'weapon' or raw.type == 'weapon_thrown' or raw.type == 'equipment'
                    row.throwable = raw.type == 'weapon_thrown' or (backend == 'wcore' and row.throwable == true)
                    row.stack = not flag(raw.unique, row.weapon == true)
                    row.close = flag(raw.shouldClose, true)
                    row.usable = flag(raw.useable, flag(raw.usable, row.weapon == true))
                    row.canRemove = true
                    row.unique = not row.stack
                    row.combinable = copy(raw.combinable)
                    if backend ~= 'wcore' then
                        -- Only a native RSG/QBR host owns its weapon mechanics externally.
                        row.ammoname, row.ammoFamily, row.ammoType, row.durability = nil, nil, nil, nil
                        row.ammo, row.ammocount = nil, nil
                    end
                end
                if backend == 'wcore' and row.throwableUnit and row.weaponType then
                    row.weapon, row.throwable, row.stack, row.unique = true, true, true, false
                end
                if row.weapon then
                    row.worldModel = row.worldModel or raw.model
                    row.model = row.weaponType or name
                    row.hash = joaat(row.model)
                end
                row.client = { image = raw.image or originalName .. '.png' }
                out[name] = row
            end
        end
    end
    if framework == 'vorp' then
        -- Native weapon definitions are separate from the SQL items catalog.
        for key, raw in pairs(nativeWeapons or {}) do
            if type(raw) == 'table' and not shared.isStoryOnlyWeapon(raw.HashName or raw.name or key) then
                local name = Catalog.name(raw.HashName or raw.name or key)
                local row = baseDefinition(name, fallback and fallback[name])
                row.weapon, row.stack, row.close = true, false, false
                if raw.NoDegradation then row.durability = 0 end
                row.nativeSource, row.nativeType, row.nativeName = 'vorp', 'item_weapon', name
                row.nativeDefinition, row.nativeWeapon = copy(raw), copy(raw)
                row.model, row.hash = raw.HashName or name, joaat(raw.HashName or name)
                row.label = english(raw.Name, nil) or english(raw.label, name)
                row.description = english(raw.Desc, nil) or english(raw.description, '')
                Catalog.i18n(row, raw)
                row.weight = math.max(0, math.floor((tonumber(raw.Weight) or 0) * 1000))
                row.usable, row.canRemove = true, true
                row.client = { image = name .. '.png' }
                out[name] = row
            end
        end
    end
    return out
end

-- ★ Behaviour the client attaches to a definition at load time, which the native
--   catalog knows nothing about. `items[name] = row` replaces the table outright,
--   so without carrying these across, everything bolted on earlier is dropped the
--   moment the live catalog lands:
--     buttons            → the refill button on weapons and pack/unpack on ammo
--                          simply stop appearing in the context menu
--     effect             → client use effects (bandage)
--                          silently stop firing
--     ammoPack/Unpack    → the boxed-ammo guard in the reload path stops holding
--
--   The native row wins wherever it actually defines the field; these only fill
--   what it leaves empty. The bilingual fields (label_ar, i18n, ...) are NOT carried
--   over: the native catalogue is the only source of an item's name, and copy() keeps
--   every string-keyed field of the row, so they arrive with it when it has them.
local carryOverFields = { 'buttons', 'effect', 'ammoPack', 'ammoUnpack' }

function Catalog.apply(items, definitions, clientSide, imagePath)
    for name, definition in pairs(definitions or {}) do
        local row = copy(definition)
        if row and row.nativeSource then
            local previous = items[name]
            if clientSide then
                row.count = previous and previous.count or 0
                if row.client and row.client.image and not row.client.image:match('^[%w]+://') then
                    row.client.image = ('%s/%s'):format(imagePath, row.client.image)
                end
                if previous then
                    for _, key in ipairs(carryOverFields) do
                        if row[key] == nil then row[key] = previous[key] end
                    end
                end
            else row.client = nil end
            items[name] = row
        end
    end
    return items
end

return Catalog
