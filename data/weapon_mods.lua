-- ============================================================
-- The gunsmith's modifications -> the weapon's power
-- ============================================================
--
-- w_gunsmith's parts are named with a fixed pattern:
--     COMPONENT_<GROUP>_<PART>_MATERIAL_<N>
--     COMPONENT_<GROUP>_<PART>_ENGRAVING_<N>   <- an engraving
--     COMPONENT_<GROUP>_<PART>_TINT_<X>_<N>    <- a colour
--
-- The **functional** parts (a barrel, a cylinder, a trigger, a hammer, a sight...) grant an increase,
-- and the engravings and the colours are pure appearance with no effect - as makes sense: the etching does not make
-- the pistol hit harder.
--
-- The material's number scales the effect: MATERIAL_10 grants the full value below, and MATERIAL_5
-- grants half of it. So the dearer material deserves a difference.
--
-- Adjust the numbers as suits your server's balance - the file is pure data.

return {
    --- The highest material's effect (MATERIAL_10) for every part kind, in points (0..100).
    parts = {
        BARREL    = { damage = 6,  range = 12 },
        CYLINDER  = { fireRate = 6, reload = 6 },
        FRAME     = { damage = 4,  accuracy = 4 },
        HAMMER    = { fireRate = 8 },
        SIGHT     = { accuracy = 12 },
        SCOPE     = { accuracy = 14, range = 6 },
        TRIGGER   = { fireRate = 7, accuracy = 3 },
        GRIPSTOCK = { accuracy = 8, reload = 5 },
        GRIP      = { accuracy = 6, reload = 4 },
        STOCK     = { accuracy = 7, range = 4 },
        STRAP     = { reload = 3 },
        BLADE     = { damage = 8 },
        WRAP      = { accuracy = 2 },
    },

    --- Words in the part's name that mean 'appearance only' - they are skipped before any computation.
    cosmetic = { 'ENGRAVING', 'TINT' },

    --- The cap on the total increase per statistic, so the parts do not accumulate without limit.
    caps = { damage = 15, range = 18, fireRate = 14, reload = 14, accuracy = 20 },

    --- Converting the damage points into a real damage multiplier in combat.
    --- 0.01 means: every damage point = +1%, so the cap of 15 points = +15%.
    damagePerPoint = 0.01,

    --- A hard limit however the computations come out - a safety barrier against any error in the table.
    maxDamageMultiplier = 1.25,
}
