Config = Config or {}

-- Language: there is no setting here. The w_lib library owns the language (Arabic or
-- English): the player's choice in /w_lib on the client, the `w_lib:locale` convar on the
-- server. Lua strings come from locales/{ar,en}.json and the React interface receives the
-- same dictionary and direction from Lua (see shared.localeKey() in init.lua).

-- Reconnecting starts with empty hands. Weapons and their loaded ammunition stay
-- in their inventory slots until the player deliberately draws them again.
-- Set true to opt back into restoring the persisted used/used2 loadout.
Config.RestoreUsedWeapons = false

-- ── A holstered weapon stays in its holster ──────────────────────────────────────
--
-- true  = the weapon stays visible on the body after holstering, as in RDR2.
-- false = it is taken off the character so it disappears after the holstering animation (the old behaviour).
--
-- ! This does not touch the ammunition accounting at all: the type's balance is taken off the character, and the damage
-- multiplier goes back to 1, and applyAmmoSeparation rebuilds the balances - all of them as they were.
-- The only difference is RemoveWeaponFromPed, that is, the appearance and not the accounting.
Config.KeepHolsteredOnBody = true

-- RDR-style weapon maintenance. The server is authoritative for the exact
-- weapon instance and for consuming the required item. The wheel only shows
-- the state returned by w_inventory.
Config.WeaponMaintenance = {
    enabled = true,
    item = 'kit_gun_oil',
    consume = 1,
    restoreCondition = 100,
    cleanDuration = 2800,
    dirtyThreshold = 0.01,
}

-- ── The magazine cap ───────────────────────────────────────────────────────────
--
-- The real engine clip in RDR3 ranges from 1 to 26 (the Evans); no engine clip is written above ClipCap.
-- The bow alone is on its own cap.
--
-- 2026-11-08 (the owner): how many rounds a weapon holds loaded, by its kind (Categories). This is
-- the weapon's clip plus its own spare rounds: the engine clip stays the weapon's real size (a revolver 6,
-- a Springfield 1) and the rest waits in the engine reserve of its bullet type, so the game reloads by
-- itself with its own animation until the loaded rounds are spent. R tops the weapon up from the bag.
-- A firearm of no listed kind takes ClipCap. Names: WEAPON_REVOLVER_* / WEAPON_PISTOL_* = sidearm,
-- WEAPON_SHOTGUN* = shotgun, WEAPON_RIFLE_* = rifle, WEAPON_SNIPERRIFLE_* = sniper, WEAPON_REPEATER_* = repeater
-- (shared.weaponLoadCap in modules/items/shared.lua).
--
-- ! Both sides read from here - the server validates the reload and the client computes what is missing, so if
-- they disagreed the reload was refused with no visible reason. Do not change one of them alone.
Config.Ammo = {
    ClipCap = 26, -- the largest engine clip (the Evans) and the load of a firearm of no listed kind
    BowCap  = 25, -- bow arrows per magazine
    Categories = {
        sidearm  = 16, -- revolvers and pistols
        shotgun  = 8,
        rifle    = 12, -- Varmint, Springfield, bolt-action, elephant rifle
        sniper   = 6,
        repeater = 26, -- the owner: "keep 26"
    },
}
