-- ============================================================
-- RDR3 ammunition types
--
-- The key is the ammoname declared in data/weapons_RDR3.lua
--
-- A type accepts existing framework names plus Wraith shop item aliases:
--   items[1] the VORP name  (the source: vorp_weaponsv2/config/ammo.lua)
--   items[2] the boxed name (ammo_box_*: the second item name a type may carry)
--   further names preserve loose ammunition already bought from Wraith shops.
-- The functions pick an existing item; explicit item names are never replaced by an alias.
--
-- `ammo` is the bullet type in the game, passed to SetPedAmmoByType
-- and SetAmmoTypeForPedWeapon.
--
-- `label`  = the Arabic label . `label_en` = the English one (for the bilingual bullet
--            selection list; chosen through shared.localeKey(), which init.lua derives from
--            w_lib's getLocaleKey() - the player's language on the client, the `w_lib:locale`
--            convar on the server).
-- ============================================================

local Families = {

    -- The revolver
    ammo_revolver = {
        { ammo = 'AMMO_REVOLVER', items = { 'ammorevolvernormal', 'ammo_box_revolver', 'ammo_revolver' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_REVOLVER_EXPRESS', items = { 'ammorevolverexpress', 'ammo_box_revolver_express' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_REVOLVER_EXPRESS_EXPLOSIVE', items = { 'ammorevolverexplosive', 'ammo_box_revolver_explosive', 'ammo_revolver_express_explosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
        { ammo = 'AMMO_REVOLVER_HIGH_VELOCITY', items = { 'ammorevolvervelocity', 'ammo_box_revolver_velocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_REVOLVER_SPLIT_POINT', items = { 'ammorevolversplitpoint', 'ammo_box_revolver_splitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
    },

    -- The pistol
    ammo_pistol = {
        { ammo = 'AMMO_PISTOL', items = { 'ammopistolnormal', 'ammo_box_pistol', 'ammo_pistol' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_PISTOL_EXPRESS', items = { 'ammopistolexpress', 'ammo_box_pistol_express' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_PISTOL_EXPRESS_EXPLOSIVE', items = { 'ammopistolexplosive', 'ammo_box_pistol_explosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
        { ammo = 'AMMO_PISTOL_HIGH_VELOCITY', items = { 'ammopistolvelocity', 'ammo_box_pistol_velocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_PISTOL_SPLIT_POINT', items = { 'ammopistolsplitpoint', 'ammo_box_pistol_splitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
    },

    -- The repeater
    ammo_repeater = {
        { ammo = 'AMMO_REPEATER', items = { 'ammorepeaternormal', 'ammo_box_repeater', 'ammo_repeater' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_REPEATER_EXPRESS', items = { 'ammorepeaterexpress', 'ammo_box_repeater_express' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_REPEATER_EXPRESS_EXPLOSIVE', items = { 'ammorepeaterexplosive', 'ammo_box_repeater_explosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
        { ammo = 'AMMO_REPEATER_HIGH_VELOCITY', items = { 'ammorepeatervelocity', 'ammo_box_repeater_velocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_REPEATER_SPLIT_POINT', items = { 'ammorepeatersplitpoint', 'ammo_box_repeater_splitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
    },

    -- The rifle
    ammo_rifle = {
        { ammo = 'AMMO_RIFLE', items = { 'ammoriflenormal', 'ammo_box_rifle', 'ammo_rifle' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_RIFLE_EXPRESS', items = { 'ammorifleexpress', 'ammo_box_rifle_express' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_RIFLE_EXPRESS_EXPLOSIVE', items = { 'ammorifleexplosive', 'ammo_box_rifle_explosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
        { ammo = 'AMMO_RIFLE_HIGH_VELOCITY', items = { 'ammoriflevelocity', 'ammo_box_rifle_velocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_RIFLE_SPLIT_POINT', items = { 'ammoriflesplitpoint', 'ammo_box_rifle_splitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
        { ammo = 'AMMO_RIFLE_ELEPHANT', items = { 'ammoelephant', 'ammo_box_rifle_elephant' }, label = 'رصاص الفيل', label_en = 'Elephant' },
    },

    -- The shotgun
    ammo_shotgun = {
        { ammo = 'AMMO_SHOTGUN', items = { 'ammoshotgunnormal', 'ammo_box_shotgun', 'ammo_shotgun' }, label = 'خرطوش عادي', label_en = 'Buckshot' },
        { ammo = 'AMMO_SHOTGUN_SLUG', items = { 'ammoshotgunslug', 'ammo_box_shotgun_slug' }, label = 'سلاق', label_en = 'Slug' },
        { ammo = 'AMMO_SHOTGUN_EXPRESS_EXPLOSIVE', items = { 'ammoshotgunexplosive', 'ammo_box_shotgun_explosive' }, label = 'متفجر', label_en = 'Explosive Slug' },
        { ammo = 'AMMO_SHOTGUN_BUCKSHOT_INCENDIARY', items = { 'ammoshotgunincendiary', 'ammo_box_shotgun_incendiary' }, label = 'حارق', label_en = 'Incendiary' },
    },

    -- The varmint
    ammo_22 = {
        { ammo = 'AMMO_22', items = { 'ammovarmint', 'ammo_box_varmint', 'ammo_22' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_22_TRANQUILIZER', items = { 'ammovarminttranq', 'ammo_box_varmint_tranquilizer' }, label = 'مخدّر', label_en = 'Tranquilizer' },
    },

    -- The bow
    ammo_arrow = {
        { ammo = 'AMMO_ARROW', items = { 'ammoarrownormal', 'ammo_arrow' }, label = 'سهم عادي', label_en = 'Arrow' },
        { ammo = 'AMMO_ARROW_FIRE', items = { 'ammoarrowfire', 'ammo_arrow_fire' }, label = 'سهم حارق', label_en = 'Fire Arrow' },
        { ammo = 'AMMO_ARROW_POISON', items = { 'ammoarrowpoison', 'ammo_arrow_poison' }, label = 'سهم سام', label_en = 'Poison Arrow' },
        { ammo = 'AMMO_ARROW_DYNAMITE', items = { 'ammoarrowdynamite', 'ammo_arrow_dynamite' }, label = 'سهم ديناميت', label_en = 'Dynamite Arrow' },
        { ammo = 'AMMO_ARROW_SMALL_GAME', items = { 'ammoarrowsmallgame', 'ammo_arrow_small' }, label = 'سهم صيد صغير', label_en = 'Small Game Arrow' },
        { ammo = 'AMMO_ARROW_IMPROVED', items = { 'ammoarrowimproved', 'ammo_arrow_improved' }, label = 'سهم محسّن', label_en = 'Improved Arrow' },
    },
}

-- ============================================================
-- The functions
-- ============================================================

--- Every type defined for a family
---@param ammoname string
---@return table
if shared and shared.framework == 'vorp' then
    for _, entries in pairs(Families) do
        for _, entry in ipairs(entries) do
            if entry.ammo == 'AMMO_SHOTGUN_EXPRESS_EXPLOSIVE' then entry.ammo = 'AMMO_SHOTGUN_SLUG_EXPLOSIVE' end
            table.insert(entry.items, 1, '__vorp_belt_' .. entry.ammo:lower())
        end
    end
end

local function getAll(ammoname)
    return ammoname and Families[ammoname] or {}
end

--- The first item name that really exists for this type
---@param entry table
---@param itemExists fun(name:string):boolean
---@return string|nil
local function pickItem(entry, itemExists)
    for i = 1, #entry.items do
        if not itemExists or itemExists(entry.items[i]) then
            return entry.items[i]
        end
    end
end

--- The types that have an actual item
---@param ammoname string
---@param itemExists fun(name:string):boolean
---@return table
local function getAvailable(ammoname, itemExists)
    local available = {}

    for _, entry in ipairs(getAll(ammoname)) do
        local item = pickItem(entry, itemExists)
        if item then
            available[#available + 1] = {
                item = item,
                ammo = entry.ammo,
                label = entry.label,
                label_en = entry.label_en,
            }
        end
    end

    return available
end

local function unsignedHash(value)
    value = tonumber(value)
    if not value or value ~= value then return end
    value = math.floor(value) % 4294967296
    return value
end

local function lookupKey(key)
    if type(key) == 'table' then
        key = key.ammo or key.ammoType or key.item or key.name or key.type
    end

    if type(key) == 'number' then
        return nil, unsignedHash(key)
    end

    if type(key) ~= 'string' or key == '' then return end
    return key:lower(), nil
end

--- Finding a type inside a family by the item's name or by the bullet type.
--- It also accepts the numeric hash and the value stored inside a table, and it ignores letter case.
---@param ammoname string
---@param key string|number|table|nil
---@param itemExists? fun(name:string):boolean
---@return table|nil
local function resolve(ammoname, key, itemExists)
    local rawKey = key
    if type(rawKey) == 'table' then
        rawKey = rawKey.ammo or rawKey.ammoType or rawKey.item or rawKey.name or rawKey.type
    end

    local textKey, numericKey = lookupKey(key)
    if not textKey and not numericKey then return nil end

    local entries = getAll(ammoname)

    -- * Separating the collision between the type's name and the item's name.
    --
    -- The arrow family's key is 'ammo_arrow' and its type is 'AMMO_ARROW' - and after lowering
    -- the letters the two match, and there is an item named 'ammo_arrow' as well. So
    -- 'the player is loading the item ammo_arrow' was matched against the **type**, so pickItem returned
    -- the first item that exists ('ammoarrownormal'), and the server tried to deduct an item the player
    -- does not own so the reload failed: 'the operation failed' and the arrows in the bag.
    --
    -- The reliable separator: bullet types are always written AMMO_* in capitals in
    -- the catalogue, and item names are not. We read the raw key before lowering its letters.
    local looksLikeType = type(rawKey) == 'string' and rawKey:find('^AMMO_') ~= nil

    local function matchItemName()
        if not textKey then return nil end

        for _, entry in ipairs(entries) do
            for i = 1, #entry.items do
                if entry.items[i]:lower() == textKey then
                    return { item = entry.items[i], ammo = entry.ammo, label = entry.label, label_en = entry.label_en }
                end
            end
        end
    end

    if not looksLikeType then
        local hit = matchItemName()
        if hit then return hit end
    end

    for _, entry in ipairs(entries) do
        local ammoMatches = textKey and entry.ammo:lower() == textKey
        if numericKey and type(joaat) == 'function' then
            ammoMatches = unsignedHash(joaat(entry.ammo)) == numericKey
        end

        if ammoMatches then
            return { item = pickItem(entry, itemExists) or entry.items[1], ammo = entry.ammo, label = entry.label, label_en = entry.label_en }
        end
    end

    -- A key in capitals but really an item name - a last resort
    return matchItemName()
end

--- A family's primary type
---@param ammoname string
---@param itemExists? fun(name:string):boolean
---@return table|nil
local function getDefault(ammoname, itemExists)
    local entry = getAll(ammoname)[1]
    if not entry then return nil end

    return { item = pickItem(entry, itemExists) or entry.items[1], ammo = entry.ammo, label = entry.label, label_en = entry.label_en }
end

return {
    Families = Families,
    GetAll = getAll,
    GetAvailable = getAvailable,
    Resolve = resolve,
    GetDefault = getDefault,
}
