local shops = {
	-- Police Armory Shop
	armory_police = {
		name = 'Police Armory',
		-- a dictionary key: the client shows it in the player's language
		label = 'shop_police_armory',
		inventory = {
			-- Weapons (the price from prices.lua through priceKey)
			{ name = 'weapon_shotgun_pump',        price = 5,  priceKey = 'shop_weapon_shotgun_pump',        count = 20,  grade = 0 },
			{ name = 'weapon_repeater_winchester', price = 5,  priceKey = 'shop_weapon_repeater_winchester', count = 20,  grade = 0 },
			{ name = 'weapon_revolver_navy',       price = 5,  priceKey = 'shop_weapon_revolver_navy',       count = 20,  grade = 0 },
			{ name = 'weapon_revolver_lemat',      price = 5,  priceKey = 'shop_weapon_revolver_lemat',      count = 20,  grade = 0 },
			-- Bullets
			{ name = 'ammo_revolver',              price = 1,  priceKey = 'shop_ammo_revolver',              count = 300, grade = 0 },
			{ name = 'ammo_repeater',              price = 1,  priceKey = 'shop_ammo_repeater',              count = 300, grade = 0 },
			{ name = 'ammo_shotgun',               price = 1,  priceKey = 'shop_ammo_shotgun',               count = 300, grade = 0 },
			{ name = 'ammo_pistol',                price = 1,  priceKey = 'shop_ammo_pistol',                count = 300, grade = 0 },
			{ name = 'ammo_rifle',                 price = 1,  priceKey = 'shop_ammo_rifle',                 count = 300, grade = 0 },
			-- Tools
			{ name = 'weapon_lasso',               price = 5,  priceKey = 'shop_weapon_lasso',               count = 20,  grade = 0 },
			{ name = 'weapon_melee_knife',         price = 5,  priceKey = 'shop_weapon_melee_knife',         count = 20,  grade = 0 },
			{ name = 'kit_gun_oil',                price = 15, priceKey = 'shop_kit_gun_oil',                count = 100, grade = 0 },
			{ name = 'handcuffs',                  price = 5,  priceKey = 'shop_handcuffs',                  count = 20,  grade = 0 },
			-- The ledger and the sack
			{ name = 'police_ledger',              price = 1,  priceKey = 'shop_police_ledger',              count = 20,  grade = 0 },
			{ name = 'headbag',                    price = 30, priceKey = 'shop_headbag',                    count = 20,  grade = 0 }
		},
		groups = shared.police
	},

	-- Medic Supplies Shop
	medic_supplies = {
		name = 'Medical Supplies',
		label = 'medical_supplies', -- dictionary key, translated on the client
		inventory = {
			{ name = 'firstaid', price = 10, priceKey = 'shop_firstaid', count = 500, grade = 0 },
			{ name = 'bandage',  price = 10, priceKey = 'shop_bandage',  count = 500, grade = 0 },
		},
		groups = { ['doctor'] = 0, ['medic'] = 0 }
	},
}

-- Built-in General Stores (enabled by `setr w_inventory:defaultShops 1` in server.cfg).
-- Disabled by default so servers running a dedicated store resource do not get duplicate blips.
if GetConvarInt('w_inventory:defaultShops', 0) == 1 then
	shops.general_store = {
		name = 'General Store',
		label = 'shop_general_store',
		blip = { id = 'blip_shop_store', colour = 'BLIP_MODIFIER_MP_COLOR_32' },
		inventory = {
			{ name = 'rdr_water_flask',           price = 2 },
			{ name = 'consumable_bread_roll',     price = 2 },
			{ name = 'consumable_apple',          price = 1 },
			{ name = 'consumable_cheese_wedge',   price = 3 },
			{ name = 'consumable_pineapples_can', price = 3 },
			{ name = 'consumable_coffee',         price = 2 },
			{ name = 'consumable_whiskey',        price = 5 },
			{ name = 'consumable_cigar',          price = 4 },
			{ name = 'bandage',                   price = 5 },
			{ name = 'lockpick',                  price = 15 },
		},
		locations = {
			vec3(-322.43, 803.79, 117.88),    -- Valentine
			vec3(1328.99, -1293.28, 77.02),   -- Rhodes
			vec3(2825.84, -1318.21, 46.76),   -- Saint Denis
			vec3(-1791.39, -386.87, 160.33),  -- Strawberry
			vec3(-785.18, -1323.83, 43.88),   -- Blackwater
			vec3(-5487.61, -2938.54, -0.38),  -- Tumbleweed
			vec3(-3685.56, -2622.59, -13.43), -- Armadillo
			vec3(3027.03, 561.00, 44.72),     -- Van Horn
		},
	}
end

return shops
