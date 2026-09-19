return {
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
			{ name = 'ammo_revolver',                  price = 1,  priceKey = 'shop_ammo_revolver',              count = 300, grade = 0 },
			{ name = 'ammo_repeater',                  price = 1,  priceKey = 'shop_ammo_repeater',              count = 300, grade = 0 },
			{ name = 'ammo_shotgun',                   price = 1,  priceKey = 'shop_ammo_shotgun',               count = 300, grade = 0 },
			{ name = 'ammo_pistol',                    price = 1,  priceKey = 'shop_ammo_pistol',                count = 300, grade = 0 },
			{ name = 'ammo_rifle',                     price = 1,  priceKey = 'shop_ammo_rifle',                 count = 300, grade = 0 },
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
		groups = { ['medic'] = 0 }
	},
}
