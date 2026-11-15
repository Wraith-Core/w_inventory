-- Crafting benches (walk-up places with a J prompt and a white marker). Red River has none: crafting lives in the
-- bag (w_crafting), so the old example bench at the Valentine gunsmith was removed (owner 2026-11-15).
-- To add a bench, put an entry like this in the list below:
--[[
	{
		items = {
			{
				name = 'WEAPON_REVOLVER_CATTLEMAN',
				ingredients = {
					iron_bar = 10,
					woodplank = 2
				},
				duration = 5000,
				count = 1,
			},
		},
		points = {
			vec3(-277.17, 779.14, 119.50),
		},
		groups = {
			["valgunsmith"] = 1,
		},
	},
]]
return {
}
