--[[
    WEAPON TO RDR2 WORLD MODEL MAPPING
    Generated from RAGE-StringsDatabase weapon model files.

    Base weapon model names extracted from:
    - packs_1 (base game)
    - mp001 through mp009 (DLC)
    - dlc_content_extra
    - patchpack002, patchpack003, patchpack004

    Used for weapon drops, inventory display props, etc.
    Filter: Excludes +hi, _hi, _grip, _barrel, _sight, _clip, _wrap, _mag, _stock
]]

return {
    -- REVOLVERS
    ['WEAPON_REVOLVER_CATTLEMAN'] = 'w_revolver_cattleman01',
    ['WEAPON_REVOLVER_CATTLEMAN_MEXICAN'] = 'w_revolver_cattleman02',
    ['WEAPON_REVOLVER_DOUBLEACTION_GAMBLER'] = 'w_revolver_doubleaction04',  -- mp001/dlc_content_extra
    ['WEAPON_REVOLVER_DOUBLEACTION'] = 'w_revolver_doubleaction01',
    ['WEAPON_REVOLVER_SCHOFIELD'] = 'w_revolver_schofield01',
    ['WEAPON_REVOLVER_LEMAT'] = 'w_revolver_lemat01',
    ['WEAPON_REVOLVER_NAVY'] = 'w_revolver_navy01',
    ['WEAPON_REVOLVER_NAVY_CROSSOVER'] = 'w_revolver_navy02',

    -- PISTOLS
    ['WEAPON_PISTOL_VOLCANIC'] = 'w_pistol_volcanic01',
    ['WEAPON_PISTOL_M1899'] = 'w_pistol_m189902',
    ['WEAPON_PISTOL_MAUSER'] = 'w_pistol_mauser01',
    ['WEAPON_PISTOL_SEMIAUTO'] = 'w_pistol_semiauto01',

    -- REPEATERS
    ['WEAPON_REPEATER_CARBINE'] = 'w_repeater_carbine01',
    ['WEAPON_REPEATER_WINCHESTER'] = 'w_repeater_winchester01',
    ['WEAPON_REPEATER_HENRY'] = 'w_repeater_henry01',
    ['WEAPON_REPEATER_EVANS'] = 'w_repeater_evans01',

    -- RIFLES
    ['WEAPON_RIFLE_VARMINT'] = 'rifle_varmint',  -- Base game uses non-w_ prefix
    ['WEAPON_RIFLE_SPRINGFIELD'] = 'w_rifle_springfield01',
    ['WEAPON_RIFLE_BOLTACTION'] = 'w_rifle_boltaction01',
    ['WEAPON_RIFLE_ELEPHANT'] = 'w_rifle_elephant01',

    -- SHOTGUNS
    ['WEAPON_SHOTGUN_DOUBLEBARREL'] = 'w_shotgun_doublebarrel01',
    ['WEAPON_SHOTGUN_DOUBLEBARREL_EXOTIC'] = 'w_shotgun_doublebarrel02',  -- or w_shotgun_doublebarrel03
    ['WEAPON_SHOTGUN_SAWEDOFF'] = 'w_shotgun_sawed01',
    ['WEAPON_SHOTGUN04'] = 'w_shotgun_repeating01',  -- Winchester 1887
    ['WEAPON_SHOTGUN05'] = 'w_shotgun_pumpaction01',  -- Winchester 1897
    ['WEAPON_SHOTGUN_SEMIAUTO'] = 'w_shotgun_semiauto01',
    ['WEAPON_SHOTGUN_PUMP'] = 'w_shotgun_pumpaction01',
    ['WEAPON_SHOTGUN_REPEATING'] = 'w_shotgun_repeating01',

    -- SNIPERS
    ['WEAPON_SNIPERRIFLE_ROLLINGBLOCK'] = 'w_rifle_rollingblock01',
    ['WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC'] = 'w_rifle_rollingblock02',
    ['WEAPON_SNIPERRIFLE_CARCANO'] = 'w_rifle_carcano01',

    -- BOWS
    ['WEAPON_BOW'] = 'w_sp_bowarrow',
    ['WEAPON_BOW_IMPROVED'] = 'w_bow_improved01',

    -- LASSO
    ['WEAPON_LASSO'] = 'w_melee_lasso01',
    ['WEAPON_LASSO_REINFORCED'] = 'w_melee_lasso02',

    -- MELEE
    ['WEAPON_MELEE_KNIFE'] = 'w_melee_knife01',
    ['WEAPON_MELEE_KNIFE_JAWBONE'] = 'w_melee_knife02',
    ['WEAPON_MELEE_HAMMER'] = 'w_melee_hammer02',  -- mp005; base has no hammer in weapons.txt
    ['WEAPON_MELEE_CLEAVER'] = 'p_cleaver01x',  -- Prop model, no w_melee_cleaver exists
    ['WEAPON_MELEE_KNIFE_MINER'] = 'w_melee_knife16',  -- patchpack002
    ['WEAPON_MELEE_KNIFE_VAMPIRE'] = 'w_melee_knife17',  -- Best match
    ['WEAPON_MELEE_TORCH'] = 'w_melee_torch01',
    ['WEAPON_MELEE_HATCHET'] = 'w_melee_hatchet01',
    ['WEAPON_MELEE_MACHETE'] = 'w_melee_machete01',
    ['WEAPON_MELEE_LANTERN'] = 'w_throw_lantern01',  -- Lantern when held
    ['WEAPON_MELEE_DAVY_LANTERN'] = 'w_throw_lantern01',
    ['WEAPON_MELEE_LANTERN_ELECTRIC'] = 'w_throw_lantern01',  -- Same base
    ['WEAPON_MELEE_MACHETE_COLLECTOR'] = 'w_melee_machete03',  -- mp005
    ['WEAPON_MELEE_KNIFE_TRADER'] = 'w_melee_knife22',  -- mp005
    ['WEAPON_MELEE_KNIFE_HORROR'] = 'w_melee_knife23',  -- mp009
    ['WEAPON_MELEE_KNIFE_RUSTIC'] = 'w_melee_knife24',  -- mp009
    ['WEAPON_MELEE_LANTERN_HALLOWEEN'] = 'w_throw_lantern01',
    ['WEAPON_MELEE_MACHETE_HORROR'] = 'w_melee_machete04',  -- mp007
    ['WEAPON_MOONSHINEJUG_MP'] = 'p_masonjarmoonshine01x',  -- Mason jar moonshine

    -- THROWABLES
    ['WEAPON_THROWN_DYNAMITE'] = 'w_throw_dynamite01',
    ['WEAPON_THROWN_MOLOTOV'] = 'w_throw_molotov01',
    ['WEAPON_THROWN_THROWING_KNIVES'] = 'w_melee_knife02',  -- Throwing knife uses knife model
    ['WEAPON_THROWN_TOMAHAWK'] = 'w_melee_tomahawk01',
    ['WEAPON_THROWN_TOMAHAWK_ANCIENT'] = 'w_melee_tomahawk02',
    ['WEAPON_THROWN_BOLAS'] = 'mp005_s_melee_bolas01',  -- Bolas DLC model; may need w_ equivalent
    ['WEAPON_THROWN_POISONBOTTLE'] = 'w_throw_poisonbottle01',
    ['WEAPON_THROWN_BOLAS_HAWKMOTH'] = 'mp008_s_melee_bolas02',
    ['WEAPON_THROWN_BOLAS_IRONSPIKED'] = 'mp008_s_melee_bolas03',
    ['WEAPON_THROWN_BOLAS_INTERTWINED'] = 'mp008_s_melee_bolas04',

    -- KITS
    ['WEAPON_KIT_BINOCULARS_IMPROVED'] = 'w_binoculars02',  -- mp005
    ['WEAPON_KIT_BINOCULARS'] = 'w_rifle_binoculars01',
    ['WEAPON_FISHINGROD'] = 'w_melee_fishingpole01',
    ['WEAPON_KIT_CAMERA'] = 'w_camerabox01x',
    ['WEAPON_KIT_CAMERA_ADVANCED'] = 'w_camerabox01x',  -- Same base
    ['WEAPON_KIT_METAL_DETECTOR'] = 'w_electricfielddetector01',
}
