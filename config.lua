Config = Config or {}

-- Language: there is no setting here. The w_lib library owns the language (Arabic or
-- English): the player's choice in /w_lib on the client, the `w_lib:locale` convar on the
-- server. Lua strings come from locales/{ar,en}.json and the React interface receives the
-- same dictionary and direction from Lua (see shared.localeKey() in init.lua).

-- Restore weapons marked as used/used2 after the character inventory loads.
-- This mirrors VORP's AUTO_EQUIP_USED_WEAPONS behaviour while keeping each
-- physical weapon identified by its own inventory slot and serial number.
Config.RestoreUsedWeapons = true

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
-- The real weapon capacity in RDR3 ranges from 1 to 26 (the Evans). The rule here caps it:
-- no firearm exceeds ClipCap, and whatever is under it keeps its own capacity (the Cattleman 6,
-- the Springfield 1). And the bow alone is on its own cap.
--
-- 2026-11-08 (the owner: "a weapon takes only a few rounds"): 26, so every firearm holds its own real
-- clip (Litchfield 16, Lancaster and Varmint 14, Evans 26). At 10 the long repeaters were cut short.
--
-- ! Both sides read from here - the server validates the reload and the client computes what is missing, so if
-- they disagreed the reload was refused with no visible reason. Do not change one of them alone.
Config.Ammo = {
    ClipCap = 26, -- every firearm's cap (the largest real clip: the Evans repeater)
    BowCap  = 25, -- bow arrows per magazine
}
