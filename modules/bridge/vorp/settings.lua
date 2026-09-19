-- Read gameplay settings only; no native UI settings are applied to W's design.
local env = setmetatable({ CONFIG = {} }, { __index = _G })
for _, file in ipairs({ 'config/config.lua', 'config/config_server.lua' }) do
    local source = LoadResourceFile('vorp_inventory', file)
    if source then
        local fn, err = load(source, '@vorp_inventory/' .. file, 't', env)
        assert(fn, err)
        fn()
    end
end
local config = env.CONFIG
return {
    slots = config.INVENTORY_UI and config.INVENTORY_UI.MAIN_INVENTORY_FIXED_SLOT_COUNT or 52,
    deleteExpired = config.DELETE_ITEM_EXPIRED == true,
    maxWeapons = config.MAX_WEAPONS or { PLAYERS = 10, JOBS = {}, WHITELIST = {
        WEAPON_KIT_BINOCULARS_IMPROVED = true, WEAPON_KIT_BINOCULARS = true,
        WEAPON_FISHINGROD = true, WEAPON_KIT_CAMERA = true, WEAPON_KIT_CAMERA_ADVANCED = true,
        WEAPON_MELEE_LANTERN = true, WEAPON_MELEE_DAVY_LANTERN = true,
        WEAPON_MELEE_LANTERN_HALLOWEEN = true, WEAPON_KIT_METAL_DETECTOR = true,
        WEAPON_MELEE_HAMMER = true, WEAPON_MELEE_KNIFE = true,
    } },
}
