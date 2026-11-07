-- Story-mode weapons RedM online never loads: the game refuses to give them (confirmed in game with
-- WEAPON_MELEE_HATCHET_VIKING; the list is the commented-out entries of femga/rdr3_discoveries
-- weapons/weapons.lua that this server had in its catalog).
--
-- 2026-11-08, the owner: remove them from the bag and from the players. They are no longer item
-- definitions (data/weapons_RDR3.lua), so no shop, admin list, crafting board or store shows them,
-- and every saved row of one is dropped where it loads (Inventory.StripStoryOnly: the player's bag,
-- stashes, saddlebags, wagons, offline edits). The next save of that inventory writes it clean.
-- The names stay here only so those old rows are recognised and removed instead of failing the load.
return {
    'WEAPON_REVOLVER_CATTLEMAN_JOHN',
    'WEAPON_REVOLVER_CATTLEMAN_PIG',
    'WEAPON_REVOLVER_DOUBLEACTION_EXOTIC',
    'WEAPON_REVOLVER_DOUBLEACTION_MICAH',
    'WEAPON_REVOLVER_SCHOFIELD_CALLOWAY',
    'WEAPON_REVOLVER_SCHOFIELD_GOLDEN',
    'WEAPON_PISTOL_MAUSER_DRUNK',
    'WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC',
    'WEAPON_MELEE_KNIFE_BEAR',
    'WEAPON_MELEE_KNIFE_CIVIL_WAR',
    'WEAPON_MELEE_KNIFE_MINER',
    'WEAPON_MELEE_KNIFE_VAMPIRE',
    'WEAPON_MELEE_KNIFE_JOHN',
    'WEAPON_MELEE_BROKEN_SWORD',
    'WEAPON_MELEE_ANCIENT_HATCHET',
    'WEAPON_MELEE_HATCHET_VIKING',
    'WEAPON_MELEE_HATCHET_HEWING',
    'WEAPON_MELEE_HATCHET_DOUBLE_BIT_RUSTED',
    'WEAPON_MELEE_HATCHET_HUNTER_RUSTED',
    'WEAPON_MELEE_LANTERN_ELECTRIC',
}
