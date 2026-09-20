-- ============================================================
-- RDR3 Ammunition Types & Family Registry
-- Defines engine bullet types, inventory box items, and loose round items.
-- ============================================================

local Families = {

    -- Revolvers
    ammo_revolver = {
        { ammo = 'AMMO_REVOLVER', items = { 'ammo_box_revolver_regular', 'ammo_revolver', 'ammorevolvernormal' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_REVOLVER_EXPRESS', items = { 'ammo_box_revolver_express', 'ammo_revolver_express', 'ammorevolverexpress' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_REVOLVER_HIGH_VELOCITY', items = { 'ammo_box_revolver_high_velocity', 'ammo_revolver_high_velocity', 'ammorevolvervelocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_REVOLVER_SPLIT_POINT', items = { 'ammo_box_revolver_split_point', 'ammo_revolver_split_point', 'ammorevolversplitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
        { ammo = 'AMMO_REVOLVER_EXPRESS_EXPLOSIVE', items = { 'ammo_box_revolver_express_explosive', 'ammo_revolver_express_explosive', 'ammorevolverexplosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
    },

    -- Pistols
    ammo_pistol = {
        { ammo = 'AMMO_PISTOL', items = { 'ammo_box_pistol_regular', 'ammo_pistol', 'ammopistolnormal' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_PISTOL_EXPRESS', items = { 'ammo_box_pistol_express', 'ammo_pistol_express', 'ammopistolexpress' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_PISTOL_HIGH_VELOCITY', items = { 'ammo_box_pistol_high_velocity', 'ammo_pistol_high_velocity', 'ammopistolvelocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_PISTOL_SPLIT_POINT', items = { 'ammo_box_pistol_split_point', 'ammo_pistol_split_point', 'ammopistolsplitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
        { ammo = 'AMMO_PISTOL_EXPRESS_EXPLOSIVE', items = { 'ammo_box_pistol_express_explosive', 'ammo_pistol_express_explosive', 'ammopistolexplosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
    },

    -- Repeaters
    ammo_repeater = {
        { ammo = 'AMMO_REPEATER', items = { 'ammo_box_repeater_regular', 'ammo_repeater', 'ammorepeaternormal' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_REPEATER_EXPRESS', items = { 'ammo_box_repeater_express', 'ammo_repeater_express', 'ammorepeaterexpress' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_REPEATER_HIGH_VELOCITY', items = { 'ammo_box_repeater_high_velocity', 'ammo_repeater_high_velocity', 'ammorepeatervelocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_REPEATER_SPLIT_POINT', items = { 'ammo_box_repeater_split_point', 'ammo_repeater_split_point', 'ammorepeatersplitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
        { ammo = 'AMMO_REPEATER_EXPRESS_EXPLOSIVE', items = { 'ammo_box_repeater_express_explosive', 'ammo_repeater_express_explosive', 'ammorepeaterexplosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
    },

    -- Rifles & Snipers & Elephant
    ammo_rifle = {
        { ammo = 'AMMO_RIFLE', items = { 'ammo_box_rifle_regular', 'ammo_rifle', 'ammoriflenormal' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_RIFLE_EXPRESS', items = { 'ammo_box_rifle_express', 'ammo_rifle_express', 'ammorifleexpress' }, label = 'إكسبريس', label_en = 'Express' },
        { ammo = 'AMMO_RIFLE_HIGH_VELOCITY', items = { 'ammo_box_rifle_high_velocity', 'ammo_rifle_high_velocity', 'ammoriflevelocity' }, label = 'سرعة عالية', label_en = 'High Velocity' },
        { ammo = 'AMMO_RIFLE_SPLIT_POINT', items = { 'ammo_box_rifle_split_point', 'ammo_rifle_split_point', 'ammoriflesplitpoint' }, label = 'سبليت بوينت', label_en = 'Split Point' },
        { ammo = 'AMMO_RIFLE_EXPRESS_EXPLOSIVE', items = { 'ammo_box_rifle_express_explosive', 'ammo_rifle_express_explosive', 'ammorifleexplosive' }, label = 'إكسبريس متفجر', label_en = 'Express Explosive' },
        { ammo = 'AMMO_RIFLE_ELEPHANT', items = { 'ammo_box_rifle_elephant', 'ammo_rifle_elephant', 'ammoelephant' }, label = 'رصاص الفيل', label_en = 'Elephant' },
    },

    -- Shotguns
    ammo_shotgun = {
        { ammo = 'AMMO_SHOTGUN', items = { 'ammo_box_shotgun_regular', 'ammo_shotgun', 'ammoshotgunnormal' }, label = 'خرطوش عادي', label_en = 'Buckshot' },
        { ammo = 'AMMO_SHOTGUN_SLUG', items = { 'ammo_box_shotgun_slug', 'ammo_shotgun_slug', 'ammoshotgunslug' }, label = 'سلاق', label_en = 'Slug' },
        { ammo = 'AMMO_SHOTGUN_BUCKSHOT_INCENDIARY', items = { 'ammo_box_shotgun_buckshot_incendiary', 'ammo_shotgun_buckshot_incendiary', 'ammoshotgunincendiary' }, label = 'حارق', label_en = 'Incendiary' },
        { ammo = 'AMMO_SHOTGUN_SLUG_EXPLOSIVE', items = { 'ammo_box_shotgun_slug_explosive', 'ammo_shotgun_slug_explosive', 'ammoshotgunexplosive' }, label = 'متفجر', label_en = 'Explosive Slug' },
    },

    -- Varmint .22
    ammo_22 = {
        { ammo = 'AMMO_22', items = { 'ammo_box_22_regular', 'ammo_22', 'ammovarmint' }, label = 'رصاص عادي', label_en = 'Normal' },
        { ammo = 'AMMO_22_TRANQUILIZER', items = { 'ammo_box_22_tranquilizer', 'ammo_22_tranquilizer', 'ammovarminttranq' }, label = 'مخدّر', label_en = 'Tranquilizer' },
    },

    -- Bows & Arrows
    ammo_arrow = {
        { ammo = 'AMMO_ARROW', items = { 'ammo_box_arrow', 'ammo_arrow', 'ammoarrownormal' }, label = 'سهم عادي', label_en = 'Arrow' },
        { ammo = 'AMMO_ARROW_IMPROVED', items = { 'ammo_box_arrow_improved', 'ammo_arrow_improved', 'ammoarrowimproved' }, label = 'سهم محسّن', label_en = 'Improved Arrow' },
        { ammo = 'AMMO_ARROW_SMALL_GAME', items = { 'ammo_box_arrow_small_game', 'ammo_arrow_small_game', 'ammoarrowsmallgame' }, label = 'سهم صيد صغير', label_en = 'Small Game Arrow' },
        { ammo = 'AMMO_ARROW_FIRE', items = { 'ammo_box_arrow_fire', 'ammo_arrow_fire', 'ammoarrowfire' }, label = 'سهم حارق', label_en = 'Fire Arrow' },
        { ammo = 'AMMO_ARROW_POISON', items = { 'ammo_box_arrow_poison', 'ammo_arrow_poison', 'ammoarrowpoison' }, label = 'سهم سام', label_en = 'Poison Arrow' },
        { ammo = 'AMMO_ARROW_DYNAMITE', items = { 'ammo_box_arrow_dynamite', 'ammo_arrow_dynamite', 'ammoarrowdynamite' }, label = 'سهم ديناميت', label_en = 'Dynamite Arrow' },
        { ammo = 'AMMO_ARROW_TRACKING', items = { 'ammo_box_arrow_tracking', 'ammo_arrow_tracking', 'ammoarrowtracking' }, label = 'سهم تتبع', label_en = 'Tracking Arrow' },
    },

    -- Thrown Weapons (Single source of truth)
    ammo_throwing_knives = {
        { ammo = 'AMMO_THROWING_KNIVES', items = { 'ammo_unit_throwing_knives' }, label = 'سكين رمي', label_en = 'Throwing Knife' },
        { ammo = 'AMMO_THROWING_KNIVES_IMPROVED', items = { 'ammo_unit_throwing_knives_improved' }, label = 'سكين رمي محسن', label_en = 'Improved Throwing Knife' },
        { ammo = 'AMMO_THROWING_KNIVES_POISON', items = { 'ammo_unit_throwing_knives_poison' }, label = 'سكين رمي سام', label_en = 'Poison Throwing Knife' },
    },

    ammo_tomahawk = {
        { ammo = 'AMMO_TOMAHAWK', items = { 'ammo_unit_tomahawk' }, label = 'توماهوك', label_en = 'Tomahawk' },
        { ammo = 'AMMO_TOMAHAWK_IMPROVED', items = { 'ammo_unit_tomahawk_improved' }, label = 'توماهوك محسن', label_en = 'Improved Tomahawk' },
        { ammo = 'AMMO_TOMAHAWK_HOMING', items = { 'ammo_unit_tomahawk_homing' }, label = 'توماهوك موجه', label_en = 'Homing Tomahawk' },
        { ammo = 'AMMO_TOMAHAWK_ANCIENT', items = { 'ammo_unit_tomahawk_ancient' }, label = 'توماهوك أثري', label_en = 'Ancient Tomahawk' },
    },

    ammo_dynamite = {
        { ammo = 'AMMO_DYNAMITE', items = { 'ammo_unit_dynamite' }, label = 'ديناميت', label_en = 'Dynamite' },
        { ammo = 'AMMO_DYNAMITE_VOLATILE', items = { 'ammo_unit_dynamite_volatile' }, label = 'ديناميت شديد الانفجار', label_en = 'Volatile Dynamite' },
    },

    ammo_molotov = {
        { ammo = 'AMMO_MOLOTOV', items = { 'ammo_unit_molotov' }, label = 'زجاجة حارقة', label_en = 'Fire Bottle' },
        { ammo = 'AMMO_MOLOTOV_VOLATILE', items = { 'ammo_unit_molotov_volatile' }, label = 'زجاجة حارقة شديدة', label_en = 'Volatile Fire Bottle' },
    },

    ammo_bolas = {
        { ammo = 'AMMO_BOLAS', items = { 'ammo_unit_bolas' }, label = 'بولاس', label_en = 'Bolas' },
        { ammo = 'AMMO_BOLAS_HAWKMOTH', items = { 'ammo_unit_bolas_hawkmoth' }, label = 'بولاس هوكموث', label_en = 'Hawkmoth Bolas' },
        { ammo = 'AMMO_BOLAS_INTERTWINED', items = { 'ammo_unit_bolas_intertwined' }, label = 'بولاس متشابك', label_en = 'Intertwined Bolas' },
        { ammo = 'AMMO_BOLAS_IRONSPIKED', items = { 'ammo_unit_bolas_ironspiked' }, label = 'بولاس بمسامير حديدية', label_en = 'Ironspiked Bolas' },
    },

    ammo_poisonbottle = {
        { ammo = 'AMMO_POISONBOTTLE', items = { 'ammo_unit_poisonbottle' }, label = 'زجاجة سم', label_en = 'Toxic Moonshine Bottle' },
    },
}

-- Exact channels from the supplied compatibility matrix: a shared family must not
-- make the elephant rifle, ancient tomahawk or distinct bolas interchangeable.
local function separate(source, target, ammo)
    for i, entry in ipairs(Families[source]) do
        if entry.ammo == ammo then
            Families[target] = { table.remove(Families[source], i) }
            return
        end
    end
end
separate('ammo_rifle', 'ammo_rifle_elephant', 'AMMO_RIFLE_ELEPHANT')
separate('ammo_tomahawk', 'ammo_tomahawk_ancient', 'AMMO_TOMAHAWK_ANCIENT')
separate('ammo_bolas', 'ammo_bolas_hawkmoth', 'AMMO_BOLAS_HAWKMOTH')
separate('ammo_bolas', 'ammo_bolas_intertwined', 'AMMO_BOLAS_INTERTWINED')
separate('ammo_bolas', 'ammo_bolas_ironspiked', 'AMMO_BOLAS_IRONSPIKED')

if shared and shared.framework == 'vorp' then
    for _, entries in pairs(Families) do
        for _, entry in ipairs(entries) do
            table.insert(entry.items, 1, '__vorp_belt_' .. entry.ammo:lower())
        end
    end
end

local function getAll(ammoname)
    return ammoname and Families[ammoname] or {}
end

local function pickItem(entry, itemExists)
    for i = 1, #entry.items do
        if not entry.items[i]:find('^ammo_box_') and (not itemExists or itemExists(entry.items[i])) then
            return entry.items[i]
        end
    end
end

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
    return math.floor(value) % 4294967296
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

local function resolve(ammoname, key, itemExists)
    local rawKey = key
    if type(rawKey) == 'table' then
        rawKey = rawKey.ammo or rawKey.ammoType or rawKey.item or rawKey.name or rawKey.type
    end

    local textKey, numericKey = lookupKey(key)
    if not textKey and not numericKey then return nil end

    local entries = getAll(ammoname)
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

    return matchItemName()
end

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
