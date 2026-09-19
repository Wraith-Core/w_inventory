-- ════════════════════════════════════════════════════════════════════════════
-- w_inventory - the bag's local item definitions (RDR2 items only)
--
-- On a running framework (w_core / rsg-core, vorp_core, qbr-core) the native item catalogue
-- replaces these rows at start (modules/items/catalog.lua); a row here only fills what the
-- framework leaves empty (buttons, effects, ammunition links).
--
--     . The ammunition kinds carry the VORP names; the reference names are in
--       data/ammo_types_RDR3.lua - do not change them except with it.
--     . The scopes are weapon attachments w_gunsmith fits.
--     . The currency items are structural: the bag itself reads them.
--
-- The weapons are not here: their place is data/weapons_RDR3.lua.
-- ════════════════════════════════════════════════════════════════════════════

return {
	-- ═══ The ammunition (the VORP names) ═══
	["ammoarrowdynamite"] = {
		label = "Arrow Dynamite",
		weight = 250,
		stack = true,
		close = true,
		description = "An explosive arrow designed to cause significant damage upon impact.",
		client = {
			image = "ammoarrowdynamite.png",
		}
	},
	["ammoarrowfire"] = {
		label = "Arrow Fire",
		weight = 250,
		stack = true,
		close = true,
		description = "An arrow equipped with a flaming tip, capable of setting targets on fire.",
		client = {
			image = "ammoarrowfire.png",
		}
	},
	["ammoarrowimproved"] = {
		label = "Arrow Improved",
		weight = 250,
		stack = true,
		close = true,
		description = "An upgraded arrow with improved accuracy and damage.",
		client = {
			image = "ammoarrowimproved.png",
		}
	},
	["ammoarrownormal"] = {
		label = "Arrow Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "A standard arrow used with bows for hunting and combat.",
		client = {
			image = "ammoarrownormal.png",
		}
	},
	["ammoarrowpoison"] = {
		label = "Arrow Poison",
		weight = 250,
		stack = true,
		close = true,
		description = "An arrow coated with a poisonous substance, capable of inflicting additional damage over time.",
		client = {
			image = "ammoarrowpoison.png",
		}
	},
	["ammoarrowsmallgame"] = {
		label = "Arrow Small Game",
		weight = 250,
		stack = true,
		close = true,
		description = "A specialized arrow designed for hunting small game without damaging their pelts.",
		client = {
			image = "ammoarrowsmallgame.png",
		}
	},
	["ammoelephant"] = {
		label = "Elephant Rifle Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition specifically designed for powerful elephant rifles, providing superior stopping power.",
		client = {
			image = "ammoelephant.png",
		}
	},
	["ammopistolexplosive"] = {
		label = "Pistol Ammo Explosive",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a pistol with explosive properties, causing significant damage upon impact.",
		client = {
			image = "ammopistolexplosive.png",
		}
	},
	["ammopistolexpress"] = {
		label = "Pistol Ammo Express",
		weight = 250,
		stack = true,
		close = true,
		description = "High-velocity ammunition specifically designed for pistols, providing increased range and damage.",
		client = {
			image = "ammopistolexpress.png",
		}
	},
	["ammopistolnormal"] = {
		label = "Pistol Ammo Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "Standard ammunition used with pistols for self-defense and combat.",
		client = {
			image = "ammopistolnormal.png",
		}
	},
	["ammopistolsplitpoint"] = {
		label = "Pistol Ammo Splitpoint",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition with a split point tip, designed to cause more damage and improve accuracy.",
		client = {
			image = "ammopistolsplitpoint.png",
		}
	},
	["ammopistolvelocity"] = {
		label = "Pistol Ammo Velocity",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition designed to enhance the velocity and accuracy of pistol shots.",
		client = {
			image = "ammopistolvelocity.png",
		}
	},
	["ammorepeaterexplosive"] = {
		label = "Repeater Ammo Explosive",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a repeater rifle with explosive properties, causing significant damage upon impact.",
		client = {
			image = "ammorepeaterexplosive.png",
		}
	},
	["ammorepeaterexpress"] = {
		label = "Repeater Ammo Express",
		weight = 250,
		stack = true,
		close = true,
		description = "High-velocity ammunition specifically designed for repeater rifles, providing increased range and damage.",
		client = {
			image = "ammorepeaterexpress.png",
		}
	},
	["ammorepeaternormal"] = {
		label = "Repeater Ammo Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "Standard ammunition used with repeater rifles for self-defense and combat.",
		client = {
			image = "ammorepeaternormal.png",
		}
	},
	["ammorepeatersplitpoint"] = {
		label = "Repeater Ammo Splitpoint",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition with a split point tip, designed to cause more damage and improve accuracy when used with repeater rifles.",
		client = {
			image = "ammorepeatersplitpoint.png",
		}
	},
	["ammorepeatervelocity"] = {
		label = "Repeater Ammo Velocity",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition designed to enhance the velocity and accuracy of repeater rifle shots.",
		client = {
			image = "ammorepeatervelocity.png",
		}
	},
	["ammorevolverexplosive"] = {
		label = "Revolver Ammo Explosive",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a revolver with explosive properties, causing significant damage upon impact.",
		client = {
			image = "ammorevolverexplosive.png",
		}
	},
	["ammorevolverexpress"] = {
		label = "Revolver Ammo Express",
		weight = 250,
		stack = true,
		close = true,
		description = "High-velocity ammunition specifically designed for revolvers, providing increased range and damage.",
		client = {
			image = "ammorevolverexpress.png",
		}
	},
	["ammorevolvernormal"] = {
		label = "Revolver Ammo Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "Standard ammunition used with revolvers for self-defense and combat.",
		client = {
			image = "ammorevolvernormal.png",
		}
	},
	["ammorevolversplitpoint"] = {
		label = "Revolver Ammo Splitpoint",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition with a split point tip, designed to cause more damage and improve accuracy when used with revolvers.",
		client = {
			image = "ammorevolversplitpoint.png",
		}
	},
	["ammorevolvervelocity"] = {
		label = "Revolver Ammo Velocity",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition designed to enhance the velocity and accuracy of revolver shots.",
		client = {
			image = "ammorevolvervelocity.png",
		}
	},
	["ammorifleexplosive"] = {
		label = "Rifle Ammo Explosive",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a rifle with explosive properties, causing significant damage upon impact.",
		client = {
			image = "ammorifleexplosive.png",
		}
	},
	["ammorifleexpress"] = {
		label = "Rifle Ammo Express",
		weight = 250,
		stack = true,
		close = true,
		description = "High-velocity ammunition specifically designed for rifles, providing increased range and damage.",
		client = {
			image = "ammorifleexpress.png",
		}
	},
	["ammoriflenormal"] = {
		label = "Rifle Ammo Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "Standard ammunition used with rifles for self-defense and combat.",
		client = {
			image = "ammoriflenormal.png",
		}
	},
	["ammoriflesplitpoint"] = {
		label = "Rifle Ammo Splitpoint",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition with a split point tip, designed to cause more damage and improve accuracy when used with rifles.",
		client = {
			image = "ammoriflesplitpoint.png",
		}
	},
	["ammoriflevelocity"] = {
		label = "Rifle Ammo Velocity",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition designed to enhance the velocity and accuracy of rifle shots.",
		client = {
			image = "ammoriflevelocity.png",
		}
	},
	["ammoshotgunexplosive"] = {
		label = "Shotgun Ammo Explosive",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a shotgun with explosive properties, causing significant damage upon impact.",
		client = {
			image = "ammoshotgunexplosive.png",
		}
	},
	["ammoshotgunincendiary"] = {
		label = "Shotgun Ammo Incendiary",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition designed to ignite targets, causing them to burst into flames.",
		client = {
			image = "ammoshotgunincendiary.png",
		}
	},
	["ammoshotgunnormal"] = {
		label = "Shotgun Ammo Normal",
		weight = 250,
		stack = true,
		close = true,
		description = "Standard ammunition used with shotguns for self-defense and combat.",
		client = {
			image = "ammoshotgunnormal.png",
		}
	},
	["ammoshotgunslug"] = {
		label = "Shotgun Ammo Slug",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition with a single solid projectile, offering increased accuracy and range for shotguns.",
		client = {
			image = "ammoshotgunslug.png",
		}
	},
	["ammovarmint"] = {
		label = "Varmint Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammo used for Varmint rifles",
		client = {
			image = "ammovarmint.png",
		}
	},
	["ammovarminttranq"] = {
		label = "Varmint Tranquilizer Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammo used for tranquilizing animals with Varmint rifles",
		client = {
			image = "ammovarminttranq.png",
		}
	},

	-- ═══ The weapon scopes ═══
	-- ════════════════════════════════════════════════════════════════════
	-- Satchels -- tiers, not stacks
	--
	-- ★ stack = false and close = true deliberately: a satchel is used once and it is
	--   a rank, not a supply. Stacking them would let a player hoard ten smalls and
	--   look like they can upgrade ten times.
	--
	-- The bonus itself lives in w_hud/shared/satchels.lua -- one place, so the number
	-- in the description and the number applied can never drift apart.
	-- ════════════════════════════════════════════════════════════════════
	["satchel_small"] = {
		label = { ar = 'حقيبة صغيرة', en = 'Small Satchel' },
		description = { ar = 'ترفع ما تحمله ١٠ كجم — تُستعمل مرّةً واحدة', en = 'Raises your carry weight by 10kg -- used once' },
		weight = 500, stack = false, close = true,
		client = { image = 'bag_small.png' },
	},
	["satchel_medium"] = {
		label = { ar = 'حقيبة متوسّطة', en = 'Medium Satchel' },
		description = { ar = 'ترفع ما تحمله ٢٥ كجم — تُستعمل مرّةً واحدة', en = 'Raises your carry weight by 25kg -- used once' },
		weight = 800, stack = false, close = true,
		client = { image = 'satchel_nav_all.png' },
	},
	["satchel_large"] = {
		label = { ar = 'حقيبة كبيرة', en = 'Large Satchel' },
		description = { ar = 'ترفع ما تحمله ٤٥ كجم — تُستعمل مرّةً واحدة', en = 'Raises your carry weight by 45kg -- used once' },
		weight = 1200, stack = false, close = true,
		client = { image = 'satchel_nav_donate.png' },
	},
	["satchel_legendary"] = {
		label = { ar = 'حقيبة الوحوش الأسطوريّة', en = 'Legendary Animal Satchel' },
		description = { ar = 'ترفع ما تحمله ٧٠ كجم — أكبر ما يُصنع', en = 'Raises your carry weight by 70kg -- the largest there is' },
		weight = 1500, stack = false, close = true,
		client = { image = 'satchel_nav_animals.png' },
	},

	["scope_boltaction"] = {
		label = { ar = 'منظار بولت أكشن', en = 'Bolt Action Scope' },
		description = { ar = 'منظار خاصّ ببندقية بولت أكشن — يُركَّب في ورشة الأسلحة', en = "Scope for the Bolt Action Rifle — install it at the gunsmith" },
		weight = 300, stack = true, close = true,
		client = { image = 'binoculars.png' },
	},
	["scope_carcano"] = {
		label = { ar = 'منظار كارثانو', en = 'Carcano Scope' },
		description = { ar = 'منظار خاصّ ببندقية كارثانو — يُركَّب في ورشة الأسلحة', en = "Scope for the Carcano Rifle — install it at the gunsmith" },
		weight = 300, stack = true, close = true,
		client = { image = 'binoculars.png' },
	},
	["scope_rollingblock"] = {
		label = { ar = 'منظار رولنغ بلوك', en = 'Rolling Block Scope' },
		description = { ar = 'منظار خاصّ ببندقية رولنغ بلوك — يُركَّب في ورشة الأسلحة', en = "Scope for the Rolling Block Rifle — install it at the gunsmith" },
		weight = 300, stack = true, close = true,
		client = { image = 'binoculars.png' },
	},
	["scope_winchester"] = {
		label = { ar = 'منظار ونشستر', en = 'Winchester Scope' },
		description = { ar = 'منظار خاصّ ببندقية ونشستر ريبيتر — يُركَّب في ورشة الأسلحة', en = "Scope for the Winchester Repeater — install it at the gunsmith" },
		weight = 300, stack = true, close = true,
		client = { image = 'binoculars.png' },
	},

	-- ═══ The currency ═══
	["blood_money_clip"] = {
		label = "Blood Money Clip",
		prop = "p_moneystack01x",
	},
	["money"] = {
		label = "Money",
		prop = "p_moneystack03x",
	},
	["money_clip"] = {
		label = "Money Clip",
		prop = "p_moneystack03x",
	},

	["butchertable3"] = {
		label = "Large Butcher Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A large table used for butchering animals.",
		client = {
			image = "butchertable3.png",
		}
	},

	["book"] = {
		label = "Book",
		weight = 250,
		stack = true,
		close = true,
		description = "A written or printed work consisting of pages.",
		client = {
			image = "book.png",
		}
	},

	["a_c_fishbluegil_01_sm"] = {
		label = "Small Bluegil",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Bluegil fish.",
		client = {
			image = "a_c_fishbluegil_01_sm.png",
		}
	},

	["consumable_salmon"] = {
		label = "Dried Salmon",
		weight = 250,
		stack = true,
		close = true,
		description = "A dried and preserved salmon.",
		client = {
			image = "consumable_salmon.png",
		}
	},

	["timber_table"] = {
		label = "Timber Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A table made of timber.",
		client = {
			image = "timber_table.png",
		}
	},

	["legramhorn"] = {
		label = "Legendary Ram Horns",
		weight = 250,
		stack = true,
		close = true,
		description = "Impressive horns from a legendary ram",
		client = {
			image = "legramhorn.png",
		}
	},

	["legbucks4"] = {
		label = "Legendary Shadow Buck pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A mysterious pelt from a legendary Shadow Buck",
		client = {
			image = "legbucks4.png",
		}
	},

	["consumable_blueberrypie"] = {
		label = "Blueberry Pie",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious pie made with blueberries.",
		client = {
			image = "consumable_blueberrypie.png",
		}
	},

	["bird"] = {
		label = "Bird Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Meat obtained from a bird.",
		client = {
			image = "bird.png",
		}
	},

	["hatchet"] = {
		label = "Hatchet",
		weight = 250,
		stack = false,
		close = true,
		description = "A small axe with a short handle.",
		client = {
			image = "hatchet.png",
		}
	},

	["hawkt"] = {
		label = "Hawk claws",
		weight = 250,
		stack = true,
		close = true,
		description = "The sharp claws of a hawk.",
		client = {
			image = "hawkt.png",
		}
	},

	["revolvercylinder"] = {
		label = "Revolver Cylinder",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement cylinder for a revolver firearm, which holds the ammunition.",
		client = {
			image = "revolvercylinder.png",
		}
	},

	["naturalwagon"] = {
		label = "Naturalists Wagon Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A wagon set equipped for naturalists and explorers",
		client = {
			image = "naturalwagon.png",
		}
	},

	["hk_101"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_101.png",
		}
	},

	["armadilloc"] = {
		label = "Armadillo Claws",
		weight = 250,
		stack = true,
		close = true,
		description = "Sharp claws harvested from an Armadillo",
		client = {
			image = "armadilloc.png",
		}
	},

	["cigarettefilter"] = {
		label = "Cig Filter",
		weight = 250,
		stack = true,
		close = true,
		description = "A filter for cigarettes.",
		client = {
			image = "cigarettefilter.png",
		}
	},

	["Yarrow_Seed"] = {
		label = "Yarrow Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow Yarrow plants.",
		client = {
			image = "Yarrow_Seed.png",
		}
	},

	["Yarrow"] = {
		label = "Yarrow",
		weight = 250,
		stack = true,
		close = true,
		description = "A flowering plant known as Yarrow.",
		client = {
			image = "Yarrow.png",
		}
	},

	["rollingpaper"] = {
		label = "Rolling paper",
		weight = 250,
		stack = true,
		close = true,
		description = "A thin, lightweight paper used for rolling cigarettes or other smoking materials.",
		client = {
			image = "rollingpaper.png",
		}
	},

	["wsnakes"] = {
		label = "Western rattlesnake pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a western rattlesnake.",
		client = {
			image = "wsnakes.png",
		}
	},

	["wrench"] = {
		label = "Wrench",
		weight = 250,
		stack = true,
		close = true,
		description = "A wrech used to tighten bolts and other things.",
		client = {
			image = "wrench.png",
		}
	},

	["a_c_fishbluegil_01_ms"] = {
		label = "Medium Bluegil",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Bluegil fish.",
		client = {
			image = "a_c_fishbluegil_01_ms.png",
		}
	},

	["wrap_pressure_band"] = {
		label = "wrap_pressure_band",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "wrap_pressure_band.png",
		}
	},

	["raspberryale"] = {
		label = "Raspberry Ale",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of ale infused with the flavor of raspberries.",
		client = {
			image = "raspberryale.png",
		}
	},

	["ammopoisonbottle"] = {
		label = "Poison Bottle Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "A glass bottle filled with a poisonous substance, used to coat weapons and inflict additional damage.",
		client = {
			image = "ammopoisonbottle.png",
		}
	},

	["revolvermold"] = {
		label = "Revolver Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for casting the components of a revolver firearm.",
		client = {
			image = "revolvermold.png",
		}
	},

	["Bulrush"] = {
		label = "Bulrush",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of tall wetland plant.",
		client = {
			image = "Bulrush.png",
		}
	},

	["prairif"] = {
		label = "Prairie Chicken Feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a prairie chicken bird, often used in crafts and decorations.",
		client = {
			image = "prairif.png",
		}
	},

	["wood_plane"] = {
		label = "Wood Plane",
		weight = 250,
		stack = true,
		close = true,
		description = "A wood plane used for shaping wood.",
		client = {
			image = "wood_plane.png",
		}
	},

	["deerskin"] = {
		label = "Deer skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a deer.",
		client = {
			image = "deerskin.png",
		}
	},

	["collector_fossil_cephalopod"] = {
		label = "Cephalopod Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common cephalopod fossil. Slightly damaged and brittle.",
		client = {
			image = "collector_fossil_cephalopod.png",
		}
	},

	["bolts"] = {
		label = "Bolts",
		weight = 250,
		stack = true,
		close = true,
		description = "Metal bolts often used in construction.",
		client = {
			image = "bolts.png",
		}
	},

	["wood_chair"] = {
		label = "Wood Chair",
		weight = 250,
		stack = true,
		close = true,
		description = "A chair made from wood material.",
		client = {
			image = "wood_chair.png",
		}
	},

	["woodsaw"] = {
		label = "Woodsaw",
		weight = 250,
		stack = true,
		close = true,
		description = "Used to cut wood.",
		client = {
			image = "woodsaw.png",
		}
	},

	["collector_fossil_coral"] = {
		label = "Agatized Coral Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common piece of agatized coral, weather-beaten but still striking.",
		client = {
			image = "collector_fossil_coral.png",
		}
	},

	["Hummingbird_Sage"] = {
		label = "Hummingbird Sage",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of sage plant favored by hummingbirds.",
		client = {
			image = "Hummingbird_Sage.png",
		}
	},

	["Agarita"] = {
		label = "Agarita",
		weight = 250,
		stack = true,
		close = true,
		description = "A flowering plant found in the wild, known for its medicinal properties.",
		client = {
			image = "Agarita.png",
		}
	},

	["hk_126"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_126.png",
		}
	},

	["hk_127"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_127.png",
		}
	},

	["candlea"] = {
		label = "Candle",
		weight = 250,
		stack = true,
		close = true,
		description = "A wax candle that provides light.",
		client = {
			image = "candlea.png",
		}
	},

	["woodpeck01_c"] = {
		label = "Woodpecker",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin and feathers of a woodpecker.",
		client = {
			image = "woodpeck01_c.png",
		}
	},

	["steel_ore"] = {
		label = "steel_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "steel_ore.png",
		}
	},

	["wooden_boards"] = {
		label = "Wooden Boards",
		weight = 250,
		stack = true,
		close = true,
		description = "Boards made from wood material.",
		client = {
			image = "wooden_boards.png",
		}
	},

	["handcuffs"] = {
		label = "Handcuffs",
		weight = 250,
		stack = true,
		close = true,
		description = "Metal restraints used for restraining someone.",
		client = {
			image = "handcuffs.png",
		}
	},

	["woodchair"] = {
		label = "Wood Chair",
		weight = 250,
		stack = true,
		close = true,
		description = "A chair made from wood material.",
		client = {
			image = "woodchair.png",
		}
	},

	["woodbench"] = {
		label = "Wooden Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made from wood material.",
		client = {
			image = "woodbench.png",
		}
	},

	["salve_mint_cool"] = {
		label = "salve_mint_cool",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_mint_cool.png",
		}
	},

	["wood"] = {
		label = "Soft Wood",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of wood that is soft and easy to work with.",
		client = {
			image = "wood.png",
		}
	},

	["Wintergreen_Berry"] = {
		label = "Wintergreen Berry",
		weight = 250,
		stack = true,
		close = true,
		description = "Berries from the wintergreen plant.",
		client = {
			image = "Wintergreen_Berry.png",
		}
	},

	["sugarcaneseed"] = {
		label = "Sugarcane Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds for growing sugarcane.",
		client = {
			image = "sugarcaneseed.png",
		}
	},

	["Texas_Bonnet"] = {
		label = "Texas Bonnet",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional Texas bonnet.",
		client = {
			image = "Texas_Bonnet.png",
		}
	},

	["varnish"] = {
		label = "Varnish",
		weight = 250,
		stack = true,
		close = true,
		description = "A typical wood finish made from oils and resins.",
		client = {
			image = "varnish.png",
		}
	},

	["wolfheart"] = {
		label = "Wolf heart",
		weight = 250,
		stack = true,
		close = true,
		description = "The heart of a wolf.",
		client = {
			image = "wolfheart.png",
		}
	},

	["provision_coin_1792_lib_qtr"] = {
		label = "1792 Liberty Quarter",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1792 Liberty Quarter",
		client = {
			image = "provision_coin_1792_lib_qtr.png",
		}
	},

	["hemp_cig"] = {
		label = "Hemp Cigarette",
		weight = 250,
		stack = false,
		close = true,
		description = "A cigarette made from hemp leaves.",
		client = {
			image = "hemp_cig.png",
		}
	},

	["money_coin"] = {
		label = "Coin",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple metal coin",
		client = {
			image = "money_coin.png",
		}
	},

	["hk_131"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_131.png",
		}
	},

	["darub"] = {
		label = "Crane beak",
		weight = 250,
		stack = true,
		close = true,
		description = "A long and slender beak from a crane.",
		client = {
			image = "darub.png",
		}
	},

	["Bitter_Weed"] = {
		label = "Bitter Weed",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of bitter herb.",
		client = {
			image = "Bitter_Weed.png",
		}
	},

	["provision_ro_flower_moccasin"] = {
		label = "Moccasin Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "Moccasin Flower Orchid can be identified by the yellow pouch like petal, red sepals, and wide leaves. This orchid can be found growing near pines or conifers in woodlands and forests.",
		client = {
			image = "provision_ro_flower_moccasin.png",
		}
	},

	["legboars"] = {
		label = "Legendary Boar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and sought-after pelt from a legendary boar",
		client = {
			image = "legboars.png",
		}
	},

	["cinematicket"] = {
		label = "Ticket",
		weight = 250,
		stack = true,
		close = true,
		description = "A ticket for a movie or event.",
		client = {
			image = "cinematicket.png",
		}
	},

	["mooses"] = {
		label = "Moose pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A large and thick fur coat from a moose",
		client = {
			image = "mooses.png",
		}
	},

	["porkfat"] = {
		label = "Pig fat",
		weight = 250,
		stack = true,
		close = true,
		description = "The fat obtained from a pig, often used in cooking and making lard.",
		client = {
			image = "porkfat.png",
		}
	},

	["armadillos"] = {
		label = "Armadillo Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt taken from an Armadillo",
		client = {
			image = "armadillos.png",
		}
	},

	["consumable_poundcake"] = {
		label = "Pound Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious pound cake.",
		client = {
			image = "consumable_poundcake.png",
		}
	},

	["Creeking_Thyme"] = {
		label = "Creeping Thyme",
		weight = 250,
		stack = true,
		close = true,
		description = "A fragrant herb with small purple flowers.",
		client = {
			image = "Creeking_Thyme.png",
		}
	},

	["Red_Raspberry"] = {
		label = "Red Raspberry",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of raspberry with a red color, commonly used in desserts and preserves.",
		client = {
			image = "Red_Raspberry.png",
		}
	},

	["Wisteria_Seed"] = {
		label = "Wisteria Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow Wisteria plants.",
		client = {
			image = "Wisteria_Seed.png",
		}
	},

	["Wisteria"] = {
		label = "Wisteria",
		weight = 250,
		stack = true,
		close = true,
		description = "A flowering plant called Wisteria.",
		client = {
			image = "Wisteria.png",
		}
	},

	["boars"] = {
		label = "Boar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt obtained from a boar.",
		client = {
			image = "boars.png",
		}
	},

	["a_c_fishchainpickerel_01_sm"] = {
		label = "Small Pickerel",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Pickerel fish.",
		client = {
			image = "a_c_fishchainpickerel_01_sm.png",
		}
	},

	["coffeebeans"] = {
		label = "Coffee Beans",
		weight = 250,
		stack = true,
		close = true,
		description = "Coffee beans for making that beautiful brew.",
		client = {
			image = "coffeebeans.png",
		}
	},

	["Wintergreen_Berry_Seed"] = {
		label = "Wintergreen Berry Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to cultivate wintergreen berries.",
		client = {
			image = "Wintergreen_Berry_Seed.png",
		}
	},

	["blackberryale"] = {
		label = "Black Berry Ale",
		weight = 250,
		stack = true,
		close = true,
		description = "An ale made from blackberries.",
		client = {
			image = "blackberryale.png",
		}
	},

	["wolftooth"] = {
		label = "Wolf tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth extracted from a wolf.",
		client = {
			image = "wolftooth.png",
		}
	},

	["provision_jewelry_ylwgld_dmnd_ring"] = {
		label = "Yates Diamond Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "An intricate gold band with one cushion cut diamond.",
		client = {
			image = "provision_jewelry_ylwgld_dmnd_ring.png",
		}
	},

	["provision_coin_1800_gld_qtr"] = {
		label = "1800 Gold Quarter",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1800 Gold Quarter",
		client = {
			image = "provision_coin_1800_gld_qtr.png",
		}
	},

	["Small_Leather"] = {
		label = "Small Leather",
		weight = 250,
		stack = true,
		close = true,
		description = "A small piece of leather",
		client = {
			image = "Small_Leather.png",
		}
	},

	["Wild_Rhubarb_Seed"] = {
		label = "Wild Rhubarb Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow wild rhubarb.",
		client = {
			image = "Wild_Rhubarb_Seed.png",
		}
	},

	["Wild_Rhubarb"] = {
		label = "Wild Rhubarb",
		weight = 250,
		stack = true,
		close = true,
		description = "A rhubarb plant that grows in the wild.",
		client = {
			image = "Wild_Rhubarb.png",
		}
	},

	["Wild_Mint_Seed"] = {
		label = "Wild Mint Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to cultivate wild mint.",
		client = {
			image = "Wild_Mint_Seed.png",
		}
	},

	["coal_ore"] = {
		label = "coal_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "coal_ore.png",
		}
	},

	["Wild_Mint"] = {
		label = "Wild Mint",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of mint that grows in the wild.",
		client = {
			image = "Wild_Mint.png",
		}
	},

	["provision_earring_platinum"] = {
		label = "Platinum Earring",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful pearl earring.",
		client = {
			image = "provision_earring_platinum.png",
		}
	},

	["gold_nugget"] = {
		label = "Gold nugget",
		weight = 250,
		stack = true,
		close = true,
		description = "A nugget of pure gold.",
		client = {
			image = "gold_nugget.png",
		}
	},

	["provision_jewelry_sphr_bracelet"] = {
		label = "Helena Sapphire Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A fine silver bracelet with claw set sapphires.",
		client = {
			image = "provision_jewelry_sphr_bracelet.png",
		}
	},

	["iguanabits"] = {
		label = "Iguana Bits",
		weight = 250,
		stack = true,
		close = true,
		description = "Tasy cooked Iguna pieces.",
		client = {
			image = "iguanabits.png",
		}
	},

	["salmon"] = {
		label = "Salmon",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh salmon",
		client = {
			image = "salmon.png",
		}
	},

	["provision_jewelry_onyx_ring"] = {
		label = "Aubrey Onyx Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare white gold ring with a bezel set diamond surrounded by polished onyx.",
		client = {
			image = "provision_jewelry_onyx_ring.png",
		}
	},

	["flour"] = {
		label = "Flour",
		weight = 250,
		stack = true,
		close = true,
		description = "Ground up wheat used for cooking and baking.",
		client = {
			image = "flour.png",
		}
	},

	["Wild_Carrot_Seed"] = {
		label = "Wild Carrot Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to cultivate wild carrots.",
		client = {
			image = "Wild_Carrot_Seed.png",
		}
	},

	["animal_crawfish"] = {
		label = "Crawfish",
		weight = 250,
		stack = true,
		close = true,
		description = "A small freshwater crustacean.",
		client = {
			image = "animal_crawfish.png",
		}
	},

	["Wild_Carrot"] = {
		label = "Wild Carrot",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of carrot that grows in the wild.",
		client = {
			image = "Wild_Carrot.png",
		}
	},

	["Alaskan_Ginseng_Seed"] = {
		label = "Alaskan Ginseng Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Alaskan Ginseng.",
		client = {
			image = "Alaskan_Ginseng_Seed.png",
		}
	},

	["wildCiderMoonshine"] = {
		label = "Black Berry Moonshine",
		weight = 250,
		stack = true,
		close = true,
		description = "Homemade moonshine crafted from blackberries.",
		client = {
			image = "wildCiderMoonshine.png",
		}
	},

	["wildCiderMash"] = {
		label = "Black Berry Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "Mashed blackberries used for making cider.",
		client = {
			image = "wildCiderMash.png",
		}
	},

	["provision_hrlm_hairpin_wooden"] = {
		label = "Wooden Hairpin",
		weight = 250,
		stack = true,
		close = true,
		description = "A hand carved wooden hairpin.",
		client = {
			image = "provision_hrlm_hairpin_wooden.png",
		}
	},

	["hk_117"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_117.png",
		}
	},

	["food_barrel"] = {
		label = "Food Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A large barrel specifically designed for storing and transporting food, ideal for provisioning during long journeys or expeditions.",
		client = {
			image = "food_barrel.png",
		}
	},

	["bparrotf"] = {
		label = "Parrot feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a parrot.",
		client = {
			image = "bparrotf.png",
		}
	},

	["legcougars2"] = {
		label = "Legendary Maza Cougar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exceptional pelt from a legendary Maza Cougar",
		client = {
			image = "legcougars2.png",
		}
	},

	["wicker_bench"] = {
		label = "Wicker Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench constructed with wicker material.",
		client = {
			image = "wicker_bench.png",
		}
	},

	["Crows_Garlic_Seed"] = {
		label = "Crows Garlic Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds for growing crows garlic.",
		client = {
			image = "Crows_Garlic_Seed.png",
		}
	},

	["SnakeSkin"] = {
		label = "Snake Skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A snake skin",
		client = {
			image = "SnakeSkin.png",
		}
	},

	["Creekplum"] = {
		label = "Creekplum",
		weight = 250,
		stack = true,
		close = true,
		description = "A small and juicy creekplum.",
		client = {
			image = "Creekplum.png",
		}
	},

	["wicker"] = {
		label = "Wicker",
		weight = 250,
		stack = true,
		close = true,
		description = "A natural material made from woven branches or reeds",
		client = {
			image = "wicker.png",
		}
	},

	["consumable_raspberrywater"] = {
		label = "Berry Water",
		weight = 250,
		stack = true,
		close = true,
		description = "Refreshing water infused with berries.",
		client = {
			image = "consumable_raspberrywater.png",
		}
	},

	["elks"] = {
		label = "Elk pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A high-quality pelt obtained from an elk.",
		client = {
			image = "elks.png",
		}
	},

	["pipe"] = {
		label = "Pipe",
		weight = 250,
		stack = true,
		close = true,
		description = "A tubular device used for smoking tobacco or other substances.",
		client = {
			image = "pipe.png",
		}
	},

	["a_c_fishredfinpickerel_01_sm"] = {
		label = "Small Redfin Pickerel",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Redfin Pickerel fish.",
		client = {
			image = "a_c_fishredfinpickerel_01_sm.png",
		}
	},

	["provision_hrlm_hairpin_jade"] = {
		label = "Jade Hairpin",
		weight = 250,
		stack = true,
		close = true,
		description = "A exotic jade hairpin.",
		client = {
			image = "provision_hrlm_hairpin_jade.png",
		}
	},

	["herbal_tonic"] = {
		label = "Herbal Tonic",
		weight = 250,
		stack = true,
		close = true,
		description = "A tonic made from herbal extracts.",
		client = {
			image = "herbal_tonic.png",
		}
	},

	["pot"] = {
		label = "Distillery Pot",
		weight = 250,
		stack = false,
		close = true,
		description = "A large pot used in the distillation process for making alcohol.",
		client = {
			image = "pot.png",
		}
	},

	["legbeavers2"] = {
		label = "Legendary White Beaver pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a White Beaver",
		client = {
			image = "legbeavers2.png",
		}
	},

	["wheatseed"] = {
		label = "Wheat Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "When planted will grow into wheat.",
		client = {
			image = "wheatseed.png",
		}
	},

	["wheat"] = {
		label = "Wheat",
		weight = 250,
		stack = true,
		close = true,
		description = "Often ground up into flour to used in cooking and baking",
		client = {
			image = "wheat.png",
		}
	},

	["collector_fossil_sea_lily"] = {
		label = "Sea Lily Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon fossilized crinoid, a marine animal millions of years old.",
		client = {
			image = "collector_fossil_sea_lily.png",
		}
	},

	["wedding_ring"] = {
		label = "Wedding Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful wedding ring.",
		client = {
			image = "wedding_ring.png",
		}
	},

	["frogbull2_c"] = {
		label = "Poisoned Frogbull",
		weight = 250,
		stack = true,
		close = true,
		description = "A toxic variant of a frogbull.",
		client = {
			image = "frogbull2_c.png",
		}
	},

	["wedding_chain_ring"] = {
		label = "Wedding Ring on chain",
		weight = 250,
		stack = true,
		close = true,
		description = "A wedding ring on chain. usally worn this way so they dont get lost.",
		client = {
			image = "wedding_chain_ring.png",
		}
	},

	["crafting_fire"] = {
		label = "Crafting Fire",
		weight = 250,
		stack = true,
		close = true,
		description = "A fire used for crafting.",
		client = {
			image = "crafting_fire.png",
		}
	},

	["provision_ro_flower_sparrows"] = {
		label = "Sparrows Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Sparrows Orchid usually has 3 to 7 oval or lance-shaped leaves arranged alternately on the stem.",
		client = {
			image = "provision_ro_flower_sparrows.png",
		}
	},

	["collector_fossil_pet_wood"] = {
		label = "Common Petrified Wood Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common chunk of wood turned to stone over the years.",
		client = {
			image = "collector_fossil_pet_wood.png",
		}
	},

	["water_pump"] = {
		label = "Water Pump",
		weight = 250,
		stack = true,
		close = true,
		description = "A pump designed to move water.",
		client = {
			image = "water_pump.png",
		}
	},

	["provision_disco_fluorite"] = {
		label = "Fluorite",
		weight = 250,
		stack = true,
		close = true,
		description = "The mineral form of calcium fluoride.",
		client = {
			image = "provision_disco_fluorite.png",
		}
	},

	["provision_jewelry_elk_tooth_earring"] = {
		label = "Sterling Tooth Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "A striking pair of elk teeth set into silver.",
		client = {
			image = "provision_jewelry_elk_tooth_earring.png",
		}
	},

	["consumable_herb_evergreen_huckleberry"] = {
		label = "Evergreen Huckleberry",
		weight = 250,
		stack = true,
		close = true,
		description = "Plump and juicy Evergreen Huckleberries.",
		client = {
			image = "consumable_herb_evergreen_huckleberry.png",
		}
	},

	["cougar_taxidermy"] = {
		label = "Cougar Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a cougar.",
		client = {
			image = "cougar_taxidermy.png",
		}
	},

	["tea_dilute"] = {
		label = "tea_dilute",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tea_dilute.png",
		}
	},

	["wateringcan_dirtywater"] = {
		label = "Dirty Watering Jug",
		weight = 250,
		stack = true,
		close = true,
		description = "A watering jug filled with dirty water.",
		client = {
			image = "wateringcan_dirtywater.png",
		}
	},

	["consumable_haycube"] = {
		label = "Haycube",
		weight = 250,
		stack = true,
		close = true,
		description = "A compact cube of hay.",
		client = {
			image = "consumable_haycube.png",
		}
	},

	["legmooseantler"] = {
		label = "Legendary Moose Antlers",
		weight = 250,
		stack = true,
		close = true,
		description = "A massive set of antlers from a legendary moose",
		client = {
			image = "legmooseantler.png",
		}
	},

	["Health_For_Dog"] = {
		label = "Pet Bandages",
		weight = 250,
		stack = true,
		close = true,
		description = "Bandages designed for treating injuries in pets.",
		client = {
			image = "Health_For_Dog.png",
		}
	},

	["consumable_kidneybeans_can"] = {
		label = "Kidney Beans",
		weight = 250,
		stack = true,
		close = true,
		description = "Canned kidney beans.",
		client = {
			image = "consumable_kidneybeans_can.png",
		}
	},

	["wateringcan"] = {
		label = "Water Jug",
		weight = 250,
		stack = true,
		close = true,
		description = "A jug-shaped container used for watering plants.",
		client = {
			image = "wateringcan.png",
		}
	},

	["provision_arrowhead_raw"] = {
		label = "Raw Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A roughly hacked arrowhead made from pale stone.",
		client = {
			image = "provision_arrowhead_raw.png",
		}
	},

	["panthers"] = {
		label = "Panther skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The sleek and supple skin of a panther.",
		client = {
			image = "panthers.png",
		}
	},

	["foodbarrel"] = {
		label = "Food Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy barrel used for storing and preserving food items, keeping them fresh and safe from pests.",
		client = {
			image = "foodbarrel.png",
		}
	},

	["gold_ore"] = {
		label = "gold_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "gold_ore.png",
		}
	},

	["waterbarrel"] = {
		label = "Water Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A large barrel used for storing water.",
		client = {
			image = "waterbarrel.png",
		}
	},

	["lizardl"] = {
		label = "Lizard foot",
		weight = 250,
		stack = true,
		close = true,
		description = "A preserved foot of a lizard",
		client = {
			image = "lizardl.png",
		}
	},

	["water"] = {
		label = "Water",
		weight = 250,
		stack = true,
		close = true,
		description = "Clean drinking water.",
		client = {
			image = "water.png",
		}
	},

	["goldnugget"] = {
		label = "goldnugget",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "goldnugget.png",
		}
	},

	["horsehitches"] = {
		label = "Horse Hitches Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of items used for hitching horses.",
		client = {
			image = "horsehitches.png",
		}
	},

	["kit_gun_oil"] = {
		label = "kit_gun_oil",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "kit_gun_oil.png",
		}
	},

	["washtub"] = {
		label = "Wash Tub",
		weight = 250,
		stack = true,
		close = true,
		description = "A tub used for washing clothes or other items.",
		client = {
			image = "washtub.png",
		}
	},

	["legmooses2"] = {
		label = "Legendary Knight Moose pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An impressive pelt from a legendary Knight Moose",
		client = {
			image = "legmooses2.png",
		}
	},

	["toolbarrel"] = {
		label = "Tool Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A barrel for storing tools.",
		client = {
			image = "toolbarrel.png",
		}
	},

	["vulture_taxidermy"] = {
		label = "Vulture Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A preserved vulture bird for display.",
		client = {
			image = "vulture_taxidermy.png",
		}
	},

	["consumable_veggies"] = {
		label = "Edible Veggies",
		weight = 250,
		stack = true,
		close = true,
		description = "A mix of various edible vegetables.",
		client = {
			image = "consumable_veggies.png",
		}
	},

	["p_crawdad01x"] = {
		label = "Crawfish Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A freshwater bait made from crawfish, used to catch larger predatory fish.",
		client = {
			image = "p_crawdad01x.png",
		}
	},

	["repeaterbarrel"] = {
		label = "Repeater Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement barrel for a repeater firearm, used for improving accuracy and performance.",
		client = {
			image = "repeaterbarrel.png",
		}
	},

	["owlt"] = {
		label = "Owl claws",
		weight = 250,
		stack = true,
		close = true,
		description = "Sharp claws from an owl.",
		client = {
			image = "owlt.png",
		}
	},

	["salve_field_kit"] = {
		label = "salve_field_kit",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_field_kit.png",
		}
	},

	["hk_113"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_113.png",
		}
	},

	["provision_arrowhead_granite"] = {
		label = "Flint Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A strong arrowhead made of flint.",
		client = {
			image = "provision_arrowhead_granite.png",
		}
	},

	["vulturetaxi"] = {
		label = "Vulture Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy of a vulture bird.",
		client = {
			image = "vulturetaxi.png",
		}
	},

	["hk_119"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_119.png",
		}
	},

	["provision_ro_flower_rat_tail"] = {
		label = "Rat Tail Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Rat Tail Orchid has long, thin hanging stems, pencil-like leaves and rigid flowering stems bearing up to twelve crowded white to cream-coloured flowers.",
		client = {
			image = "provision_ro_flower_rat_tail.png",
		}
	},

	["timbertable"] = {
		label = "Timber Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy table made of timber.",
		client = {
			image = "timbertable.png",
		}
	},

	["raw_meat"] = {
		label = "raw_meat",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "raw_meat.png",
		}
	},

	["coyote_taxidermy"] = {
		label = "Coyote Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a coyote.",
		client = {
			image = "coyote_taxidermy.png",
		}
	},

	["provision_coin_1787_cent_tkn"] = {
		label = "1787 One cent Token",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1787 One cent Token",
		client = {
			image = "provision_coin_1787_cent_tkn.png",
		}
	},

	["vodka"] = {
		label = "Vodka",
		weight = 250,
		stack = true,
		close = true,
		description = "A strong alcoholic beverage known as Vodka.",
		client = {
			image = "vodka.png",
		}
	},

	["riflestock"] = {
		label = "Rifle Stock",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement stock for a rifle firearm, providing stability and control.",
		client = {
			image = "riflestock.png",
		}
	},

	["pigs"] = {
		label = "Pig pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin and fur of a pig.",
		client = {
			image = "pigs.png",
		}
	},

	["Violet_Snowdrop_Seed"] = {
		label = "Violet Snowdrop Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow Violet Snowdrop flowers.",
		client = {
			image = "Violet_Snowdrop_Seed.png",
		}
	},

	["tool_barrel"] = {
		label = "Tool Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A barrel used for storing tools.",
		client = {
			image = "tool_barrel.png",
		}
	},

	["Violet_Snowdrop"] = {
		label = "Violet Snowdrop",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate flower called Violet Snowdrop.",
		client = {
			image = "Violet_Snowdrop.png",
		}
	},

	["fancydouble"] = {
		label = "Fancy Double",
		weight = 250,
		stack = true,
		close = true,
		description = "A stylish and well-crafted double-barreled firearm.",
		client = {
			image = "fancydouble.png",
		}
	},

	["consumable_chickenpie"] = {
		label = "Chicken Pie",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious pie made with chicken.",
		client = {
			image = "consumable_chickenpie.png",
		}
	},

	["Agarita_Seed"] = {
		label = "Agarita Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Agarita plants.",
		client = {
			image = "Agarita_Seed.png",
		}
	},

	["roach"] = {
		label = "Roach",
		weight = 250,
		stack = true,
		close = true,
		description = "A small insect commonly found in households and other environments.",
		client = {
			image = "roach.png",
		}
	},

	["consumable_pear"] = {
		label = "Pear",
		weight = 250,
		stack = true,
		close = true,
		description = "A sweet and juicy pear.",
		client = {
			image = "consumable_pear.png",
		}
	},

	["mashapple"] = {
		label = "Apple Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of apples used for various recipes",
		client = {
			image = "mashapple.png",
		}
	},

	["prongs"] = {
		label = "Pronghorn Skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a pronghorn, known for its soft and durable fur.",
		client = {
			image = "prongs.png",
		}
	},

	["collector_fossil_pet_wood_yellow_cat"] = {
		label = "Yellow Cat Petrified Wood Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon lump of petrified wood featuring bright red and yellow colors.",
		client = {
			image = "collector_fossil_pet_wood_yellow_cat.png",
		}
	},

	["wolfpelt"] = {
		label = "Wolf skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a wolf.",
		client = {
			image = "wolfpelt.png",
		}
	},

	["vanillaFlower"] = {
		label = "Vanille Flower",
		weight = 250,
		stack = true,
		close = true,
		description = "A flower known as Vanille.",
		client = {
			image = "vanillaFlower.png",
		}
	},

	["consumable_crumbcake"] = {
		label = "Crumb Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious crumb cake.",
		client = {
			image = "consumable_crumbcake.png",
		}
	},

	["beart"] = {
		label = "Bear tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth obtained from a bear.",
		client = {
			image = "beart.png",
		}
	},

	["unique_horse_feed"] = {
		label = "Horse Feed",
		weight = 250,
		stack = true,
		close = true,
		description = "Feed for horses.",
		client = {
			image = "unique_horse_feed.png",
		}
	},

	["stolenmerch"] = {
		label = "Stolen Items",
		weight = 250,
		stack = true,
		close = true,
		description = "Various stolen items of questionable origin.",
		client = {
			image = "stolenmerch.png",
		}
	},

	["legrams1"] = {
		label = "Legendary Gabbro Horn Ram pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and valuable pelt from a legendary Gabbro Horn Ram",
		client = {
			image = "legrams1.png",
		}
	},

	["log_bencha"] = {
		label = "Log Bench 1",
		weight = 250,
		stack = true,
		close = true,
		description = "A comfortable log bench for outdoor seating",
		client = {
			image = "log_bencha.png",
		}
	},

	["unique_brad_horsesugar"] = {
		label = "Brad Horse Sugar",
		weight = 250,
		stack = true,
		close = true,
		description = "Sugar used for horses owned by Brad.",
		client = {
			image = "unique_brad_horsesugar.png",
		}
	},

	["gold_bar"] = {
		label = "gold_bar",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "gold_bar.png",
		}
	},

	["blanket_box"] = {
		label = "Blanket Box",
		weight = 250,
		stack = true,
		close = true,
		description = "A box used for storing blankets.",
		client = {
			image = "blanket_box.png",
		}
	},

	["pokerset"] = {
		label = "Poker Table Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A complete set for playing poker, including a table and cards.",
		client = {
			image = "pokerset.png",
		}
	},

	["Indian_Tobbaco"] = {
		label = "Indian Tobbaco",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of tobacco used by Native Americans.",
		client = {
			image = "Indian_Tobbaco.png",
		}
	},

	["undertaker1"] = {
		label = "Coffin",
		weight = 250,
		stack = true,
		close = true,
		description = "A wooden coffin.",
		client = {
			image = "undertaker1.png",
		}
	},

	["hk_130"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_130.png",
		}
	},

	["provision_hrlm_comb_tortoiseshell"] = {
		label = "Tortoiseshell Comb",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful tortoiseshell comb.",
		client = {
			image = "provision_hrlm_comb_tortoiseshell.png",
		}
	},

	["provision_jewelry_moon_ring"] = {
		label = "Pilgrim Moonstone Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A thick gold band with a single claw set moonstone.",
		client = {
			image = "provision_jewelry_moon_ring.png",
		}
	},

	["Goose_Egg_4"] = {
		label = "Goose Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "An egg laid by a goose.",
		client = {
			image = "Goose_Egg_4.png",
		}
	},

	["cowh"] = {
		label = "Cow horn",
		weight = 250,
		stack = true,
		close = true,
		description = "A long and curved horn from a cow.",
		client = {
			image = "cowh.png",
		}
	},

	["Gator_Egg_3"] = {
		label = "Aligator Egg 3",
		weight = 250,
		stack = true,
		close = true,
		description = "The third stage of an alligator egg.",
		client = {
			image = "Gator_Egg_3.png",
		}
	},

	["turtlet"] = {
		label = "Turtle tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth extracted from a turtle.",
		client = {
			image = "turtlet.png",
		}
	},

	["boobyf"] = {
		label = "Red-footed booby feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a red-footed booby bird.",
		client = {
			image = "boobyf.png",
		}
	},

	["syringe"] = {
		label = "Syringe",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical instrument used for injecting fluids.",
		client = {
			image = "syringe.png",
		}
	},

	["mexitillas"] = {
		label = "Mexitillas",
		weight = 250,
		stack = true,
		close = true,
		description = "A can of mixed mexcian beans.",
		client = {
			image = "mexitillas.png",
		}
	},

	["craftingfire"] = {
		label = "Crafting Fire",
		weight = 250,
		stack = true,
		close = true,
		description = "A fire used for crafting.",
		client = {
			image = "craftingfire.png",
		}
	},

	["turkeyf"] = {
		label = "Turkey feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a turkey.",
		client = {
			image = "turkeyf.png",
		}
	},

	["turkeyb"] = {
		label = "Turkey beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a turkey.",
		client = {
			image = "turkeyb.png",
		}
	},

	["trout"] = {
		label = "Trout",
		weight = 250,
		stack = true,
		close = true,
		description = "A fish of the trout family.",
		client = {
			image = "trout.png",
		}
	},

	["tropicalPunchMoonshine"] = {
		label = "Ginseng Moonshine",
		weight = 250,
		stack = true,
		close = true,
		description = "Moonshine infused with ginseng.",
		client = {
			image = "tropicalPunchMoonshine.png",
		}
	},

	["Chanterelles_Seed"] = {
		label = "Chanterelles Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Chanterelles mushrooms.",
		client = {
			image = "Chanterelles_Seed.png",
		}
	},

	["money_coinpurse"] = {
		label = "Coin Purse",
		weight = 250,
		stack = true,
		close = true,
		description = "A small coin purse.",
		client = {
			image = "money_coinpurse.png",
		}
	},

	["tropicalPunchMash"] = {
		label = "Ginseng Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mash made from ginseng.",
		client = {
			image = "tropicalPunchMash.png",
		}
	},

	["absinthe"] = {
		label = "Absinthe",
		weight = 250,
		stack = true,
		close = true,
		description = "An anise-flavoured spirit derived from several plants, including the flowers and leaves of Artemisia absinthium",
		client = {
			image = "absinthe.png",
		}
	},

	["sugar"] = {
		label = "Sugar",
		weight = 250,
		stack = true,
		close = true,
		description = "A sweet and granulated substance used for sweetening.",
		client = {
			image = "sugar.png",
		}
	},

	["pipecopper"] = {
		label = "Copper Pipe",
		weight = 250,
		stack = true,
		close = true,
		description = "A pipe made of copper.",
		client = {
			image = "pipecopper.png",
		}
	},

	["a_c_fishsalmonsockeye_01_ms"] = {
		label = "Sockeye Salmon",
		weight = 250,
		stack = true,
		close = true,
		description = "A Sockeye Salmon fish.",
		client = {
			image = "a_c_fishsalmonsockeye_01_ms.png",
		}
	},

	["trainkey"] = {
		label = "Train Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A key to unlock a train.",
		client = {
			image = "trainkey.png",
		}
	},

	["tool_trap_animal_small"] = {
		label = "tool_trap_animal_small",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tool_trap_animal_small.png",
		}
	},

	["peasantf"] = {
		label = "Peasant feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a peasant bird.",
		client = {
			image = "peasantf.png",
		}
	},

	["nativeskull"] = {
		label = "Native Decor 1",
		weight = 250,
		stack = true,
		close = true,
		description = "A decorative native skull for ornamental purposes",
		client = {
			image = "nativeskull.png",
		}
	},

	["tonic_mild"] = {
		label = "tonic_mild",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tonic_mild.png",
		}
	},

	["bitters_decoction"] = {
		label = "bitters_decoction",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "bitters_decoction.png",
		}
	},

	["trayoffood"] = {
		label = "Serving Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A table used for serving food.",
		client = {
			image = "trayoffood.png",
		}
	},

	["tonic_bitters_rich"] = {
		label = "tonic_bitters_rich",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tonic_bitters_rich.png",
		}
	},

	["consumable_herb_wintergreen_berry"] = {
		label = "Wintergreen Berry",
		weight = 250,
		stack = true,
		close = true,
		description = "Tart and refreshing Wintergreen Berries.",
		client = {
			image = "consumable_herb_wintergreen_berry.png",
		}
	},

	["provision_coin_1792_nickel"] = {
		label = "1792 Nickel",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1792 Nickel",
		client = {
			image = "provision_coin_1792_nickel.png",
		}
	},

	["legbucks1"] = {
		label = "Legendary Buck pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A splendid pelt from a legendary buck",
		client = {
			image = "legbucks1.png",
		}
	},

	["horsebrush"] = {
		label = "Horse Brush",
		weight = 250,
		stack = true,
		close = true,
		description = "A brush used for grooming horses.",
		client = {
			image = "horsebrush.png",
		}
	},

	["rubbertube"] = {
		label = "Rubber Tube",
		weight = 250,
		stack = true,
		close = true,
		description = "A cylindrical tube made of rubber, commonly used for various applications such as plumbing or medical procedures.",
		client = {
			image = "rubbertube.png",
		}
	},

	["lanterna"] = {
		label = "Lantern",
		weight = 250,
		stack = true,
		close = true,
		description = "A lantern",
		client = {
			image = "lanterna.png",
		}
	},

	["planttrimmer"] = {
		label = "Plant Trimmer",
		weight = 250,
		stack = true,
		close = true,
		description = "A set plant trimmers to keep the weeds in check.",
		client = {
			image = "planttrimmer.png",
		}
	},

	["toad_c"] = {
		label = "Toad",
		weight = 250,
		stack = true,
		close = true,
		description = "A common toad.",
		client = {
			image = "toad_c.png",
		}
	},

	["steak"] = {
		label = "Steak",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious steak for a hearty meal.",
		client = {
			image = "steak.png",
		}
	},

	["toadpoison_c"] = {
		label = "Poisoned Toad",
		weight = 250,
		stack = true,
		close = true,
		description = "A toad that carries poison.",
		client = {
			image = "toadpoison_c.png",
		}
	},

	["toaddesert_c"] = {
		label = "Desert Toad",
		weight = 250,
		stack = true,
		close = true,
		description = "A toad found in the desert.",
		client = {
			image = "toaddesert_c.png",
		}
	},

	["chipmunk_c"] = {
		label = "Chipmunk",
		weight = 250,
		stack = true,
		close = true,
		description = "A small, striped rodent known for its burrowing habits.",
		client = {
			image = "chipmunk_c.png",
		}
	},

	["tipi"] = {
		label = "Native Tipi",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional Native American tipi.",
		client = {
			image = "tipi.png",
		}
	},

	["tin_nugget"] = {
		label = "tin_nugget",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tin_nugget.png",
		}
	},

	["potion"] = {
		label = "Potion",
		weight = 250,
		stack = true,
		close = true,
		description = "A potion with magical healing properties.",
		client = {
			image = "potion.png",
		}
	},

	["tin_bar"] = {
		label = "tin_bar",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tin_bar.png",
		}
	},

	["collector_fossil_stone"] = {
		label = "Petoskey Stone Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common rock made of fossilized coral. Unpolished.",
		client = {
			image = "collector_fossil_stone.png",
		}
	},

	["smallchest"] = {
		label = "Small Chest",
		weight = 250,
		stack = false,
		close = true,
		description = "A small storage chest",
		client = {
			image = "smallchest.png",
		}
	},

	["corn"] = {
		label = "Corn",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh and juicy corn.",
		client = {
			image = "corn.png",
		}
	},

	["legalpaper"] = {
		label = "Legal Paper",
		weight = 250,
		stack = true,
		close = true,
		description = "Legal paper",
		client = {
			image = "legalpaper.png",
		}
	},

	["rectangle_table"] = {
		label = "Rectangle Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A table with a rectangular shape, often used for dining or as a work surface.",
		client = {
			image = "rectangle_table.png",
		}
	},

	["hairpomade"] = {
		label = "Hair Pomade",
		weight = 250,
		stack = true,
		close = true,
		description = "A grooming product for styling hair.",
		client = {
			image = "hairpomade.png",
		}
	},

	["animal_fat"] = {
		label = "animal_fat",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "animal_fat.png",
		}
	},

	["duckfat"] = {
		label = "Duck fat",
		weight = 250,
		stack = true,
		close = true,
		description = "The rendered fat from a duck, commonly used in cooking and baking.",
		client = {
			image = "duckfat.png",
		}
	},

	["loonf"] = {
		label = "Common loon feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful feather from a common loon bird",
		client = {
			image = "loonf.png",
		}
	},

	-- The handicraft kit - it opens the w_crafting menu when it is used.
	--
	-- ! consume = 0 is intended. Adding client.export alone makes w_inventory set
	--    consume = 1 automatically (modules/items/shared.lua), so the kit is consumed with every
	--    opening of the menu - and it is a permanent tool, not a material.
	["handcraft_kit"] = {
		label = "طقم الصناعة البدوي",
		weight = 250,
		stack = true,
		close = true,
		consume = 0,
		description = "يفتح قائمة الحرفة اليدويّة، أو الطبخ إن كنت قرب نار.",
		client = {
			image = "handcraft_kit.png",
			export = "w_crafting.useHandcraftKit",
		}
	},

	["Blood_Flower"] = {
		label = "Blood Flower",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of flower with red petals.",
		client = {
			image = "Blood_Flower.png",
		}
	},

	["side_tableb"] = {
		label = "side table 3",
		weight = 250,
		stack = true,
		close = true,
		description = "A modern side table",
		client = {
			image = "side_tableb.png",
		}
	},

	["Texas_Bonnet_Seed"] = {
		label = "Texas Bonnet Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow Texas Bonnet flowers.",
		client = {
			image = "Texas_Bonnet_Seed.png",
		}
	},

	["consumable_herb_oregano"] = {
		label = "Oregano",
		weight = 250,
		stack = true,
		close = true,
		description = "Fragrant oregano leaves.",
		client = {
			image = "consumable_herb_oregano.png",
		}
	},

	["mashalaskan"] = {
		label = "Alaskan Gin Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mixture of ingredients used in the production of Alaskan gin",
		client = {
			image = "mashalaskan.png",
		}
	},

	["bat_c"] = {
		label = "Bat",
		weight = 250,
		stack = true,
		close = true,
		description = "A flying mammal known for its nocturnal habits.",
		client = {
			image = "bat_c.png",
		}
	},

	["provision_buckle_gold"] = {
		label = "Gold Buckle",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold belt buckle.",
		client = {
			image = "provision_buckle_gold.png",
		}
	},

	["tent4"] = {
		label = "Canvas Shade",
		weight = 250,
		stack = true,
		close = true,
		description = "A canvas shade for shelter.",
		client = {
			image = "tent4.png",
		}
	},

	["fertilizer"] = {
		label = "Fertilizer",
		weight = 250,
		stack = true,
		close = true,
		description = "A substance used to enrich soil and promote plant growth.",
		client = {
			image = "fertilizer.png",
		}
	},

	["p_finishedragonflylegendary01x"] = {
		label = "Legendary Dragonfly Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A high-quality dragonfly lure crafted to attract legendary fish in special locations.",
		client = {
			image = "p_finishedragonflylegendary01x.png",
		}
	},

	["applebarrel"] = {
		label = "Apple Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A barrel filled with fresh apples",
		client = {
			image = "applebarrel.png",
		}
	},

	["tent2"] = {
		label = "Trader Tent",
		weight = 250,
		stack = true,
		close = true,
		description = "A tent specifically designed for trading purposes.",
		client = {
			image = "tent2.png",
		}
	},

	["tent"] = {
		label = "Tent",
		weight = 250,
		stack = false,
		close = true,
		description = "A portable shelter for camping or temporary use.",
		client = {
			image = "tent.png",
		}
	},

	["deer_taxidermy"] = {
		label = "Deer Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a deer.",
		client = {
			image = "deer_taxidermy.png",
		}
	},

	["gauze_yarrow_wrap"] = {
		label = "gauze_yarrow_wrap",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "gauze_yarrow_wrap.png",
		}
	},

	["bbears"] = {
		label = "Black Bear skin",
		weight = 250,
		stack = true,
		close = true,
		description = "Skin obtained from a black bear.",
		client = {
			image = "bbears.png",
		}
	},

	["legbisons2"] = {
		label = "Legendary Winyan Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful pelt from a legendary Winyan Bison",
		client = {
			image = "legbisons2.png",
		}
	},

	["ammovoldynamite"] = {
		label = "Volatile Dynamite Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammo used for crafting Volatile Dynamite",
		client = {
			image = "ammovoldynamite.png",
		}
	},

	["morpcert"] = {
		label = "Morphine Prescription",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical prescription for morphine medication",
		client = {
			image = "morpcert.png",
		}
	},

	["provision_jewelry_pearl_earring"] = {
		label = "Josephine Pearl Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Fashionable pearl earrings with neat gold hooks.",
		client = {
			image = "provision_jewelry_pearl_earring.png",
		}
	},

	["foxskin"] = {
		label = "Foxskin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a fox.",
		client = {
			image = "foxskin.png",
		}
	},

	["tea_pot_strong"] = {
		label = "tea_pot_strong",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tea_pot_strong.png",
		}
	},

	["logbench"] = {
		label = "Log Bench 1",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple and natural log bench",
		client = {
			image = "logbench.png",
		}
	},

	["legbisons3"] = {
		label = "Legendary Payata Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A prized pelt from a legendary Payata Bison",
		client = {
			image = "legbisons3.png",
		}
	},

	["shootingtarget"] = {
		label = "Shooting Target",
		weight = 250,
		stack = true,
		close = true,
		description = "Target for shooting practice",
		client = {
			image = "shootingtarget.png",
		}
	},

	["tea_mint_tisane"] = {
		label = "tea_mint_tisane",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tea_mint_tisane.png",
		}
	},

	["hk_1"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A standard house key.",
		client = {
			image = "hk_1.png",
		}
	},

	["leatherchair"] = {
		label = "Leather Chair",
		weight = 250,
		stack = true,
		close = true,
		description = "A leather chair",
		client = {
			image = "leatherchair.png",
		}
	},

	["silver"] = {
		label = "silver",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "silver.png",
		}
	},

	["consumable_pretzel"] = {
		label = "Pretzel",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty pretzel with salt.",
		client = {
			image = "consumable_pretzel.png",
		}
	},

	["syringe_2"] = {
		label = "Syringe",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical instrument used for injecting fluids.",
		client = {
			image = "syringe_2.png",
		}
	},

	["empty_bottle"] = {
		label = "Empty Bottle",
		weight = 250,
		stack = true,
		close = true,
		description = "Empty Bottle",
		client = {
			image = "empty_bottle.png",
		}
	},

	["rabbitpaw"] = {
		label = "Rabbitfoot",
		weight = 250,
		stack = true,
		close = true,
		description = "The foot of a rabbit, sometimes considered a good luck charm.",
		client = {
			image = "rabbitpaw.png",
		}
	},

	["synpackage"] = {
		label = "Syn Package",
		weight = 250,
		stack = true,
		close = true,
		description = "A package containing synthetic substances.",
		client = {
			image = "synpackage.png",
		}
	},

	["timber"] = {
		label = "Timber",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy chunck of timber.",
		client = {
			image = "timber.png",
		}
	},

	["provision_hrlm_hairpin_ivory"] = {
		label = "Ivory Hairpin",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate ivory hairpin.",
		client = {
			image = "provision_hrlm_hairpin_ivory.png",
		}
	},

	["herbal_medicine"] = {
		label = "Herbal Medicine",
		weight = 250,
		stack = true,
		close = true,
		description = "Medicine made from natural herbal ingredients.",
		client = {
			image = "herbal_medicine.png",
		}
	},

	["lamppost2"] = {
		label = "Lamp Post 2 Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of Lamp Post 2",
		client = {
			image = "lamppost2.png",
		}
	},

	["sugarcube"] = {
		label = "Sugar Cube",
		weight = 250,
		stack = true,
		close = true,
		description = "A compact form of sugar for easy use.",
		client = {
			image = "sugarcube.png",
		}
	},

	["stringy"] = {
		label = "Stringy Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Tough and chewy meat that requires thorough cooking.",
		client = {
			image = "stringy.png",
		}
	},

	["diamond"] = {
		label = "Diamond",
		weight = 250,
		stack = true,
		close = true,
		description = "A precious gemstone known for its brilliance and value.",
		client = {
			image = "diamond.png",
		}
	},

	["Red_Sage_Seed"] = {
		label = "Red Sage Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow red sage plants.",
		client = {
			image = "Red_Sage_Seed.png",
		}
	},

	["Golden_Currant_Seed"] = {
		label = "Golden Currant Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow golden currants.",
		client = {
			image = "Golden_Currant_Seed.png",
		}
	},

	["string"] = {
		label = "String",
		weight = 250,
		stack = true,
		close = true,
		description = "A bundle of string with many uses.",
		client = {
			image = "string.png",
		}
	},

	["herbmed"] = {
		label = "Herbal Remedy",
		weight = 250,
		stack = true,
		close = true,
		description = "A remedy made from various herbs.",
		client = {
			image = "herbmed.png",
		}
	},

	["Apple_Seed"] = {
		label = "Apple Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed used for growing apple trees",
		client = {
			image = "Apple_Seed.png",
		}
	},

	["stonehammer"] = {
		label = "Stone Hammer",
		weight = 250,
		stack = true,
		close = true,
		description = "A durable hammer made of stone.",
		client = {
			image = "stonehammer.png",
		}
	},

	["stim"] = {
		label = "Horse Stimulant",
		weight = 250,
		stack = true,
		close = true,
		description = "A stimulant to boost a horses performance.",
		client = {
			image = "stim.png",
		}
	},

	["Creekplum_Seed"] = {
		label = "Creekplum Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds for growing creekplums.",
		client = {
			image = "Creekplum_Seed.png",
		}
	},

	["stillkit"] = {
		label = "Still Kit",
		weight = 250,
		stack = true,
		close = true,
		description = "A kit for setting up a still to make distilled spirits.",
		client = {
			image = "stillkit.png",
		}
	},

	["provision_hrlm_brush_boar"] = {
		label = "Boar bristle Brush",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautifully made boar bristle brush.",
		client = {
			image = "provision_hrlm_brush_boar.png",
		}
	},

	["pork"] = {
		label = "Pork",
		weight = 250,
		stack = true,
		close = true,
		description = "The meat from a pig, commonly used for cooking and eating.",
		client = {
			image = "pork.png",
		}
	},

	["bcandle"] = {
		label = "Bottle Candle",
		weight = 250,
		stack = true,
		close = true,
		description = "A candle made from a glass bottle.",
		client = {
			image = "bcandle.png",
		}
	},

	["legfoxskin"] = {
		label = "Legendary Fox skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A valuable and versatile skin from a legendary fox",
		client = {
			image = "legfoxskin.png",
		}
	},

	["camera"] = {
		label = "Camera",
		weight = 250,
		stack = false,
		close = true,
		description = "A device used to capture photographs.",
		client = {
			image = "camera.png",
		}
	},

	["legcoyotes2"] = {
		label = "Legendary Midnight Paw Coyote pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A dark and mysterious pelt from a legendary Midnight Paw Coyote",
		client = {
			image = "legcoyotes2.png",
		}
	},

	["provision_jewelry_rudy_dngl_earring"] = {
		label = "Beauchêne Ruby Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Elaborate gold hook earrings with vivid rubies.",
		client = {
			image = "provision_jewelry_rudy_dngl_earring.png",
		}
	},

	["provision_jewelry_turquoise_ring"] = {
		label = "Magnate Turquoise Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid gold ring with an oval of polished turquoise from Persia.",
		client = {
			image = "provision_jewelry_turquoise_ring.png",
		}
	},

	["stew"] = {
		label = "stew",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "stew.png",
		}
	},

	["fertilizerwoj"] = {
		label = "Fertilizer with Wojape",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer infused with the essence of Wojape, a rare and powerful herb known for its profound effects on plant growth.",
		client = {
			image = "fertilizerwoj.png",
		}
	},

	["steel"] = {
		label = "steel",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "steel.png",
		}
	},

	["carrots"] = {
		label = "Carrot",
		weight = 250,
		stack = true,
		close = true,
		description = "An orange root vegetable commonly used in cooking.",
		client = {
			image = "carrots.png",
		}
	},

	["Black_Berry"] = {
		label = "Black Berry",
		weight = 250,
		stack = true,
		close = true,
		description = "A small and sweet black-colored berry.",
		client = {
			image = "Black_Berry.png",
		}
	},

	["waterpump"] = {
		label = "Water Pump",
		weight = 250,
		stack = true,
		close = true,
		description = "A device used for pumping water.",
		client = {
			image = "waterpump.png",
		}
	},

	["standard_table"] = {
		label = "Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A standard table for various uses.",
		client = {
			image = "standard_table.png",
		}
	},

	["legbears1"] = {
		label = "Legendary Deadly Bear pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Deadly Bear",
		client = {
			image = "legbears1.png",
		}
	},

	["orden_presidente"] = {
		label = "Order of the President",
		weight = 250,
		stack = true,
		close = true,
		description = "A prestigious order awarded by the President.",
		client = {
			image = "orden_presidente.png",
		}
	},

	["lockpick"] = {
		label = "Lockpick",
		weight = 250,
		stack = true,
		close = true,
		description = "A handy tool used for picking locks",
		client = {
			image = "lockpick.png",
		}
	},

	["squirrel_grey_c"] = {
		label = "Gray Squirrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A gray squirrel",
		client = {
			image = "squirrel_grey_c.png",
		}
	},

	["chickenheart"] = {
		label = "Chicken heart",
		weight = 250,
		stack = true,
		close = true,
		description = "The internal organ of a chicken.",
		client = {
			image = "chickenheart.png",
		}
	},

	["collector_fossil_tooth_trex"] = {
		label = "Front Tooth Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare fossilized front tooth, perhaps belonging to the recently discovered Manospondylus Gigas. Highly prized.",
		client = {
			image = "collector_fossil_tooth_trex.png",
		}
	},

	["legelks3"] = {
		label = "Legendary Inahme Elk pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exquisite pelt from a legendary Inahme Elk",
		client = {
			image = "legelks3.png",
		}
	},

	["ink"] = {
		label = "Ink",
		weight = 250,
		stack = true,
		close = true,
		description = "A small bottle of ink.",
		client = {
			image = "ink.png",
		}
	},

	["squirrel_black_c"] = {
		label = "Black Squirrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A black squirrel",
		client = {
			image = "squirrel_black_c.png",
		}
	},

	["bucks"] = {
		label = "Buck skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt obtained from a buck.",
		client = {
			image = "bucks.png",
		}
	},

	["hk_121"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_121.png",
		}
	},

	["spool"] = {
		label = "Spool",
		weight = 250,
		stack = true,
		close = true,
		description = "A empty spool. often used to wrap wire around.",
		client = {
			image = "spool.png",
		}
	},

	["consumable_herb_chanterelles"] = {
		label = "Chanterelles",
		weight = 250,
		stack = true,
		close = true,
		description = "A bundle of Chanterelle mushrooms.",
		client = {
			image = "consumable_herb_chanterelles.png",
		}
	},

	["sparrow1_c"] = {
		label = "Sparrow",
		weight = 250,
		stack = true,
		close = true,
		description = "A sparrow",
		client = {
			image = "sparrow1_c.png",
		}
	},

	["mashplum"] = {
		label = "Plum Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of plums used in cooking and distilling",
		client = {
			image = "mashplum.png",
		}
	},

	["legbucks2"] = {
		label = "Legendary Mudrunner Buck pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A distinct pelt from a legendary Mudrunner Buck",
		client = {
			image = "legbucks2.png",
		}
	},

	["sparrow0_c"] = {
		label = "Common Sparrow",
		weight = 250,
		stack = true,
		close = true,
		description = "A common sparrow",
		client = {
			image = "sparrow0_c.png",
		}
	},

	["fertilizerbless"] = {
		label = "Blessed Fertilizer",
		weight = 250,
		stack = true,
		close = true,
		description = "Sacred fertilizer imbued with spiritual blessings, known to enhance crop yield.",
		client = {
			image = "fertilizerbless.png",
		}
	},

	["Blood_Flower_Seed"] = {
		label = "Blood Flower Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow blood flowers.",
		client = {
			image = "Blood_Flower_Seed.png",
		}
	},

	["provision_jewelry_pearl_ring"] = {
		label = "Bonnard Pearl Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A valuable pearl set into a white gold band.",
		client = {
			image = "provision_jewelry_pearl_ring.png",
		}
	},

	["copper_bar"] = {
		label = "copper_bar",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "copper_bar.png",
		}
	},

	["prairib"] = {
		label = "Prairie Chicken Beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a prairie chicken, a bird species found in grassland habitats.",
		client = {
			image = "prairib.png",
		}
	},

	["egg"] = {
		label = "Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "A small oval object laid by a female bird, reptile, or fish, containing a fertilized embryo and nutrients for development.",
		client = {
			image = "egg.png",
		}
	},

	["provision_buckle_silver"] = {
		label = "Silver Buckle",
		weight = 250,
		stack = true,
		close = true,
		description = "A silver belt buckle.",
		client = {
			image = "provision_buckle_silver.png",
		}
	},

	["barrel"] = {
		label = "Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A container made of wood or metal used for storing or transporting goods.",
		client = {
			image = "barrel.png",
		}
	},

	["Bay_Bolete_Seed"] = {
		label = "Bay Bolete Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Bay Bolete mushrooms.",
		client = {
			image = "Bay_Bolete_Seed.png",
		}
	},

	["provision_hrlm_brush_ebony"] = {
		label = "Ebony Hairbrush",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate and finely crafted ebony brush.",
		client = {
			image = "provision_hrlm_brush_ebony.png",
		}
	},

	["provision_jewelry_amethyst_necklace"] = {
		label = "Richelieu Amethyst Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate necklace featuring a duo of purple amethyst and silver pearl.",
		client = {
			image = "provision_jewelry_amethyst_necklace.png",
		}
	},

	["cedarwaxwing_c"] = {
		label = "Cedar waxwing",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized bird with a distinctive crest and red tips on its wings.",
		client = {
			image = "cedarwaxwing_c.png",
		}
	},

	["consumable_chocolatecoffee"] = {
		label = "Chocolate Coffee",
		weight = 250,
		stack = true,
		close = true,
		description = "A chocolate flaverd coffee drink.",
		client = {
			image = "consumable_chocolatecoffee.png",
		}
	},

	["Snake_Poison"] = {
		label = "Snake Poison",
		weight = 250,
		stack = true,
		close = true,
		description = "Poison extracted from a snake",
		client = {
			image = "Snake_Poison.png",
		}
	},

	["secondchance"] = {
		label = "Second Chance",
		weight = 250,
		stack = true,
		close = true,
		description = "Opportunity for a second chance",
		client = {
			image = "secondchance.png",
		}
	},

	["snaket"] = {
		label = "Snake tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth from a snake",
		client = {
			image = "snaket.png",
		}
	},

	["frogbull_c"] = {
		label = "Frogbull",
		weight = 250,
		stack = true,
		close = true,
		description = "A small creature found near water bodies.",
		client = {
			image = "frogbull_c.png",
		}
	},

	["wine"] = {
		label = "Wine",
		weight = 250,
		stack = true,
		close = true,
		description = "An alcoholic beverage made from fermented grapes.",
		client = {
			image = "wine.png",
		}
	},

	["American_Ginseng"] = {
		label = "American Ginseng",
		weight = 250,
		stack = true,
		close = true,
		description = "A species of ginseng native to North America, valued for its medicinal properties.",
		client = {
			image = "American_Ginseng.png",
		}
	},

	["asnakes"] = {
		label = "Copperhead Snake pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A valuable pelt from a Copperhead Snake.",
		client = {
			image = "asnakes.png",
		}
	},

	["milk"] = {
		label = "Milk",
		weight = 250,
		stack = true,
		close = true,
		description = "A nutritious and creamy dairy product",
		client = {
			image = "milk.png",
		}
	},

	["legbeavers1"] = {
		label = "Legendary Grey Beaver pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Grey Beaver",
		client = {
			image = "legbeavers1.png",
		}
	},

	["Gator_Egg_4"] = {
		label = "Aligator Egg 4",
		weight = 250,
		stack = true,
		close = true,
		description = "The fourth stage of an alligator egg.",
		client = {
			image = "Gator_Egg_4.png",
		}
	},

	["skullpost"] = {
		label = "Skull Post",
		weight = 250,
		stack = true,
		close = true,
		description = "A decorative skull post",
		client = {
			image = "skullpost.png",
		}
	},

	["consumable_breakfast"] = {
		label = "Breakfast",
		weight = 250,
		stack = true,
		close = true,
		description = "A hearty breakfast meal.",
		client = {
			image = "consumable_breakfast.png",
		}
	},

	["cornseed"] = {
		label = "Corn seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds for growing corn.",
		client = {
			image = "cornseed.png",
		}
	},

	["singlebed"] = {
		label = "single bed",
		weight = 250,
		stack = true,
		close = true,
		description = "A comfortable single bed",
		client = {
			image = "singlebed.png",
		}
	},

	["provision_jewelry_carved_bracelet"] = {
		label = "Elliston Carved Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid gold bracelet with elegant etching.",
		client = {
			image = "provision_jewelry_carved_bracelet.png",
		}
	},

	["logbechs"] = {
		label = "Log Bench 2",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy and rustic log bench design",
		client = {
			image = "logbechs.png",
		}
	},

	["provision_jewelry_qn_dmnd_earring"] = {
		label = "Royal Victoria Diamond Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "A series of small diamonds claw set in a floral cluster on a white gold band.",
		client = {
			image = "provision_jewelry_qn_dmnd_earring.png",
		}
	},

	["silver_nugget"] = {
		label = "silver_nugget",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "silver_nugget.png",
		}
	},

	["silver_bar"] = {
		label = "silver_bar",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "silver_bar.png",
		}
	},

	["loungechair"] = {
		label = "Lounge Chair",
		weight = 250,
		stack = true,
		close = true,
		description = "A comfortable and stylish lounge chair",
		client = {
			image = "loungechair.png",
		}
	},

	["teabag"] = {
		label = "Teabag",
		weight = 250,
		stack = true,
		close = true,
		description = "A teabag for making that perfect cup.",
		client = {
			image = "teabag.png",
		}
	},

	["side_tablea"] = {
		label = "side table 2",
		weight = 250,
		stack = true,
		close = true,
		description = "An elegant side table",
		client = {
			image = "side_tablea.png",
		}
	},

	["kbirdf"] = {
		label = "Great Blue Heron Feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a Great Blue Heron, valued for its beauty and softness.",
		client = {
			image = "kbirdf.png",
		}
	},

	["ironbar"] = {
		label = "Iron Bar",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid bar made of iron, known for its strength and durability.",
		client = {
			image = "ironbar.png",
		}
	},

	["legrams4"] = {
		label = "Legendary GreatHorn Ram pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An impressive pelt from a legendary GreatHorn Ram",
		client = {
			image = "legrams4.png",
		}
	},

	["antipoison"] = {
		label = "Antipoison",
		weight = 250,
		stack = true,
		close = true,
		description = "A medicine used to counteract the effects of poison",
		client = {
			image = "antipoison.png",
		}
	},

	["ammovolmolotov"] = {
		label = "Volatile Molotov Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammo used for crafting Volatile Molotovs",
		client = {
			image = "ammovolmolotov.png",
		}
	},

	["side_table"] = {
		label = "side table 1",
		weight = 250,
		stack = true,
		close = true,
		description = "A stylish side table",
		client = {
			image = "side_table.png",
		}
	},

	["deer_pelt"] = {
		label = "Deer Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The soft and warm pelt of a deer.",
		client = {
			image = "deer_pelt.png",
		}
	},

	["bbirdf"] = {
		label = "Cormorant feather",
		weight = 250,
		stack = true,
		close = true,
		description = "Feather obtained from a cormorant bird.",
		client = {
			image = "bbirdf.png",
		}
	},

	["legbears4"] = {
		label = "Legendary Golden Spirit Bear pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Golden Spirit Bear",
		client = {
			image = "legbears4.png",
		}
	},

	["provision_arrowhead_feldspar"] = {
		label = "Feldspar Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A mysterious arrowhead made from some sort of feldspar.",
		client = {
			image = "provision_arrowhead_feldspar.png",
		}
	},

	["bacon"] = {
		label = "Bacon",
		weight = 250,
		stack = true,
		close = true,
		description = "Bacon what else do you need to know?",
		client = {
			image = "bacon.png",
		}
	},

	["sidetableb"] = {
		label = "side table 3",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful side table",
		client = {
			image = "sidetableb.png",
		}
	},

	["sidetablea"] = {
		label = "side table 2",
		weight = 250,
		stack = true,
		close = true,
		description = "Stylish side table",
		client = {
			image = "sidetablea.png",
		}
	},

	["undertaker2"] = {
		label = "Flower Coffin",
		weight = 250,
		stack = true,
		close = true,
		description = "A coffin decorated with flowers.",
		client = {
			image = "undertaker2.png",
		}
	},

	["dynamite"] = {
		label = "Pipe charge dynamite",
		weight = 250,
		stack = true,
		close = true,
		description = "An explosive device consisting of a tube filled with explosive material, used for various purposes including mining and demolition.",
		client = {
			image = "dynamite.png",
		}
	},

	["paper"] = {
		label = "Paper",
		weight = 250,
		stack = true,
		close = true,
		description = "Sheets of paper for writing or drawing.",
		client = {
			image = "paper.png",
		}
	},

	["hitchingpost"] = {
		label = "Hitching Post",
		weight = 250,
		stack = true,
		close = true,
		description = "A post used for tying up horses.",
		client = {
			image = "hitchingpost.png",
		}
	},

	["foxt"] = {
		label = "Fox tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth extracted from a fox.",
		client = {
			image = "foxt.png",
		}
	},

	["shotgunstock"] = {
		label = "Shotgun Stock",
		weight = 250,
		stack = true,
		close = true,
		description = "Stock for a shotgun",
		client = {
			image = "shotgunstock.png",
		}
	},

	["Cardinal_Flower"] = {
		label = "Cardinal Flower",
		weight = 250,
		stack = true,
		close = true,
		description = "A vibrant red flower often found near water.",
		client = {
			image = "Cardinal_Flower.png",
		}
	},

	["shotgunmold"] = {
		label = "Shotgun Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "Mold for a shotgun",
		client = {
			image = "shotgunmold.png",
		}
	},

	["riflemold"] = {
		label = "Rifle Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for casting the components of a rifle firearm.",
		client = {
			image = "riflemold.png",
		}
	},

	["flowerboxes"] = {
		label = "Flower Boxes",
		weight = 250,
		stack = true,
		close = true,
		description = "Containers or receptacles designed to hold and display blooming flowers, adding beauty and charm to any setting.",
		client = {
			image = "flowerboxes.png",
		}
	},

	["beefjerky"] = {
		label = "Beef Jerky",
		weight = 250,
		stack = true,
		close = true,
		description = "Dried and seasoned beef meat.",
		client = {
			image = "beefjerky.png",
		}
	},

	["a_c_fishlargemouthbass_01_ms"] = {
		label = "Largemouth Bass",
		weight = 250,
		stack = true,
		close = true,
		description = "A large Largemouth Bass fish.",
		client = {
			image = "a_c_fishlargemouthbass_01_ms.png",
		}
	},

	["infusion_light"] = {
		label = "infusion_light",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "infusion_light.png",
		}
	},

	["shellcasing"] = {
		label = "Shell Casing",
		weight = 250,
		stack = true,
		close = true,
		description = "Empty shell casing",
		client = {
			image = "shellcasing.png",
		}
	},

	["provision_db_finger_bone"] = {
		label = "Bone",
		weight = 250,
		stack = true,
		close = true,
		description = "A small bone possibly from a finger.",
		client = {
			image = "provision_db_finger_bone.png",
		}
	},

	["sheephead"] = {
		label = "Sheep head",
		weight = 250,
		stack = true,
		close = true,
		description = "Head of a sheep",
		client = {
			image = "sheephead.png",
		}
	},

	["hk_3"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A standard house key.",
		client = {
			image = "hk_3.png",
		}
	},

	["seagullf"] = {
		label = "Seagull feather",
		weight = 250,
		stack = true,
		close = true,
		description = "Feather from a seagull",
		client = {
			image = "seagullf.png",
		}
	},

	["provision_dog_tag"] = {
		label = "Dog Tag",
		weight = 250,
		stack = true,
		close = true,
		description = "A dog tag. Possibly from a soldier.",
		client = {
			image = "provision_dog_tag.png",
		}
	},

	["mashpeach"] = {
		label = "Peach Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of peaches used in culinary preparations",
		client = {
			image = "mashpeach.png",
		}
	},

	["consumable_chocolatecake"] = {
		label = "Chocolate Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty chocolate cake.",
		client = {
			image = "consumable_chocolatecake.png",
		}
	},

	["scale"] = {
		label = "Scale",
		weight = 250,
		stack = true,
		close = true,
		description = "Measuring scale",
		client = {
			image = "scale.png",
		}
	},

	["sarsaparilla"] = {
		label = "Sarsaparilla",
		weight = 250,
		stack = true,
		close = true,
		description = "Medicinal sarsaparilla",
		client = {
			image = "sarsaparilla.png",
		}
	},

	["fertilizerpulpsap"] = {
		label = "Fertilizer with Pulp/Sap",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer enriched with natural pulp or sap, promoting robust growth and vitality in plants.",
		client = {
			image = "fertilizerpulpsap.png",
		}
	},

	["cigar"] = {
		label = "Cigar",
		weight = 250,
		stack = true,
		close = true,
		description = "A fine cigar for relaxing.",
		client = {
			image = "cigar.png",
		}
	},

	["p_baitBread01x"] = {
		label = "Bread Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A piece of bread used as bait for fishing.",
		client = {
			image = "p_baitBread01x.png",
		}
	},

	["handsaw"] = {
		label = "Handsaw",
		weight = 250,
		stack = true,
		close = true,
		description = "A hand saw used to cut wood",
		client = {
			image = "handsaw.png",
		}
	},

	["sandpaper"] = {
		label = "Sandpaper",
		weight = 250,
		stack = true,
		close = true,
		description = "A sheet of sandpaper used for smoothing wood.",
		client = {
			image = "sandpaper.png",
		}
	},

	["Big_Leather"] = {
		label = "Big Leather",
		weight = 250,
		stack = true,
		close = true,
		description = "Large piece of leather.",
		client = {
			image = "Big_Leather.png",
		}
	},

	["p_baitWorm01x"] = {
		label = "Worm Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A classic bait made from worms, ideal for catching a wide variety of fish species.",
		client = {
			image = "p_baitWorm01x.png",
		}
	},

	["collector_fossil_tail_spike"] = {
		label = "Tail Spike Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare fossilized tail spike, thought to have belonged to a Stegosaurus.",
		client = {
			image = "collector_fossil_tail_spike.png",
		}
	},

	["salve_sage_winter"] = {
		label = "salve_sage_winter",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_sage_winter.png",
		}
	},

	["legwolfs2"] = {
		label = "Legendary Onyx Wolf pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "legwolfs2.png",
		}
	},

	["salve_natural"] = {
		label = "salve_natural",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_natural.png",
		}
	},

	["salve_grease"] = {
		label = "salve_grease",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_grease.png",
		}
	},

	["provision_coin_1796_hlf_pny"] = {
		label = "1796 Half Penny",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1796 Half Penny",
		client = {
			image = "provision_coin_1796_hlf_pny.png",
		}
	},

	["Saltbush_Seed"] = {
		label = "Saltbush Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seed of Saltbush plant",
		client = {
			image = "Saltbush_Seed.png",
		}
	},

	["Saltbush"] = {
		label = "Saltbush",
		weight = 250,
		stack = true,
		close = true,
		description = "Saltbush plant",
		client = {
			image = "Saltbush.png",
		}
	},

	["beavertail"] = {
		label = "Beaver tail",
		weight = 250,
		stack = true,
		close = true,
		description = "A flat and scaly tail obtained from a beaver.",
		client = {
			image = "beavertail.png",
		}
	},

	["provision_arrowhead_chipped"] = {
		label = "Chipped Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A hurriedly made arrowhead made from chiseled flint.",
		client = {
			image = "provision_arrowhead_chipped.png",
		}
	},

	["repeatermold"] = {
		label = "Repeater Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for casting the components of a repeater firearm.",
		client = {
			image = "repeatermold.png",
		}
	},

	["hk_103"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_103.png",
		}
	},

	["chestc"] = {
		label = "Chest C",
		weight = 250,
		stack = true,
		close = true,
		description = "A storage container used to store items securely.",
		client = {
			image = "chestc.png",
		}
	},

	["bmdresser"] = {
		label = "brown mirror dresser",
		weight = 250,
		stack = true,
		close = true,
		description = "A dresser with a brown mirror.",
		client = {
			image = "bmdresser.png",
		}
	},

	["glassbottle"] = {
		label = "Glass Bottle",
		weight = 250,
		stack = true,
		close = true,
		description = "A transparent bottle made of glass.",
		client = {
			image = "glassbottle.png",
		}
	},

	["pulp"] = {
		label = "Pulp",
		weight = 250,
		stack = true,
		close = true,
		description = "A soft and moist mass of plant fibers, typically obtained from crushing or processing plant materials.",
		client = {
			image = "pulp.png",
		}
	},

	["fishmeat"] = {
		label = "Bigfish Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Meat obtained from large fish species, known for its tender texture and rich flavor.",
		client = {
			image = "fishmeat.png",
		}
	},

	["hk_110"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_110.png",
		}
	},

	["gun_barrel"] = {
		label = "Gun Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A cylindrical barrel used in firearm construction.",
		client = {
			image = "gun_barrel.png",
		}
	},

	["beartrap"] = {
		label = "Beartrap",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy beartrap used for catching animals or stopping trespassers",
		client = {
			image = "beartrap.png",
		}
	},

	["riflerecmold"] = {
		label = "Rifle Receiver Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for casting the receiver of a rifle firearm.",
		client = {
			image = "riflerecmold.png",
		}
	},

	["Creeking_Thyme_Seed"] = {
		label = "Creeping Thyme Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds for growing creeping thyme.",
		client = {
			image = "Creeking_Thyme_Seed.png",
		}
	},

	["hk_109"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_109.png",
		}
	},

	["tonic_bitters"] = {
		label = "tonic_bitters",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tonic_bitters.png",
		}
	},

	["rubber"] = {
		label = "Rubber",
		weight = 250,
		stack = true,
		close = true,
		description = "A flexible, elastic material derived from the sap of certain plants or synthesized chemically.",
		client = {
			image = "rubber.png",
		}
	},

	["rspoonf"] = {
		label = "Roseta Spoonbill feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a Roseta Spoonbill bird, often used in crafts and decorative items.",
		client = {
			image = "rspoonf.png",
		}
	},

	["consumable_trout"] = {
		label = "Cooked Trout",
		weight = 250,
		stack = true,
		close = true,
		description = "A cooked and seasoned trout.",
		client = {
			image = "consumable_trout.png",
		}
	},

	["rspoonb"] = {
		label = "Roseta Spoonbill beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The long, slender beak of a Roseta Spoonbill bird, known for its distinctive shape and color.",
		client = {
			image = "rspoonb.png",
		}
	},

	["provision_ro_flower_ghost"] = {
		label = "Ghost Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Ghost Orchid is named after the white to pale pink flowers that can be seen in shaded habitats. This small orchid grows in shaded areas, such as woodlands, and under leaves and soil, with only the flower appearing above ground.",
		client = {
			image = "provision_ro_flower_ghost.png",
		}
	},

	["roundtable"] = {
		label = "Round Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A circular table with a flat top surface, often used for dining or discussions.",
		client = {
			image = "roundtable.png",
		}
	},

	["wsnakeskin"] = {
		label = "Watersnake pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a watersnake.",
		client = {
			image = "wsnakeskin.png",
		}
	},

	["a_c_fishperch_01_sm"] = {
		label = "Small Perch",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Perch fish.",
		client = {
			image = "a_c_fishperch_01_sm.png",
		}
	},

	["legrams3"] = {
		label = "Legendary Rutile Horn Ram pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exquisite pelt from a legendary Rutile Horn Ram",
		client = {
			image = "legrams3.png",
		}
	},

	["aligatorto"] = {
		label = "Alligator Tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth extracted from an alligator, sometimes used for decorative purposes.",
		client = {
			image = "aligatorto.png",
		}
	},

	["apple_barrel"] = {
		label = "Apple Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A barrel filled with fresh apples",
		client = {
			image = "apple_barrel.png",
		}
	},

	["bigchest"] = {
		label = "Big Chest",
		weight = 250,
		stack = false,
		close = true,
		description = "A large chest for storing items.",
		client = {
			image = "bigchest.png",
		}
	},

	["chococake"] = {
		label = "Chocolate Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty chocolate cake.",
		client = {
			image = "chococake.png",
		}
	},

	["legalbook"] = {
		label = "Legal Book",
		weight = 250,
		stack = false,
		close = true,
		description = "A legal book",
		client = {
			image = "legalbook.png",
		}
	},

	["robin_c"] = {
		label = "Robin",
		weight = 250,
		stack = true,
		close = true,
		description = "A small songbird known for its red breast and melodious voice.",
		client = {
			image = "robin_c.png",
		}
	},

	["robberyplanning"] = {
		label = "Robbery Planning Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of tools and materials used for planning a robbery or heist.",
		client = {
			image = "robberyplanning.png",
		}
	},

	["provision_jewelry_dmnd_bngle_bracelet"] = {
		label = "Abelló Ruby Bangle Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A hinged gold bangle with a series of claw set rubies.",
		client = {
			image = "provision_jewelry_dmnd_bngle_bracelet.png",
		}
	},

	["Volture_Egg"] = {
		label = "Volture Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "An egg laid by a Volture bird.",
		client = {
			image = "Volture_Egg.png",
		}
	},

	["shotgunbarrel"] = {
		label = "Shotgun Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "Barrel for a shotgun",
		client = {
			image = "shotgunbarrel.png",
		}
	},

	["legfoxs3"] = {
		label = "Legendary Cross Fox pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exquisite pelt from a legendary Cross Fox",
		client = {
			image = "legfoxs3.png",
		}
	},

	["egretb"] = {
		label = "Snowy Egret beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a Snowy Egret, commonly used for crafting and trading.",
		client = {
			image = "egretb.png",
		}
	},

	["provision_disco_fertility_statue"] = {
		label = "Fertility Statue",
		weight = 250,
		stack = true,
		close = true,
		description = "A statue that apparently possesses the power to grant fertility.",
		client = {
			image = "provision_disco_fertility_statue.png",
		}
	},

	["a_c_fishsmallmouthbass_01_ms"] = {
		label = "Smallmouth Bass",
		weight = 250,
		stack = true,
		close = true,
		description = "A small and tasty bass fish.",
		client = {
			image = "a_c_fishsmallmouthbass_01_ms.png",
		}
	},

	["riflebarrel"] = {
		label = "Rifle Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement barrel for a rifle firearm, used for improving accuracy and performance.",
		client = {
			image = "riflebarrel.png",
		}
	},

	["wool"] = {
		label = "Wool",
		weight = 250,
		stack = true,
		close = true,
		description = "Fiber obtained from the fleece of sheep.",
		client = {
			image = "wool.png",
		}
	},

	["a_c_fishperch_01_ms"] = {
		label = "Medium Perch",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Perch fish.",
		client = {
			image = "a_c_fishperch_01_ms.png",
		}
	},

	["legaligators2"] = {
		label = "Legendary Sun Alligator pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Sun Alligator",
		client = {
			image = "legaligators2.png",
		}
	},

	["hk_124"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_124.png",
		}
	},

	["provision_jewelry_coral_dngl_earring"] = {
		label = "Emmeline Coral Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Drop hook earrings of polished pink coral set in gold.",
		client = {
			image = "provision_jewelry_coral_dngl_earring.png",
		}
	},

	["repeaterstock"] = {
		label = "Repeater Stock",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement stock for a repeater firearm, providing stability and control.",
		client = {
			image = "repeaterstock.png",
		}
	},

	["fish"] = {
		label = "Fish",
		weight = 250,
		stack = true,
		close = true,
		description = "A aquatic creature with fins and scales, commonly caught for food or sport.",
		client = {
			image = "fish.png",
		}
	},

	["Alaskan_Ginseng"] = {
		label = "Alaskan Ginseng",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of ginseng native to the Alaskan region, prized for its healing properties.",
		client = {
			image = "Alaskan_Ginseng.png",
		}
	},

	["deerpelt"] = {
		label = "Deer pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The soft and warm pelt of a deer.",
		client = {
			image = "deerpelt.png",
		}
	},

	["clothbench"] = {
		label = "Cloth Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made of cloth material.",
		client = {
			image = "clothbench.png",
		}
	},

	["repeaterrecmold"] = {
		label = "Repeater Receiver Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for casting the receiver of a repeater firearm.",
		client = {
			image = "repeaterrecmold.png",
		}
	},

	["pronghornh"] = {
		label = "Pronghorn Horn",
		weight = 250,
		stack = true,
		close = true,
		description = "The horn of a pronghorn, a mammal native to North America.",
		client = {
			image = "pronghornh.png",
		}
	},

	["repeaterreceiver"] = {
		label = "Repeater Receiver",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement receiver for a repeater firearm, which houses the firing mechanism.",
		client = {
			image = "repeaterreceiver.png",
		}
	},

	["pocket_watch"] = {
		label = "Pocket Watch",
		weight = 250,
		stack = true,
		close = true,
		description = "A small timepiece designed to be carried in a pocket.",
		client = {
			image = "pocket_watch.png",
		}
	},

	["hk_114"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_114.png",
		}
	},

	["mexitillastaco"] = {
		label = "Taco",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicous taco.",
		client = {
			image = "mexitillastaco.png",
		}
	},

	["Red_Sage"] = {
		label = "Red Sage",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of sage plant with red-colored flowers, often used in herbal remedies and smudging ceremonies.",
		client = {
			image = "Red_Sage.png",
		}
	},

	["Red_Raspberry_Seed"] = {
		label = "Red Raspberry Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow red raspberry plants.",
		client = {
			image = "Red_Raspberry_Seed.png",
		}
	},

	["syn"] = {
		label = "Syn",
		weight = 250,
		stack = true,
		close = true,
		description = "A synthetic substance used for various purposes.",
		client = {
			image = "syn.png",
		}
	},

	["legcougars1"] = {
		label = "Legendary Iguga Cougar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A striking pelt from a legendary Iguga Cougar",
		client = {
			image = "legcougars1.png",
		}
	},

	["legmooses"] = {
		label = "Legendary Moose pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A majestic pelt from a legendary moose",
		client = {
			image = "legmooses.png",
		}
	},

	["parasol"] = {
		label = "Parasol",
		weight = 250,
		stack = false,
		close = true,
		description = "A stylish and functional parasol to shield from the sun.",
		client = {
			image = "parasol.png",
		}
	},

	["tonic_deep"] = {
		label = "tonic_deep",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tonic_deep.png",
		}
	},

	["riflereceiver"] = {
		label = "Rifle Receiver",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement receiver for a rifle firearm, which houses the firing mechanism.",
		client = {
			image = "riflereceiver.png",
		}
	},

	["provision_jewelry_emerald_ring"] = {
		label = "Bosque Emerald Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold band with an extravagant bezel set Columbian emerald.",
		client = {
			image = "provision_jewelry_emerald_ring.png",
		}
	},

	["raw_bacon"] = {
		label = "Raw Bacon",
		weight = 250,
		stack = true,
		close = true,
		description = "Raw uncooked bacon.",
		client = {
			image = "raw_bacon.png",
		}
	},

	["ravenf"] = {
		label = "Raven Feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a raven bird, known for its glossy black color and sleek appearance.",
		client = {
			image = "ravenf.png",
		}
	},

	["goats"] = {
		label = "Goat pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a goat.",
		client = {
			image = "goats.png",
		}
	},

	["fibers"] = {
		label = "Fibers",
		weight = 250,
		stack = true,
		close = true,
		description = "Fine threads or filaments extracted from plants or animals, often used for crafting or weaving.",
		client = {
			image = "fibers.png",
		}
	},

	["goosef"] = {
		label = "Goose feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a goose.",
		client = {
			image = "goosef.png",
		}
	},

	["hemp_seed"] = {
		label = "Hemp Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow hemp plants.",
		client = {
			image = "hemp_seed.png",
		}
	},

	["rat_c"] = {
		label = "Rat",
		weight = 250,
		stack = true,
		close = true,
		description = "A small rodent known for its agility and ability to adapt to various environments.",
		client = {
			image = "rat_c.png",
		}
	},

	["nightstand"] = {
		label = "Nightstand",
		weight = 250,
		stack = true,
		close = true,
		description = "A small bedside table for holding personal items",
		client = {
			image = "nightstand.png",
		}
	},

	["provision_earring_silver"] = {
		label = "Silver Earring",
		weight = 250,
		stack = true,
		close = true,
		description = "A silver earring.",
		client = {
			image = "provision_earring_silver.png",
		}
	},

	["a_c_fishbullheadcat_01_sm"] = {
		label = "Small Bullhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Bullhead fish.",
		client = {
			image = "a_c_fishbullheadcat_01_sm.png",
		}
	},

	["dressing_mud_rinse"] = {
		label = "dressing_mud_rinse",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "dressing_mud_rinse.png",
		}
	},

	["provision_ro_flower_acunas_star"] = {
		label = "Acunas Star Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Acunas Star Orchid an be identified by the branching of the stems, alternate leaves, and cream colored petals. The trailing plant is often found on the ground or growing around trees in swampland areas.",
		client = {
			image = "provision_ro_flower_acunas_star.png",
		}
	},

	["Rams_Head"] = {
		label = "Rams Head",
		weight = 250,
		stack = true,
		close = true,
		description = "The preserved head of a ram, often used as a hunting trophy or decorative item.",
		client = {
			image = "Rams_Head.png",
		}
	},

	["legaligators"] = {
		label = "Legendary Alligator pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from an alligator",
		client = {
			image = "legaligators.png",
		}
	},

	["ramhorn"] = {
		label = "Ram Horn",
		weight = 250,
		stack = true,
		close = true,
		description = "The horn of a ram, a male sheep, often used in crafting and decoration.",
		client = {
			image = "ramhorn.png",
		}
	},

	["legcoyotes3"] = {
		label = "Legendary Milk Coyote pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare pelt from a legendary Milk Coyote",
		client = {
			image = "legcoyotes3.png",
		}
	},

	["rajahdysoljy"] = {
		label = "Explosive Oil",
		weight = 250,
		stack = true,
		close = true,
		description = "An explosive oil used for various purposes, such as creating dynamite and explosives.",
		client = {
			image = "rajahdysoljy.png",
		}
	},

	["provision_jewelry_gld_pendt_necklace"] = {
		label = "Gosselin White Gold Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A lavalier style white gold necklace with a series of small diamonds.",
		client = {
			image = "provision_jewelry_gld_pendt_necklace.png",
		}
	},

	["soborno"] = {
		label = "Soborno Alcohol",
		weight = 250,
		stack = true,
		close = true,
		description = "A bottle of Soborno alcohol",
		client = {
			image = "soborno.png",
		}
	},

	["collector_fossil_trilobite_iso"] = {
		label = "Isotelus Trilobite Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon fossil of a huge trilobite. Fully intact.",
		client = {
			image = "collector_fossil_trilobite_iso.png",
		}
	},

	["legelks2"] = {
		label = "Legendary Ozula Elk pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare pelt from a legendary Ozula Elk",
		client = {
			image = "legelks2.png",
		}
	},

	["legendbuckantler"] = {
		label = "Legendary Buck Antlers",
		weight = 250,
		stack = true,
		close = true,
		description = "A pair of majestic antlers from a legendary buck",
		client = {
			image = "legendbuckantler.png",
		}
	},

	["legbisonstak"] = {
		label = "Legendary Takanta Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exceptional pelt from a legendary Takanta Bison",
		client = {
			image = "legbisonstak.png",
		}
	},

	["collector_fossil_toe_claw"] = {
		label = "Toe Sickle Claw Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare fossilized claw. Still sharp, it belonged to a genus of Dromaeosauridae.",
		client = {
			image = "collector_fossil_toe_claw.png",
		}
	},

	["Evergreen_Huckleberry"] = {
		label = "Evergreen Huckleberry",
		weight = 250,
		stack = true,
		close = true,
		description = "A small, dark purple berry known for its tart and sweet flavor.",
		client = {
			image = "Evergreen_Huckleberry.png",
		}
	},

	["ammobolainterwired"] = {
		label = "Bola Ammo Interwired",
		weight = 250,
		stack = true,
		close = true,
		description = "A reinforced bola ammunition with interwoven materials, providing enhanced durability.",
		client = {
			image = "ammobolainterwired.png",
		}
	},

	["raccoont"] = {
		label = "Raccoon Tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A tooth from a raccoon, often used in crafts and jewelry.",
		client = {
			image = "raccoont.png",
		}
	},

	["raccoons"] = {
		label = "Raccoon Skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a raccoon, known for its distinctive ringed tail and soft fur.",
		client = {
			image = "raccoons.png",
		}
	},

	["fishchips"] = {
		label = "Fish and Chips",
		weight = 250,
		stack = true,
		close = true,
		description = "A classic dish consisting of fried fish fillets and potato chips, often served with tartar sauce.",
		client = {
			image = "fishchips.png",
		}
	},

	["provision_ro_flower_clamshell"] = {
		label = "Clamshell Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Clamshell Orchid can be identified by the deep purple and white petals with yellow streaks, and thin leaves.",
		client = {
			image = "provision_ro_flower_clamshell.png",
		}
	},

	["quartz"] = {
		label = "Quartz",
		weight = 250,
		stack = true,
		close = true,
		description = "A hard mineral often used in jewelry and decorative items.",
		client = {
			image = "quartz.png",
		}
	},

	["quailf"] = {
		label = "Quail Feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a quail bird, known for its small size and distinctive patterns.",
		client = {
			image = "quailf.png",
		}
	},

	["legbeawers"] = {
		label = "Legendary Beaver pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Beaver",
		client = {
			image = "legbeawers.png",
		}
	},

	["provision_jewelry_gld_bngle_bracelet"] = {
		label = "Ojeda Rose Gold Bangle Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A large bracelet of rose gold with elaborate cameo detailing.",
		client = {
			image = "provision_jewelry_gld_bngle_bracelet.png",
		}
	},

	["rock"] = {
		label = "Rock",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid mineral material that forms the Earths crust, commonly found in various shapes and sizes.",
		client = {
			image = "rock.png",
		}
	},

	["p_lgoc_spinner_v4"] = {
		label = "Spinner V4",
		weight = 250,
		stack = true,
		close = true,
		description = "A high-speed spinner lure, perfect for attracting aggressive, fast-moving fish.",
		client = {
			image = "p_lgoc_spinner_v4.png",
		}
	},

	["bwdresser"] = {
		label = "brown wood dresser",
		weight = 250,
		stack = true,
		close = true,
		description = "A dresser made of brown wood.",
		client = {
			image = "bwdresser.png",
		}
	},

	["bear_bench"] = {
		label = "Bear Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made from the hide and bones of a bear.",
		client = {
			image = "bear_bench.png",
		}
	},

	["p_finishdcrawdlegendary01x"] = {
		label = "Legendary Crawfish Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A specialized crawfish lure made for catching rare legendary fish.",
		client = {
			image = "p_finishdcrawdlegendary01x.png",
		}
	},

	["p_finishdcrawd01x"] = {
		label = "Crawfish Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A lure that mimics the movement of a crawfish, enticing larger predatory fish.",
		client = {
			image = "p_finishdcrawd01x.png",
		}
	},

	["ammobolahawk"] = {
		label = "Bola Ammo Hawk",
		weight = 250,
		stack = true,
		close = true,
		description = "A projectile consisting of weights attached to ropes, used to immobilize targets.",
		client = {
			image = "ammobolahawk.png",
		}
	},

	["bullhorn"] = {
		label = "Bull horn",
		weight = 250,
		stack = true,
		close = true,
		description = "A horn obtained from a bull.",
		client = {
			image = "bullhorn.png",
		}
	},

	["hk_120"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_120.png",
		}
	},

	["lizards"] = {
		label = "Lizard pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A unique and scaly skin from a lizard",
		client = {
			image = "lizards.png",
		}
	},

	["bulls"] = {
		label = "Bull pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt obtained from a bull.",
		client = {
			image = "bulls.png",
		}
	},

	["provision_hrlm_brush_goathair"] = {
		label = "Goat Hair Brush",
		weight = 250,
		stack = true,
		close = true,
		description = "A exquisite hand crafted goat hair brush.",
		client = {
			image = "provision_hrlm_brush_goathair.png",
		}
	},

	["provision_disco_ancient_eagle"] = {
		label = "Ancient Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "An ancient eagle statue.",
		client = {
			image = "provision_disco_ancient_eagle.png",
		}
	},

	["p_baitCheese01x"] = {
		label = "Cheese Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A soft cheese bait, favored by fish with a strong sense of smell like catfish.",
		client = {
			image = "p_baitCheese01x.png",
		}
	},

	["sandbag"] = {
		label = "Sandbag",
		weight = 250,
		stack = true,
		close = true,
		description = "A bag of sand. often used in construction.",
		client = {
			image = "sandbag.png",
		}
	},

	["p_baitCricket01x"] = {
		label = "Cricket Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A lively bait made from crickets, effective for attracting larger fish.",
		client = {
			image = "p_baitCricket01x.png",
		}
	},

	["consumable_coffee"] = {
		label = "Coffee",
		weight = 250,
		stack = true,
		close = true,
		description = "A warm cup of coffee.",
		client = {
			image = "consumable_coffee.png",
		}
	},

	["Fat"] = {
		label = "Animal Fat",
		weight = 250,
		stack = true,
		close = true,
		description = "Rendered fat obtained from animals, commonly used in cooking and crafting.",
		client = {
			image = "Fat.png",
		}
	},

	["p_baitCorn01x"] = {
		label = "Corn Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple bait made from corn, commonly used to attract small freshwater fish.",
		client = {
			image = "p_baitCorn01x.png",
		}
	},

	["p_barrelmoonshine"] = {
		label = "Barrel",
		weight = 250,
		stack = false,
		close = true,
		description = "A container, typically made of wood, used for storing and aging moonshine.",
		client = {
			image = "p_barrelmoonshine.png",
		}
	},

	["loonb"] = {
		label = "Common loon beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a common loon bird",
		client = {
			image = "loonb.png",
		}
	},

	["legwolfpelt"] = {
		label = "Legendary Wolf skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A prized and valuable skin from a legendary wolf",
		client = {
			image = "legwolfpelt.png",
		}
	},

	["nativebasket1"] = {
		label = "Native Basket 1",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional native basket for carrying items",
		client = {
			image = "nativebasket1.png",
		}
	},

	["hk_134"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_134.png",
		}
	},

	["consumable_raspberryjelly"] = {
		label = "Raspberry Jelly",
		weight = 250,
		stack = true,
		close = true,
		description = "Raspberry flavored jelly.",
		client = {
			image = "consumable_raspberryjelly.png",
		}
	},

	["coyotes"] = {
		label = "Coyote skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The rugged and weathered skin of a coyote.",
		client = {
			image = "coyotes.png",
		}
	},

	["Chanterelles"] = {
		label = "Chanterelles",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of edible mushroom with a fruity aroma.",
		client = {
			image = "Chanterelles.png",
		}
	},

	["hk_108"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_108.png",
		}
	},

	["provision_ro_flower_lady_of_night"] = {
		label = "Lady of Night Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "Lady of the Night Orchid takes its name from the sweet citrus fragrance it produces during nightfall. The orchid can be identified by the white heart shaped flowers and long leaves.",
		client = {
			image = "provision_ro_flower_lady_of_night.png",
		}
	},

	["round_table"] = {
		label = "Round Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A table with a round top surface, typically used for dining or meetings.",
		client = {
			image = "round_table.png",
		}
	},

	["bluejay_c"] = {
		label = "Blue jay",
		weight = 250,
		stack = true,
		close = true,
		description = "A colorful bird known as blue jay.",
		client = {
			image = "bluejay_c.png",
		}
	},

	["copper"] = {
		label = "Copper",
		weight = 250,
		stack = true,
		close = true,
		description = "A piece of copper.",
		client = {
			image = "copper.png",
		}
	},

	["honey"] = {
		label = "Honey",
		weight = 250,
		stack = true,
		close = true,
		description = "A sweet and sticky substance produced by bees.",
		client = {
			image = "honey.png",
		}
	},

	["smallmcandle"] = {
		label = "Small Melted Candle",
		weight = 250,
		stack = true,
		close = true,
		description = "A small melted candle",
		client = {
			image = "smallmcandle.png",
		}
	},

	["rabbits"] = {
		label = "Rabbit Skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a rabbit, commonly used in making fur garments and accessories.",
		client = {
			image = "rabbits.png",
		}
	},

	["deertaxi"] = {
		label = "Deer Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a deer.",
		client = {
			image = "deertaxi.png",
		}
	},

	["provision_ro_flower_cigar"] = {
		label = "Cigar Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Cigar Orchid can be identified by the inflorescence which can produce around five hundred bright yellow flowers with purple and brown markings.",
		client = {
			image = "provision_ro_flower_cigar.png",
		}
	},

	["provision_ring_platinum"] = {
		label = "Platinum Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A finely crafted platinum ring.",
		client = {
			image = "provision_ring_platinum.png",
		}
	},

	["cloth"] = {
		label = "Cloth",
		weight = 250,
		stack = true,
		close = true,
		description = "Simple cloth with many uses.",
		client = {
			image = "cloth.png",
		}
	},

	["cougars"] = {
		label = "Cougar skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The thick and durable skin of a cougar.",
		client = {
			image = "cougars.png",
		}
	},

	["provision_jewelry_whtgld_dmnd_ring"] = {
		label = "Sackville Diamond Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A series of small diamonds claw set in a floral cluster on a white gold band.",
		client = {
			image = "provision_jewelry_whtgld_dmnd_ring.png",
		}
	},

	["copper_ore"] = {
		label = "copper_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "copper_ore.png",
		}
	},

	["provision_jewelry_turq_stud_earring"] = {
		label = "Calumet Turquoise Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Lavish gold studs with claw set turquoise stones.",
		client = {
			image = "provision_jewelry_turq_stud_earring.png",
		}
	},

	["a_c_fishchainpickerel_01_ms"] = {
		label = "Medium Pickerel",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Pickerel fish.",
		client = {
			image = "a_c_fishchainpickerel_01_ms.png",
		}
	},

	["provision_jewelry_topaz_ring"] = {
		label = "Banais Topaz Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A neat silver wedding ring with brilliant cut topaz.",
		client = {
			image = "provision_jewelry_topaz_ring.png",
		}
	},

	["provision_jewelry_topaz_necklace"] = {
		label = "Dane Topaz Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A precious platinum chain necklace with a small drop of topaz.",
		client = {
			image = "provision_jewelry_topaz_necklace.png",
		}
	},

	["consumable_caramel"] = {
		label = "Caramel",
		weight = 250,
		stack = true,
		close = true,
		description = "Sweet and sticky caramel.",
		client = {
			image = "consumable_caramel.png",
		}
	},

	["Choc_Daisy_Seed"] = {
		label = "Choc Daisy Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed to grow Choc Daisies.",
		client = {
			image = "Choc_Daisy_Seed.png",
		}
	},

	["log_benchb"] = {
		label = "Log Bench 2",
		weight = 250,
		stack = true,
		close = true,
		description = "A spacious log bench for outdoor gatherings",
		client = {
			image = "log_benchb.png",
		}
	},

	["Wild_Feverfew"] = {
		label = "Wild Feverfew",
		weight = 250,
		stack = true,
		close = true,
		description = "A wild plant known as Feverfew.",
		client = {
			image = "Wild_Feverfew.png",
		}
	},

	["blueberry"] = {
		label = "Blueberry",
		weight = 250,
		stack = true,
		close = true,
		description = "A small sweet fruit with a bluish color.",
		client = {
			image = "blueberry.png",
		}
	},

	["aligatormeat"] = {
		label = "Alligator Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Raw meat obtained from hunting alligators, suitable for cooking.",
		client = {
			image = "aligatormeat.png",
		}
	},

	["goldfish"] = {
		label = "Gold Fish",
		weight = 250,
		stack = true,
		close = true,
		description = "A shimmering gold-colored fish.",
		client = {
			image = "goldfish.png",
		}
	},

	["collector_fossil_trilobite_crypto"] = {
		label = "Cryptolithus Trilobite Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A small, uncommon trilobite fossil. Good condition.",
		client = {
			image = "collector_fossil_trilobite_crypto.png",
		}
	},

	["beer"] = {
		label = "Beer",
		weight = 250,
		stack = true,
		close = true,
		description = "An alcoholic beverage brewed from grains.",
		client = {
			image = "beer.png",
		}
	},

	["collector_fossil_pet_wood_rainbow"] = {
		label = "Rainbow Petrified Wood Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon piece of petrified wood filled with multicolored crystals.",
		client = {
			image = "collector_fossil_pet_wood_rainbow.png",
		}
	},

	["lamppost1"] = {
		label = "Lamp Post 1 Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of Lamp Post 1",
		client = {
			image = "lamppost1.png",
		}
	},

	["provision_jewelry_sphr_bngle_bracelet"] = {
		label = "Greco Sapphire Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate gold bracelet with three small sapphires.",
		client = {
			image = "provision_jewelry_sphr_bngle_bracelet.png",
		}
	},

	["provision_jewelry_slvr_pearl_necklace"] = {
		label = "Silver Pearl Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A necklace made of fine silver and pearls.",
		client = {
			image = "provision_jewelry_slvr_pearl_necklace.png",
		}
	},

	["silver_ore"] = {
		label = "silver_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "silver_ore.png",
		}
	},

	["steakveg"] = {
		label = "Steak with Veggies",
		weight = 250,
		stack = true,
		close = true,
		description = "A balanced meal with steak and vegetables.",
		client = {
			image = "steakveg.png",
		}
	},

	["a_c_fishrockbass_01_sm"] = {
		label = "Small Rockbass",
		weight = 250,
		stack = true,
		close = true,
		description = "A small Rockbass fish.",
		client = {
			image = "a_c_fishrockbass_01_sm.png",
		}
	},

	["apple_basket"] = {
		label = "Apple Basket",
		weight = 250,
		stack = true,
		close = true,
		description = "A basket filled with fresh apples",
		client = {
			image = "apple_basket.png",
		}
	},

	["tea_sage_evening"] = {
		label = "tea_sage_evening",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tea_sage_evening.png",
		}
	},

	["cookedbluegil"] = {
		label = "Cooked Bluegil with Veggies",
		weight = 250,
		stack = true,
		close = true,
		description = "A cooked Bluegil fish served with vegetables.",
		client = {
			image = "cookedbluegil.png",
		}
	},

	["provision_arrowhead_quartz"] = {
		label = "Quartz Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "An eye-catching arrowhead of cut quartz, in good condition.",
		client = {
			image = "provision_arrowhead_quartz.png",
		}
	},

	["guitar"] = {
		label = "Classic Guitar",
		weight = 250,
		stack = false,
		close = true,
		description = "A traditional six-string guitar.",
		client = {
			image = "guitar.png",
		}
	},

	["decortent1"] = {
		label = "Decor Tent 1 Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A decorative tent set with unique patterns.",
		client = {
			image = "decortent1.png",
		}
	},

	["legpanthers1"] = {
		label = "Legendary Nightwalker Panther pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A dark and elusive pelt from a legendary Nightwalker Panther",
		client = {
			image = "legpanthers1.png",
		}
	},

	["consumable_meat_greavy"] = {
		label = "Meat Stew",
		weight = 250,
		stack = true,
		close = true,
		description = "A hearty meat stew.",
		client = {
			image = "consumable_meat_greavy.png",
		}
	},

	["provision_jewelry_gld_pearl_necklace"] = {
		label = "Rou Pearl Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A necklace made of fine rose gold featuring a single pearl from the Orient.",
		client = {
			image = "provision_jewelry_gld_pearl_necklace.png",
		}
	},

	["legelks1"] = {
		label = "Legendary Katata Elk pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exceptional pelt from a legendary Katata Elk",
		client = {
			image = "legelks1.png",
		}
	},

	["coyote_pelt"] = {
		label = "Coyote Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur pelt of a coyote.",
		client = {
			image = "coyote_pelt.png",
		}
	},

	["provision_jewelry_pearl_bracelet"] = {
		label = "Durant Pearl Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "An intricate link bracelet with natural pearls and gold filigree.",
		client = {
			image = "provision_jewelry_pearl_bracelet.png",
		}
	},

	["provision_jewelry_mthr_pearl_necklace"] = {
		label = "Pellé Pearl Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A beaded chain necklace with a fashionable mother of pearl pendant.",
		client = {
			image = "provision_jewelry_mthr_pearl_necklace.png",
		}
	},

	["bparrotb"] = {
		label = "Parrot beak",
		weight = 250,
		stack = true,
		close = true,
		description = "A beak obtained from a parrot.",
		client = {
			image = "bparrotb.png",
		}
	},

	["mashraspberry90p"] = {
		label = "Raspberry Mash 90p",
		weight = 250,
		stack = true,
		close = true,
		description = "A concentrated raspberry mash used for crafting potent beverages",
		client = {
			image = "mashraspberry90p.png",
		}
	},

	["hemp"] = {
		label = "Hemp",
		weight = 250,
		stack = true,
		close = true,
		description = "A plant commonly used for its fiber.",
		client = {
			image = "hemp.png",
		}
	},

	["loungechair2"] = {
		label = "Lounge Chair 2",
		weight = 250,
		stack = true,
		close = true,
		description = "A modern and luxurious lounge chair",
		client = {
			image = "loungechair2.png",
		}
	},

	["provision_jewelry_grnet_bracelet"] = {
		label = "Hajnal Garnet Bangle Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A bohemian style silver bangle with numerous claw set garnets.",
		client = {
			image = "provision_jewelry_grnet_bracelet.png",
		}
	},

	["provision_jewelry_gld_cross_necklace"] = {
		label = "Ainsworth Cross Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid gold chain necklace with an etched gold cross.",
		client = {
			image = "provision_jewelry_gld_cross_necklace.png",
		}
	},

	["provision_jewelry_dmnd_pendt_earring"] = {
		label = "Orchidée Diamond Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Earrings set with clusters of brilliant cut diamonds in a floral pattern.",
		client = {
			image = "provision_jewelry_dmnd_pendt_earring.png",
		}
	},

	["provision_ro_flower_queens"] = {
		label = "Queens Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Queens Orchid can be identified by the white sepals, and purple and white curled petal.",
		client = {
			image = "provision_ro_flower_queens.png",
		}
	},

	["consumable_peachjelly"] = {
		label = "Peach Jelly",
		weight = 250,
		stack = true,
		close = true,
		description = "Peach flavored jelly.",
		client = {
			image = "consumable_peachjelly.png",
		}
	},

	["daruf"] = {
		label = "Crane feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful feather from a crane.",
		client = {
			image = "daruf.png",
		}
	},

	["provision_jewelry_emerald_earring"] = {
		label = "Duchess Emerald Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "A famous set of oval cut emeralds fashioned into earrings.",
		client = {
			image = "provision_jewelry_emerald_earring.png",
		}
	},

	["Oregano_Seed"] = {
		label = "Oregano Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Oregano.",
		client = {
			image = "Oregano_Seed.png",
		}
	},

	["game"] = {
		label = "Game Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh meat obtained from hunting animals.",
		client = {
			image = "game.png",
		}
	},

	["wateringcan_empty"] = {
		label = "Empty Watering Jug",
		weight = 250,
		stack = true,
		close = true,
		description = "An empty watering jug.",
		client = {
			image = "wateringcan_empty.png",
		}
	},

	["syringecert"] = {
		label = "Syringe Cert",
		weight = 250,
		stack = true,
		close = true,
		description = "A certification for the proper use of syringes.",
		client = {
			image = "syringecert.png",
		}
	},

	["herptile"] = {
		label = "Herptile meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Meat obtained from reptiles and amphibians.",
		client = {
			image = "herptile.png",
		}
	},

	["collector_fossil_brachiopod"] = {
		label = "Brachiopod Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common Brachiopod fossil with some chips and scrapes.",
		client = {
			image = "collector_fossil_brachiopod.png",
		}
	},

	["provision_jewelry_box"] = {
		label = "Jewelry Box",
		weight = 250,
		stack = true,
		close = true,
		description = "A small jewlery box.",
		client = {
			image = "provision_jewelry_box.png",
		}
	},

	["Black_Currant_Seed"] = {
		label = "Black Currant Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow black currants.",
		client = {
			image = "Black_Currant_Seed.png",
		}
	},

	["vanillacake"] = {
		label = "Vanilla Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty vanilla flavored cake.",
		client = {
			image = "vanillacake.png",
		}
	},

	["consumable_horsepeppermints"] = {
		label = "Peppermint Stick",
		weight = 250,
		stack = true,
		close = true,
		description = "Peppermint flavored candy stick.",
		client = {
			image = "consumable_horsepeppermints.png",
		}
	},

	["provision_jail_keys"] = {
		label = "Jail Keys",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of keys used to unlock jail cells and gates.",
		client = {
			image = "provision_jail_keys.png",
		}
	},

	["panthere"] = {
		label = "Panther eyes",
		weight = 250,
		stack = true,
		close = true,
		description = "Intense and captivating eyes from a panther.",
		client = {
			image = "panthere.png",
		}
	},

	["alcohol"] = {
		label = "Alcohol",
		weight = 250,
		stack = true,
		close = true,
		description = "An intoxicating beverage consumed for recreational purposes.",
		client = {
			image = "alcohol.png",
		}
	},

	["legboars4"] = {
		label = "Legendary Wildhog pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An untamed pelt from a legendary Wildhog",
		client = {
			image = "legboars4.png",
		}
	},

	["ammobolaironspiked"] = {
		label = "Bola Ammo Ironspiked",
		weight = 250,
		stack = true,
		close = true,
		description = "A bola ammunition featuring iron spikes, inflicting additional damage to immobilized targets.",
		client = {
			image = "ammobolaironspiked.png",
		}
	},

	["provision_hrlm_hairpin_metal"] = {
		label = "Meatl Hairpin",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful metal hairpin.",
		client = {
			image = "provision_hrlm_hairpin_metal.png",
		}
	},

	["whisky"] = {
		label = "Whisky",
		weight = 250,
		stack = true,
		close = true,
		description = "An alcoholic beverage known as whisky.",
		client = {
			image = "whisky.png",
		}
	},

	["consumable_lock_breaker"] = {
		label = "Lock Breaker",
		weight = 250,
		stack = true,
		close = true,
		description = "A tool for breaking locks.",
		client = {
			image = "consumable_lock_breaker.png",
		}
	},

	["Bitter_Weed_Seed"] = {
		label = "Bitter Weed Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow bitter weed.",
		client = {
			image = "Bitter_Weed_Seed.png",
		}
	},

	["sulfur"] = {
		label = "Sulfur",
		weight = 250,
		stack = true,
		close = true,
		description = "A yellow chemical element often used in manufacturing.",
		client = {
			image = "sulfur.png",
		}
	},

	["cane"] = {
		label = "Cane",
		weight = 250,
		stack = false,
		close = true,
		description = "A walking stick for support and stability.",
		client = {
			image = "cane.png",
		}
	},

	["opossums"] = {
		label = "Opossum skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur and skin of an opossum.",
		client = {
			image = "opossums.png",
		}
	},

	["Indian_Tobbaco_Seed"] = {
		label = "Indian Tobbaco Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Indian tobbaco plants.",
		client = {
			image = "Indian_Tobbaco_Seed.png",
		}
	},

	["bouquet"] = {
		label = "Bouquet",
		weight = 250,
		stack = false,
		close = true,
		description = "A collection of flowers arranged in an artistic way.",
		client = {
			image = "bouquet.png",
		}
	},

	["coyotef"] = {
		label = "Coyote tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A sharp tooth from a coyote.",
		client = {
			image = "coyotef.png",
		}
	},

	["ironextract"] = {
		label = "Iron Extract",
		weight = 250,
		stack = false,
		close = true,
		description = "A concentrated form of iron, extracted from natural sources.",
		client = {
			image = "ironextract.png",
		}
	},

	["legbucks"] = {
		label = "Legendary Buck skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A prized skin from a legendary buck",
		client = {
			image = "legbucks.png",
		}
	},

	["tylenol"] = {
		label = "Tylenol",
		weight = 250,
		stack = true,
		close = true,
		description = "A medication called Tylenol.",
		client = {
			image = "tylenol.png",
		}
	},

	["provision_hrlm_hairpin_ebony"] = {
		label = "Ebony Hairpin",
		weight = 250,
		stack = true,
		close = true,
		description = "A exquisite ebony hairpin.",
		client = {
			image = "provision_hrlm_hairpin_ebony.png",
		}
	},

	["pelicanb"] = {
		label = "Pelican beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a pelican bird.",
		client = {
			image = "pelicanb.png",
		}
	},

	["decortent3"] = {
		label = "Decor Tent 3 Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A decorative tent set with unique patterns.",
		client = {
			image = "decortent3.png",
		}
	},

	["hk_102"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_102.png",
		}
	},

	["Oleander_Sage_Seed"] = {
		label = "Oleander Sage Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Oleander Sage.",
		client = {
			image = "Oleander_Sage_Seed.png",
		}
	},

	["clothes_line"] = {
		label = "Clothes Line",
		weight = 250,
		stack = true,
		close = true,
		description = "A line for hanging clothes.",
		client = {
			image = "clothes_line.png",
		}
	},

	["Desert_Sage_Seed"] = {
		label = "Desert Sage Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed of Desert Sage that can be planted to grow Desert Sage plants.",
		client = {
			image = "Desert_Sage_Seed.png",
		}
	},

	["provision_hrlm_comb_boxwood"] = {
		label = "Boxwood Comb",
		weight = 250,
		stack = true,
		close = true,
		description = "A finley made boxwood comb.",
		client = {
			image = "provision_hrlm_comb_boxwood.png",
		}
	},

	["seagullb"] = {
		label = "Seagull beak",
		weight = 250,
		stack = true,
		close = true,
		description = "Beak of a seagull",
		client = {
			image = "seagullb.png",
		}
	},

	["provision_hrlm_brush_rosewood"] = {
		label = "Rosewood Hairbrush",
		weight = 250,
		stack = true,
		close = true,
		description = "A hand carved rosewood brush.",
		client = {
			image = "provision_hrlm_brush_rosewood.png",
		}
	},

	["provision_hrlm_brush_horsehair"] = {
		label = "Horse Hair brush",
		weight = 250,
		stack = true,
		close = true,
		description = "A finley made horse hair brush.",
		client = {
			image = "provision_hrlm_brush_horsehair.png",
		}
	},

	["raisin"] = {
		label = "Raisin",
		weight = 250,
		stack = true,
		close = true,
		description = "A dried grape that makes good eating.",
		client = {
			image = "raisin.png",
		}
	},

	["stickfish"] = {
		label = "stickfish",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "stickfish.png",
		}
	},

	[""] = {
		label = "pestle",
		weight = 250,
		stack = true,
		close = true,
		description = "pestle",
		client = {
			image = ".png",
		}
	},

	["boobyb"] = {
		label = "Red-footed booby beak",
		weight = 250,
		stack = true,
		close = true,
		description = "A beak obtained from a red-footed booby bird.",
		client = {
			image = "boobyb.png",
		}
	},

	["ammobolla"] = {
		label = "Bolla Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "A weighted throwing weapon used to ensnare and immobilize targets.",
		client = {
			image = "ammobolla.png",
		}
	},

	["legcougars3"] = {
		label = "Legendary Sapa Cougar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A majestic pelt from a legendary Sapa Cougar",
		client = {
			image = "legcougars3.png",
		}
	},

	["provision_generic_key"] = {
		label = "Key",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple key.",
		client = {
			image = "provision_generic_key.png",
		}
	},

	["legbisons"] = {
		label = "Legendary Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and valuable pelt from a legendary bison",
		client = {
			image = "legbisons.png",
		}
	},

	["Wild_Feverfew_Seed"] = {
		label = "Wild Feverfew Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow Feverfew plants.",
		client = {
			image = "Wild_Feverfew_Seed.png",
		}
	},

	["legcoyotes1"] = {
		label = "Legendary Red Streak Coyote pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A vibrant pelt from a legendary Red Streak Coyote",
		client = {
			image = "legcoyotes1.png",
		}
	},

	["provision_earring_pearl"] = {
		label = "Pearl Earring",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold earring.",
		client = {
			image = "provision_earring_pearl.png",
		}
	},

	["bark"] = {
		label = "bark",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "bark.png",
		}
	},

	["provision_earring_gold"] = {
		label = "Gold Earring",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold earring.",
		client = {
			image = "provision_earring_gold.png",
		}
	},

	["provision_hrlm_brush_rosewood_ng"] = {
		label = "New Guinea Rosewood Hairbrush",
		weight = 250,
		stack = true,
		close = true,
		description = "An exotic new guinea rosewood hairbrush.",
		client = {
			image = "provision_hrlm_brush_rosewood_ng.png",
		}
	},

	["provision_disco_viking_comb"] = {
		label = "Viking Comb",
		weight = 250,
		stack = true,
		close = true,
		description = "A old viking comb.",
		client = {
			image = "provision_disco_viking_comb.png",
		}
	},

	["legbisonhorn"] = {
		label = "Legendary Bison Horns",
		weight = 250,
		stack = true,
		close = true,
		description = "A pair of majestic horns from a legendary bison",
		client = {
			image = "legbisonhorn.png",
		}
	},

	["Oleander_Sage"] = {
		label = "Oleander Sage",
		weight = 250,
		stack = true,
		close = true,
		description = "A herb known for its medicinal properties.",
		client = {
			image = "Oleander_Sage.png",
		}
	},

	["grapes"] = {
		label = "Grapes",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty fruit that grows in clusters. Often used to make wine.",
		client = {
			image = "grapes.png",
		}
	},

	["provision_disco_urn"] = {
		label = "Urn",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple urn often used to hold things.",
		client = {
			image = "provision_disco_urn.png",
		}
	},

	["cooked_fish"] = {
		label = "cooked_fish",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "cooked_fish.png",
		}
	},

	["hop_seed"] = {
		label = "Hop Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow hop plants.",
		client = {
			image = "hop_seed.png",
		}
	},

	["beerbox"] = {
		label = "Beer Box",
		weight = 250,
		stack = true,
		close = true,
		description = "A container holding multiple bottles of beer.",
		client = {
			image = "beerbox.png",
		}
	},

	["cougarf"] = {
		label = "Cougar tooth",
		weight = 250,
		stack = true,
		close = true,
		description = "A sharp tooth from a cougar.",
		client = {
			image = "cougarf.png",
		}
	},

	["pelicanf"] = {
		label = "Pelican feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather from a pelican bird.",
		client = {
			image = "pelicanf.png",
		}
	},

	["consumable_coffeecake"] = {
		label = "Coffee Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious coffee cake.",
		client = {
			image = "consumable_coffeecake.png",
		}
	},

	["standingtorch"] = {
		label = "Standing Torch",
		weight = 250,
		stack = true,
		close = true,
		description = "A standing torch to provide light.",
		client = {
			image = "standingtorch.png",
		}
	},

	["consumable_donut"] = {
		label = "Donut",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty donut.",
		client = {
			image = "consumable_donut.png",
		}
	},

	["cordbow"] = {
		label = "Bow Cord",
		weight = 250,
		stack = true,
		close = true,
		description = "Cord used for making a bow.",
		client = {
			image = "cordbow.png",
		}
	},

	["cocoa"] = {
		label = "Cocoa",
		weight = 250,
		stack = true,
		close = true,
		description = "Cocoa beans for making chocolate.",
		client = {
			image = "cocoa.png",
		}
	},

	["provision_disco_ancient_necklace"] = {
		label = "Ancient Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "An ancient necklace.",
		client = {
			image = "provision_disco_ancient_necklace.png",
		}
	},

	["p_FinisdFishlure01x"] = {
		label = "Fish Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A versatile fish lure designed to attract a variety of freshwater species.",
		client = {
			image = "p_FinisdFishlure01x.png",
		}
	},

	["hk_129"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_129.png",
		}
	},

	["gypsywagon"] = {
		label = "Gypsys Wagon Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of items related to a gypsy wagon.",
		client = {
			image = "gypsywagon.png",
		}
	},

	["hoe"] = {
		label = "Garden Hoe",
		weight = 250,
		stack = true,
		close = true,
		description = "A gardening tool with a thin metal blade.",
		client = {
			image = "hoe.png",
		}
	},

	["bountylicns"] = {
		label = "Bounty Hunter License",
		weight = 250,
		stack = true,
		close = true,
		description = "A license granting permission to be a bounty hunter.",
		client = {
			image = "bountylicns.png",
		}
	},

	["pota"] = {
		label = "House Pot",
		weight = 250,
		stack = true,
		close = true,
		description = "A pot typically used for cooking and boiling ingredients.",
		client = {
			image = "pota.png",
		}
	},

	["pigeon_c"] = {
		label = "Pigeon",
		weight = 250,
		stack = true,
		close = true,
		description = "A pigeon bird.",
		client = {
			image = "pigeon_c.png",
		}
	},

	["bisonhorn"] = {
		label = "Bison horn",
		weight = 250,
		stack = true,
		close = true,
		description = "A horn obtained from a bison.",
		client = {
			image = "bisonhorn.png",
		}
	},

	["condenser"] = {
		label = "Condenser",
		weight = 250,
		stack = true,
		close = true,
		description = "A device used to condense substances.",
		client = {
			image = "condenser.png",
		}
	},

	["provision_diamond_ring"] = {
		label = "Diamond Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful diamond ring.",
		client = {
			image = "provision_diamond_ring.png",
		}
	},

	["provision_coin_1800_hlf_dime"] = {
		label = "1800 Half Dime",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1800 Half Dime",
		client = {
			image = "provision_coin_1800_hlf_dime.png",
		}
	},

	["provision_coin_1800_gld_dlr"] = {
		label = "1800 Gold Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1800 Gold Dollar",
		client = {
			image = "provision_coin_1800_gld_dlr.png",
		}
	},

	["provision_coin_1792_qtr"] = {
		label = "1792 Quarter",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1792 Quarter",
		client = {
			image = "provision_coin_1792_qtr.png",
		}
	},

	["provision_coin_1798_slv_dlr"] = {
		label = "1798 Silver Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1798 Silver Dollar",
		client = {
			image = "provision_coin_1798_slv_dlr.png",
		}
	},

	["provision_coin_1797_gld_eag"] = {
		label = "1797 Gold Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1797 Gold Eagle",
		client = {
			image = "provision_coin_1797_gld_eag.png",
		}
	},

	["Gamey_Meat"] = {
		label = "Gamey Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of meat with a distinct gamey flavor.",
		client = {
			image = "Gamey_Meat.png",
		}
	},

	["provision_coin_1795_hlf_eag"] = {
		label = "1795 Half Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1795 Half Eagle",
		client = {
			image = "provision_coin_1795_hlf_eag.png",
		}
	},

	["consumable_salmon_can"] = {
		label = "Salmon Can",
		weight = 250,
		stack = true,
		close = true,
		description = "Canned salmon.",
		client = {
			image = "consumable_salmon_can.png",
		}
	},

	["nails"] = {
		label = "Nails",
		weight = 250,
		stack = true,
		close = true,
		description = "Small metal fasteners used for joining materials",
		client = {
			image = "nails.png",
		}
	},

	["provision_coin_1800_five_dlr"] = {
		label = "1800 Five Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1800 Five Dollar",
		client = {
			image = "provision_coin_1800_five_dlr.png",
		}
	},

	["hk_105"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_105.png",
		}
	},

	["bearbench"] = {
		label = "Bear Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made from the hide and bones of a bear.",
		client = {
			image = "bearbench.png",
		}
	},

	["salt"] = {
		label = "Salt",
		weight = 250,
		stack = true,
		close = true,
		description = "Common salt",
		client = {
			image = "salt.png",
		}
	},

	["gold_panning_license"] = {
		label = "Gold Panning License",
		weight = 250,
		stack = true,
		close = true,
		description = "A license to pan gold.",
		client = {
			image = "gold_panning_license.png",
		}
	},

	["Duck_Egg"] = {
		label = "Duck Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "An egg laid by a duck, often used in various culinary preparations.",
		client = {
			image = "Duck_Egg.png",
		}
	},

	["provision_coin_1700_ny_tkn"] = {
		label = "1700 New Yorke Token",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1700 New Yorke Token",
		client = {
			image = "provision_coin_1700_ny_tkn.png",
		}
	},

	["hk_106"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_106.png",
		}
	},

	["fan"] = {
		label = "Fan",
		weight = 250,
		stack = true,
		close = true,
		description = "A handheld device with flat blades used to create a breeze or provide cooling.",
		client = {
			image = "fan.png",
		}
	},

	["provision_capitale"] = {
		label = "Capitale",
		weight = 250,
		stack = true,
		close = true,
		description = "Capitale. very valuable.",
		client = {
			image = "provision_capitale.png",
		}
	},

	["blanketbox"] = {
		label = "Blanket Box",
		weight = 250,
		stack = true,
		close = true,
		description = "A box used for storing blankets.",
		client = {
			image = "blanketbox.png",
		}
	},

	["hk_132"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_132.png",
		}
	},

	["iron_ore"] = {
		label = "iron_ore",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "iron_ore.png",
		}
	},

	["hk_118"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_118.png",
		}
	},

	["coyotetaxi"] = {
		label = "Coyote Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a coyote.",
		client = {
			image = "coyotetaxi.png",
		}
	},

	["moonshine"] = {
		label = "Moonshine",
		weight = 250,
		stack = true,
		close = true,
		description = "An illegally distilled and potent alcoholic beverage",
		client = {
			image = "moonshine.png",
		}
	},

	["condorf"] = {
		label = "Condor feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful feather from a condor.",
		client = {
			image = "condorf.png",
		}
	},

	["crab_c"] = {
		label = "Crab",
		weight = 250,
		stack = true,
		close = true,
		description = "A crab with a hard shell.",
		client = {
			image = "crab_c.png",
		}
	},

	["consumable_fruitsalad"] = {
		label = "Fruit Salad",
		weight = 250,
		stack = true,
		close = true,
		description = "A refreshing fruit salad.",
		client = {
			image = "consumable_fruitsalad.png",
		}
	},

	["handmixer"] = {
		label = "Handmixer",
		weight = 250,
		stack = true,
		close = true,
		description = "A hand-held mixing device",
		client = {
			image = "handmixer.png",
		}
	},

	["songbird2_c"] = {
		label = "Scarlet songbird",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful scarlet songbird",
		client = {
			image = "songbird2_c.png",
		}
	},

	["hk_111"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_111.png",
		}
	},

	["provision_buckle_platinum"] = {
		label = "Platinum Buckle",
		weight = 250,
		stack = true,
		close = true,
		description = "A platinum belt buckle.",
		client = {
			image = "provision_buckle_platinum.png",
		}
	},

	["provision_bra_shield"] = {
		label = "Brass Shield",
		weight = 250,
		stack = true,
		close = true,
		description = "An old brass shield. Probably valuable.",
		client = {
			image = "provision_bra_shield.png",
		}
	},

	["mooseantler"] = {
		label = "Moose Antlers",
		weight = 250,
		stack = true,
		close = true,
		description = "Impressive antlers shed by a moose",
		client = {
			image = "mooseantler.png",
		}
	},

	["provision_bracelet_silver"] = {
		label = "Silver Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A silver bracelet.",
		client = {
			image = "provision_bracelet_silver.png",
		}
	},

	["American_Ginseng_Seed"] = {
		label = "American Ginseng Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow American Ginseng.",
		client = {
			image = "American_Ginseng_Seed.png",
		}
	},

	["provision_bracelet_platinum"] = {
		label = "Platinum Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A platinum bracelet",
		client = {
			image = "provision_bracelet_platinum.png",
		}
	},

	["provision_bracelet_gold"] = {
		label = "Gold Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold bracelet.",
		client = {
			image = "provision_bracelet_gold.png",
		}
	},

	["provision_asteroid_chunk"] = {
		label = "Meteorite",
		weight = 250,
		stack = true,
		close = true,
		description = "A rock that has fallen from space.",
		client = {
			image = "provision_asteroid_chunk.png",
		}
	},

	["meat"] = {
		label = "Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh and uncooked meat from various animals",
		client = {
			image = "meat.png",
		}
	},

	["horsemeal"] = {
		label = "Horse ration",
		weight = 250,
		stack = true,
		close = true,
		description = "Food provided to horses for sustenance.",
		client = {
			image = "horsemeal.png",
		}
	},

	["consumable_medicine"] = {
		label = "Medicine",
		weight = 250,
		stack = true,
		close = true,
		description = "Medicinal treatment.",
		client = {
			image = "consumable_medicine.png",
		}
	},

	["birdfeather"] = {
		label = "birdfeather",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "birdfeather.png",
		}
	},

	["p_lgoc_spinner_v6"] = {
		label = "Spinner V6",
		weight = 250,
		stack = true,
		close = true,
		description = "An advanced spinner lure with enhanced spinning action, ideal for large, deep-water fish.",
		client = {
			image = "p_lgoc_spinner_v6.png",
		}
	},

	["provision_arrowhead_rough"] = {
		label = "Rough Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A stone arrowhead, badly weathered over time.",
		client = {
			image = "provision_arrowhead_rough.png",
		}
	},

	["a_c_fishrainbowtrout_01_ms"] = {
		label = "Rainbow Trout",
		weight = 250,
		stack = true,
		close = true,
		description = "A Rainbow Trout fish.",
		client = {
			image = "a_c_fishrainbowtrout_01_ms.png",
		}
	},

	["provision_arrowhead_obsidian"] = {
		label = "Obsidian Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A valuable arrowhead of smooth, gleaming obsidian.",
		client = {
			image = "provision_arrowhead_obsidian.png",
		}
	},

	["fertilizersq"] = {
		label = "Fertilizer with Squirrel",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer infused with nutrients derived from squirrels, providing essential elements for plant nourishment and vitality.",
		client = {
			image = "fertilizersq.png",
		}
	},

	["provision_arrowhead_crude"] = {
		label = "Crude Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A clumsily made flint arrowhead, blunt from age.",
		client = {
			image = "provision_arrowhead_crude.png",
		}
	},

	["legbeavers3"] = {
		label = "Legendary Black Beaver pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Black Beaver",
		client = {
			image = "legbeavers3.png",
		}
	},

	["leggbears"] = {
		label = "Legendary Bear skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A formidable and sought-after skin from a legendary bear",
		client = {
			image = "leggbears.png",
		}
	},

	["provision_coin_1789_pny"] = {
		label = "1789 Penny",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1789 Penny",
		client = {
			image = "provision_coin_1789_pny.png",
		}
	},

	["provision_arrowhead_bone"] = {
		label = "Bone Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A serrated arrowhead made from animal bone.",
		client = {
			image = "provision_arrowhead_bone.png",
		}
	},

	["provision_arrowhead_agate"] = {
		label = "Agate Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare arrowhead fashioned from sharp, colorful agate.",
		client = {
			image = "provision_arrowhead_agate.png",
		}
	},

	["mp001_p_mp_still02x"] = {
		label = "Brennerei",
		weight = 250,
		stack = false,
		close = true,
		description = "A large still used for distilling alcoholic beverages",
		client = {
			image = "mp001_p_mp_still02x.png",
		}
	},

	["Prairie_Poppy"] = {
		label = "Prairie Poppy",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of poppy flower that is native to prairie regions.",
		client = {
			image = "Prairie_Poppy.png",
		}
	},

	["a_c_fishredfinpickerel_01_ms"] = {
		label = "Medium Redfin Pickerel",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Redfin Pickerel fish.",
		client = {
			image = "a_c_fishredfinpickerel_01_ms.png",
		}
	},

	["songbird_c"] = {
		label = "Songbird",
		weight = 250,
		stack = true,
		close = true,
		description = "A lovely songbird",
		client = {
			image = "songbird_c.png",
		}
	},

	["goldbar"] = {
		label = "GoldBar",
		weight = 250,
		stack = true,
		close = true,
		description = "A bar made of solid gold.",
		client = {
			image = "goldbar.png",
		}
	},

	["leather_chair"] = {
		label = "Leather Chair",
		weight = 250,
		stack = true,
		close = true,
		description = "A leather chair",
		client = {
			image = "leather_chair.png",
		}
	},

	["potato"] = {
		label = "Potato",
		weight = 250,
		stack = true,
		close = true,
		description = "An edible starchy tuber that is commonly used in cooking.",
		client = {
			image = "potato.png",
		}
	},

	["collector_fossil_tooth_serrated"] = {
		label = "Serrated Tooth Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and jagged fossilized tooth, once belonging to an Allosaurus.",
		client = {
			image = "collector_fossil_tooth_serrated.png",
		}
	},

	["sidetable"] = {
		label = "side table 1",
		weight = 250,
		stack = true,
		close = true,
		description = "Functional side table",
		client = {
			image = "sidetable.png",
		}
	},

	["token"] = {
		label = "Camp License",
		weight = 250,
		stack = true,
		close = true,
		description = "A license for setting up a camp.",
		client = {
			image = "token.png",
		}
	},

	["provision_disco_ammolite"] = {
		label = "Ammolite",
		weight = 250,
		stack = true,
		close = true,
		description = "Fossilized shell of an ammonite.",
		client = {
			image = "provision_disco_ammolite.png",
		}
	},

	["pickaxe"] = {
		label = "Pickaxe",
		weight = 250,
		stack = false,
		close = true,
		description = "A tool with a pointed end and a handle, used for breaking up rocks and mining.",
		client = {
			image = "pickaxe.png",
		}
	},

	["phestaxi"] = {
		label = "Pheasant Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A preserved mount of a pheasant bird for display.",
		client = {
			image = "phestaxi.png",
		}
	},

	["Feed_For_Dog"] = {
		label = "Dog Food",
		weight = 250,
		stack = true,
		close = true,
		description = "Nutritious food specifically formulated for dogs.",
		client = {
			image = "Feed_For_Dog.png",
		}
	},

	["pheasant_taxidermy"] = {
		label = "Pheasant Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A preserved mount of a pheasant bird for display.",
		client = {
			image = "pheasant_taxidermy.png",
		}
	},

	["clothesline"] = {
		label = "Clothes Line",
		weight = 250,
		stack = true,
		close = true,
		description = "A line for hanging clothes.",
		client = {
			image = "clothesline.png",
		}
	},

	["provision_hrlm_comb_ivory"] = {
		label = "Ivory Comb",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate ivory comb.",
		client = {
			image = "provision_hrlm_comb_ivory.png",
		}
	},

	["buckantler"] = {
		label = "Buck Antlers",
		weight = 250,
		stack = true,
		close = true,
		description = "Antlers obtained from a buck.",
		client = {
			image = "buckantler.png",
		}
	},

	["grinder"] = {
		label = "Grinder",
		weight = 250,
		stack = true,
		close = true,
		description = "Used to crush up and grind herbs and plants.",
		client = {
			image = "grinder.png",
		}
	},

	["pecaris"] = {
		label = "Peccary pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur of a peccary, a pig-like mammal.",
		client = {
			image = "pecaris.png",
		}
	},

	["tonic_mint_note"] = {
		label = "tonic_mint_note",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "tonic_mint_note.png",
		}
	},

	["emerald"] = {
		label = "Emerald",
		weight = 250,
		stack = true,
		close = true,
		description = "A precious green gemstone with a sparkling appearance.",
		client = {
			image = "emerald.png",
		}
	},

	["copper_nugget"] = {
		label = "copper_nugget",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "copper_nugget.png",
		}
	},

	["Burdock_Root"] = {
		label = "Burdock Root",
		weight = 250,
		stack = true,
		close = true,
		description = "The root of a burdock plant, often used for medicinal purposes.",
		client = {
			image = "Burdock_Root.png",
		}
	},

	["peachseeds"] = {
		label = "Peach Seeds",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds that can be planted to grow peach trees.",
		client = {
			image = "peachseeds.png",
		}
	},

	["condorb"] = {
		label = "Condor beak",
		weight = 250,
		stack = true,
		close = true,
		description = "A beak from a condor bird.",
		client = {
			image = "condorb.png",
		}
	},

	["Parasol_Mushroom_Seed"] = {
		label = "Parasol Mushroom Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow parasol mushrooms.",
		client = {
			image = "Parasol_Mushroom_Seed.png",
		}
	},

	["Parasol_Mushroom"] = {
		label = "Parasol Mushroom",
		weight = 250,
		stack = true,
		close = true,
		description = "A mushroom with a wide, umbrella-like cap.",
		client = {
			image = "Parasol_Mushroom.png",
		}
	},

	["rectable"] = {
		label = "Rectangle Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A rectangular-shaped table, suitable for various purposes such as dining or work.",
		client = {
			image = "rectable.png",
		}
	},

	["consumable_cupcake"] = {
		label = "Cupcake",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious cupcake.",
		client = {
			image = "consumable_cupcake.png",
		}
	},

	["oxs"] = {
		label = "Angus Bull pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The thick fur and skin of an Angus Bull.",
		client = {
			image = "oxs.png",
		}
	},

	["nativedecor"] = {
		label = "Native Decor Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of decorative native items for display",
		client = {
			image = "nativedecor.png",
		}
	},

	["oriole_c"] = {
		label = "Oriole",
		weight = 250,
		stack = true,
		close = true,
		description = "Vibrant feathers from an Oriole bird.",
		client = {
			image = "oriole_c.png",
		}
	},

	["oriole2_c"] = {
		label = "Hooded Oriole",
		weight = 250,
		stack = true,
		close = true,
		description = "Brightly colored feathers from a Hooded Oriole.",
		client = {
			image = "oriole2_c.png",
		}
	},

	["Oregano"] = {
		label = "Oregano",
		weight = 250,
		stack = true,
		close = true,
		description = "A fragrant herb commonly used in cooking.",
		client = {
			image = "Oregano.png",
		}
	},

	["opossumc"] = {
		label = "Opossum claws",
		weight = 250,
		stack = true,
		close = true,
		description = "Sharp claws from an opossum.",
		client = {
			image = "opossumc.png",
		}
	},

	["flag"] = {
		label = "Camp Flag",
		weight = 250,
		stack = true,
		close = true,
		description = "A colorful and distinctive flag used to mark and identify a campsite or specific location.",
		client = {
			image = "flag.png",
		}
	},

	["provision_hrlm_comb_cherrywood"] = {
		label = "Cherrywood Comb",
		weight = 250,
		stack = true,
		close = true,
		description = "A exquisite cheerywood comb.",
		client = {
			image = "provision_hrlm_comb_cherrywood.png",
		}
	},

	["shrimps"] = {
		label = "Shrimp Stew",
		weight = 250,
		stack = false,
		close = true,
		description = "Delicious shrimp stew",
		client = {
			image = "shrimps.png",
		}
	},

	["notebook"] = {
		label = "Notebook",
		weight = 250,
		stack = true,
		close = true,
		description = "A small book with blank pages for writing or drawing",
		client = {
			image = "notebook.png",
		}
	},

	["normaltable"] = {
		label = "Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A standard table for dining or work purposes",
		client = {
			image = "normaltable.png",
		}
	},

	["provision_jewelry_wht_dmnd_earring"] = {
		label = "Endicott Diamond Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Exquisite pendant earrings with old mine cut diamonds.",
		client = {
			image = "provision_jewelry_wht_dmnd_earring.png",
		}
	},

	["nitrite"] = {
		label = "Nitrite",
		weight = 250,
		stack = true,
		close = true,
		description = "A chemical compound used in various industrial processes",
		client = {
			image = "nitrite.png",
		}
	},

	["hk_107"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_107.png",
		}
	},

	["Rams_Head_Seed"] = {
		label = "Rams Head Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow plants resembling a rams head.",
		client = {
			image = "Rams_Head_Seed.png",
		}
	},

	["newspaper"] = {
		label = "Newspaper",
		weight = 250,
		stack = true,
		close = true,
		description = "A printed publication containing news and articles",
		client = {
			image = "newspaper.png",
		}
	},

	["nativepot"] = {
		label = "Native Pot",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional native pot for cooking and storage",
		client = {
			image = "nativepot.png",
		}
	},

	["owlf"] = {
		label = "Owl feather",
		weight = 250,
		stack = true,
		close = true,
		description = "Feathers shed by an owl.",
		client = {
			image = "owlf.png",
		}
	},

	["nativebasket2"] = {
		label = "Native Basket 2",
		weight = 250,
		stack = true,
		close = true,
		description = "A second variation of a traditional native basket",
		client = {
			image = "nativebasket2.png",
		}
	},

	["provision_coin_1794_slv_dlr"] = {
		label = "1794 Silver Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare 1794 Silver Dollar",
		client = {
			image = "provision_coin_1794_slv_dlr.png",
		}
	},

	["legbears2"] = {
		label = "Legendary Owiza Bear pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from an Owiza Bear",
		client = {
			image = "legbears2.png",
		}
	},

	["Mutton"] = {
		label = "Mutton",
		weight = 250,
		stack = true,
		close = true,
		description = "Meat from mature sheep used in cooking",
		client = {
			image = "Mutton.png",
		}
	},

	["glasseye"] = {
		label = "Glass Eye",
		weight = 250,
		stack = true,
		close = true,
		description = "A glass eye. Probably lost in a bar fight.",
		client = {
			image = "glasseye.png",
		}
	},

	["a_c_fishbullheadcat_01_ms"] = {
		label = "Medium Bullhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Bullhead fish.",
		client = {
			image = "a_c_fishbullheadcat_01_ms.png",
		}
	},

	["Bulrush_Seed"] = {
		label = "Bulrush Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow bulrushes.",
		client = {
			image = "Bulrush_Seed.png",
		}
	},

	["muskrats"] = {
		label = "Muskrat skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur skin of a muskrat, commonly used for crafting",
		client = {
			image = "muskrats.png",
		}
	},

	["legendsnakes"] = {
		label = "Legendary Boa pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and valuable pelt from a legendary boa",
		client = {
			image = "legendsnakes.png",
		}
	},

	["Prairie_Poppy_Seed"] = {
		label = "Prairie Poppy Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow prairie poppy flowers.",
		client = {
			image = "Prairie_Poppy_Seed.png",
		}
	},

	["mountainmen"] = {
		label = "Mountain Camp Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A set of equipment and supplies for a mountain camp",
		client = {
			image = "mountainmen.png",
		}
	},

	["legrams"] = {
		label = "Legendary Ram pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A distinctive pelt from a legendary ram",
		client = {
			image = "legrams.png",
		}
	},

	["wojape"] = {
		label = "Wojape",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional Native American sauce made from berries.",
		client = {
			image = "wojape.png",
		}
	},

	["acid"] = {
		label = "Acid",
		weight = 250,
		stack = true,
		close = true,
		description = "A corrosive substance used for various purposes.",
		client = {
			image = "acid.png",
		}
	},

	["provision_calderon_cross"] = {
		label = "Wooden Cross",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple wooden cross. Often used by preists and clergymen.",
		client = {
			image = "provision_calderon_cross.png",
		}
	},

	["mashamerican"] = {
		label = "Alaskan Gin Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A blend of ingredients used in the production of Alaskan gin",
		client = {
			image = "mashamerican.png",
		}
	},

	["cigarette"] = {
		label = "Cigarette",
		weight = 250,
		stack = true,
		close = true,
		description = "A cigarette for a quick smoke.",
		client = {
			image = "cigarette.png",
		}
	},

	["Milk_Weed_Seed"] = {
		label = "Milk Weed Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds of the milkweed plant for cultivation",
		client = {
			image = "Milk_Weed_Seed.png",
		}
	},

	["Milk_Weed"] = {
		label = "Milk Weed",
		weight = 250,
		stack = true,
		close = true,
		description = "A plant with milky sap used for medicinal purposes",
		client = {
			image = "Milk_Weed.png",
		}
	},

	["provision_ro_flower_dragons"] = {
		label = "Dragons Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "Dragons Mouth Orchids can be recognized by their wild purple flowers which are said to resemble a dragon. The general size of this type of orchid is around six inches.",
		client = {
			image = "provision_ro_flower_dragons.png",
		}
	},

	["consumable_bluegil"] = {
		label = "Dried Bluegil",
		weight = 250,
		stack = true,
		close = true,
		description = "A dried Bluegil fish.",
		client = {
			image = "consumable_bluegil.png",
		}
	},

	["TurtleShell"] = {
		label = "Turtle Shell",
		weight = 250,
		stack = true,
		close = true,
		description = "The shell of a turtle.",
		client = {
			image = "TurtleShell.png",
		}
	},

	["metal_gear"] = {
		label = "Metal gear",
		weight = 250,
		stack = true,
		close = true,
		description = "A metal gear used in many machines.",
		client = {
			image = "metal_gear.png",
		}
	},

	["kbirdb"] = {
		label = "Great Blue Heron Beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a Great Blue Heron, known for its long and slender shape.",
		client = {
			image = "kbirdb.png",
		}
	},

	["medic_satchel_batch"] = {
		label = "medic_satchel_batch",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "medic_satchel_batch.png",
		}
	},

	["mashstrong"] = {
		label = "Strong Mash Batch",
		weight = 250,
		stack = true,
		close = true,
		description = "A powerful and highly concentrated mash batch for advanced recipes",
		client = {
			image = "mashstrong.png",
		}
	},

	["mashraspberry"] = {
		label = "Raspberry Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of raspberries used for culinary purposes",
		client = {
			image = "mashraspberry.png",
		}
	},

	["bandage_2"] = {
		label = "Bandage",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical item used to dress wounds.",
		client = {
			image = "bandage_2.png",
		}
	},

	["scentg"] = {
		label = "Scent glad",
		weight = 250,
		stack = true,
		close = true,
		description = "Scented glad",
		client = {
			image = "scentg.png",
		}
	},

	["mashblackberry90p"] = {
		label = "Blackberry Mash 90p",
		weight = 250,
		stack = true,
		close = true,
		description = "A concentrated blackberry mash used for crafting high-quality beverages",
		client = {
			image = "mashblackberry90p.png",
		}
	},

	["elkantler"] = {
		label = "Elk antler",
		weight = 250,
		stack = true,
		close = true,
		description = "A large branched horn-like appendage grown by male elks.",
		client = {
			image = "elkantler.png",
		}
	},

	["mashblackberry"] = {
		label = "Blackberry Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of blackberries used in cooking and beverages",
		client = {
			image = "mashblackberry.png",
		}
	},

	["sparrow2_c"] = {
		label = "Golden Sparrow",
		weight = 250,
		stack = true,
		close = true,
		description = "A golden sparrow",
		client = {
			image = "sparrow2_c.png",
		}
	},

	["consumable_peppermint"] = {
		label = "Peppermint",
		weight = 250,
		stack = true,
		close = true,
		description = "Peppermint flavored candy.",
		client = {
			image = "consumable_peppermint.png",
		}
	},

	["marriagebook"] = {
		label = "Marriage Book",
		weight = 250,
		stack = false,
		close = true,
		description = "A book containing the guidelines and rituals for marriage",
		client = {
			image = "marriagebook.png",
		}
	},

	["bunkbed"] = {
		label = "bunk bed",
		weight = 250,
		stack = true,
		close = true,
		description = "A bed with two tiers, designed for multiple occupants.",
		client = {
			image = "bunkbed.png",
		}
	},

	["legpanthers2"] = {
		label = "Legendary Ghost Panther pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An ethereal pelt from a legendary Ghost Panther",
		client = {
			image = "legpanthers2.png",
		}
	},

	["provision_jewelry_grnet_post_earring"] = {
		label = "Harford Garnet Earrings",
		weight = 250,
		stack = true,
		close = true,
		description = "Clustered garnet studs with silver posts and scrolls.",
		client = {
			image = "provision_jewelry_grnet_post_earring.png",
		}
	},

	["provision_ro_flower_spider"] = {
		label = "Spider Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "The Spider Orchid is Characterised by five long spreading petals and sepals around a broad down-curled lip.",
		client = {
			image = "provision_ro_flower_spider.png",
		}
	},

	["lockpickmold"] = {
		label = "Lockpick Mold",
		weight = 250,
		stack = true,
		close = true,
		description = "A mold used for crafting lockpicks",
		client = {
			image = "lockpickmold.png",
		}
	},

	["cougartaxi"] = {
		label = "Cougar Taxidermy",
		weight = 250,
		stack = true,
		close = true,
		description = "A taxidermy mount of a cougar.",
		client = {
			image = "cougartaxi.png",
		}
	},

	["squirrel_red_c"] = {
		label = "Red Squirrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A Red squirrel",
		client = {
			image = "squirrel_red_c.png",
		}
	},

	["goldpan"] = {
		label = "Gold pan",
		weight = 250,
		stack = true,
		close = true,
		description = "A shallow pan used for gold panning.",
		client = {
			image = "goldpan.png",
		}
	},

	["antipoison2"] = {
		label = "Anti Snake Poison",
		weight = 250,
		stack = true,
		close = true,
		description = "A poison used to fend off snakes",
		client = {
			image = "antipoison2.png",
		}
	},

	["collector_fossil_sea_scorpion"] = {
		label = "Sea Scorpion Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon eurypterid fossil in good condition.",
		client = {
			image = "collector_fossil_sea_scorpion.png",
		}
	},

	["cockf"] = {
		label = "Rooster feather",
		weight = 250,
		stack = true,
		close = true,
		description = "Feathers from a rooster.",
		client = {
			image = "cockf.png",
		}
	},

	["legwolfs1"] = {
		label = "Legendary Emerald Wolf pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A vibrant pelt from a legendary Emerald Wolf",
		client = {
			image = "legwolfs1.png",
		}
	},

	["consumable_spongecake"] = {
		label = "Sponge Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A soft and delicious spong cake.",
		client = {
			image = "consumable_spongecake.png",
		}
	},

	["legcougars4"] = {
		label = "Legendary Black Cougar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare pelt from a legendary Black Cougar",
		client = {
			image = "legcougars4.png",
		}
	},

	["gleguans"] = {
		label = "Green Iguana pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a green iguana.",
		client = {
			image = "gleguans.png",
		}
	},

	["provision_arrowhead_slate"] = {
		label = "Slate Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A carefully made, well-preserved slate arrowhead.",
		client = {
			image = "provision_arrowhead_slate.png",
		}
	},

	["ginsengtea"] = {
		label = "Ginseng Tea",
		weight = 250,
		stack = true,
		close = true,
		description = "A soothing tea made from ginseng roots.",
		client = {
			image = "ginsengtea.png",
		}
	},

	["dleguans"] = {
		label = "Desert Iguana pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a Desert Iguana, commonly used for crafting and trading.",
		client = {
			image = "dleguans.png",
		}
	},

	["legrams2"] = {
		label = "Legendary Chalk Horn Ram pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exceptional pelt from a legendary Chalk Horn Ram",
		client = {
			image = "legrams2.png",
		}
	},

	["morphine"] = {
		label = "Morphine",
		weight = 250,
		stack = true,
		close = true,
		description = "A potent analgesic and narcotic medication",
		client = {
			image = "morphine.png",
		}
	},

	["bisons"] = {
		label = "Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt obtained from a bison.",
		client = {
			image = "bisons.png",
		}
	},

	["legpanthers3"] = {
		label = "Legendary Iwakta Panther pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and valuable pelt from a legendary Iwakta Panther",
		client = {
			image = "legpanthers3.png",
		}
	},

	["lumberaxe"] = {
		label = "Lumber Axe",
		weight = 250,
		stack = false,
		close = true,
		description = "A sturdy axe designed for cutting lumber",
		client = {
			image = "lumberaxe.png",
		}
	},

	["legmooses3"] = {
		label = "Legendary Rudy Moose pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A distinctive pelt from a legendary Rudy Moose",
		client = {
			image = "legmooses3.png",
		}
	},

	["hk_128"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_128.png",
		}
	},

	["legmooses1"] = {
		label = "Legendary Snowflake Moose pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pristine pelt from a legendary Snowflake Moose",
		client = {
			image = "legmooses1.png",
		}
	},

	["provision_arrowhead_splintered"] = {
		label = "Splintered Arrowhead",
		weight = 250,
		stack = true,
		close = true,
		description = "A partially damaged, jagged arrowhead made of chert.",
		client = {
			image = "provision_arrowhead_splintered.png",
		}
	},

	["quailb"] = {
		label = "Quail Beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a quail bird, often used for crafts and decorative purposes.",
		client = {
			image = "quailb.png",
		}
	},

	["kitchencounter"] = {
		label = "Kitchen Counter",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy counter surface typically found in kitchens, providing space for food preparation and other tasks.",
		client = {
			image = "kitchencounter.png",
		}
	},

	["bbirdb"] = {
		label = "Cormorant beak",
		weight = 250,
		stack = true,
		close = true,
		description = "Beak obtained from a cormorant bird.",
		client = {
			image = "bbirdb.png",
		}
	},

	["legbucks3"] = {
		label = "Legendary Snow Buck pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pristine pelt from a legendary Snow Buck",
		client = {
			image = "legbucks3.png",
		}
	},

	["banana"] = {
		label = "Banana",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious and nutritious tropical fruit.",
		client = {
			image = "banana.png",
		}
	},

	["hk_2"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A standard house key.",
		client = {
			image = "hk_2.png",
		}
	},

	["cloth_bench"] = {
		label = "Cloth Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made of cloth material.",
		client = {
			image = "cloth_bench.png",
		}
	},

	["legcoyotes"] = {
		label = "Legendary Coyote skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A prized skin from a legendary coyote",
		client = {
			image = "legcoyotes.png",
		}
	},

	["provision_ro_flower_night_scented"] = {
		label = "Night Scented Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "Night Scented Orchid can be identified by the alternate stems, the long sepals, and white petal flowers. This orchid can be found growing upon another plant, often draping down from trees.",
		client = {
			image = "provision_ro_flower_night_scented.png",
		}
	},

	["fishbait"] = {
		label = "Fishbait",
		weight = 250,
		stack = true,
		close = true,
		description = "A substance or lure used to attract fish, increasing the chances of a successful catch.",
		client = {
			image = "fishbait.png",
		}
	},

	["gbarrelx"] = {
		label = "Gun Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A part used in firearm manufacturing.",
		client = {
			image = "gbarrelx.png",
		}
	},

	["rams"] = {
		label = "Ram Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur and skin of a ram, known for its warmth and durability.",
		client = {
			image = "rams.png",
		}
	},

	["English_Mace"] = {
		label = "English Mace",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of spice commonly used in cooking and herbal medicine.",
		client = {
			image = "English_Mace.png",
		}
	},

	["hwood"] = {
		label = "Hard Wood",
		weight = 250,
		stack = true,
		close = true,
		description = "Durable and strong wood used in various applications.",
		client = {
			image = "hwood.png",
		}
	},

	["Choc_Daisy"] = {
		label = "Choc Daisy",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful Choc Daisy.",
		client = {
			image = "Choc_Daisy.png",
		}
	},

	["cooked_meat"] = {
		label = "cooked_meat",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "cooked_meat.png",
		}
	},

	["appleCrumbMash"] = {
		label = "Minty Berry Mash",
		weight = 250,
		stack = true,
		close = true,
		description = "A mashed mixture of mint and berries used for crafting Moonshine",
		client = {
			image = "appleCrumbMash.png",
		}
	},

	["consumable_grapejelly"] = {
		label = "Grape Jelly",
		weight = 250,
		stack = true,
		close = true,
		description = "Grape flavored jelly.",
		client = {
			image = "consumable_grapejelly.png",
		}
	},

	["hk_115"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_115.png",
		}
	},

	["grainmill"] = {
		label = "Grain Mill",
		weight = 250,
		stack = true,
		close = true,
		description = "A hand-held Grain Mill for grinding grain.",
		client = {
			image = "grainmill.png",
		}
	},

	["crablegs"] = {
		label = "Crab Legs",
		weight = 250,
		stack = true,
		close = true,
		description = "Legs from a crab.",
		client = {
			image = "crablegs.png",
		}
	},

	["dbcandle"] = {
		label = "Dbl Candle",
		weight = 250,
		stack = true,
		close = true,
		description = "A double-sided candle with two wicks.",
		client = {
			image = "dbcandle.png",
		}
	},

	["chickenf"] = {
		label = "Chicken feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a chicken.",
		client = {
			image = "chickenf.png",
		}
	},

	["hk_133"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_133.png",
		}
	},

	["boarmusk"] = {
		label = "Boar tusk",
		weight = 250,
		stack = true,
		close = true,
		description = "A large tusk obtained from a boar.",
		client = {
			image = "boarmusk.png",
		}
	},

	["revolverbarrel"] = {
		label = "Revolver Barrel",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement barrel for a revolver firearm, used for improving accuracy and performance.",
		client = {
			image = "revolverbarrel.png",
		}
	},

	["legaligators3"] = {
		label = "Legendary Banded Alligator pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Banded Alligator",
		client = {
			image = "legaligators3.png",
		}
	},

	["ammomolotov"] = {
		label = "Molotov Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "A glass bottle filled with flammable liquid, designed to burst into flames upon impact.",
		client = {
			image = "ammomolotov.png",
		}
	},

	["eaglet"] = {
		label = "Eagle claws",
		weight = 250,
		stack = true,
		close = true,
		description = "The sharp claws of an eagle, sometimes collected as a trophy or used in traditional medicine.",
		client = {
			image = "eaglet.png",
		}
	},

	["hop"] = {
		label = "Hop",
		weight = 250,
		stack = true,
		close = true,
		description = "A plant used in brewing beer.",
		client = {
			image = "hop.png",
		}
	},

	["handcuffkey"] = {
		label = "Handcuff Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A key used to unlock handcuffs.",
		client = {
			image = "handcuffkey.png",
		}
	},

	["hawkf"] = {
		label = "Hawk feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a hawk.",
		client = {
			image = "hawkf.png",
		}
	},

	["Golden_Currant"] = {
		label = "Golden Currant",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of golden-colored currant.",
		client = {
			image = "Golden_Currant.png",
		}
	},

	["legbears3"] = {
		label = "Legendary Ridgeback Spirit Bear pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Ridgeback Spirit Bear",
		client = {
			image = "legbears3.png",
		}
	},

	["pen"] = {
		label = "Pen",
		weight = 250,
		stack = true,
		close = true,
		description = "A writing instrument used to apply ink.",
		client = {
			image = "pen.png",
		}
	},

	["tealeaf"] = {
		label = "Tealeaf",
		weight = 250,
		stack = true,
		close = true,
		description = "Used to make tea or teabags.",
		client = {
			image = "tealeaf.png",
		}
	},

	["hk_123"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_123.png",
		}
	},

	["eaglef"] = {
		label = "Eagle feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from an eagle, often used for decorative purposes and in crafting.",
		client = {
			image = "eaglef.png",
		}
	},

	["salve_trail_double"] = {
		label = "salve_trail_double",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "salve_trail_double.png",
		}
	},

	["campfire"] = {
		label = "Campfire",
		weight = 250,
		stack = true,
		close = true,
		description = "A fire pit used for cooking and warmth during camping.",
		client = {
			image = "campfire.png",
		}
	},

	["beef"] = {
		label = "Beef",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh and tender beef meat.",
		client = {
			image = "beef.png",
		}
	},

	["floursack"] = {
		label = "Flour Sack",
		weight = 250,
		stack = true,
		close = true,
		description = "A sack of flour.",
		client = {
			image = "floursack.png",
		}
	},

	["fertilizersyn"] = {
		label = "Synful Fertilizer",
		weight = 250,
		stack = true,
		close = true,
		description = "A potent and forbidden fertilizer concocted from mystical ingredients, known to produce extraordinary growth in plants.",
		client = {
			image = "fertilizersyn.png",
		}
	},

	["cardinal_c"] = {
		label = "Cardinal bird",
		weight = 250,
		stack = true,
		close = true,
		description = "A small, colorful bird known for its distinctive crest.",
		client = {
			image = "cardinal_c.png",
		}
	},

	["butchertable1"] = {
		label = "Small Butcher Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A small table used for butchering animals.",
		client = {
			image = "butchertable1.png",
		}
	},

	["legwolfs3"] = {
		label = "Legendary Moonstone Wolf pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A magnificent pelt from a legendary Moonstone Wolf",
		client = {
			image = "legwolfs3.png",
		}
	},

	["English_Mace_Seed"] = {
		label = "English Mace Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds that can be planted to grow English Mace plants.",
		client = {
			image = "English_Mace_Seed.png",
		}
	},

	["apple"] = {
		label = "Apple",
		weight = 250,
		stack = true,
		close = true,
		description = "A juicy and delicious fruit",
		client = {
			image = "apple.png",
		}
	},

	["goathead"] = {
		label = "Goat head",
		weight = 250,
		stack = true,
		close = true,
		description = "The severed head of a goat.",
		client = {
			image = "goathead.png",
		}
	},

	["friedtater"] = {
		label = "Fried Taters",
		weight = 250,
		stack = true,
		close = true,
		description = "Crispy and delicious fried potatoes.",
		client = {
			image = "friedtater.png",
		}
	},

	["Gator_Egg_5"] = {
		label = "Aligator Egg 5",
		weight = 250,
		stack = true,
		close = true,
		description = "The final stage of an alligator egg.",
		client = {
			image = "Gator_Egg_5.png",
		}
	},

	["provision_ro_flower_lady_slipper"] = {
		label = "Lady Slipper Orchid",
		weight = 250,
		stack = true,
		close = true,
		description = "Lady Slipper Orchid can be identified by the large bulbous purple flower and speckled purple leaves. This type of orchid can be seen growing in the ground of forests, meadows and woodland areas.",
		client = {
			image = "provision_ro_flower_lady_slipper.png",
		}
	},

	["ammotomahawk"] = {
		label = "Tomahawk Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammo used for Tomahawk throwing weapons",
		client = {
			image = "ammotomahawk.png",
		}
	},

	["bait"] = {
		label = "Bait",
		weight = 250,
		stack = true,
		close = true,
		description = "Used as bait to attract fish while fishing.",
		client = {
			image = "bait.png",
		}
	},

	["tent3"] = {
		label = "Simple Tent",
		weight = 250,
		stack = true,
		close = true,
		description = "A basic tent for camping.",
		client = {
			image = "tent3.png",
		}
	},

	["Black_Berry_Seed"] = {
		label = "Black Berry Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow blackberries.",
		client = {
			image = "Black_Berry_Seed.png",
		}
	},

	["woodpeck02_c"] = {
		label = "Woodpecker 2",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin and feathers of a woodpecker.",
		client = {
			image = "woodpeck02_c.png",
		}
	},

	["beawers"] = {
		label = "Beaver pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A pelt obtained from a beaver.",
		client = {
			image = "beawers.png",
		}
	},

	["ironhammer"] = {
		label = "Iron Hammer",
		weight = 250,
		stack = true,
		close = true,
		description = "A hammer with a head made of iron, used for various construction and crafting purposes.",
		client = {
			image = "ironhammer.png",
		}
	},

	["provision_disco_shrunken_head"] = {
		label = "Shrunken Head",
		weight = 250,
		stack = true,
		close = true,
		description = "A shurken head. possibly used in vodoo.",
		client = {
			image = "provision_disco_shrunken_head.png",
		}
	},

	["collector_fossil_bivalve"] = {
		label = "Bivalve Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common fossilized mollusc, badly worn.",
		client = {
			image = "collector_fossil_bivalve.png",
		}
	},

	["cleanser"] = {
		label = "Cleanser",
		weight = 250,
		stack = true,
		close = true,
		description = "A cleanser for various uses.",
		client = {
			image = "cleanser.png",
		}
	},

	["applebasket"] = {
		label = "Apple Basket",
		weight = 250,
		stack = true,
		close = true,
		description = "A basket filled with fresh apples",
		client = {
			image = "applebasket.png",
		}
	},

	["provision_jewelry_porcelain_necklace"] = {
		label = "Braxton Amethyst Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A fashionable necklace with a porcelain hand painted miniature.",
		client = {
			image = "provision_jewelry_porcelain_necklace.png",
		}
	},

	["egretf"] = {
		label = "Snowy Egret feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A feather obtained from a Snowy Egret, often used for decorative purposes and in crafting.",
		client = {
			image = "egretf.png",
		}
	},

	["collector_fossil_tully_monster"] = {
		label = "Tully Monster Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "An uncommon Tullimonstrum fossil, nicely preserved.",
		client = {
			image = "collector_fossil_tully_monster.png",
		}
	},

	["appleCrumbMoonshine"] = {
		label = "Minty Berry Moonshine",
		weight = 250,
		stack = true,
		close = true,
		description = "A strong alcoholic beverage made from mint and berries",
		client = {
			image = "appleCrumbMoonshine.png",
		}
	},

	["cockc"] = {
		label = "Rooster claws",
		weight = 250,
		stack = true,
		close = true,
		description = "Claws from a rooster.",
		client = {
			image = "cockc.png",
		}
	},

	["legaligators1"] = {
		label = "Legendary Teca Alligator pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A legendary pelt from a Teca Alligator",
		client = {
			image = "legaligators1.png",
		}
	},

	["Cardinal_Flower_Seed"] = {
		label = "Cardinal Flower Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow Cardinal Flowers.",
		client = {
			image = "Cardinal_Flower_Seed.png",
		}
	},

	["ammodynamite"] = {
		label = "Dynamite Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "An explosive device with a short fuse, capable of causing significant damage.",
		client = {
			image = "ammodynamite.png",
		}
	},

	["coffindecor"] = {
		label = "Coffin Decor",
		weight = 250,
		stack = true,
		close = true,
		description = "Decorations for a coffin.",
		client = {
			image = "coffindecor.png",
		}
	},

	["chewingtobacco"] = {
		label = "Chewing Tobacco",
		weight = 250,
		stack = true,
		close = true,
		description = "A form of tobacco that is chewed rather than smoked.",
		client = {
			image = "chewingtobacco.png",
		}
	},

	["legfoxs2"] = {
		label = "Legendary Marble Fox pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A beautiful pelt from a legendary Marble Fox",
		client = {
			image = "legfoxs2.png",
		}
	},

	["boaskin"] = {
		label = "Boa Snake pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A snake skin obtained from a boa.",
		client = {
			image = "boaskin.png",
		}
	},

	["fertilizersw"] = {
		label = "Fertilizer with Soft Wood",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer blended with fine particles of softwood, enriching the soil with organic matter and enhancing plant development.",
		client = {
			image = "fertilizersw.png",
		}
	},

	["provision_jewelry_turquoise_bracelet"] = {
		label = "Infanta Turquoise Bracelet",
		weight = 250,
		stack = true,
		close = true,
		description = "A solid silver bracelet with a large turquoise stone.",
		client = {
			image = "provision_jewelry_turquoise_bracelet.png",
		}
	},

	["ammoknives"] = {
		label = "Knives Ammo",
		weight = 250,
		stack = true,
		close = true,
		description = "Ammunition for a throwing knife, used as a versatile and silent weapon.",
		client = {
			image = "ammoknives.png",
		}
	},

	["legboars1"] = {
		label = "Legendary Cogi Boar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A magnificent pelt from a legendary Cogi Boar",
		client = {
			image = "legboars1.png",
		}
	},

	["consumable_peachcobbler"] = {
		label = "Peach Cobbler",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty peach cobbler.",
		client = {
			image = "consumable_peachcobbler.png",
		}
	},

	["tequila"] = {
		label = "Tequila",
		weight = 250,
		stack = true,
		close = true,
		description = "A bottle of tequila.",
		client = {
			image = "tequila.png",
		}
	},

	["nitroglyserolia"] = {
		label = "Nitroglycerol",
		weight = 250,
		stack = true,
		close = true,
		description = "A highly explosive liquid compound used in explosives",
		client = {
			image = "nitroglyserolia.png",
		}
	},

	["sap"] = {
		label = "Sap",
		weight = 250,
		stack = true,
		close = true,
		description = "Sticky sap",
		client = {
			image = "sap.png",
		}
	},

	["heroin"] = {
		label = "Heroin",
		weight = 250,
		stack = true,
		close = true,
		description = "A highly addictive and illegal drug.",
		client = {
			image = "heroin.png",
		}
	},

	["consumable_steakpie"] = {
		label = "Steak Pie",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious pie made with beef.",
		client = {
			image = "consumable_steakpie.png",
		}
	},

	["char"] = {
		label = "Char",
		weight = 250,
		stack = true,
		close = true,
		description = "A type of fish commonly found in cold, deep lakes and rivers.",
		client = {
			image = "char.png",
		}
	},

	["badgers"] = {
		label = "Badger skin",
		weight = 250,
		stack = true,
		close = true,
		description = "Skin obtained from a badger.",
		client = {
			image = "badgers.png",
		}
	},

	["consumable_peach"] = {
		label = "Peach",
		weight = 250,
		stack = true,
		close = true,
		description = "Juicy and ripe peach.",
		client = {
			image = "consumable_peach.png",
		}
	},

	["axe"] = {
		label = "axe",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "axe.png",
		}
	},

	["boiledegg"] = {
		label = "Boiled Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "An egg cooked by boiling.",
		client = {
			image = "boiledegg.png",
		}
	},

	["iron"] = {
		label = "Iron",
		weight = 250,
		stack = true,
		close = true,
		description = "A strong and durable metal.",
		client = {
			image = "iron.png",
		}
	},

	["oxhorn"] = {
		label = "Angus Bull horn",
		weight = 250,
		stack = true,
		close = true,
		description = "A sturdy horn from an Angus Bull.",
		client = {
			image = "oxhorn.png",
		}
	},

	["bandage"] = {
		label = "Bandage",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical item used to dress wounds.",
		client = {
			image = "bandage.png",
		}
	},

	["crawfish_c"] = {
		label = "Crawfish",
		weight = 250,
		stack = true,
		close = true,
		description = "A small freshwater crustacean.",
		client = {
			image = "crawfish_c.png",
		}
	},

	["salamelle"] = {
		label = "Fresh Pork ",
		weight = 250,
		stack = true,
		close = true,
		description = "Fresh pork salamelle",
		client = {
			image = "salamelle.png",
		}
	},

	["coffeefilter"] = {
		label = "Coffee Filter",
		weight = 250,
		stack = true,
		close = true,
		description = "A simple coffee filter.",
		client = {
			image = "coffeefilter.png",
		}
	},

	["wickerbench"] = {
		label = "Wicker Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench made from wicker material.",
		client = {
			image = "wickerbench.png",
		}
	},

	["Crows_Garlic"] = {
		label = "Crows Garlic",
		weight = 250,
		stack = true,
		close = true,
		description = "A pungent garlic with black bulbs.",
		client = {
			image = "Crows_Garlic.png",
		}
	},

	["fertilizersn"] = {
		label = "Fertilizer with Snake",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer enriched with beneficial nutrients extracted from snakes, promoting vigorous growth in plants.",
		client = {
			image = "fertilizersn.png",
		}
	},

	["decortent2"] = {
		label = "Decor Tent 2 Set",
		weight = 250,
		stack = true,
		close = true,
		description = "A decorative tent set with unique patterns.",
		client = {
			image = "decortent2.png",
		}
	},

	["legprongs"] = {
		label = "Legendary Pronghorn skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A sleek and coveted skin from a legendary pronghorn",
		client = {
			image = "legprongs.png",
		}
	},

	["raw_silver"] = {
		label = "raw_silver",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "raw_silver.png",
		}
	},

	["consumable_lemoncake"] = {
		label = "Lemon Cake",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious lemon cake",
		client = {
			image = "consumable_lemoncake.png",
		}
	},

	["fertilizerpro"] = {
		label = "Fertilizer with Produce",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer containing organic matter from fresh produce, enhancing soil fertility and plant health.",
		client = {
			image = "fertilizerpro.png",
		}
	},

	["aligators"] = {
		label = "Alligator Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of an alligator, commonly used for crafting and trading.",
		client = {
			image = "aligators.png",
		}
	},

	["consumable_herb_vanilla_flower"] = {
		label = "Vanilla Flower",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate vanilla flower.",
		client = {
			image = "consumable_herb_vanilla_flower.png",
		}
	},

	["collector_fossil_brow_horn"] = {
		label = "Brow Horn Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare fossilized brow horn, believed to have belonged to a Triceratops.",
		client = {
			image = "collector_fossil_brow_horn.png",
		}
	},

	["Drink_For_Dog"] = {
		label = "Pet Water",
		weight = 250,
		stack = true,
		close = true,
		description = "A refreshing drink specially made for pets to keep them hydrated.",
		client = {
			image = "Drink_For_Dog.png",
		}
	},

	["marriagecertification"] = {
		label = "Marriage Certify",
		weight = 250,
		stack = true,
		close = true,
		description = "A legal document certifying a marriage",
		client = {
			image = "marriagecertification.png",
		}
	},

	["Bay_Bolete"] = {
		label = "Bay Bolete",
		weight = 250,
		stack = true,
		close = true,
		description = "An edible mushroom with a brown cap and yellow pores.",
		client = {
			image = "Bay_Bolete.png",
		}
	},

	["Black_Currant"] = {
		label = "Black Currant",
		weight = 250,
		stack = true,
		close = true,
		description = "A small dark purple berry with a tart flavor.",
		client = {
			image = "Black_Currant.png",
		}
	},

	["peasantb"] = {
		label = "Peasant beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a peasant bird.",
		client = {
			image = "peasantb.png",
		}
	},

	["fsnakes"] = {
		label = "Blacktail rattlesnake pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a blacktail rattlesnake.",
		client = {
			image = "fsnakes.png",
		}
	},

	["clay"] = {
		label = "Clay",
		weight = 250,
		stack = true,
		close = true,
		description = "A block of clay for crafting.",
		client = {
			image = "clay.png",
		}
	},

	["obed"] = {
		label = "Old bed",
		weight = 250,
		stack = true,
		close = true,
		description = "An old bed that has seen better days.",
		client = {
			image = "obed.png",
		}
	},

	["gooseb"] = {
		label = "Goose beak",
		weight = 250,
		stack = true,
		close = true,
		description = "The beak of a goose.",
		client = {
			image = "gooseb.png",
		}
	},

	["bearc"] = {
		label = "Bear claws",
		weight = 250,
		stack = true,
		close = true,
		description = "Sharp claws obtained from a bear.",
		client = {
			image = "bearc.png",
		}
	},

	["Burdock_Root_Seed"] = {
		label = "Burdock Root Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow burdock roots.",
		client = {
			image = "Burdock_Root_Seed.png",
		}
	},

	["eggs"] = {
		label = "Egg",
		weight = 250,
		stack = true,
		close = true,
		description = "Various types of eggs collected from different animals, often used in cooking and crafting.",
		client = {
			image = "eggs.png",
		}
	},

	["cocoaseeds"] = {
		label = "Cocoa Seeds",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds to grow cocoa plants.",
		client = {
			image = "cocoaseeds.png",
		}
	},

	["hk_116"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_116.png",
		}
	},

	["legcougars"] = {
		label = "Legendary Cougar skin",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare and valuable skin from a legendary cougar",
		client = {
			image = "legcougars.png",
		}
	},

	["legboars3"] = {
		label = "Legendary Icahi Boar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare pelt from a legendary Icahi Boar",
		client = {
			image = "legboars3.png",
		}
	},

	["dreamcatcher"] = {
		label = "Dream Catcher",
		weight = 250,
		stack = true,
		close = true,
		description = "A traditional Native American ornament believed to filter out bad dreams and let only good dreams pass through.",
		client = {
			image = "dreamcatcher.png",
		}
	},

	["provision_jewelry_blck_pearl_necklace"] = {
		label = "Tuamotu Pearl Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A silk strung necklace of magnificent black Tahitian pearls.",
		client = {
			image = "provision_jewelry_blck_pearl_necklace.png",
		}
	},

	["pearl"] = {
		label = "Pearl",
		weight = 250,
		stack = true,
		close = true,
		description = "A hard, glistening object produced within the soft tissue of a living shelled mollusk.",
		client = {
			image = "pearl.png",
		}
	},

	["brokenpearlnecklace"] = {
		label = "Broken Pearl Necklace",
		weight = 250,
		stack = true,
		close = true,
		description = "A broken pearl necklace.",
		client = {
			image = "brokenpearlnecklace.png",
		}
	},

	["provision_jewelry_coral_ring"] = {
		label = "Harland Coral Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicate gold ring featuring a large angel skin coral.",
		client = {
			image = "provision_jewelry_coral_ring.png",
		}
	},

	["gbears"] = {
		label = "Grizzly Bear skin",
		weight = 250,
		stack = true,
		close = true,
		description = "The skin of a grizzly bear.",
		client = {
			image = "gbears.png",
		}
	},

	["deerheart"] = {
		label = "Deer heart",
		weight = 250,
		stack = true,
		close = true,
		description = "The heart of a deer.",
		client = {
			image = "deerheart.png",
		}
	},

	["Feather"] = {
		label = "Feather",
		weight = 250,
		stack = true,
		close = true,
		description = "A lightweight and delicate feather, often used for decorative purposes.",
		client = {
			image = "Feather.png",
		}
	},

	["provision_jewelry_pers_turq_ring"] = {
		label = "Thorburn Turquoise Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicately crafted rose gold ring with turquoise beads.",
		client = {
			image = "provision_jewelry_pers_turq_ring.png",
		}
	},

	["goldring"] = {
		label = "Gold Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A ring made of solid gold.",
		client = {
			image = "goldring.png",
		}
	},

	["ravenc"] = {
		label = "Raven Claws",
		weight = 250,
		stack = true,
		close = true,
		description = "The claws of a raven bird, often used for crafts and jewelry.",
		client = {
			image = "ravenc.png",
		}
	},

	["butchertable2"] = {
		label = "Medium Butcher Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized table used for butchering animals.",
		client = {
			image = "butchertable2.png",
		}
	},

	["wooden_bench"] = {
		label = "Wooden Bench",
		weight = 250,
		stack = true,
		close = true,
		description = "A bench constructed with wooden material.",
		client = {
			image = "wooden_bench.png",
		}
	},

	["crow_c"] = {
		label = "Crow",
		weight = 250,
		stack = true,
		close = true,
		description = "A black-feathered bird with a sharp beak.",
		client = {
			image = "crow_c.png",
		}
	},

	["Hummingbird_Sage_Seed"] = {
		label = "Hummingbird Sage Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow hummingbird sage.",
		client = {
			image = "Hummingbird_Sage_Seed.png",
		}
	},

	["crabbutter"] = {
		label = "Crab Butter",
		weight = 250,
		stack = true,
		close = true,
		description = "Butter made from crab. Delicious on toast.",
		client = {
			image = "crabbutter.png",
		}
	},

	["consumable_game"] = {
		label = "Jerkied GameMeat",
		weight = 250,
		stack = true,
		close = true,
		description = "Dried and seasoned game meat.",
		client = {
			image = "consumable_game.png",
		}
	},

	["kit_bandana"] = {
		label = "Bandana",
		weight = 250,
		stack = true,
		close = true,
		description = "A versatile and stylish piece of cloth that can be worn around the neck or head for various purposes. It adds a touch of fashion to any outfit.",
		client = {
			image = "kit_bandana.png",
		}
	},

	["legelkantler"] = {
		label = "Legendary Elk Antlers",
		weight = 250,
		stack = true,
		close = true,
		description = "A magnificent set of antlers from a legendary elk",
		client = {
			image = "legelkantler.png",
		}
	},

	["fertilizeregg"] = {
		label = "Fertilizer with Eggs",
		weight = 250,
		stack = true,
		close = true,
		description = "Fertilizer enriched with nutrients from various eggs, providing excellent nourishment for plants.",
		client = {
			image = "fertilizeregg.png",
		}
	},

	["a_c_fishrockbass_01_ms"] = {
		label = "Medium Rockbass",
		weight = 250,
		stack = true,
		close = true,
		description = "A medium-sized Rockbass fish.",
		client = {
			image = "a_c_fishrockbass_01_ms.png",
		}
	},

	["hk_104"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_104.png",
		}
	},

	["hk_112"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_112.png",
		}
	},

	["p_finisdfishlurelegendary01x"] = {
		label = "Legendary Fish Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A premium fish lure designed to catch elusive legendary fish.",
		client = {
			image = "p_finisdfishlurelegendary01x.png",
		}
	},

	["biggame"] = {
		label = "Big Game Meat",
		weight = 250,
		stack = true,
		close = true,
		description = "Meat obtained from a large game animal.",
		client = {
			image = "biggame.png",
		}
	},

	["leather"] = {
		label = "Leather",
		weight = 250,
		stack = true,
		close = true,
		description = "Leather material",
		client = {
			image = "leather.png",
		}
	},

	["hk_125"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_125.png",
		}
	},

	["hk_122"] = {
		label = "House Key",
		weight = 250,
		stack = false,
		close = true,
		description = "A specialized house key.",
		client = {
			image = "hk_122.png",
		}
	},

	["provision_jewelry_french_dmnd_ring"] = {
		label = "Beaulieux Diamond Ring",
		weight = 250,
		stack = true,
		close = true,
		description = "A number of old mine cut diamonds claw set in a silver ring from France.",
		client = {
			image = "provision_jewelry_french_dmnd_ring.png",
		}
	},

	["cows"] = {
		label = "Cow pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The soft and furry pelt of a cow.",
		client = {
			image = "cows.png",
		}
	},

	["consumable_lemondrops"] = {
		label = "Leamon Drops",
		weight = 250,
		stack = true,
		close = true,
		description = "Lemon flavored candy.",
		client = {
			image = "consumable_lemondrops.png",
		}
	},

	["collector_fossil_tooth_mega"] = {
		label = "Upper Tooth Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A rare fossilized tooth from a Megalodon.",
		client = {
			image = "collector_fossil_tooth_mega.png",
		}
	},

	["consumable_chocolate"] = {
		label = "Chocolate Bar",
		weight = 250,
		stack = true,
		close = true,
		description = "A delicious chocolate bar.",
		client = {
			image = "consumable_chocolate.png",
		}
	},

	["coyotepelt"] = {
		label = "Coyote Pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "The fur pelt of a coyote.",
		client = {
			image = "coyotepelt.png",
		}
	},

	["collector_fossil_neo"] = {
		label = "Neospirifer Fossil",
		weight = 250,
		stack = true,
		close = true,
		description = "A common Neospirifer fossil, millions of years old. Good condition.",
		client = {
			image = "collector_fossil_neo.png",
		}
	},

	["Evergreen_Huckleberry_Seed"] = {
		label = "Evergreen Huckleberry Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "Seeds that can be planted to grow Evergreen Huckleberry bushes.",
		client = {
			image = "Evergreen_Huckleberry_Seed.png",
		}
	},

	["Desert_Sage"] = {
		label = "Desert Sage",
		weight = 250,
		stack = true,
		close = true,
		description = "A bundle of Desert Sage used for crafting and medicinal purposes.",
		client = {
			image = "Desert_Sage.png",
		}
	},

	["potatoseed"] = {
		label = "Potato Seed",
		weight = 250,
		stack = true,
		close = true,
		description = "A seed that can be planted to grow potato plants.",
		client = {
			image = "potatoseed.png",
		}
	},

	["coal"] = {
		label = "Coal",
		weight = 250,
		stack = true,
		close = true,
		description = "A chunk of coal for fuel.",
		client = {
			image = "coal.png",
		}
	},

	["legbisons1"] = {
		label = "Legendary Tatanka Bison pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An exquisite pelt from a legendary Tatanka Bison",
		client = {
			image = "legbisons1.png",
		}
	},

	["mackerel"] = {
		label = "Mackerel",
		weight = 250,
		stack = true,
		close = true,
		description = "A small and silvery fish called mackerel",
		client = {
			image = "mackerel.png",
		}
	},

	["p_finishedragonfly01x"] = {
		label = "Dragonfly Lure",
		weight = 250,
		stack = true,
		close = true,
		description = "A realistic dragonfly lure designed to mimic flying insects, perfect for catching surface-feeding fish.",
		client = {
			image = "p_finishedragonfly01x.png",
		}
	},

	["revolverhandle"] = {
		label = "Revolver Handle",
		weight = 250,
		stack = true,
		close = true,
		description = "A replacement handle for a revolver firearm, providing grip and control.",
		client = {
			image = "revolverhandle.png",
		}
	},

	["legboars2"] = {
		label = "Legendary Wakpa Boar pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "A formidable pelt from a legendary Wakpa Boar",
		client = {
			image = "legboars2.png",
		}
	},

	["cheesecake"] = {
		label = "Cheesecake",
		weight = 250,
		stack = true,
		close = true,
		description = "A tasty cheesecake.",
		client = {
			image = "cheesecake.png",
		}
	},

	["venison"] = {
		label = "Venison",
		weight = 250,
		stack = true,
		close = true,
		description = "Lean meat obtained from deer.",
		client = {
			image = "venison.png",
		}
	},

	["biscuitbox"] = {
		label = "Biscuitbox",
		weight = 250,
		stack = true,
		close = true,
		description = "A box of assorted biscuits.",
		client = {
			image = "biscuitbox.png",
		}
	},

	["legelks"] = {
		label = "Legendary Elk pelt",
		weight = 250,
		stack = true,
		close = true,
		description = "An impressive pelt from a legendary elk",
		client = {
			image = "legelks.png",
		}
	},

	-- ════════════════════════════════════════════════════════════════════
	-- ═══ The HUD consumables - what was missing of them ═══
	--
	-- * w_hud/shared/consumables.lua grants the effect (hunger and thirst and cores and poisoning),
	--   and this file grants the existence. And the contract between them: **what is mentioned there must exist
	--   here**, otherwise it is a line registering an item nobody owns.
	--
	--   And the other seven of the six pairs are already in the file, so they were not repeated:
	--   cooked_meat · water · herbal_tonic · tonic_bitters ·
	--   consumable_horsepeppermints · whisky · absinthe
	-- ════════════════════════════════════════════════════════════════════

	-- ── The horse boost ───────────────────────────────────────────────
	-- ! It is used near the horse: the care system in w_hud requires the distance
	--   (Config.HorseCare.MaxDistance) and says 'get close to your horse first' if it is far.
	["horse_reviver"] = {
		label = "منشّط الخيل",
		weight = 100,
		stack = true,
		close = true,
		description = "جرعةٌ تُعيد إلى الحصان أنفاسه بعد ركضٍ طويل.",
		prop = "p_bottleblack01x",
		client = {
			image = "horse_reviver.png",
		}
	},

	-- ── The poisoning ──────────────────────────────────────────────────
	-- * The description says what the two of them do, so they are not eaten by mistake. And the antidote is a herb infusion.
	["rotten_meat"] = {
		label = "لحمٌ فاسد",
		weight = 250,
		stack = true,
		close = true,
		description = "لحمٌ خضّره العفن وفاحت منه رائحة. أكلُه تسمُّم.",
		client = {
			image = "rotten_meat.png",
		}
	},

	["oleander_sage"] = {
		label = "مريميّة الدفلى",
		weight = 1,
		stack = true,
		close = true,
		description = "زهرةٌ صفراء سامّة. لا تُؤكل — تُصنع منها السموم.",
		client = {
			image = "oleander_sage.png",
		}
	},

	-- ── The stimulants ────────────────────────────────────────────────
	["morphine_shot"] = {
		label = "حقنة مورفين",
		weight = 250,
		-- ! They do not stack: one syringe in the slot, so the player does not carry ten in one place.
		stack = false,
		close = true,
		description = "حقنةٌ تُذهب الألم وتُنسي التعب — أثرها قويٌّ وقصير.",
		client = {
			image = "morphine_shot.png",
		}
	},

	["painkiller"] = {
		label = "مسكّن ألم",
		weight = 250,
		stack = false,
		close = true,
		description = "حبوبٌ تُخفّف الوجع وتُبقيك على قدميك.",
		client = {
			image = "painkiller.png",
		}
	},


	["OutfitMen144"] = {
		label = "بدلة رجالية 144",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen144.png",
		}
	},

	["womenoutfit141"] = {
		label = "زي نسائي 141",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit141.png",
		}
	},

	["womenoutfit453"] = {
		label = "زي نسائي 453",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit453.png",
		}
	},

	["womenoutfit497"] = {
		label = "زي نسائي 497",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit497.png",
		}
	},

	["WomenHats190"] = {
		label = "قبعة نسائية 190",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats190.png",
		}
	},

	["womenoutfit288"] = {
		label = "زي نسائي 288",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit288.png",
		}
	},

	["womenoutfit774"] = {
		label = "زي نسائي 774",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit774.png",
		}
	},

	["consumable_cheesecake"] = {
		label = "تشيز كيك",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cheesecake.png",
		}
	},

	["poisonplant"] = {
		label = "نبات سام",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "poisonplant.png",
		}
	},

	["snakes_d"] = {
		label = "ثعبان (d)",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان من النوع d، يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "snakes_d.png",
		}
	},

	["OutfitMen188"] = {
		label = "بدلة رجالية 188",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen188.png",
		}
	},

	["womenoutfit823"] = {
		label = "زي نسائي 823",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit823.png",
		}
	},

	["sary_gold"] = {
		label = "ذهب ساري",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sary_gold.png",
		}
	},

	["menoutfit115"] = {
		label = "ملابس الرجال 115",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit115.png",
		}
	},

	["bluepearl"] = {
		label = "لؤلؤة زرقاء",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع اللؤلؤة الزرقاء بأسعار مرتفعة.",
		client = {
			image = "bluepearl.png",
		}
	},

	["resource_bag_nitrite"] = {
		label = "كيس نترات ",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس نترات ",
		client = {
			image = "resource_bag_nitrite.png",
		}
	},

	["MenOutfits009"] = {
		label = "زي رجالي 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits009.png",
		}
	},

	["womenoutfit674"] = {
		label = "زي نسائي 674",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit674.png",
		}
	},

	["womenoutfit274"] = {
		label = "زي نسائي 274",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit274.png",
		}
	},

	["menoutfit108"] = {
		label = "ملابس الرجال 108",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit108.png",
		}
	},

	["chicken_stew"] = {
		label = "يخنة الدجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "يخنة الدجاج",
		client = {
			image = "chicken_stew.png",
		}
	},

	["OutfitMen141"] = {
		label = "بدلة رجالية 141",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen141.png",
		}
	},

	["consumable_herb_english_mace"] = {
		label = "عشبة الميس الإنجليزية",
		weight = 250,
		stack = true,
		close = true,
		description = "نبتة الميس الإنجليزية.",
		client = {
			image = "consumable_herb_english_mace.png",
		}
	},

	["a_c_fishsalmonsockeye_01_lg"] = {
		label = "سمك السلمون المرقط",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك السلمون المرقط",
		client = {
			image = "a_c_fishsalmonsockeye_01_lg.png",
		}
	},

	["pipepeace2"] = {
		label = "غليون السلام 2",
		weight = 250,
		stack = true,
		close = true,
		description = "غليون السلام 2",
		client = {
			image = "pipepeace2.png",
		}
	},

	["menoutfit54"] = {
		label = "ملابس الرجال 54",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit54.png",
		}
	},

	["resource_pelt_coyote_star_2"] = {
		label = "فراء ذئب البراري 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_coyote_star_2.png",
		}
	},

	["menoutfit111"] = {
		label = "ملابس الرجال 111",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit111.png",
		}
	},

	["s_inv_cigcard_plt_07x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #07",
		client = {
			image = "s_inv_cigcard_plt_07x.png",
		}
	},

	["satchels"] = {
		label = "حقائب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "satchels.png",
		}
	},

	["provision_trinket_badger_claw"] = {
		label = "تعويذة مخلب الغرير",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من مخلب غرير.",
		client = {
			image = "provision_trinket_badger_claw.png",
		}
	},

	["MenOutfits027"] = {
		label = "زي رجالي 027",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits027.png",
		}
	},

	["policeBWhatFemale"] = {
		label = "زي شرطة للنساء",
		weight = 250,
		stack = false,
		close = true,
		description = "زي خاص بشرطة النساء.",
		client = {
			image = "policeBWhatFemale.png",
		}
	},

	["womenoutfit599"] = {
		label = "زي نسائي 599",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit599.png",
		}
	},

	["consumable_vodka"] = {
		label = "فودكا",
		weight = 250,
		stack = true,
		close = true,
		description = "فودكا",
		client = {
			image = "consumable_vodka.png",
		}
	},

	["womenoutfit452"] = {
		label = "زي نسائي 452",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit452.png",
		}
	},

	["moonshinetable"] = {
		label = "Moonshine Distiller Machine",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshinetable.png",
		}
	},

	["WomenGloves017"] = {
		label = "قفازات نسائية 017",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves017.png",
		}
	},

	["lumber_cedar_wood_plank"] = {
		label = "لوح خشب الأرز",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح خشب الأرز",
		client = {
			image = "lumber_cedar_wood_plank.png",
		}
	},

	["animal_snakeredboa"] = {
		label = "أفعى بوا حمراء",
		weight = 250,
		stack = true,
		close = true,
		description = "أفعى بوا حمراء.",
		client = {
			image = "animal_snakeredboa.png",
		}
	},

	["womenoutfit329"] = {
		label = "زي نسائي 329",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit329.png",
		}
	},

	["OutfitMen024"] = {
		label = "بدلة رجالية 024",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen024.png",
		}
	},

	["marijuana_joint3_3"] = {
		label = "لفافة ماريجوانا 3-3",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-3",
		client = {
			image = "marijuana_joint3_3.png",
		}
	},

	["WomenOutfits48"] = {
		label = "زي نسائي 48",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits48.png",
		}
	},

	["WomenBracelets009"] = {
		label = "سوار نسائي 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets009.png",
		}
	},

	["s_inv_cigcard_gun_04x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 04",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #04",
		client = {
			image = "s_inv_cigcard_gun_04x.png",
		}
	},

	["womenoutfit234"] = {
		label = "زي نسائي 234",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit234.png",
		}
	},

	["MenOutfits026"] = {
		label = "زي رجالي 026",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits026.png",
		}
	},

	["womenoutfit602"] = {
		label = "زي نسائي 602",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit602.png",
		}
	},

	["newbucket"] = {
		label = "دلو ماء",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن استخدام الدلو لملئه بالماء.",
		client = {
			image = "newbucket.png",
		}
	},

	["birdfeeder"] = {
		label = "مغذي الطيور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "birdfeeder.png",
		}
	},

	["womenoutfit679"] = {
		label = "زي نسائي 679",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit679.png",
		}
	},

	["womenoutfit165"] = {
		label = "زي نسائي 165",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit165.png",
		}
	},

	["marijuana_joint_double2"] = {
		label = "لفافة ماريجوانا مزدوجة 2",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا مزدوجة 2",
		client = {
			image = "marijuana_joint_double2.png",
		}
	},

	["WomenGloves006"] = {
		label = "قفازات نسائية 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves006.png",
		}
	},

	["provision_pelican_feather"] = {
		label = "ريشة البجع",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة كبيرة مأخوذة من بجعة.",
		client = {
			image = "provision_pelican_feather.png",
		}
	},

	["OutfitMen064"] = {
		label = "بدلة رجالية 064",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen064.png",
		}
	},

	["womenoutfit668"] = {
		label = "زي نسائي 668",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit668.png",
		}
	},

	["miningdynamitecrate"] = {
		label = "طقم طبي للمصابين بالضرب",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين المصابين بعد تعرضهم لضربة!",
		client = {
			image = "miningdynamitecrate.png",
		}
	},

	["animal_quail"] = {
		label = "طائر السمان",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر السمان.",
		client = {
			image = "animal_quail.png",
		}
	},

	["WomenOutfits24"] = {
		label = "زي نسائي 24",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits24.png",
		}
	},

	["WomenHats090"] = {
		label = "قبعة نسائية 090",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats090.png",
		}
	},

	["door4"] = {
		label = "مفتاح الباب 4",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door4.png",
		}
	},

	["womenoutfit307"] = {
		label = "زي نسائي 307",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit307.png",
		}
	},

	["WomenHats103"] = {
		label = "قبعة نسائية 103",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats103.png",
		}
	},

	["MenOutfits012"] = {
		label = "زي رجالي 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits012.png",
		}
	},

	["WomenHats186"] = {
		label = "قبعة نسائية 186",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats186.png",
		}
	},

	["womenoutfit148"] = {
		label = "زي نسائي 148",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit148.png",
		}
	},

	["womenoutfit267"] = {
		label = "زي نسائي 267",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit267.png",
		}
	},

	["womenoutfit159"] = {
		label = "زي نسائي 159",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit159.png",
		}
	},

	["perfect_possum_pelt"] = {
		label = "فرو أبوسوم ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أبوسوم بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_possum_pelt.png",
		}
	},

	["provision_coin_1800_gold_quarter"] = {
		label = "1800 Gold Quarter",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold quarter coin from 1800.",
		client = {
			image = "provision_coin_1800_gold_quarter.png",
		}
	},

	["jewelry_rings_left"] = {
		label = "خواتم المجوهرات اليسرى",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "jewelry_rings_left.png",
		}
	},

	["OutfitMen015"] = {
		label = "بدلة رجالية 015",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen015.png",
		}
	},

	["WomenOutfit014"] = {
		label = "زي نسائي 014",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit014.png",
		}
	},

	["resource_box_grapes"] = {
		label = "صندوق العنب ",
		weight = 250,
		stack = true,
		close = true,
		description = "صندوق العنب ",
		client = {
			image = "resource_box_grapes.png",
		}
	},

	["perfect_aligator_meat"] = {
		label = "لحم تمساح ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_aligator_meat.png",
		}
	},

	["WomenHats116"] = {
		label = "قبعة نسائية 116",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats116.png",
		}
	},

	["dochitkit"] = {
		label = "طقم طبي للمصابين بالضرب",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين المصابين بعد تعرضهم لضربة!",
		client = {
			image = "dochitkit.png",
		}
	},

	["womenoutfit218"] = {
		label = "زي نسائي 218",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit218.png",
		}
	},

	["womenoutfit52"] = {
		label = "زي نسائي 52",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit52.png",
		}
	},

	["WomenOutfit092"] = {
		label = "زي نسائي 092",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit092.png",
		}
	},

	["womenoutfit315"] = {
		label = "زي نسائي 315",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit315.png",
		}
	},

	["s_inv_cigcard_act_09x"] = {
		label = "بطاقة السجائر 09",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 09",
		client = {
			image = "s_inv_cigcard_act_09x.png",
		}
	},

	["s_inv_cigcard_gun_12x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 12",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #12",
		client = {
			image = "s_inv_cigcard_gun_12x.png",
		}
	},

	["a_wool"] = {
		label = "صوف",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_wool.png",
		}
	},

	["hat11"] = {
		label = "قبعة 11",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat11.png",
		}
	},

	["wethemp_ll"] = {
		label = "Wet Lagras Lullaby",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the tranquil Lagras Swamps!",
		client = {
			image = "wethemp_ll.png",
		}
	},

	["knapsack1"] = {
		label = "حقيبة تحمل سعة 500",
		weight = 250,
		stack = true,
		close = true,
		description = "حقيبة تحمل سعة 500",
		client = {
			image = "knapsack1.png",
		}
	},

	["WomenOutfit074"] = {
		label = "زي نسائي 074",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit074.png",
		}
	},

	["MenOutfits20"] = {
		label = "زي رجالي 20",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits20.png",
		}
	},

	["pickaxe_gold"] = {
		label = "معول ذهبي",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين المصابين لأسباب عديدة!",
		client = {
			image = "pickaxe_gold.png",
		}
	},

	["WomenNecklaces001"] = {
		label = "قلادة نسائية 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces001.png",
		}
	},

	["poor_pronghorn_pelt"] = {
		label = "فرو ظبي رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظبي بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_pronghorn_pelt.png",
		}
	},

	["s_inv_cigcard_spt_10x"] = {
		label = "بطاقة السجائر أبطال العالم 10",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #10",
		client = {
			image = "s_inv_cigcard_spt_10x.png",
		}
	},

	["womenoutfit85"] = {
		label = "زي نسائي 85",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit85.png",
		}
	},

	["WomenOutfit045"] = {
		label = "زي نسائي 045",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit045.png",
		}
	},

	["womenoutfit31"] = {
		label = "زي نسائي 31",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit31.png",
		}
	},

	["WomenHats093"] = {
		label = "قبعة نسائية 093",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats093.png",
		}
	},

	["OutfitMen170"] = {
		label = "بدلة رجالية 170",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen170.png",
		}
	},

	["medium_buffalo_pelt"] = {
		label = "فرو جاموس متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو جاموس بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_buffalo_pelt.png",
		}
	},

	["turkey_feathers"] = {
		label = "ريش ديك رومي",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش ديك رومي يُستخدم في أعمال التصنيع.",
		client = {
			image = "turkey_feathers.png",
		}
	},

	["squirrel_animal"] = {
		label = "سنجاب",
		weight = 100,
		stack = true,
		close = true,
		description = "سنجاب صغير يمكن استخدامه في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "squirrel_animal.png",
		}
	},

	["consumable_scotch_whiskey"] = {
		label = "ويسكي سكوتش",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب ويسكي سكوتش.",
		client = {
			image = "consumable_scotch_whiskey.png",
		}
	},

	["WomenOutfit056"] = {
		label = "زي نسائي 056",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit056.png",
		}
	},

	["legendary_alligator_pelt"] = {
		label = "فرو تمساح أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_alligator_pelt.png",
		}
	},

	["WOLF_VAR_003"] = {
		label = "ذئب أسطوري أسود",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب أسطوري أسود.",
		client = {
			image = "WOLF_VAR_003.png",
		}
	},

	["spear01"] = {
		label = "رمح 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "spear01.png",
		}
	},

	["WomenHats185"] = {
		label = "قبعة نسائية 185",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats185.png",
		}
	},

	["womenoutfit624"] = {
		label = "زي نسائي 624",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit624.png",
		}
	},

	["medium_coyote_pelt"] = {
		label = "فرو ذئب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_coyote_pelt.png",
		}
	},

	["exoticjoint"] = {
		label = "سيجارة ملفوفة فاخرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "exoticjoint.png",
		}
	},

	["OutfitMen010"] = {
		label = "بدلة رجالية 010",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen010.png",
		}
	},

	["womenoutfit496"] = {
		label = "زي نسائي 496",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit496.png",
		}
	},

	["menoutfit6"] = {
		label = "ملابس الرجال 6",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit6.png",
		}
	},

	["loveenvelope"] = {
		label = "ظرف الحب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "loveenvelope.png",
		}
	},

	["chicken_drumstick"] = {
		label = "ساق دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "ساق دجاج مقطعة",
		client = {
			image = "chicken_drumstick.png",
		}
	},

	["WomenHats111"] = {
		label = "قبعة نسائية 111",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats111.png",
		}
	},

	["WomenGloves024"] = {
		label = "قفازات نسائية 024",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves024.png",
		}
	},

	["womenoutfit73"] = {
		label = "زي نسائي 73",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit73.png",
		}
	},

	["womenoutfit478"] = {
		label = "زي نسائي 478",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit478.png",
		}
	},

	["cuthemp_rd"] = {
		label = "Trimmed Roanoke Dream",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp originating from the rugged Roanoke Ridge!",
		client = {
			image = "cuthemp_rd.png",
		}
	},

	["hookah03"] = {
		label = "شيشة 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hookah03.png",
		}
	},

	["OutfitMen011"] = {
		label = "بدلة رجالية 011",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen011.png",
		}
	},

	["np"] = {
		label = "Newspaper",
		weight = 250,
		stack = false,
		close = true,
		description = "Newspaper",
		client = {
			image = "np.png",
		}
	},

	["mp001_p_mp_still03x"] = {
		label = "Moonshine Still 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp001_p_mp_still03x.png",
		}
	},

	["OutfitMen054"] = {
		label = "بدلة رجالية 054",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen054.png",
		}
	},

	["WomenGloves012"] = {
		label = "قفازات نسائية 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves012.png",
		}
	},

	["WomenHats196"] = {
		label = "قبعة نسائية 196",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats196.png",
		}
	},

	["mapa_06"] = {
		label = "الخريطة المفقودة 6",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 6",
		client = {
			image = "mapa_06.png",
		}
	},

	["MenOutfits12"] = {
		label = "زي رجالي 12",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits12.png",
		}
	},

	["menoutfit105"] = {
		label = "ملابس الرجال 105",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit105.png",
		}
	},

	["key_hunter"] = {
		label = "مفتاح الصياد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "key_hunter.png",
		}
	},

	["OutfitMen012"] = {
		label = "بدلة رجالية 012",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen012.png",
		}
	},

	["womenoutfit217"] = {
		label = "زي نسائي 217",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit217.png",
		}
	},

	["WomenGloves018"] = {
		label = "قفازات نسائية 018",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves018.png",
		}
	},

	["marijuana_joint2_4"] = {
		label = "لفافة ماريجوانا 2-4",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-4",
		client = {
			image = "marijuana_joint2_4.png",
		}
	},

	["s_inv_cigcard_act_04x"] = {
		label = "بطاقة السجائر 04",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 04",
		client = {
			image = "s_inv_cigcard_act_04x.png",
		}
	},

	["baghemp_bb"] = {
		label = "Bagged Bayou Bliss",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the muckiness of the bayou!",
		client = {
			image = "baghemp_bb.png",
		}
	},

	["womenoutfit442"] = {
		label = "زي نسائي 442",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit442.png",
		}
	},

	["consumable_chipsnsalsa"] = {
		label = "رقائق الشيبس وصلصة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chipsnsalsa.png",
		}
	},

	["womenoutfit308"] = {
		label = "زي نسائي 308",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit308.png",
		}
	},

	["OutfitMen001"] = {
		label = "بدلة رجالية 001",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen001.png",
		}
	},

	["OutfitMen035"] = {
		label = "بدلة رجالية 035",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen035.png",
		}
	},

	["animal_crow"] = {
		label = "غراب",
		weight = 250,
		stack = true,
		close = true,
		description = "غراب.",
		client = {
			image = "animal_crow.png",
		}
	},

	["survival_guitar_002"] = {
		label = "survival guitar 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "survival_guitar_002.png",
		}
	},

	["OutfitMen111"] = {
		label = "بدلة رجالية 111",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen111.png",
		}
	},

	["womenoutfit371"] = {
		label = "زي نسائي 371",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit371.png",
		}
	},

	["consumable_flakey_fish_oregano_cooked"] = {
		label = "سمك متبل بالأوريجانو",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك مطبوخ ومتبل بالأوريجانو.",
		client = {
			image = "consumable_flakey_fish_oregano_cooked.png",
		}
	},

	["WomenHats070"] = {
		label = "قبعة نسائية 070",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats070.png",
		}
	},

	["scopeshorthenry"] = {
		label = "Repeater Henry Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshorthenry.png",
		}
	},

	["womenoutfit322"] = {
		label = "زي نسائي 322",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit322.png",
		}
	},

	["OutfitMen132"] = {
		label = "بدلة رجالية 132",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen132.png",
		}
	},

	["OutfitMen075"] = {
		label = "بدلة رجالية 075",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen075.png",
		}
	},

	["WomenHats135"] = {
		label = "قبعة نسائية 135",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats135.png",
		}
	},

	["champagne"] = {
		label = "شامبانيا",
		weight = 250,
		stack = true,
		close = true,
		description = "شامبانيا.",
		client = {
			image = "champagne.png",
		}
	},

	["menoutfit11"] = {
		label = "ملابس الرجال 11",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit11.png",
		}
	},

	["womenoutfit423"] = {
		label = "زي نسائي 423",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit423.png",
		}
	},

	["menoutfit102"] = {
		label = "ملابس الرجال 102",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit102.png",
		}
	},

	["oilwell_repair"] = {
		label = "عدة إصلاح آبار النفط",
		weight = 250,
		stack = true,
		close = true,
		description = "عدة إصلاح آبار النفط",
		client = {
			image = "oilwell_repair.png",
		}
	},

	["womenoutfit705"] = {
		label = "زي نسائي 705",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit705.png",
		}
	},

	["womenoutfit186"] = {
		label = "زي نسائي 186",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit186.png",
		}
	},

	["WomenOutfits13"] = {
		label = "زي نسائي 13",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits13.png",
		}
	},

	["womenoutfit853"] = {
		label = "زي نسائي 853",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit853.png",
		}
	},

	["stamina_tonic"] = {
		label = "منشط التحمل",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط التحمل",
		client = {
			image = "stamina_tonic.png",
		}
	},

	["medium_buck_meat"] = {
		label = "لحم غزال متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_buck_meat.png",
		}
	},

	["ag"] = {
		label = "حقائب إضافية",
		weight = 250,
		stack = true,
		close = true,
		description = "حقائب إضافية للحصان",
		client = {
			image = "ag.png",
		}
	},

	["WomenHats197"] = {
		label = "قبعة نسائية 197",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats197.png",
		}
	},

	["resource_skin_desert_iguana_star_3"] = {
		label = "جلد الإغوانا الصحراوية 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_desert_iguana_star_3.png",
		}
	},

	["trapoil"] = {
		label = "Trap Oil",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "trapoil.png",
		}
	},

	["OutfitMen003"] = {
		label = "بدلة رجالية 003",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen003.png",
		}
	},

	["Fertilizeregg"] = {
		label = "بيض السماد",
		weight = 250,
		stack = true,
		close = true,
		description = "بيض السماد هو منتج طبيعي يستخدم لتحسين جودة التربة وتعزيز نمو النباتات",
		client = {
			image = "Fertilizeregg.png",
		}
	},

	["MenOutfits028"] = {
		label = "زي رجالي 028",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits028.png",
		}
	},

	["womenoutfit121"] = {
		label = "زي نسائي 121",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit121.png",
		}
	},

	["womenoutfit524"] = {
		label = "زي نسائي 524",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit524.png",
		}
	},

	["resource_box_watermelon"] = {
		label = "بطيخ",
		weight = 250,
		stack = true,
		close = true,
		description = "بطيخ",
		client = {
			image = "resource_box_watermelon.png",
		}
	},

	["s_inv_cigcard_grl_04x"] = {
		label = "بطاقة السجائر جواهر الجمال 04",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #04",
		client = {
			image = "s_inv_cigcard_grl_04x.png",
		}
	},

	["legenrady_elk_antlers"] = {
		label = "قرون وعل أسطورية",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون وعل أسطورية، يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "legenrady_elk_antlers.png",
		}
	},

	["menoutfit112"] = {
		label = "ملابس الرجال 112",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit112.png",
		}
	},

	["al-frakchiya"] = {
		label = "اعلان  القبيلة 2",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "al-frakchiya.png",
		}
	},

	["consumable_meat_big_game_cooked"] = {
		label = "لحم الصيد المطبوخ",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم صيد بري مطبوخ.",
		client = {
			image = "consumable_meat_big_game_cooked.png",
		}
	},

	["OutfitMen021"] = {
		label = "بدلة رجالية 021",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen021.png",
		}
	},

	["womenoutfit710"] = {
		label = "زي نسائي 710",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit710.png",
		}
	},

	["womenoutfit58"] = {
		label = "زي نسائي 58",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit58.png",
		}
	},

	["perfect_legendaryalligator_pelt"] = {
		label = "فرو تمساح أسطوري ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح أسطوري بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_legendaryalligator_pelt.png",
		}
	},

	["asiaspower"] = {
		label = "قوة آسيا",
		weight = 250,
		stack = true,
		close = true,
		description = "قوة آسيا",
		client = {
			image = "asiaspower.png",
		}
	},

	["WomenHats049"] = {
		label = "قبعة نسائية 049",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats049.png",
		}
	},

	["OutfitMen056"] = {
		label = "بدلة رجالية 056",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen056.png",
		}
	},

	["womenoutfit639"] = {
		label = "زي نسائي 639",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit639.png",
		}
	},

	["Cactus_Seed"] = {
		label = "بذور الصبار",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات نبات الصبار.",
		client = {
			image = "Cactus_Seed.png",
		}
	},

	["medium_elk_pelt"] = {
		label = "فرو وعل متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو وعل بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_elk_pelt.png",
		}
	},

	["menoutfit107"] = {
		label = "ملابس الرجال 107",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit107.png",
		}
	},

	["consumable_milkshake_vanilla"] = {
		label = "ميلك شيك فانيليا",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_milkshake_vanilla.png",
		}
	},

	["s_inv_cigcard_aml_05x"] = {
		label = "بطاقة السجائر أمل 05",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #05",
		client = {
			image = "s_inv_cigcard_aml_05x.png",
		}
	},

	["playerbuff"] = {
		label = "تعزيز اللاعب",
		weight = 250,
		stack = true,
		close = true,
		description = "تعزيز اللاعب",
		client = {
			image = "playerbuff.png",
		}
	},

	["resource_skin_moose_star_2"] = {
		label = "فرو الموظ 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_moose_star_2.png",
		}
	},

	["belts"] = {
		label = "أحزمة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "belts.png",
		}
	},

	["womenoutfit214"] = {
		label = "زي نسائي 214",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit214.png",
		}
	},

	["saddleStand_3"] = {
		label = "حامل السرج 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "saddleStand_3.png",
		}
	},

	["womenoutfit611"] = {
		label = "زي نسائي 611",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit611.png",
		}
	},

	["eyewear"] = {
		label = "نظارات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "eyewear.png",
		}
	},

	["MenOutfits21"] = {
		label = "زي رجالي 21",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits21.png",
		}
	},

	["womenoutfit659"] = {
		label = "زي نسائي 659",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit659.png",
		}
	},

	["mp_animal_cougar_legendary_01"] = {
		label = "أسد الجبال الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "أسد الجبال الأسطوري.",
		client = {
			image = "mp_animal_cougar_legendary_01.png",
		}
	},

	["womenoutfit314"] = {
		label = "زي نسائي 314",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit314.png",
		}
	},

	["s_inv_cigcard_inv_09x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 09",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #09",
		client = {
			image = "s_inv_cigcard_inv_09x.png",
		}
	},

	["sword02"] = {
		label = "سيف 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sword02.png",
		}
	},

	["s_inv_cigcard_art_12x"] = {
		label = "بطاقة السجائر فن 12",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #12",
		client = {
			image = "s_inv_cigcard_art_12x.png",
		}
	},

	["whitepearl"] = {
		label = "لؤلؤة بيضاء",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع اللؤلؤة البيضاء بأسعار مرتفعة.",
		client = {
			image = "whitepearl.png",
		}
	},

	["womenoutfit483"] = {
		label = "زي نسائي 483",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit483.png",
		}
	},

	["watsh_gold"] = {
		label = "ساعة ذهبية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "watsh_gold.png",
		}
	},

	["resource_pelt_opossum_star_2"] = {
		label = "جلد الأبوسوم 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_opossum_star_2.png",
		}
	},

	["honeywhisky"] = {
		label = "ويسكي بالعسل",
		weight = 250,
		stack = true,
		close = true,
		description = "ويسكي بالعسل",
		client = {
			image = "honeywhisky.png",
		}
	},

	["menoutfit116"] = {
		label = "ملابس الرجال 116",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit116.png",
		}
	},

	["scopemediumvarmint"] = {
		label = "Rifle Varmint Medium Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopemediumvarmint.png",
		}
	},

	["WomenOutfit005"] = {
		label = "زي نسائي 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit005.png",
		}
	},

	["clamp01"] = {
		label = "ملزمة 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clamp01.png",
		}
	},

	["saber01"] = {
		label = "سابر 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "saber01.png",
		}
	},

	["p_benchwork01x"] = {
		label = "Craft Table",
		weight = 250,
		stack = true,
		close = true,
		description = "A workbench for Making Craft",
		client = {
			image = "p_benchwork01x.png",
		}
	},

	["womenoutfit5"] = {
		label = "زي نسائي 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit5.png",
		}
	},

	["birdticket"] = {
		label = "رسالة",
		weight = 250,
		stack = false,
		close = true,
		description = "رسالة",
		client = {
			image = "birdticket.png",
		}
	},

	["pan02"] = {
		label = "مقلاة 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pan02.png",
		}
	},

	["womenoutfit257"] = {
		label = "زي نسائي 257",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit257.png",
		}
	},

	["OutfitMen087"] = {
		label = "بدلة رجالية 087",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen087.png",
		}
	},

	["mp001_p_mp_still01x"] = {
		label = "Moonshine Still 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp001_p_mp_still01x.png",
		}
	},

	["WomenHats115"] = {
		label = "قبعة نسائية 115",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats115.png",
		}
	},

	["s_inv_cigcard_grl_01x"] = {
		label = "بطاقة السجائر جواهر الجمال 01",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #01",
		client = {
			image = "s_inv_cigcard_grl_01x.png",
		}
	},

	["legendary_buck_antlers"] = {
		label = "قرون غزال أسطورية",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون غزال أسطورية، يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "legendary_buck_antlers.png",
		}
	},

	["womenoutfit563"] = {
		label = "زي نسائي 563",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit563.png",
		}
	},

	["womenoutfit560"] = {
		label = "زي نسائي 560",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit560.png",
		}
	},

	["r_locker8"] = {
		label = "خزنة رقم 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker8.png",
		}
	},

	["antar"] = {
		label = "عنتر بن شداد",
		weight = 250,
		stack = true,
		close = true,
		description = "قوة الحصان الكابوسي",
		client = {
			image = "antar.png",
		}
	},

	["womenoutfit663"] = {
		label = "زي نسائي 663",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit663.png",
		}
	},

	["womenoutfit67"] = {
		label = "زي نسائي 67",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit67.png",
		}
	},

	["perfect_panther_meat"] = {
		label = "لحم نمر ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم نمر بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_panther_meat.png",
		}
	},

	["omg_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "omg_news.png",
		}
	},

	["provision_legendary_bear_heart"] = {
		label = "قلب دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب قوي من دب أسطوري.",
		client = {
			image = "provision_legendary_bear_heart.png",
		}
	},

	["chicken_patties"] = {
		label = "فطائر دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "فطائر دجاج مفرومة للطبخ أو للمطاعم",
		client = {
			image = "chicken_patties.png",
		}
	},

	["kkk_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "kkk_news.png",
		}
	},

	["ban4"] = {
		label = "باندانا 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ban4.png",
		}
	},

	["honey_gk"] = {
		label = "عسل gk",
		weight = 250,
		stack = true,
		close = true,
		description = "عسل gk",
		client = {
			image = "honey_gk.png",
		}
	},

	["OutfitMen147"] = {
		label = "بدلة رجالية 147",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen147.png",
		}
	},

	["crow_feathers"] = {
		label = "ريش غراب",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش غراب يُستخدم في أعمال التصنيع.",
		client = {
			image = "crow_feathers.png",
		}
	},

	["WomenHats075"] = {
		label = "قبعة نسائية 075",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats075.png",
		}
	},

	["provision_legendary_coyote_fang"] = {
		label = "ناب ذئب بري أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب حاد من ذئب بري أسطوري.",
		client = {
			image = "provision_legendary_coyote_fang.png",
		}
	},

	["MenOutfits013"] = {
		label = "زي رجالي 013",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits013.png",
		}
	},

	["p_trowel01x"] = {
		label = "مجرفة",
		weight = 250,
		stack = true,
		close = true,
		description = "مجرفة لزراعة البذور",
		client = {
			image = "p_trowel01x.png",
		}
	},

	["lumber_oak_split_logs"] = {
		label = "جذوع شقوق البلوط",
		weight = 250,
		stack = true,
		close = true,
		description = "جذوع شقوق البلوط",
		client = {
			image = "lumber_oak_split_logs.png",
		}
	},

	["womenoutfit137"] = {
		label = "زي نسائي 137",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit137.png",
		}
	},

	["perfect_beaver_meat"] = {
		label = "لحم قندس ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم قندس بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_beaver_meat.png",
		}
	},

	["provision_legendary_bear_claw"] = {
		label = "مخلب دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب قوي من دب أسطوري.",
		client = {
			image = "provision_legendary_bear_claw.png",
		}
	},

	["large_storagebox"] = {
		label = "storage box",
		weight = 250,
		stack = true,
		close = true,
		description = "storage box",
		client = {
			image = "large_storagebox.png",
		}
	},

	["p_finishedragonfly01x_hf"] = {
		label = "طُعم اليعسوب المميز",
		weight = 250,
		stack = true,
		close = true,
		description = "طُعم يعسوب واقعي مصمم لمحاكاة الحشرات الطائرة، مثالي لصيد الأسماك السطحية.",
		client = {
			image = "p_finishedragonfly01x_hf.png",
		}
	},

	["OutfitMen018"] = {
		label = "بدلة رجالية 018",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen018.png",
		}
	},

	["womenoutfit630"] = {
		label = "زي نسائي 630",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit630.png",
		}
	},

	["hat"] = {
		label = "قبعة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat.png",
		}
	},

	["Rose_Seed"] = {
		label = "بذور الورد",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات الورد.",
		client = {
			image = "Rose_Seed.png",
		}
	},

	["s_inv_cigcard_aml_09x"] = {
		label = "بطاقة السجائر أمل 09",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #09",
		client = {
			image = "s_inv_cigcard_aml_09x.png",
		}
	},

	["s_inv_cigcard_hrs_01x"] = {
		label = "بطاقة السجائر سلالات الخيول 01",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #01",
		client = {
			image = "s_inv_cigcard_hrs_01x.png",
		}
	},

	["womenoutfit227"] = {
		label = "زي نسائي 227",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit227.png",
		}
	},

	["womenoutfit590"] = {
		label = "زي نسائي 590",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit590.png",
		}
	},

	["womenoutfit28"] = {
		label = "زي نسائي 28",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit28.png",
		}
	},

	["womenoutfit118"] = {
		label = "زي نسائي 118",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit118.png",
		}
	},

	["poor_possum_pelt"] = {
		label = "فرو أبوسوم رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أبوسوم بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_possum_pelt.png",
		}
	},

	["animal_snakeblacktailrattle"] = {
		label = "أفعى ذات الذيل الأسود المجلجل",
		weight = 250,
		stack = true,
		close = true,
		description = "أفعى ذات الذيل الأسود المجلجل.",
		client = {
			image = "animal_snakeblacktailrattle.png",
		}
	},

	["womenoutfit394"] = {
		label = "زي نسائي 394",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit394.png",
		}
	},

	["womenoutfit16"] = {
		label = "زي نسائي 16",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit16.png",
		}
	},

	["shotgunreceiver"] = {
		label = "فوهة ذخيرة سلاح شتقن",
		weight = 250,
		stack = true,
		close = true,
		description = "فوهة ذخيرة سلاح شتقن",
		client = {
			image = "shotgunreceiver.png",
		}
	},

	["WomenHats152"] = {
		label = "قبعة نسائية 152",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats152.png",
		}
	},

	["womenoutfit126"] = {
		label = "زي نسائي 126",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit126.png",
		}
	},

	["consumable_grits"] = {
		label = "جريش الجدة نيزز",
		weight = 250,
		stack = true,
		close = true,
		description = "تم صنع هاذا الجريش من الجده نيزز",
		client = {
			image = "consumable_grits.png",
		}
	},

	["mp_animal_coyote_legendary_03"] = {
		label = "ذئب أسطوري",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب أسطوري.",
		client = {
			image = "mp_animal_coyote_legendary_03.png",
		}
	},

	["WomenHats050"] = {
		label = "قبعة نسائية 050",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats050.png",
		}
	},

	["menoutfit80"] = {
		label = "ملابس الرجال 80",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit80.png",
		}
	},

	["womenoutfit740"] = {
		label = "زي نسائي 740",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit740.png",
		}
	},

	["womenoutfit631"] = {
		label = "زي نسائي 631",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit631.png",
		}
	},

	["docunarmedkit"] = {
		label = "طقم طبي للضرب",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين بعد تعرضهم للضرب!",
		client = {
			image = "docunarmedkit.png",
		}
	},

	["MenOutfits37"] = {
		label = "زي رجالي 37",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits37.png",
		}
	},

	["womenoutfit475"] = {
		label = "زي نسائي 475",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit475.png",
		}
	},

	["WomenHats005"] = {
		label = "قبعة نسائية 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats005.png",
		}
	},

	["a_manure"] = {
		label = "سماد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_manure.png",
		}
	},

	["WomenOutfit073"] = {
		label = "زي نسائي 073",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit073.png",
		}
	},

	["womenoutfit46"] = {
		label = "زي نسائي 46",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit46.png",
		}
	},

	["baghemp_mm"] = {
		label = "Bagged Montana Mist",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the crisp air of Montana plains!",
		client = {
			image = "baghemp_mm.png",
		}
	},

	["OutfitMen004"] = {
		label = "بدلة رجالية 004",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen004.png",
		}
	},

	["dryhemp_sb"] = {
		label = "Dry Sandy Breeze",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp gathered from the sandy and breezy coastal areas!",
		client = {
			image = "dryhemp_sb.png",
		}
	},

	["legendary_bear_meat"] = {
		label = "لحم دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_bear_meat.png",
		}
	},

	["forge"] = {
		label = "فرن",
		weight = 8000,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "forge.png",
		}
	},

	["crab_animal"] = {
		label = "سرطان البحر",
		weight = 250,
		stack = true,
		close = true,
		description = "سرطان بحر يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "crab_animal.png",
		}
	},

	["WomenGloves022"] = {
		label = "قفازات نسائية 022",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves022.png",
		}
	},

	["blackmulberry"] = {
		label = "توت أسود",
		weight = 250,
		stack = true,
		close = true,
		description = "توت صغير وحلو اللون",
		client = {
			image = "blackmulberry.png",
		}
	},

	["MenOutfits25"] = {
		label = "زي رجالي 25",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits25.png",
		}
	},

	["OutfitMen115"] = {
		label = "بدلة رجالية 115",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen115.png",
		}
	},

	["marijuana_bud2"] = {
		label = "برعم الماريجوانا 2",
		weight = 250,
		stack = true,
		close = true,
		description = "برعم الماريجوانا 2",
		client = {
			image = "marijuana_bud2.png",
		}
	},

	["craftbook"] = {
		label = "Craft Book",
		weight = 250,
		stack = true,
		close = true,
		description = "a craft book with recipes for making crafts",
		client = {
			image = "craftbook.png",
		}
	},

	["WomenHats096"] = {
		label = "قبعة نسائية 096",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats096.png",
		}
	},

	["WomenHats172"] = {
		label = "قبعة نسائية 172",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats172.png",
		}
	},

	["WomenHats189"] = {
		label = "قبعة نسائية 189",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats189.png",
		}
	},

	["bread_pita"] = {
		label = "خبز بيتا",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "bread_pita.png",
		}
	},

	["womenoutfit1"] = {
		label = "زي نسائي 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit1.png",
		}
	},

	["WomenHats121"] = {
		label = "قبعة نسائية 121",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats121.png",
		}
	},

	["potion_healing"] = {
		label = "Healing Potion",
		weight = 250,
		stack = true,
		close = true,
		description = "A custom healing tonic.",
		client = {
			image = "potion_healing.png",
		}
	},

	["womenoutfit17"] = {
		label = "زي نسائي 17",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit17.png",
		}
	},

	["kcondorf"] = {
		label = "ريشة الكندور",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة الكندور",
		client = {
			image = "kcondorf.png",
		}
	},

	["poor_legendaryaligator_pelt"] = {
		label = "فرو تمساح أسطوري رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح أسطوري بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_legendaryaligator_pelt.png",
		}
	},

	["dryhemp_is"] = {
		label = "Dry Indigenous Sativa",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp grown from native strains in pristine environments!",
		client = {
			image = "dryhemp_is.png",
		}
	},

	["tool_hammer"] = {
		label = "مطرقة أداة",
		weight = 250,
		stack = true,
		close = true,
		description = "مطرقة أداة",
		client = {
			image = "tool_hammer.png",
		}
	},

	["womenoutfit400"] = {
		label = "زي نسائي 400",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit400.png",
		}
	},

	["OutfitMen161"] = {
		label = "بدلة رجالية 161",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen161.png",
		}
	},

	["womenoutfit337"] = {
		label = "زي نسائي 337",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit337.png",
		}
	},

	["MenOutfits006"] = {
		label = "زي رجالي 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits006.png",
		}
	},

	["turtle_shell"] = {
		label = "صدفة سلحفاة",
		weight = 500,
		stack = true,
		close = true,
		description = "صدفة سلحفاة يمكن استخدامها في التصنيع.",
		client = {
			image = "turtle_shell.png",
		}
	},

	["womenoutfit766"] = {
		label = "زي نسائي 766",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit766.png",
		}
	},

	["WomenHats120"] = {
		label = "قبعة نسائية 120",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats120.png",
		}
	},

	["WomenHats164"] = {
		label = "قبعة نسائية 164",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats164.png",
		}
	},

	["womenoutfit428"] = {
		label = "زي نسائي 428",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit428.png",
		}
	},

	["provision_panther_heart"] = {
		label = "قلب الفهد",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب قوي ونادر لفهد بري.",
		client = {
			image = "provision_panther_heart.png",
		}
	},

	["WomenOutfit021"] = {
		label = "زي نسائي 021",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit021.png",
		}
	},

	["OutfitMen099"] = {
		label = "بدلة رجالية 099",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen099.png",
		}
	},

	["MenOutfits031"] = {
		label = "زي رجالي 031",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits031.png",
		}
	},

	["womenoutfit91"] = {
		label = "زي نسائي 91",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit91.png",
		}
	},

	["r_locker4"] = {
		label = "خزنة رقم 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker4.png",
		}
	},

	["consumable_applejuice"] = {
		label = "عصير التفاح",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_applejuice.png",
		}
	},

	["jewelry_bracelets"] = {
		label = "أساور المجوهرات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "jewelry_bracelets.png",
		}
	},

	["horseloadout5"] = {
		label = "حمولة حصان 5",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout5.png",
		}
	},

	["pipepeace"] = {
		label = "غليون السلام",
		weight = 250,
		stack = true,
		close = true,
		description = "غليون السلام",
		client = {
			image = "pipepeace.png",
		}
	},

	["resource_skin_elk_star_3"] = {
		label = "جلد الأيل 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_elk_star_3.png",
		}
	},

	["saber03"] = {
		label = "سابر 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "saber03.png",
		}
	},

	["WomenHats104"] = {
		label = "قبعة نسائية 104",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats104.png",
		}
	},

	["menoutfit34"] = {
		label = "ملابس الرجال 34",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit34.png",
		}
	},

	["WomenHats015"] = {
		label = "قبعة نسائية 015",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats015.png",
		}
	},

	["MenOutfits26"] = {
		label = "زي رجالي 26",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits26.png",
		}
	},

	["menoutfit57"] = {
		label = "ملابس الرجال 57",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit57.png",
		}
	},

	["gold_horse"] = {
		label = "حصان ذهبي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "gold_horse.png",
		}
	},

	["bat_animal"] = {
		label = "خفاش",
		weight = 250,
		stack = true,
		close = true,
		description = "خفاش يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "bat_animal.png",
		}
	},

	["Granddaddy_Purple_Seed"] = {
		label = "بذور غراندادي بيربل",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج نبات غراندادي بيربل.",
		client = {
			image = "Granddaddy_Purple_Seed.png",
		}
	},

	["canteen"] = {
		label = "قربة ماء",
		weight = 250,
		stack = true,
		close = true,
		description = "قربة تحمل الماء",
		client = {
			image = "canteen.png",
		}
	},

	["womenoutfit539"] = {
		label = "زي نسائي 539",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit539.png",
		}
	},

	["medium_oxen_pelt"] = {
		label = "فرو ثور متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_oxen_pelt.png",
		}
	},

	["MenOutfits19"] = {
		label = "زي رجالي 19",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits19.png",
		}
	},

	["WOLF_VAR_001"] = {
		label = "ذئب أسطوري ذهبي",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب أسطوري ذهبي.",
		client = {
			image = "WOLF_VAR_001.png",
		}
	},

	["petrevive"] = {
		label = "Pet Revive",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "petrevive.png",
		}
	},

	["bill_stacks_bm"] = {
		label = "المال غير المشروع",
		weight = 250,
		stack = true,
		close = true,
		description = "المال القذر",
		client = {
			image = "bill_stacks_bm.png",
		}
	},

	["resource_pelt_rabbit_star_1"] = {
		label = "جلد الأرنب 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_rabbit_star_1.png",
		}
	},

	["womenoutfit370"] = {
		label = "زي نسائي 370",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit370.png",
		}
	},

	["building_plan_5"] = {
		label = "ورقة بناء بيت 5",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_5.png",
		}
	},

	["womenoutfit193"] = {
		label = "زي نسائي 193",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit193.png",
		}
	},

	["womenoutfit240"] = {
		label = "زي نسائي 240",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit240.png",
		}
	},

	["WomenHats043"] = {
		label = "قبعة نسائية 043",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats043.png",
		}
	},

	["MenOutfits03"] = {
		label = "زي رجالي 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits03.png",
		}
	},

	["medium_rabbit_pelt"] = {
		label = "فرو أرنب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرنب بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_rabbit_pelt.png",
		}
	},

	["mapa_05"] = {
		label = "الخريطة المفقودة 5",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 5",
		client = {
			image = "mapa_05.png",
		}
	},

	["MenOutfits033"] = {
		label = "زي رجالي 033",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits033.png",
		}
	},

	["s_inv_cigcard_art_05x"] = {
		label = "بطاقة السجائر فن 05",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #05",
		client = {
			image = "s_inv_cigcard_art_05x.png",
		}
	},

	["club06"] = {
		label = "عصا 06",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club06.png",
		}
	},

	["menoutfit44"] = {
		label = "ملابس الرجال 44",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit44.png",
		}
	},

	["menoutfit58"] = {
		label = "ملابس الرجال 58",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit58.png",
		}
	},

	["consumable_mash"] = {
		label = "الهريس",
		weight = 250,
		stack = true,
		close = true,
		description = "الهريس",
		client = {
			image = "consumable_mash.png",
		}
	},

	["resource_skin_iguana_green_star_1"] = {
		label = "جلد الإغوانا 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_iguana_green_star_1.png",
		}
	},

	["fishing_rod_basic"] = {
		label = "Basic Fishing Rod",
		weight = 2500,
		stack = false,
		close = true,
		description = "A simple fishing rod for beginners",
		client = {
			image = "fishing_rod_basic.png",
		}
	},

	["s_inv_cigcard_spt_02x"] = {
		label = "بطاقة السجائر أبطال العالم 02",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #02",
		client = {
			image = "s_inv_cigcard_spt_02x.png",
		}
	},

	["WomenOutfit024"] = {
		label = "زي نسائي 024",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit024.png",
		}
	},

	["MenOutfits019"] = {
		label = "زي رجالي 019",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits019.png",
		}
	},

	["resource_snake_skin_boa_star_1"] = {
		label = "جلد الثعبان البواء 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_boa_star_1.png",
		}
	},

	["ammohunterhatchet"] = {
		label = "ذخيرة فأس الصياد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ammohunterhatchet.png",
		}
	},

	["backpack5"] = {
		label = "حقيبة تحمل سعة 400",
		weight = 250,
		stack = false,
		close = true,
		description = "حقيبة تحمل سعة 400",
		client = {
			image = "backpack5.png",
		}
	},

	["woodlog"] = {
		label = "Woodlog",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "woodlog.png",
		}
	},

	["womenoutfit304"] = {
		label = "زي نسائي 304",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit304.png",
		}
	},

	["Cucumber_Seed"] = {
		label = "بذور الخيار",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور تُزرع لإنتاج نبات الخيار.",
		client = {
			image = "Cucumber_Seed.png",
		}
	},

	["womenoutfit614"] = {
		label = "زي نسائي 614",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit614.png",
		}
	},

	["consumable_huevos_rancheros"] = {
		label = "بيض رانشيروس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_huevos_rancheros.png",
		}
	},

	["WomenHats108"] = {
		label = "قبعة نسائية 108",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats108.png",
		}
	},

	["ponchos"] = {
		label = "بونشو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ponchos.png",
		}
	},

	["WomenOutfit086"] = {
		label = "زي نسائي 086",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit086.png",
		}
	},

	["resource_pelt_wolf_star_3"] = {
		label = "جلد الذئب 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_wolf_star_3.png",
		}
	},

	["legendary_moose_meat"] = {
		label = "لحم موظ أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم موظ أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_moose_meat.png",
		}
	},

	["consumable_irish_whiskey"] = {
		label = "ويسكي إيرلندي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب الويسكي الإيرلندي.",
		client = {
			image = "consumable_irish_whiskey.png",
		}
	},

	["womenoutfit852"] = {
		label = "زي نسائي 852",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit852.png",
		}
	},

	["laudanum"] = {
		label = "Laudanum",
		weight = 250,
		stack = true,
		close = true,
		description = "A potent painkiller and sedative.",
		client = {
			image = "laudanum.png",
		}
	},

	["consumable_donut3"] = {
		label = "دونات 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut3.png",
		}
	},

	["WomenOutfit042"] = {
		label = "زي نسائي 042",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit042.png",
		}
	},

	["condor_feathers"] = {
		label = "ريش كوندور",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش كوندور يُستخدم في أعمال التصنيع.",
		client = {
			image = "condor_feathers.png",
		}
	},

	["clothingset2"] = {
		label = "طقم ملابس 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothingset2.png",
		}
	},

	["womenoutfit573"] = {
		label = "زي نسائي 573",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit573.png",
		}
	},

	["womenoutfit746"] = {
		label = "زي نسائي 746",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit746.png",
		}
	},

	["resource_skin_buffalo_star_3"] = {
		label = "جلد البيسون 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buffalo_star_3.png",
		}
	},

	["consumable_hot_coco"] = {
		label = "جوز الهند الساخن",
		weight = 250,
		stack = true,
		close = true,
		description = "جوز الهند الساخن",
		client = {
			image = "consumable_hot_coco.png",
		}
	},

	["womenoutfit556"] = {
		label = "زي نسائي 556",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit556.png",
		}
	},

	["zinc_bar"] = {
		label = "سبيكة الزنك",
		weight = 250,
		stack = true,
		close = true,
		description = "سبيكة الزنك",
		client = {
			image = "zinc_bar.png",
		}
	},

	["womenoutfit501"] = {
		label = "زي نسائي 501",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit501.png",
		}
	},

	["WomenHats029"] = {
		label = "قبعة نسائية 029",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats029.png",
		}
	},

	["resource_skin_snake_blacktail_rattlesnake_star_2"] = {
		label = "جلد أفعى ذات الذيل الأسود 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_snake_blacktail_rattlesnake_star_2.png",
		}
	},

	["baghemp_ll"] = {
		label = "Bagged Lagras Lullaby",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the tranquil Lagras Swamps!",
		client = {
			image = "baghemp_ll.png",
		}
	},

	["s_inv_cigcard_inv_08x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 08",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #08",
		client = {
			image = "s_inv_cigcard_inv_08x.png",
		}
	},

	["s_inv_cigcard_art_04x"] = {
		label = "بطاقة السجائر فن 04",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #04",
		client = {
			image = "s_inv_cigcard_art_04x.png",
		}
	},

	["OutfitMen156"] = {
		label = "بدلة رجالية 156",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen156.png",
		}
	},

	["womenoutfit398"] = {
		label = "زي نسائي 398",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit398.png",
		}
	},

	["gin"] = {
		label = "جن",
		weight = 250,
		stack = true,
		close = true,
		description = "جن",
		client = {
			image = "gin.png",
		}
	},

	["medium_deer_meat"] = {
		label = "لحم غزال متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_deer_meat.png",
		}
	},

	["womenoutfit686"] = {
		label = "زي نسائي 686",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit686.png",
		}
	},

	["mp006_p_moonshiner_still04x"] = {
		label = "Moonshine Still 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp006_p_moonshiner_still04x.png",
		}
	},

	["teaseeds"] = {
		label = "بذور الشاي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "teaseeds.png",
		}
	},

	["womenoutfit732"] = {
		label = "زي نسائي 732",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit732.png",
		}
	},

	["WomenOutfits07"] = {
		label = "زي نسائي 07",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits07.png",
		}
	},

	["cuthemp_md"] = {
		label = "Trimmed Mountain Dew",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp collected from the misty heights of the mountains!",
		client = {
			image = "cuthemp_md.png",
		}
	},

	["resource_pelt_muskrat_star_3"] = {
		label = "جلد المسك رات 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_muskrat_star_3.png",
		}
	},

	["a_c_fishnorthernpike_01_lg"] = {
		label = "سمك البايك الشمالي",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك البايك الشمالي",
		client = {
			image = "a_c_fishnorthernpike_01_lg.png",
		}
	},

	["womenoutfit567"] = {
		label = "زي نسائي 567",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit567.png",
		}
	},

	["menoutfit27"] = {
		label = "ملابس الرجال 27",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit27.png",
		}
	},

	["perfect_saligator_meat"] = {
		label = "لحم تمساح ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_saligator_meat.png",
		}
	},

	["womenoutfit20"] = {
		label = "زي نسائي 20",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit20.png",
		}
	},

	["door2"] = {
		label = "مفتاح الباب 2",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door2.png",
		}
	},

	["provision_legendary_wolf_fur"] = {
		label = "فراء الذئب الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم وفاخر من ذئب أسطوري.",
		client = {
			image = "provision_legendary_wolf_fur.png",
		}
	},

	["s_inv_cigcard_veh_12x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 12",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #12",
		client = {
			image = "s_inv_cigcard_veh_12x.png",
		}
	},

	["WomenHats151"] = {
		label = "قبعة نسائية 151",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats151.png",
		}
	},

	["menoutfit37"] = {
		label = "ملابس الرجال 37",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit37.png",
		}
	},

	["womenoutfit213"] = {
		label = "زي نسائي 213",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit213.png",
		}
	},

	["toilet1"] = {
		label = "مرحاض",
		weight = 250,
		stack = true,
		close = true,
		description = "مرحاض",
		client = {
			image = "toilet1.png",
		}
	},

	["poor_sheep_pelt"] = {
		label = "فرو شاة رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو شاة بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_sheep_pelt.png",
		}
	},

	["WomenOutfit001"] = {
		label = "زي نسائي 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit001.png",
		}
	},

	["marijuana_joint3_4"] = {
		label = "لفافة ماريجوانا 3-4",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-4",
		client = {
			image = "marijuana_joint3_4.png",
		}
	},

	["s_inv_cigcard_aml_11x"] = {
		label = "بطاقة السجائر أمل 11",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #11",
		client = {
			image = "s_inv_cigcard_aml_11x.png",
		}
	},

	["OutfitMen006"] = {
		label = "بدلة رجالية 006",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen006.png",
		}
	},

	["poor_deer_meat"] = {
		label = "لحم غزال رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_deer_meat.png",
		}
	},

	["WomenHats145"] = {
		label = "قبعة نسائية 145",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats145.png",
		}
	},

	["robustocigar"] = {
		label = "سيجار روبوستو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "robustocigar.png",
		}
	},

	["womenoutfit848"] = {
		label = "زي نسائي 848",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit848.png",
		}
	},

	["OutfitMen005"] = {
		label = "بدلة رجالية 005",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen005.png",
		}
	},

	["medium_bear_meat"] = {
		label = "لحم دب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_bear_meat.png",
		}
	},

	["WomenHats048"] = {
		label = "قبعة نسائية 048",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats048.png",
		}
	},

	["menoutfit91"] = {
		label = "ملابس الرجال 91",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit91.png",
		}
	},

	["provision_legendary_boar_skin"] = {
		label = "جلد خنزير بري أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد قوي لخنزير بري أسطوري.",
		client = {
			image = "provision_legendary_boar_skin.png",
		}
	},

	["menoutfit53"] = {
		label = "ملابس الرجال 53",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit53.png",
		}
	},

	["womenoutfit182"] = {
		label = "زي نسائي 182",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit182.png",
		}
	},

	["dryhemp_ti"] = {
		label = "Dry Tropical Indica",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush, tropical regions!",
		client = {
			image = "dryhemp_ti.png",
		}
	},

	["OutfitMen139"] = {
		label = "بدلة رجالية 139",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen139.png",
		}
	},

	["mlp_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "mlp_news.png",
		}
	},

	["womenoutfit739"] = {
		label = "زي نسائي 739",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit739.png",
		}
	},

	["s_inv_cigcard_art_03x"] = {
		label = "بطاقة السجائر فن 03",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #03",
		client = {
			image = "s_inv_cigcard_art_03x.png",
		}
	},

	["womenoutfit200"] = {
		label = "زي نسائي 200",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit200.png",
		}
	},

	["raw_chicken"] = {
		label = "دجاج نيء",
		weight = 250,
		stack = true,
		close = true,
		description = "دجاج طازج",
		client = {
			image = "raw_chicken.png",
		}
	},

	["womenoutfit680"] = {
		label = "زي نسائي 680",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit680.png",
		}
	},

	["womenoutfit515"] = {
		label = "زي نسائي 515",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit515.png",
		}
	},

	["WomenOutfits55"] = {
		label = "زي نسائي 55",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits55.png",
		}
	},

	["ammocleaverhatchet"] = {
		label = "ذخيرة فأس الساطور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ammocleaverhatchet.png",
		}
	},

	["OutfitMen175"] = {
		label = "بدلة رجالية 175",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen175.png",
		}
	},

	["WomenOutfit013"] = {
		label = "زي نسائي 013",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit013.png",
		}
	},

	["unique_beef_stew"] = {
		label = "يخنة اللحم الفريدة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_beef_stew.png",
		}
	},

	["WomenOutfits20"] = {
		label = "زي نسائي 20",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits20.png",
		}
	},

	["WomenHats013"] = {
		label = "قبعة نسائية 013",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats013.png",
		}
	},

	["WomenHats064"] = {
		label = "قبعة نسائية 064",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats064.png",
		}
	},

	["FemaleFix"] = {
		label = "FemaleFix",
		weight = 250,
		stack = true,
		close = true,
		description = "Female fiix",
		client = {
			image = "FemaleFix.png",
		}
	},

	["WomenOutfit058"] = {
		label = "زي نسائي 058",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit058.png",
		}
	},

	["menoutfit56"] = {
		label = "ملابس الرجال 56",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit56.png",
		}
	},

	["pumpkin"] = {
		label = "اليقطين",
		weight = 250,
		stack = true,
		close = true,
		description = "اليقطين",
		client = {
			image = "pumpkin.png",
		}
	},

	["womenoutfit534"] = {
		label = "زي نسائي 534",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit534.png",
		}
	},

	["womenoutfit40"] = {
		label = "زي نسائي 40",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit40.png",
		}
	},

	["MenOutfits11"] = {
		label = "زي رجالي 11",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits11.png",
		}
	},

	["guarma_ticket"] = {
		label = "تذكرة غوارما",
		weight = 250,
		stack = true,
		close = true,
		description = "تذكرة سفر إلى غوارما.",
		client = {
			image = "guarma_ticket.png",
		}
	},

	["provision_coin_1792_quarter"] = {
		label = "1792 Quarter",
		weight = 250,
		stack = true,
		close = true,
		description = "A quarter coin from 1792.",
		client = {
			image = "provision_coin_1792_quarter.png",
		}
	},

	["menoutfit92"] = {
		label = "ملابس الرجال 92",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit92.png",
		}
	},

	["consumable_carrot"] = {
		label = "1796 Half Penny",
		weight = 250,
		stack = true,
		close = true,
		description = "A half penny coin from 1796.",
		client = {
			image = "consumable_carrot.png",
		}
	},

	["grapes_seed"] = {
		label = "بذور العنب",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور العنب",
		client = {
			image = "grapes_seed.png",
		}
	},

	["WomenOutfits21"] = {
		label = "زي نسائي 21",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits21.png",
		}
	},

	["OutfitMen148"] = {
		label = "بدلة رجالية 148",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen148.png",
		}
	},

	["s_inv_cigcard_inv_12x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 12",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #12",
		client = {
			image = "s_inv_cigcard_inv_12x.png",
		}
	},

	["pistolmold"] = {
		label = "قالب سلاح بيستول",
		weight = 250,
		stack = true,
		close = true,
		description = "قالب سلاح بيستول",
		client = {
			image = "pistolmold.png",
		}
	},

	["resource_snake_skin_western_rattlesnake_star_3"] = {
		label = "جلد أفعى الغربية المجلجلة 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_western_rattlesnake_star_3.png",
		}
	},

	["quadrochique"] = {
		label = "Quadro Chique",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "quadrochique.png",
		}
	},

	["provision_egret_feather"] = {
		label = "ريشة مالك الحزين",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة جميلة من طائر مالك الحزين.",
		client = {
			image = "provision_egret_feather.png",
		}
	},

	["poor_beaver_meat"] = {
		label = "لحم قندس رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم قندس بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_beaver_meat.png",
		}
	},

	["menoutfit103"] = {
		label = "ملابس الرجال 103",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit103.png",
		}
	},

	["provision_beaver_scentgland"] = {
		label = "غدة رائحة القندس",
		weight = 250,
		stack = true,
		close = true,
		description = "غدة تُفرز رائحة مميزة يستخدمها القندس.",
		client = {
			image = "provision_beaver_scentgland.png",
		}
	},

	["biggamemeat"] = {
		label = "لحم الحيوانات الكبيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "biggamemeat.png",
		}
	},

	["resource_pelt_skunk_star_3"] = {
		label = "فرو الظربان 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_skunk_star_3.png",
		}
	},

	["poor_skunk_pelt"] = {
		label = "فرو ظربان رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظربان بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_skunk_pelt.png",
		}
	},

	["womenoutfit749"] = {
		label = "زي نسائي 749",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit749.png",
		}
	},

	["consumable_tenn_whiskey"] = {
		label = "ويسكي تينيسي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب ويسكي تينيسي.",
		client = {
			image = "consumable_tenn_whiskey.png",
		}
	},

	["OutfitMen027"] = {
		label = "بدلة رجالية 027",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen027.png",
		}
	},

	["marijuana_joint2_5"] = {
		label = "لفافة ماريجوانا 2-5",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-5",
		client = {
			image = "marijuana_joint2_5.png",
		}
	},

	["menoutfit41"] = {
		label = "ملابس الرجال 41",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit41.png",
		}
	},

	["womenoutfit84"] = {
		label = "زي نسائي 84",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit84.png",
		}
	},

	["menoutfit93"] = {
		label = "ملابس الرجال 93",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit93.png",
		}
	},

	["womenoutfit548"] = {
		label = "زي نسائي 548",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit548.png",
		}
	},

	["provision_black_bear_fur"] = {
		label = "فراء الدب الأسود",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء سميك أسود مأخوذ من دب.",
		client = {
			image = "provision_black_bear_fur.png",
		}
	},

	["s_inv_cigcard_inv_05x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 05",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #05",
		client = {
			image = "s_inv_cigcard_inv_05x.png",
		}
	},

	["womenoutfit90"] = {
		label = "زي نسائي 90",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit90.png",
		}
	},

	["menoutfit106"] = {
		label = "ملابس الرجال 106",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit106.png",
		}
	},

	["OutfitMen053"] = {
		label = "بدلة رجالية 053",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen053.png",
		}
	},

	["provision_parrot_feather"] = {
		label = "ريشة ببغاء",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة زاهية الألوان مأخوذة من ببغاء.",
		client = {
			image = "provision_parrot_feather.png",
		}
	},

	["medium_bull_meat"] = {
		label = "لحم ثور متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_bull_meat.png",
		}
	},

	["provision_wolf_fur"] = {
		label = "فراء الذئب",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء مأخوذ من ذئب.",
		client = {
			image = "provision_wolf_fur.png",
		}
	},

	["womenoutfit456"] = {
		label = "زي نسائي 456",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit456.png",
		}
	},

	["WomenOutfit046"] = {
		label = "زي نسائي 046",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit046.png",
		}
	},

	["Rice_Seed"] = {
		label = "بذور الأرز",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات الأرز.",
		client = {
			image = "Rice_Seed.png",
		}
	},

	["oth_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "oth_news.png",
		}
	},

	["womenoutfit115"] = {
		label = "زي نسائي 115",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit115.png",
		}
	},

	["OutfitMen031"] = {
		label = "بدلة رجالية 031",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen031.png",
		}
	},

	["backpack2"] = {
		label = "حقيبة تحمل سعة 150",
		weight = 250,
		stack = false,
		close = true,
		description = "حقيبة تحمل سعة 150",
		client = {
			image = "backpack2.png",
		}
	},

	["medium_cow_meat"] = {
		label = "لحم بقرة متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بقرة بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_cow_meat.png",
		}
	},

	["tzk_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "tzk_news.png",
		}
	},

	["key_killer"] = {
		label = "مفتاح القاتل",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "key_killer.png",
		}
	},

	["weed_packed"] = {
		label = "حشيش مكيّس",
		weight = 220,
		stack = true,
		close = true,
		description = "بضاعة معدّة للبيع - لا تُمسك بها أمام القانون.",
		client = {
			image = "weed_packed.png",
		}
	},

	["snakes_a"] = {
		label = "ثعبان (a)",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان من النوع a، يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "snakes_a.png",
		}
	},

	["womenoutfit232"] = {
		label = "زي نسائي 232",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit232.png",
		}
	},

	["Tomato_Seed"] = {
		label = "بذور الطماطم",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج الطماطم",
		client = {
			image = "Tomato_Seed.png",
		}
	},

	["chipmunk_animal"] = {
		label = "سنجاب",
		weight = 250,
		stack = true,
		close = true,
		description = "سنجاب صغير يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "chipmunk_animal.png",
		}
	},

	["womenoutfit609"] = {
		label = "زي نسائي 609",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit609.png",
		}
	},

	["WomenOutfit094"] = {
		label = "زي نسائي 094",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit094.png",
		}
	},

	["hawk_feathers"] = {
		label = "ريش صقر",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش صقر يُستخدم في أعمال التصنيع.",
		client = {
			image = "hawk_feathers.png",
		}
	},

	["consumable_chewing_tobacco"] = {
		label = "تبغ مضغ",
		weight = 250,
		stack = true,
		close = true,
		description = "تبغ مضغ لاستهلاك سريع.",
		client = {
			image = "consumable_chewing_tobacco.png",
		}
	},

	["legendary_boar_pelt"] = {
		label = "فرو خنزير بري أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو خنزير بري أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_boar_pelt.png",
		}
	},

	["resource_skin_desert_iguana_star_1"] = {
		label = "جلد الإغوانا الصحراوية 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_desert_iguana_star_1.png",
		}
	},

	["MenOutfits003"] = {
		label = "زي رجالي 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits003.png",
		}
	},

	["s_inv_cigcard_grl_07x"] = {
		label = "بطاقة السجائر جواهر الجمال 07",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #07",
		client = {
			image = "s_inv_cigcard_grl_07x.png",
		}
	},

	["vasoflor"] = {
		label = "Vaso Floral",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "vasoflor.png",
		}
	},

	["womenoutfit835"] = {
		label = "زي نسائي 835",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit835.png",
		}
	},

	["womenoutfit850"] = {
		label = "زي نسائي 850",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit850.png",
		}
	},

	["poor_buffalo_pelt"] = {
		label = "فرو جاموس رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو جاموس بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_buffalo_pelt.png",
		}
	},

	["club01"] = {
		label = "عصا 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club01.png",
		}
	},

	["WomenOutfits51"] = {
		label = "زي نسائي 51",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits51.png",
		}
	},

	["machete_outlaw_005"] = {
		label = "machete outlaw 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "machete_outlaw_005.png",
		}
	},

	["Sleeppoppy_Seed"] = {
		label = "بذور الخشخاش المنوم",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات الخشخاش المنوم",
		client = {
			image = "Sleeppoppy_Seed.png",
		}
	},

	["consumable_water"] = {
		label = "ماء صالح للشرب",
		weight = 250,
		stack = true,
		close = true,
		description = "زجاجة تحتوي على ماء نقي.",
		client = {
			image = "consumable_water.png",
		}
	},

	["rollingblockprint"] = {
		label = "Rollingblock Matrice",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "rollingblockprint.png",
		}
	},

	["resource_skin_ram_star_1"] = {
		label = "جلد الكبش 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_ram_star_1.png",
		}
	},

	["WomenHats084"] = {
		label = "قبعة نسائية 084",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats084.png",
		}
	},

	["womenoutfit380"] = {
		label = "زي نسائي 380",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit380.png",
		}
	},

	["trt_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "trt_news.png",
		}
	},

	["scopeshortboltaction"] = {
		label = "Rifle Boltaction Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortboltaction.png",
		}
	},

	["poor_panther_meat"] = {
		label = "لحم نمر رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم نمر بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_panther_meat.png",
		}
	},

	["womenoutfit170"] = {
		label = "زي نسائي 170",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit170.png",
		}
	},

	["pack_cigarette_indigo"] = {
		label = "علبة سجائر إنديغو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pack_cigarette_indigo.png",
		}
	},

	["turtleshell"] = {
		label = "صدفة السلحفاة",
		weight = 250,
		stack = true,
		close = true,
		description = "صدفة السلحفاة",
		client = {
			image = "turtleshell.png",
		}
	},

	["womenoutfit779"] = {
		label = "زي نسائي 779",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit779.png",
		}
	},

	["menoutfit60"] = {
		label = "ملابس الرجال 60",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit60.png",
		}
	},

	["large_beer"] = {
		label = "بيرة كبيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "large_beer.png",
		}
	},

	["lovewheelspin"] = {
		label = "دولاب الحب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "lovewheelspin.png",
		}
	},

	["unique_cajun_gumbo"] = {
		label = "جامبو كاجون الفريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_cajun_gumbo.png",
		}
	},

	["WomenOutfit004"] = {
		label = "زي نسائي 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit004.png",
		}
	},

	["womenoutfit241"] = {
		label = "زي نسائي 241",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit241.png",
		}
	},

	["MenOutfits35"] = {
		label = "زي رجالي 35",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits35.png",
		}
	},

	["mp001_p_mp_still04x"] = {
		label = "Moonshine Still 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp001_p_mp_still04x.png",
		}
	},

	["scopeshortvarmint"] = {
		label = "Rifle Varmint Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortvarmint.png",
		}
	},

	["womenoutfit654"] = {
		label = "زي نسائي 654",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit654.png",
		}
	},

	["womenoutfit281"] = {
		label = "زي نسائي 281",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit281.png",
		}
	},

	["WomenHats083"] = {
		label = "قبعة نسائية 083",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats083.png",
		}
	},

	["wethemp_ck"] = {
		label = "Wet Cumberland Kush",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush Cumberland Mountains!",
		client = {
			image = "wethemp_ck.png",
		}
	},

	["WomenHats098"] = {
		label = "قبعة نسائية 098",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats098.png",
		}
	},

	["provision_coin_1794_silver_dollar"] = {
		label = "1794 Silver Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A silver dollar coin from 1794.",
		client = {
			image = "provision_coin_1794_silver_dollar.png",
		}
	},

	["forge_advanced"] = {
		label = "طقم التحقق من الإصابات",
		weight = 250,
		stack = true,
		close = true,
		description = "استخدم هذه المجموعة للتحقق من المصابين!",
		client = {
			image = "forge_advanced.png",
		}
	},

	["a_c_fishmuskie_01_lg"] = {
		label = "Muskie (Large)",
		weight = 4800,
		stack = true,
		close = true,
		description = "A large Muskie",
		client = {
			image = "a_c_fishmuskie_01_lg.png",
		}
	},

	["perfect_redfox_meat"] = {
		label = "لحم ثعلب أحمر ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثعلب أحمر بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_redfox_meat.png",
		}
	},

	["resource_sapphire"] = {
		label = "الياقوت",
		weight = 250,
		stack = true,
		close = true,
		description = "الياقوت",
		client = {
			image = "resource_sapphire.png",
		}
	},

	["s_inv_cigcard_lnd_04x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 04",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #04",
		client = {
			image = "s_inv_cigcard_lnd_04x.png",
		}
	},

	["clothe"] = {
		label = "ملابس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe.png",
		}
	},

	["WomenHats063"] = {
		label = "قبعة نسائية 063",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats063.png",
		}
	},

	["womenoutfit172"] = {
		label = "زي نسائي 172",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit172.png",
		}
	},

	["hat400400"] = {
		label = "Hat vip pro 2",
		weight = 250,
		stack = true,
		close = true,
		description = "Hat vip pro 2",
		client = {
			image = "hat400400.png",
		}
	},

	["womenoutfit826"] = {
		label = "زي نسائي 826",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit826.png",
		}
	},

	["medium_saligator_meat"] = {
		label = "لحم تمساح متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_saligator_meat.png",
		}
	},

	["loadouts"] = {
		label = "تجهيزات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "loadouts.png",
		}
	},

	["lumber_sticks"] = {
		label = "العصي",
		weight = 250,
		stack = true,
		close = true,
		description = "العصي",
		client = {
			image = "lumber_sticks.png",
		}
	},

	["WomenOutfits10"] = {
		label = "زي نسائي 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits10.png",
		}
	},

	["neckties"] = {
		label = "ربطات عنق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "neckties.png",
		}
	},

	["moonshine_interior4"] = {
		label = "Moonshine Interior 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_interior4.png",
		}
	},

	["magazine"] = {
		label = "مجلة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "magazine.png",
		}
	},

	["consumable_canned_vegetables"] = {
		label = "خضار معلبة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_canned_vegetables.png",
		}
	},

	["consumable_cyprus_brandy"] = {
		label = "براندي قبرصي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب البراندي القبرصي.",
		client = {
			image = "consumable_cyprus_brandy.png",
		}
	},

	["WomenHats167"] = {
		label = "قبعة نسائية 167",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats167.png",
		}
	},

	["s_inv_cigcard_art_11x"] = {
		label = "بطاقة السجائر فن 11",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #11",
		client = {
			image = "s_inv_cigcard_art_11x.png",
		}
	},

	["womenoutfit800"] = {
		label = "زي نسائي 800",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit800.png",
		}
	},

	["legendary_bhr_meat"] = {
		label = "لحم كبش أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم كبش أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_bhr_meat.png",
		}
	},

	["tgb_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "tgb_news.png",
		}
	},

	["resource_skin_buck_star_3"] = {
		label = "فراء الغزال 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buck_star_3.png",
		}
	},

	["womenoutfit279"] = {
		label = "زي نسائي 279",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit279.png",
		}
	},

	["womenoutfit580"] = {
		label = "زي نسائي 580",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit580.png",
		}
	},

	["MenOutfits09"] = {
		label = "زي رجالي 9",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits09.png",
		}
	},

	["rooster_feathers"] = {
		label = "ريش ديك",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش ديك يُستخدم في أعمال التصنيع.",
		client = {
			image = "rooster_feathers.png",
		}
	},

	["s_inv_cigcard_art_10x"] = {
		label = "بطاقة السجائر فن 10",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #10",
		client = {
			image = "s_inv_cigcard_art_10x.png",
		}
	},

	["flamehorses"] = {
		label = "أحذية اللهب",
		weight = 250,
		stack = true,
		close = true,
		description = "أحذية نارية للحصان",
		client = {
			image = "flamehorses.png",
		}
	},

	["boost2"] = {
		label = "تعزيز 2",
		weight = 250,
		stack = true,
		close = true,
		description = "تعزيز 2",
		client = {
			image = "boost2.png",
		}
	},

	["provision_coin_1800_gold_dollar"] = {
		label = "1800 Gold Dollar",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold dollar coin from 1800.",
		client = {
			image = "provision_coin_1800_gold_dollar.png",
		}
	},

	["WomenHats192"] = {
		label = "قبعة نسائية 192",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats192.png",
		}
	},

	["womenoutfit260"] = {
		label = "زي نسائي 260",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit260.png",
		}
	},

	["womenoutfit238"] = {
		label = "زي نسائي 238",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit238.png",
		}
	},

	["ammoarrmownormal"] = {
		label = "سهم عادي",
		weight = 250,
		stack = true,
		close = true,
		description = "سهم قياسي يستخدم مع الأقواس للصيد والقتال.",
		client = {
			image = "ammoarrmownormal.png",
		}
	},

	["womenoutfit189"] = {
		label = "زي نسائي 189",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit189.png",
		}
	},

	["cuthemp_mm"] = {
		label = "Trimmed Montana Mist",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the crisp air of Montana plains!",
		client = {
			image = "cuthemp_mm.png",
		}
	},

	["provision_moose_antler"] = {
		label = "قرن الموظ",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن مأخوذ من موظ بري.",
		client = {
			image = "provision_moose_antler.png",
		}
	},

	["perfect_salligatore_pelt"] = {
		label = "فرو تمساح صغير ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح صغير بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_salligatore_pelt.png",
		}
	},

	["goldnugget_small"] = {
		label = "كتلة صلبة صغيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "goldnugget_small.png",
		}
	},

	["clothe5"] = {
		label = "ملابس 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe5.png",
		}
	},

	["poor_coyote_pelt"] = {
		label = "فرو ذئب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_coyote_pelt.png",
		}
	},

	["womenoutfit77"] = {
		label = "زي نسائي 77",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit77.png",
		}
	},

	["perfect_elk_meat"] = {
		label = "لحم وعل ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم وعل بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_elk_meat.png",
		}
	},

	["tobaccoseed"] = {
		label = "بذور التبغ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tobaccoseed.png",
		}
	},

	["provision_boar_tusk"] = {
		label = "ناب الخنزير البري",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب طويل وحاد من خنزير بري.",
		client = {
			image = "provision_boar_tusk.png",
		}
	},

	["s_inv_cigcard_lnd_10x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 10",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #10",
		client = {
			image = "s_inv_cigcard_lnd_10x.png",
		}
	},

	["perfect_oxen_pelt"] = {
		label = "فرو ثور ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_oxen_pelt.png",
		}
	},

	["womenoutfit292"] = {
		label = "زي نسائي 292",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit292.png",
		}
	},

	["medium_fox_pelt"] = {
		label = "فرو ثعلب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثعلب بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_fox_pelt.png",
		}
	},

	["s_inv_cigcard_amer_06x"] = {
		label = "بطاقة السجائر أمريكي 06",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #06",
		client = {
			image = "s_inv_cigcard_amer_06x.png",
		}
	},

	["womenoutfit761"] = {
		label = "زي نسائي 761",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit761.png",
		}
	},

	["Red_Grapes_Seed"] = {
		label = "بذور العنب الأحمر",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات العنب الأحمر",
		client = {
			image = "Red_Grapes_Seed.png",
		}
	},

	["womenoutfit26"] = {
		label = "زي نسائي 26",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit26.png",
		}
	},

	["womenoutfit190"] = {
		label = "زي نسائي 190",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit190.png",
		}
	},

	["consumable_apple"] = {
		label = "تفاحة",
		weight = 250,
		stack = true,
		close = true,
		description = "تفاحة طازجة لإطعام الحصان",
		client = {
			image = "consumable_apple.png",
		}
	},

	["s_inv_cigcard_hrs_03x"] = {
		label = "بطاقة السجائر سلالات الخيول 03",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #03",
		client = {
			image = "s_inv_cigcard_hrs_03x.png",
		}
	},

	["OutfitMen089"] = {
		label = "بدلة رجالية 089",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen089.png",
		}
	},

	["mushroom"] = {
		label = "فطر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mushroom.png",
		}
	},

	["OutfitMen196"] = {
		label = "بدلة رجالية 196",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen196.png",
		}
	},

	["consumable_meal_camp_stew_daily_1"] = {
		label = "حساء المخيم اليومي",
		weight = 250,
		stack = true,
		close = true,
		description = "وجبة حساء المخيم اليومي.",
		client = {
			image = "consumable_meal_camp_stew_daily_1.png",
		}
	},

	["WomenHats147"] = {
		label = "قبعة نسائية 147",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats147.png",
		}
	},

	["OutfitMen128"] = {
		label = "بدلة رجالية 128",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen128.png",
		}
	},

	["Tea_Seed"] = {
		label = "بذور الشاي",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور الشاي هي بذور يمكن زراعتها لإنبات نبات الشاي، الذي يُستخدم في إنتاج مشروب الشاي الشهير",
		client = {
			image = "Tea_Seed.png",
		}
	},

	["s_inv_cigcard_spt_07x"] = {
		label = "بطاقة السجائر أبطال العالم 07",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #07",
		client = {
			image = "s_inv_cigcard_spt_07x.png",
		}
	},

	["scopeshortspringfield"] = {
		label = "Rifle Springfield Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortspringfield.png",
		}
	},

	["WomenOutfit027"] = {
		label = "زي نسائي 027",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit027.png",
		}
	},

	["womenoutfit220"] = {
		label = "زي نسائي 220",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit220.png",
		}
	},

	["WomenHats129"] = {
		label = "قبعة نسائية 129",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats129.png",
		}
	},

	["turtlesea_animal"] = {
		label = "سلحفاة بحرية",
		weight = 100,
		stack = true,
		close = true,
		description = "سلحفاة بحرية يمكن استخدامها في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "turtlesea_animal.png",
		}
	},

	["lhj_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "lhj_news.png",
		}
	},

	["WomenGloves010"] = {
		label = "قفازات نسائية 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves010.png",
		}
	},

	["WomenOutfit012"] = {
		label = "زي نسائي 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit012.png",
		}
	},

	["r_locker2"] = {
		label = "الخزانة 2",
		weight = 250,
		stack = true,
		close = true,
		description = "الخزانة 2",
		client = {
			image = "r_locker2.png",
		}
	},

	["horseadrenaline"] = {
		label = "أدرينalin الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "أدرينalin الحصان",
		client = {
			image = "horseadrenaline.png",
		}
	},

	["s_inv_cigcard_veh_05x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 05",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #05",
		client = {
			image = "s_inv_cigcard_veh_05x.png",
		}
	},

	["MenOutfits18"] = {
		label = "زي رجالي 18",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits18.png",
		}
	},

	["scopelongrollingblock"] = {
		label = "Sniper Rifle Rolling Block Long Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopelongrollingblock.png",
		}
	},

	["brokenweapon"] = {
		label = "Broken Weapon",
		weight = 250,
		stack = false,
		close = true,
		description = "Broken Weapon",
		client = {
			image = "brokenweapon.png",
		}
	},

	["WomenOutfit055"] = {
		label = "زي نسائي 055",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit055.png",
		}
	},

	["animal_snakeferdelance"] = {
		label = "أفعى فيردي لانس",
		weight = 250,
		stack = true,
		close = true,
		description = "أفعى فيردي لانس.",
		client = {
			image = "animal_snakeferdelance.png",
		}
	},

	["OutfitMen123"] = {
		label = "بدلة رجالية 123",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen123.png",
		}
	},

	["womenoutfit164"] = {
		label = "زي نسائي 164",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit164.png",
		}
	},

	["consumable_lemonade_raspberry"] = {
		label = "ليمونادة بالتوت",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_lemonade_raspberry.png",
		}
	},

	["Gold_For_Horse"] = {
		label = "ذهب للحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "Gold_For_Horse.png",
		}
	},

	["fan_01"] = {
		label = "مروحة يدوية",
		weight = 250,
		stack = true,
		close = true,
		description = "جهاز يدوي ذو شفرات مسطحة يُستخدم لتوفير التهوية والتبريد.",
		client = {
			image = "fan_01.png",
		}
	},

	["menoutfit5"] = {
		label = "ملابس الرجال 5",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit5.png",
		}
	},

	["resource_skin_snake_blacktail_rattlesnake_star_1"] = {
		label = "جلد أفعى ذات الذيل الأسود 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_snake_blacktail_rattlesnake_star_1.png",
		}
	},

	["WomenOutfit084"] = {
		label = "زي نسائي 084",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit084.png",
		}
	},

	["marijuana_bud2_untrimmed"] = {
		label = "برعم الماريجوانا 2 غير مقلم",
		weight = 250,
		stack = true,
		close = true,
		description = "برعم الماريجوانا 2 غير مقلم",
		client = {
			image = "marijuana_bud2_untrimmed.png",
		}
	},

	["OutfitMen104"] = {
		label = "بدلة رجالية 104",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen104.png",
		}
	},

	["OutfitMen116"] = {
		label = "بدلة رجالية 116",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen116.png",
		}
	},

	["menoutfit83"] = {
		label = "ملابس الرجال 83",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit83.png",
		}
	},

	["woman_idcard"] = {
		label = "بطاقة هوية امرأة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "woman_idcard.png",
		}
	},

	["menoutfit3"] = {
		label = "ملابس الرجال 3",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit3.png",
		}
	},

	["saddleStand_1"] = {
		label = "حامل السرج 1",
		weight = 250,
		stack = true,
		close = true,
		description = "حامل السرج 1",
		client = {
			image = "saddleStand_1.png",
		}
	},

	["r_locker10"] = {
		label = "خزنة رقم 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker10.png",
		}
	},

	["MenOutfits24"] = {
		label = "زي رجالي 24",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits24.png",
		}
	},

	["medium_panther_meat"] = {
		label = "لحم نمر متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم نمر بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_panther_meat.png",
		}
	},

	["poor_armadillo_pelt"] = {
		label = "فرو أرماديلو رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرماديلو بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_armadillo_pelt.png",
		}
	},

	["mp006_p_moonshiner_still02x"] = {
		label = "Moonshine Still 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp006_p_moonshiner_still02x.png",
		}
	},

	["WomenHats027"] = {
		label = "قبعة نسائية 027",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats027.png",
		}
	},

	["stone"] = {
		label = "حجر",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن استخدام الحجر في الصهر.",
		client = {
			image = "stone.png",
		}
	},

	["s_inv_cigcard_plt_04x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #04",
		client = {
			image = "s_inv_cigcard_plt_04x.png",
		}
	},

	["WomenBracelets001"] = {
		label = "سوار نسائي 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets001.png",
		}
	},

	["womenoutfit54"] = {
		label = "زي نسائي 54",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit54.png",
		}
	},

	["womenoutfit116"] = {
		label = "زي نسائي 116",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit116.png",
		}
	},

	["medium_raccoon_pelt"] = {
		label = "فرو راكون متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو راكون بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_raccoon_pelt.png",
		}
	},

	["provision_talisman_eagle_talon"] = {
		label = "تميمة مخلب النسر",
		weight = 250,
		stack = true,
		close = true,
		description = "تميمة مصنوعة من مخلب نسر.",
		client = {
			image = "provision_talisman_eagle_talon.png",
		}
	},

	["womenoutfit661"] = {
		label = "زي نسائي 661",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit661.png",
		}
	},

	["resource_pelt_fox_star_2"] = {
		label = "جلد الثعلب 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_fox_star_2.png",
		}
	},

	["shield04"] = {
		label = "درع 04",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield04.png",
		}
	},

	["womenoutfit618"] = {
		label = "زي نسائي 618",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit618.png",
		}
	},

	["WomenHats021"] = {
		label = "قبعة نسائية 021",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats021.png",
		}
	},

	["s_inv_cigcard_spt_04x"] = {
		label = "بطاقة السجائر أبطال العالم 04",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #04",
		client = {
			image = "s_inv_cigcard_spt_04x.png",
		}
	},

	["OutfitMen060"] = {
		label = "بدلة رجالية 060",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen060.png",
		}
	},

	["s_inv_cigcard_aml_08x"] = {
		label = "بطاقة السجائر أمل 08",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #08",
		client = {
			image = "s_inv_cigcard_aml_08x.png",
		}
	},

	["OutfitMen182"] = {
		label = "بدلة رجالية 182",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen182.png",
		}
	},

	["ce_opal_uncut"] = {
		label = "خام الأوبال",
		weight = 250,
		stack = true,
		close = true,
		description = "خام الأوبال",
		client = {
			image = "ce_opal_uncut.png",
		}
	},

	["s_inv_cigcard_hrs_05x"] = {
		label = "بطاقة السجائر سلالات الخيول 05",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #05",
		client = {
			image = "s_inv_cigcard_hrs_05x.png",
		}
	},

	["s_inv_cigcard_amer_03x"] = {
		label = "بطاقة السجائر أمريكي 03",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #03",
		client = {
			image = "s_inv_cigcard_amer_03x.png",
		}
	},

	["building_plan_3"] = {
		label = "ورقة بناء بيت 3",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_3.png",
		}
	},

	["legendary_panther_pelt"] = {
		label = "فرو نمر أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو نمر أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_panther_pelt.png",
		}
	},

	["khanja"] = {
		label = "ال جنجل",
		weight = 250,
		stack = true,
		close = true,
		description = "ال جنجل",
		client = {
			image = "khanja.png",
		}
	},

	["desert_chronic"] = {
		label = "كرونيك الصحراء",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "desert_chronic.png",
		}
	},

	["womenoutfit258"] = {
		label = "زي نسائي 258",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit258.png",
		}
	},

	["womenoutfit237"] = {
		label = "زي نسائي 237",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit237.png",
		}
	},

	["coats_heavy"] = {
		label = "معطف ثقيل",
		weight = 250,
		stack = true,
		close = true,
		description = "معطف ثقيل",
		client = {
			image = "coats_heavy.png",
		}
	},

	["consumable_toulouse_style_cassoulet"] = {
		label = "كاسولي على طريقة تولوز",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_toulouse_style_cassoulet.png",
		}
	},

	["pickaxe_silver"] = {
		label = "معول فضي",
		weight = 250,
		stack = true,
		close = true,
		description = "يجب على اللاعب أن يحمل هذا معه لتنبيه الطبيب عند إصابته!",
		client = {
			image = "pickaxe_silver.png",
		}
	},

	["WomenHats127"] = {
		label = "قبعة نسائية 127",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats127.png",
		}
	},

	["consumable_chocolate_bar"] = {
		label = "لوح شوكولاتة صالح للأكل",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح شوكولاتة مناسب للأكل.",
		client = {
			image = "consumable_chocolate_bar.png",
		}
	},

	["perfect_sheep_pelt"] = {
		label = "فرو شاة ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو شاة بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_sheep_pelt.png",
		}
	},

	["Agave_Seed"] = {
		label = "بذور الأغاف",
		weight = 250,
		stack = true,
		close = true,
		description = "بذرة يمكن زراعتها لإنبات نبات الأغاف",
		client = {
			image = "Agave_Seed.png",
		}
	},

	["WomenOutfit044"] = {
		label = "زي نسائي 044",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit044.png",
		}
	},

	["club03"] = {
		label = "عصا 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club03.png",
		}
	},

	["WomenNecklaces022"] = {
		label = "قلادة نسائية 022",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces022.png",
		}
	},

	["menoutfit45"] = {
		label = "ملابس الرجال 45",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit45.png",
		}
	},

	["womenoutfit547"] = {
		label = "زي نسائي 547",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit547.png",
		}
	},

	["WomenOutfit003"] = {
		label = "زي نسائي 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit003.png",
		}
	},

	["a_corn"] = {
		label = "ذرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_corn.png",
		}
	},

	["buck_antlers"] = {
		label = "قرون غزال",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون غزال يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "buck_antlers.png",
		}
	},

	["womenoutfit815"] = {
		label = "زي نسائي 815",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit815.png",
		}
	},

	["marijuana_joint2_1"] = {
		label = "لفافة ماريجوانا 2-1",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-1",
		client = {
			image = "marijuana_joint2_1.png",
		}
	},

	["srock"] = {
		label = "صخر صغير",
		weight = 250,
		stack = true,
		close = true,
		description = "صخور صغيرة تُستخدم في التصنيع.",
		client = {
			image = "srock.png",
		}
	},

	["MenOutfits004"] = {
		label = "زي رجالي 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits004.png",
		}
	},

	["INSERT INTO `items`(`item`, `label`, `limit`, `can"] = {
		label = "زي نسائي 34",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "INSERT INTO `items`(`item`, `label`, `limit`, `can.png",
		}
	},

	["MenOutfits030"] = {
		label = "زي رجالي 030",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits030.png",
		}
	},

	["hookah02"] = {
		label = "شيشة 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hookah02.png",
		}
	},

	["provision_legendary_buffalo_fur"] = {
		label = "فراء الجاموس الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء كثيف وقوي من جاموس أسطوري.",
		client = {
			image = "provision_legendary_buffalo_fur.png",
		}
	},

	["washcloth"] = {
		label = "قماش تنظيف",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "washcloth.png",
		}
	},

	["resource_bag_sulfur"] = {
		label = "كيس الكبريت",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس الكبريت",
		client = {
			image = "resource_bag_sulfur.png",
		}
	},

	["consumable_alcohol_candycane_cocktail"] = {
		label = "كوكتيل حلوى كحولية",
		weight = 250,
		stack = true,
		close = true,
		description = "كوكتيل حلوى كحولية",
		client = {
			image = "consumable_alcohol_candycane_cocktail.png",
		}
	},

	["womenoutfit313"] = {
		label = "زي نسائي 313",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit313.png",
		}
	},

	["bucketfull"] = {
		label = "دلو ممتلئ بالماء",
		weight = 250,
		stack = true,
		close = true,
		description = "دلو ممتلئ تمامًا بالماء العذب، ثقيل ومتين.",
		client = {
			image = "bucketfull.png",
		}
	},

	["Onion_Seed"] = {
		label = "بذور البصل",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج نبات البصل.",
		client = {
			image = "Onion_Seed.png",
		}
	},

	["pie_blueberry2"] = {
		label = "فطيرة التوت الأزرق 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pie_blueberry2.png",
		}
	},

	["bear_heart"] = {
		label = "قلب دب",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب دب بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "bear_heart.png",
		}
	},

	["womenoutfit379"] = {
		label = "زي نسائي 379",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit379.png",
		}
	},

	["womenoutfit742"] = {
		label = "زي نسائي 742",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit742.png",
		}
	},

	["poor_panther_pelt"] = {
		label = "فرو نمر رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو نمر بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_panther_pelt.png",
		}
	},

	["OutfitMen174"] = {
		label = "بدلة رجالية 174",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen174.png",
		}
	},

	["provision_beaver_tail"] = {
		label = "ذيل القندس",
		weight = 250,
		stack = true,
		close = true,
		description = "ذيل مسطح ومتقشر للقندس.",
		client = {
			image = "provision_beaver_tail.png",
		}
	},

	["womenoutfit246"] = {
		label = "زي نسائي 246",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit246.png",
		}
	},

	["jvs_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "jvs_news.png",
		}
	},

	["perfect_blackbear_meat"] = {
		label = "لحم دب أسود ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب أسود بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_blackbear_meat.png",
		}
	},

	["womenoutfit129"] = {
		label = "زي نسائي 129",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit129.png",
		}
	},

	["consumable_cigarette_box"] = {
		label = "علبة سجائر",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة سجائر للاسترخاء.",
		client = {
			image = "consumable_cigarette_box.png",
		}
	},

	["MedicalGanja"] = {
		label = "Medical Ganja",
		weight = 250,
		stack = true,
		close = true,
		description = "A medic-approved smokeable herb.",
		client = {
			image = "MedicalGanja.png",
		}
	},

	["consumable_herb_tomato"] = {
		label = "طماطم",
		weight = 250,
		stack = true,
		close = true,
		description = "طماطم",
		client = {
			image = "consumable_herb_tomato.png",
		}
	},

	["provision_trinket_duck_feather"] = {
		label = "تعويذة ريشة البط",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من ريش البط.",
		client = {
			image = "provision_trinket_duck_feather.png",
		}
	},

	["medium_bighornram_pelt"] = {
		label = "فرو كبش متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو كبش بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_bighornram_pelt.png",
		}
	},

	["womenoutfit195"] = {
		label = "زي نسائي 195",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit195.png",
		}
	},

	["WomenOutfit050"] = {
		label = "زي نسائي 050",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit050.png",
		}
	},

	["OutfitMen096"] = {
		label = "بدلة رجالية 096",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen096.png",
		}
	},

	["MenOutfits15"] = {
		label = "زي رجالي 15",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits15.png",
		}
	},

	["flag1"] = {
		label = "راية",
		weight = 250,
		stack = true,
		close = true,
		description = "راية",
		client = {
			image = "flag1.png",
		}
	},

	["menoutfit90"] = {
		label = "ملابس الرجال 90",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit90.png",
		}
	},

	["consumable_moonshine_american"] = {
		label = "لغو أمريكي",
		weight = 250,
		stack = true,
		close = true,
		description = "لغو أمريكي",
		client = {
			image = "consumable_moonshine_american.png",
		}
	},

	["s_inv_cigcard_lnd_08x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 08",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #08",
		client = {
			image = "s_inv_cigcard_lnd_08x.png",
		}
	},

	["womenoutfit134"] = {
		label = "زي نسائي 134",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit134.png",
		}
	},

	["provision_booby_feather"] = {
		label = "ريش الطائر البحري",
		weight = 250,
		stack = true,
		close = true,
		description = "ريش مأخوذ من طائر بحري.",
		client = {
			image = "provision_booby_feather.png",
		}
	},

	["shield06"] = {
		label = "درع 06",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield06.png",
		}
	},

	["Goldnugget"] = {
		label = "قطعة ذهب",
		weight = 250,
		stack = true,
		close = true,
		description = "قطعة ذهب خام",
		client = {
			image = "Goldnugget.png",
		}
	},

	["resource_skin_ram_star_3"] = {
		label = "جلد الكبش 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_ram_star_3.png",
		}
	},

	["MenOutfits10"] = {
		label = "زي رجالي 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits10.png",
		}
	},

	["WomenHats166"] = {
		label = "قبعة نسائية 166",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats166.png",
		}
	},

	["WomenOutfits06"] = {
		label = "زي نسائي 06",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits06.png",
		}
	},

	["womenoutfit69"] = {
		label = "زي نسائي 69",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit69.png",
		}
	},

	["womenoutfit700"] = {
		label = "زي نسائي 700",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit700.png",
		}
	},

	["OutfitMen136"] = {
		label = "بدلة رجالية 136",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen136.png",
		}
	},

	["saddleStand_2"] = {
		label = "حامل السرج 2",
		weight = 250,
		stack = true,
		close = true,
		description = "حامل السرج 2",
		client = {
			image = "saddleStand_2.png",
		}
	},

	["WomenHats099"] = {
		label = "قبعة نسائية 099",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats099.png",
		}
	},

	["s_inv_cigcard_gun_02x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 02",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #02",
		client = {
			image = "s_inv_cigcard_gun_02x.png",
		}
	},

	["legendary_panther_meat"] = {
		label = "لحم نمر أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم نمر أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_panther_meat.png",
		}
	},

	["WomenNecklaces020"] = {
		label = "قلادة نسائية 020",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces020.png",
		}
	},

	["perfect_sheep_meat"] = {
		label = "لحم شاة ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم شاة بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_sheep_meat.png",
		}
	},

	["menoutfit12"] = {
		label = "ملابس الرجال 12",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit12.png",
		}
	},

	["womenoutfit11"] = {
		label = "زي نسائي 11",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit11.png",
		}
	},

	["legendary_bighornram_pelt"] = {
		label = "فرو كبش أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو كبش أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_bighornram_pelt.png",
		}
	},

	["womenoutfit259"] = {
		label = "زي نسائي 259",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit259.png",
		}
	},

	["womenoutfit53"] = {
		label = "زي نسائي 53",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit53.png",
		}
	},

	["womenoutfit38"] = {
		label = "زي نسائي 38",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit38.png",
		}
	},

	["consumable_tea_yaupon"] = {
		label = "شاي يابون",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tea_yaupon.png",
		}
	},

	["womenoutfit239"] = {
		label = "زي نسائي 239",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit239.png",
		}
	},

	["WomenGloves016"] = {
		label = "قفازات نسائية 016",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves016.png",
		}
	},

	["OutfitMen180"] = {
		label = "بدلة رجالية 180",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen180.png",
		}
	},

	["shield01"] = {
		label = "درع 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield01.png",
		}
	},

	["provision_legendary_cougar_fur"] = {
		label = "فراء كوغار أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم من كوغار أسطوري.",
		client = {
			image = "provision_legendary_cougar_fur.png",
		}
	},

	["baghemp_ck"] = {
		label = "Bagged Cumberland Kush",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush Cumberland Mountains!",
		client = {
			image = "baghemp_ck.png",
		}
	},

	["WomenHats202"] = {
		label = "قبعة نسائية 202",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats202.png",
		}
	},

	["womenoutfit441"] = {
		label = "زي نسائي 441",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit441.png",
		}
	},

	["muskart_animal"] = {
		label = "فأر المسك",
		weight = 250,
		stack = true,
		close = true,
		description = "فأر المسك حيوان صغير يُصاد غالبًا من أجل الفرو واللحم.",
		client = {
			image = "muskart_animal.png",
		}
	},

	["WomenNecklaces019"] = {
		label = "قلادة نسائية 019",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces019.png",
		}
	},

	["womenoutfit125"] = {
		label = "زي نسائي 125",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit125.png",
		}
	},

	["womenoutfit447"] = {
		label = "زي نسائي 447",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit447.png",
		}
	},

	["consumable_cupcake_blueberry"] = {
		label = "كعكة التوت الأزرق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cupcake_blueberry.png",
		}
	},

	["womenoutfit135"] = {
		label = "زي نسائي 135",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit135.png",
		}
	},

	["womenoutfit421"] = {
		label = "زي نسائي 421",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit421.png",
		}
	},

	["womenoutfit623"] = {
		label = "زي نسائي 623",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit623.png",
		}
	},

	["snakes_c"] = {
		label = "ثعبان (c)",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان من النوع c، يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "snakes_c.png",
		}
	},

	["s_inv_cigcard_spt_05x"] = {
		label = "بطاقة السجائر أبطال العالم 05",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #05",
		client = {
			image = "s_inv_cigcard_spt_05x.png",
		}
	},

	["WomenOutfits54"] = {
		label = "زي نسائي 54",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits54.png",
		}
	},

	["key_gang"] = {
		label = "مفتاح العصابة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "key_gang.png",
		}
	},

	["WomenOutfits30"] = {
		label = "زي نسائي 30",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits30.png",
		}
	},

	["womenoutfit804"] = {
		label = "زي نسائي 804",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit804.png",
		}
	},

	["raven_feathers"] = {
		label = "ريش غراب",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش غراب يُستخدم في أعمال التصنيع.",
		client = {
			image = "raven_feathers.png",
		}
	},

	["womenoutfit221"] = {
		label = "زي نسائي 221",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit221.png",
		}
	},

	["poor_fox_pelt"] = {
		label = "فرو ثعلب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثعلب بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_fox_pelt.png",
		}
	},

	["menoutfit7"] = {
		label = "ملابس الرجال 7",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit7.png",
		}
	},

	["WomenOutfit023"] = {
		label = "زي نسائي 023",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit023.png",
		}
	},

	["unique_peach_tea"] = {
		label = "شاي الخوخ الفريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_peach_tea.png",
		}
	},

	["legendary_elk_meat"] = {
		label = "لحم وعل أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم وعل أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_elk_meat.png",
		}
	},

	["urs_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "urs_news.png",
		}
	},

	["womenoutfit820"] = {
		label = "زي نسائي 820",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit820.png",
		}
	},

	["OutfitMen135"] = {
		label = "بدلة رجالية 135",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen135.png",
		}
	},

	["consumable_pie_key_lime"] = {
		label = "فطيرة ليمون المفاتيح",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_pie_key_lime.png",
		}
	},

	["s_inv_cigcard_art_08x"] = {
		label = "بطاقة السجائر فن 08",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #08",
		client = {
			image = "s_inv_cigcard_art_08x.png",
		}
	},

	["provision_fox_claw"] = {
		label = "مخلب ثعلب",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب حاد مأخوذ من الثعلب.",
		client = {
			image = "provision_fox_claw.png",
		}
	},

	["menoutfit69"] = {
		label = "ملابس الرجال 69",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit69.png",
		}
	},

	["consumable_tanka_me_a_lo"] = {
		label = "تانكا مي آ لو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tanka_me_a_lo.png",
		}
	},

	["Peanut_Seed"] = {
		label = "بذور الفول السوداني",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج الفول السوداني.",
		client = {
			image = "Peanut_Seed.png",
		}
	},

	["door9"] = {
		label = "مفتاح الباب 9",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door9.png",
		}
	},

	["docfirstaidkit"] = {
		label = "طقم الإسعافات الأولية",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين المصابين لأسباب عديدة!",
		client = {
			image = "docfirstaidkit.png",
		}
	},

	["womenoutfit682"] = {
		label = "زي نسائي 682",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit682.png",
		}
	},

	["medium_elk_meat"] = {
		label = "لحم وعل متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم وعل بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_elk_meat.png",
		}
	},

	["womenoutfit235"] = {
		label = "زي نسائي 235",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit235.png",
		}
	},

	["OutfitMen068"] = {
		label = "بدلة رجالية 068",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen068.png",
		}
	},

	["Strawberry_Seed"] = {
		label = "بذور الفراولة",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات نبات الفراولة",
		client = {
			image = "Strawberry_Seed.png",
		}
	},

	["womenoutfit566"] = {
		label = "زي نسائي 566",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit566.png",
		}
	},

	["pipe_2"] = {
		label = "غليون 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pipe_2.png",
		}
	},

	["MenOutfits31"] = {
		label = "زي رجالي 31",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits31.png",
		}
	},

	["survival_guitar_004"] = {
		label = "survival guitar 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "survival_guitar_004.png",
		}
	},

	["sss_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "sss_news.png",
		}
	},

	["resource_pelt_raccoon_star_1"] = {
		label = "جلد الراكون 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_raccoon_star_1.png",
		}
	},

	["OutfitMen157"] = {
		label = "بدلة رجالية 157",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen157.png",
		}
	},

	["roupa"] = {
		label = "ملابس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "roupa.png",
		}
	},

	["provision_panther_eye"] = {
		label = "عين الفهد",
		weight = 250,
		stack = true,
		close = true,
		description = "عين ذات مظهر قوي ومخيف.",
		client = {
			image = "provision_panther_eye.png",
		}
	},

	["WomenHats052"] = {
		label = "قبعة نسائية 052",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats052.png",
		}
	},

	["rakan_hat"] = {
		label = "rakan hat",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "rakan_hat.png",
		}
	},

	["legendary_moose_antlers"] = {
		label = "قرون موظ أسطورية",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون موظ أسطورية، يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "legendary_moose_antlers.png",
		}
	},

	["rts_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "rts_news.png",
		}
	},

	["kit_horse_brush"] = {
		label = "فرشاة حصان",
		weight = 250,
		stack = true,
		close = true,
		description = "فرشاة لتنظيف وتمشيط الحصان",
		client = {
			image = "kit_horse_brush.png",
		}
	},

	["s_inv_cigcard_hrs_02x"] = {
		label = "بطاقة السجائر سلالات الخيول 02",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #02",
		client = {
			image = "s_inv_cigcard_hrs_02x.png",
		}
	},

	["cormorant_feathers"] = {
		label = "ريش غراب البحر",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش غراب البحر يُستخدم في أعمال التصنيع.",
		client = {
			image = "cormorant_feathers.png",
		}
	},

	["menoutfit75"] = {
		label = "ملابس الرجال 75",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit75.png",
		}
	},

	["WomenHats022"] = {
		label = "قبعة نسائية 022",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats022.png",
		}
	},

	["womenoutfit33"] = {
		label = "زي نسائي 33",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit33.png",
		}
	},

	["unique_ginger_ale"] = {
		label = "",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_ginger_ale.png",
		}
	},

	["stake01"] = {
		label = "وتد 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "stake01.png",
		}
	},

	["MenOutfits39"] = {
		label = "زي رجالي 39",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits39.png",
		}
	},

	["prairiechiken_feathers"] = {
		label = "ريش طائر دجاج المروج",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش طائر دجاج المروج يُستخدم في أعمال التصنيع.",
		client = {
			image = "prairiechiken_feathers.png",
		}
	},

	["menoutfit24"] = {
		label = "ملابس الرجال 24",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit24.png",
		}
	},

	["menoutfit21"] = {
		label = "ملابس الرجال 21",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit21.png",
		}
	},

	["OutfitMen122"] = {
		label = "بدلة رجالية 122",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen122.png",
		}
	},

	["WomenOutfits47"] = {
		label = "زي نسائي 47",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits47.png",
		}
	},

	["womenoutfit619"] = {
		label = "زي نسائي 619",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit619.png",
		}
	},

	["womenoutfit269"] = {
		label = "زي نسائي 269",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit269.png",
		}
	},

	["womenoutfit458"] = {
		label = "زي نسائي 458",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit458.png",
		}
	},

	["resource_skin_cougar_star_1"] = {
		label = "جلد الكوجر 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_cougar_star_1.png",
		}
	},

	["poor_salligatore_pelt"] = {
		label = "فرو تمساح صغير رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح صغير بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_salligatore_pelt.png",
		}
	},

	["WomenHats143"] = {
		label = "قبعة نسائية 143",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats143.png",
		}
	},

	["womenoutfit787"] = {
		label = "زي نسائي 787",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit787.png",
		}
	},

	["WOLF_VAR_002"] = {
		label = "ذئب أسطوري رمادي",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب أسطوري رمادي.",
		client = {
			image = "WOLF_VAR_002.png",
		}
	},

	["hbtrh_np"] = {
		label = "HBTRH NP",
		weight = 250,
		stack = true,
		close = true,
		description = "HBTRH NP",
		client = {
			image = "hbtrh_np.png",
		}
	},

	["join"] = {
		label = "سيجارة حشيش",
		weight = 250,
		stack = true,
		close = true,
		description = "سيجارة حشيش",
		client = {
			image = "join.png",
		}
	},

	["accessories"] = {
		label = "إكسسوارات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "accessories.png",
		}
	},

	["blanketwolf"] = {
		label = "بطانية ذئب",
		weight = 250,
		stack = true,
		close = true,
		description = "بطانية ذئب للحصان",
		client = {
			image = "blanketwolf.png",
		}
	},

	["clothe8"] = {
		label = "ملابس 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe8.png",
		}
	},

	["empty_mud_bucket"] = {
		label = "دلو طين فارغ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "empty_mud_bucket.png",
		}
	},

	["katana01"] = {
		label = "كاتانا 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana01.png",
		}
	},

	["womenoutfit643"] = {
		label = "زي نسائي 643",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit643.png",
		}
	},

	["WomenOutfit075"] = {
		label = "زي نسائي 075",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit075.png",
		}
	},

	["womenoutfit179"] = {
		label = "زي نسائي 179",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit179.png",
		}
	},

	["OutfitMen088"] = {
		label = "بدلة رجالية 088",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen088.png",
		}
	},

	["poor_bigalligatore_pelt"] = {
		label = "فرو تمساح ضخم رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح ضخم بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_bigalligatore_pelt.png",
		}
	},

	["pickaxe_steel"] = {
		label = "معول فولاذي",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين بعد تعرضهم لإطلاق نار!",
		client = {
			image = "pickaxe_steel.png",
		}
	},

	["womenoutfit536"] = {
		label = "زي نسائي 536",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit536.png",
		}
	},

	["OutfitMen185"] = {
		label = "بدلة رجالية 185",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen185.png",
		}
	},

	["WomenOutfit069"] = {
		label = "زي نسائي 069",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit069.png",
		}
	},

	["xpbook"] = {
		label = "Experience Book",
		weight = 250,
		stack = true,
		close = true,
		description = "A jack of all trades is a master of none, but often times better than a master of one..",
		client = {
			image = "xpbook.png",
		}
	},

	["ammohatchethunter"] = {
		label = "ذخيرة فأس الصياد",
		weight = 250,
		stack = true,
		close = true,
		description = "ذخيرة فأس الصياد.",
		client = {
			image = "ammohatchethunter.png",
		}
	},

	["s_inv_cigcard_amer_08x"] = {
		label = "بطاقة السجائر أمريكي 08",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #08",
		client = {
			image = "s_inv_cigcard_amer_08x.png",
		}
	},

	["perfect_boar_pelt"] = {
		label = "فرو خنزير بري ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو خنزير بري بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_boar_pelt.png",
		}
	},

	["wethemp_rd"] = {
		label = "Wet Roanoke Dream",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp originating from the rugged Roanoke Ridge!",
		client = {
			image = "wethemp_rd.png",
		}
	},

	["roseateseagull_feathers"] = {
		label = "ريش نورس وردي",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش نورس وردي يُستخدم في أعمال التصنيع.",
		client = {
			image = "roseateseagull_feathers.png",
		}
	},

	["poor_cow_pelt"] = {
		label = "فرو بقرة رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بقرة بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_cow_pelt.png",
		}
	},

	["eaglefliesoutfit"] = {
		label = "زي إيجل فلايز",
		weight = 250,
		stack = false,
		close = true,
		description = "زي إيجل فلايز.",
		client = {
			image = "eaglefliesoutfit.png",
		}
	},

	["wethemp_mm"] = {
		label = "Wet Montana Mist",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the crisp air of Montana plains!",
		client = {
			image = "wethemp_mm.png",
		}
	},

	["cvb_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "cvb_news.png",
		}
	},

	["consumable_fishnchips"] = {
		label = "سمك ورقائق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_fishnchips.png",
		}
	},

	["tabbaco_chicha_doubleappel"] = {
		label = "تبغ شيشة تفاحتين",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tabbaco_chicha_doubleappel.png",
		}
	},

	["womenoutfit219"] = {
		label = "زي نسائي 219",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit219.png",
		}
	},

	["man_idcard"] = {
		label = "بطاقة هوية رجل",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "man_idcard.png",
		}
	},

	["MenOutfits011"] = {
		label = "زي رجالي 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits011.png",
		}
	},

	["ygv_news"] = {
		label = "جريدة الحساويه",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "ygv_news.png",
		}
	},

	["womenoutfit309"] = {
		label = "زي نسائي 309",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit309.png",
		}
	},

	["womenoutfit319"] = {
		label = "زي نسائي 319",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit319.png",
		}
	},

	["WomenHats095"] = {
		label = "قبعة نسائية 095",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats095.png",
		}
	},

	["medium_beaver_pelt"] = {
		label = "فرو قندس متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو قندس بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_beaver_pelt.png",
		}
	},

	["womenoutfit146"] = {
		label = "زي نسائي 146",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit146.png",
		}
	},

	["perfect_bear_meat"] = {
		label = "لحم دب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_bear_meat.png",
		}
	},

	["docanimalkit"] = {
		label = "طقم طبي للحيوانات",
		weight = 250,
		stack = true,
		close = true,
		description = "يجب أن يكون متوفرًا طوال الوقت، لوجود الكثير من الثعابين في المنطقة!",
		client = {
			image = "docanimalkit.png",
		}
	},

	["MenOutfits34"] = {
		label = "زي رجالي 34",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits34.png",
		}
	},

	["blanketbear"] = {
		label = "بطانية دب",
		weight = 250,
		stack = true,
		close = true,
		description = "بطانية دب للحصان",
		client = {
			image = "blanketbear.png",
		}
	},

	["consumable_biscuits"] = {
		label = "بسكويت",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_biscuits.png",
		}
	},

	["WomenGloves011"] = {
		label = "قفازات نسائية 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves011.png",
		}
	},

	["WomenHats176"] = {
		label = "قبعة نسائية 176",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats176.png",
		}
	},

	["womenoutfit320"] = {
		label = "زي نسائي 320",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit320.png",
		}
	},

	["womenoutfit71"] = {
		label = "زي نسائي 71",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit71.png",
		}
	},

	["s_inv_cigcard_plt_08x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #08",
		client = {
			image = "s_inv_cigcard_plt_08x.png",
		}
	},

	["medium_deer_pelt"] = {
		label = "فرو غزال متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_deer_pelt.png",
		}
	},

	["womenoutfit302"] = {
		label = "زي نسائي 302",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit302.png",
		}
	},

	["m_badge"] = {
		label = "Marshal Badge",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "m_badge.png",
		}
	},

	["l_badge"] = {
		label = "Sheriff Badge",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "l_badge.png",
		}
	},

	["resource_skin_armadillo_star_3"] = {
		label = "فرو الأرماديلو 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_armadillo_star_3.png",
		}
	},

	["OutfitMen158"] = {
		label = "بدلة رجالية 158",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen158.png",
		}
	},

	["crowbar01"] = {
		label = "مرفاع 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "crowbar01.png",
		}
	},

	["s_inv_cigcard_amer_01x"] = {
		label = "بطاقة السجائر أمريكي 01",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #01",
		client = {
			image = "s_inv_cigcard_amer_01x.png",
		}
	},

	["resource_pelt_opossum_star_1"] = {
		label = "جلد الأبوسوم 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_opossum_star_1.png",
		}
	},

	["clothe9"] = {
		label = "ملابس 9",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe9.png",
		}
	},

	["horselist"] = {
		label = "دفتر الخيول",
		weight = 250,
		stack = true,
		close = true,
		description = "قائمة خيول المدربين",
		client = {
			image = "horselist.png",
		}
	},

	["womenoutfit138"] = {
		label = "زي نسائي 138",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit138.png",
		}
	},

	["s_inv_cigcard_act_12x"] = {
		label = "بطاقة السجائر 12",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 12",
		client = {
			image = "s_inv_cigcard_act_12x.png",
		}
	},

	["perfect_bighornram_pelt"] = {
		label = "فرو كبش ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو كبش بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_bighornram_pelt.png",
		}
	},

	["ktf_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "ktf_news.png",
		}
	},

	["provision_wedding_ring"] = {
		label = "خاتم زواج",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم الزواج",
		client = {
			image = "provision_wedding_ring.png",
		}
	},

	["menoutfit98"] = {
		label = "ملابس الرجال 98",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit98.png",
		}
	},

	["womenoutfit310"] = {
		label = "زي نسائي 310",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit310.png",
		}
	},

	["pack_cigarette"] = {
		label = "علبة سجائر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pack_cigarette.png",
		}
	},

	["qaz_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "qaz_news.png",
		}
	},

	["stampilabilet"] = {
		label = "ختم التذكرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "stampilabilet.png",
		}
	},

	["consumable_meat_mutton_cooked"] = {
		label = "لحم خروف مشوي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_meat_mutton_cooked.png",
		}
	},

	["OutfitMen131"] = {
		label = "بدلة رجالية 131",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen131.png",
		}
	},

	["WomenGloves003"] = {
		label = "قفازات نسائية 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves003.png",
		}
	},

	["womenoutfit344"] = {
		label = "زي نسائي 344",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit344.png",
		}
	},

	["club04"] = {
		label = "عصا 04",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club04.png",
		}
	},

	["resource_ruby_uncut"] = {
		label = "ياقوت غير مقطوع",
		weight = 250,
		stack = true,
		close = true,
		description = "ياقوت غير مقطوع",
		client = {
			image = "resource_ruby_uncut.png",
		}
	},

	["womenoutfit706"] = {
		label = "زي نسائي 706",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit706.png",
		}
	},

	["OutfitMen082"] = {
		label = "بدلة رجالية 082",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen082.png",
		}
	},

	["WomenOutfits31"] = {
		label = "زي نسائي 31",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits31.png",
		}
	},

	["womenoutfit809"] = {
		label = "زي نسائي 809",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit809.png",
		}
	},

	["OutfitMen192"] = {
		label = "بدلة رجالية 192",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen192.png",
		}
	},

	["shoptoken"] = {
		label = "رمز المتجر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shoptoken.png",
		}
	},

	["WomenOutfit054"] = {
		label = "زي نسائي 054",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit054.png",
		}
	},

	["s_inv_cigcard_amer_10x"] = {
		label = "بطاقة السجائر أمريكي 10",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #10",
		client = {
			image = "s_inv_cigcard_amer_10x.png",
		}
	},

	["OutfitMen077"] = {
		label = "بدلة رجالية 077",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen077.png",
		}
	},

	["womenoutfit295"] = {
		label = "زي نسائي 295",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit295.png",
		}
	},

	["menoutfit100"] = {
		label = "ملابس الرجال 100",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit100.png",
		}
	},

	["womenoutfit473"] = {
		label = "زي نسائي 473",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit473.png",
		}
	},

	["s_inv_cigcard_plt_09x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #09",
		client = {
			image = "s_inv_cigcard_plt_09x.png",
		}
	},

	["marijuana_joint1_4"] = {
		label = "لفافة ماريجوانا 1-4",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-4",
		client = {
			image = "marijuana_joint1_4.png",
		}
	},

	["OutfitMen100"] = {
		label = "بدلة رجالية 100",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen100.png",
		}
	},

	["dryhemp_md"] = {
		label = "Dry Mountain Dew",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp collected from the misty heights of the mountains!",
		client = {
			image = "dryhemp_md.png",
		}
	},

	["womenoutfit491"] = {
		label = "زي نسائي 491",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit491.png",
		}
	},

	["smoke_campfire"] = {
		label = "دخان نار المخيم",
		weight = 250,
		stack = true,
		close = true,
		description = "دخان نار المخيم",
		client = {
			image = "smoke_campfire.png",
		}
	},

	["powerpatata"] = {
		label = "مخفوق البطاطا",
		weight = 250,
		stack = true,
		close = true,
		description = "مخفوق البطاطا",
		client = {
			image = "powerpatata.png",
		}
	},

	["meduim_panther_pelt"] = {
		label = "فرو نمر متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو نمر بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "meduim_panther_pelt.png",
		}
	},

	["medium_armadillo_pelt"] = {
		label = "فرو أرماديلو متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرماديلو بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_armadillo_pelt.png",
		}
	},

	["medium_coyote_meat"] = {
		label = "لحم ذئب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_coyote_meat.png",
		}
	},

	["weapontable"] = {
		label = "تصنيع الأسلحة",
		weight = 250,
		stack = true,
		close = true,
		description = "كتاب لتعلم تصنيع الأسلحة.",
		client = {
			image = "weapontable.png",
		}
	},

	["WomenOutfit028"] = {
		label = "زي نسائي 028",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit028.png",
		}
	},

	["womenoutfit30"] = {
		label = "زي نسائي 30",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit30.png",
		}
	},

	["sword03"] = {
		label = "سيف 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sword03.png",
		}
	},

	["consumable_jello_blueberry"] = {
		label = "جيلو التوت الأزرق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_jello_blueberry.png",
		}
	},

	["perfect_oxen_meat"] = {
		label = "لحم ثور ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_oxen_meat.png",
		}
	},

	["perfect_bull_meat"] = {
		label = "لحم ثور ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_bull_meat.png",
		}
	},

	["s_inv_cigcard_inv_06x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 06",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #06",
		client = {
			image = "s_inv_cigcard_inv_06x.png",
		}
	},

	["menoutfit15"] = {
		label = "ملابس الرجال 15",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit15.png",
		}
	},

	["womenoutfit537"] = {
		label = "زي نسائي 537",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit537.png",
		}
	},

	["provision_muskrat_fur"] = {
		label = "فراء الجرذ المسكي",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء مأخوذ من جرذ مسكي.",
		client = {
			image = "provision_muskrat_fur.png",
		}
	},

	["WomenHats085"] = {
		label = "قبعة نسائية 085",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats085.png",
		}
	},

	["consumable_med_special"] = {
		label = "طعام طبي خاص",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_med_special.png",
		}
	},

	["OutfitMen164"] = {
		label = "بدلة رجالية 164",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen164.png",
		}
	},

	["MenOutfits07"] = {
		label = "زي رجالي 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits07.png",
		}
	},

	["hair_accessories"] = {
		label = "إكسسوارات الشعر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hair_accessories.png",
		}
	},

	["ring_almas"] = {
		label = "خاتم ألماس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ring_almas.png",
		}
	},

	["WomenBracelets007"] = {
		label = "سوار نسائي 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets007.png",
		}
	},

	["WomenHats080"] = {
		label = "قبعة نسائية 080",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats080.png",
		}
	},

	["WomenHats032"] = {
		label = "قبعة نسائية 032",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats032.png",
		}
	},

	["sfv_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "sfv_news.png",
		}
	},

	["OutfitMen163"] = {
		label = "بدلة رجالية 163",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen163.png",
		}
	},

	["katana07"] = {
		label = "كاتانا 07",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana07.png",
		}
	},

	["poor_wolf_pelt"] = {
		label = "فرو ذئب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_wolf_pelt.png",
		}
	},

	["resource_pelt_wolf_star_1"] = {
		label = "جلد الذئب 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_wolf_star_1.png",
		}
	},

	["consumable_iced_coffee_sugar"] = {
		label = "قهوة مثلجة بالسكر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_iced_coffee_sugar.png",
		}
	},

	["OutfitMen179"] = {
		label = "بدلة رجالية 179",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen179.png",
		}
	},

	["resource_iron_extract"] = {
		label = "البارود",
		weight = 250,
		stack = true,
		close = true,
		description = "البارود ",
		client = {
			image = "resource_iron_extract.png",
		}
	},

	["menoutfit73"] = {
		label = "ملابس الرجال 73",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit73.png",
		}
	},

	["brass_ore"] = {
		label = "خام النحاس",
		weight = 250,
		stack = true,
		close = true,
		description = "خام النحاس",
		client = {
			image = "brass_ore.png",
		}
	},

	["sword05"] = {
		label = "سيف 05",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sword05.png",
		}
	},

	["resource_bone"] = {
		label = "عظم",
		weight = 250,
		stack = true,
		close = true,
		description = "عظم",
		client = {
			image = "resource_bone.png",
		}
	},

	["OutfitMen195"] = {
		label = "بدلة رجالية 195",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen195.png",
		}
	},

	["scopeshortrollingblock"] = {
		label = "Sniper Rifle Rolling Block Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortrollingblock.png",
		}
	},

	["unique_helper"] = {
		label = "مساعد فريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_helper.png",
		}
	},

	["tattoomachine"] = {
		label = "آلة الوشم",
		weight = 250,
		stack = true,
		close = true,
		description = "آلة الوشم",
		client = {
			image = "tattoomachine.png",
		}
	},

	["menoutfit74"] = {
		label = "ملابس الرجال 74",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit74.png",
		}
	},

	["animal_poop_bag"] = {
		label = "فتات التربة ",
		weight = 250,
		stack = true,
		close = true,
		description = "فتات التربة ",
		client = {
			image = "animal_poop_bag.png",
		}
	},

	["womenoutfit183"] = {
		label = "زي نسائي 183",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit183.png",
		}
	},

	["WomenOutfit087"] = {
		label = "زي نسائي 087",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit087.png",
		}
	},

	["womenoutfit430"] = {
		label = "زي نسائي 430",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit430.png",
		}
	},

	["belt_buckles"] = {
		label = "دبابيس الأحزمة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "belt_buckles.png",
		}
	},

	["baghemp_is"] = {
		label = "Bagged Indigenous Sativa",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp grown from native strains in pristine environments!",
		client = {
			image = "baghemp_is.png",
		}
	},

	["zzz_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "zzz_news.png",
		}
	},

	["womenoutfit278"] = {
		label = "زي نسائي 278",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit278.png",
		}
	},

	["s_inv_cigcard_plt_03x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #03",
		client = {
			image = "s_inv_cigcard_plt_03x.png",
		}
	},

	["yty_news"] = {
		label = "جريدة عبدالله",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "yty_news.png",
		}
	},

	["menoutfit10"] = {
		label = "ملابس الرجال 10",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit10.png",
		}
	},

	["WomenOutfit078"] = {
		label = "زي نسائي 078",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit078.png",
		}
	},

	["WomenOutfits14"] = {
		label = "زي نسائي 14",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits14.png",
		}
	},

	["X"] = {
		label = "X",
		weight = 250,
		stack = true,
		close = true,
		description = "X",
		client = {
			image = "X.png",
		}
	},

	["womenoutfit201"] = {
		label = "زي نسائي 201",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit201.png",
		}
	},

	["egret_feathers"] = {
		label = "ريش بلشون",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش بلشون يُستخدم في أعمال التصنيع.",
		client = {
			image = "egret_feathers.png",
		}
	},

	["consumable_donut2"] = {
		label = "دونات 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut2.png",
		}
	},

	["baking_pie_plate"] = {
		label = "طبق فطيرة الخبز",
		weight = 250,
		stack = true,
		close = true,
		description = "طبق فطيرة الخبز",
		client = {
			image = "baking_pie_plate.png",
		}
	},

	["legendary_buck_pelt"] = {
		label = "فرو غزال أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_buck_pelt.png",
		}
	},

	["legendary_coyote_pelt"] = {
		label = "فرو ذئب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_coyote_pelt.png",
		}
	},

	["www_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "www_news.png",
		}
	},

	["WomenHats091"] = {
		label = "قبعة نسائية 091",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats091.png",
		}
	},

	["MenOutfits034"] = {
		label = "زي رجالي 034",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits034.png",
		}
	},

	["menoutfit68"] = {
		label = "ملابس الرجال 68",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit68.png",
		}
	},

	["sword04"] = {
		label = "سيف 04",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sword04.png",
		}
	},

	["woodplaner"] = {
		label = "مسوي الخشب",
		weight = 250,
		stack = true,
		close = true,
		description = "مسوي الخشب",
		client = {
			image = "woodplaner.png",
		}
	},

	["womenoutfit113"] = {
		label = "زي نسائي 113",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit113.png",
		}
	},

	["woodpeice"] = {
		label = "قطعة خشب",
		weight = 250,
		stack = false,
		close = true,
		description = "يمكن استخدام قطعة الخشب في مهنة الحطاب.",
		client = {
			image = "woodpeice.png",
		}
	},

	["woodhandle"] = {
		label = "مقبض خشبي",
		weight = 250,
		stack = true,
		close = true,
		description = "مقبض خشبي",
		client = {
			image = "woodhandle.png",
		}
	},

	["OutfitMen137"] = {
		label = "بدلة رجالية 137",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen137.png",
		}
	},

	["WomenShawls006"] = {
		label = "شال نسائي 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls006.png",
		}
	},

	["WomenShawls005"] = {
		label = "شال نسائي 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls005.png",
		}
	},

	["menoutfit4"] = {
		label = "ملابس الرجال 4",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit4.png",
		}
	},

	["WomenShawls004"] = {
		label = "شال نسائي 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls004.png",
		}
	},

	["miningdynamite"] = {
		label = "طقم طبي للحيوانات",
		weight = 250,
		stack = true,
		close = true,
		description = "يجب أن يكون متوفرًا طوال الوقت، لوجود الكثير من الثعابين في المنطقة!",
		client = {
			image = "miningdynamite.png",
		}
	},

	["WomenShawls003"] = {
		label = "شال نسائي 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls003.png",
		}
	},

	["womenoutfit327"] = {
		label = "زي نسائي 327",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit327.png",
		}
	},

	["womenoutfit255"] = {
		label = "زي نسائي 255",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit255.png",
		}
	},

	["poor_boar_meat"] = {
		label = "لحم خنزير بري رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم خنزير بري بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_boar_meat.png",
		}
	},

	["animal_cedarwaxwing"] = {
		label = "طائر السيدار واكسوينج",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر السيدار واكسوينج.",
		client = {
			image = "animal_cedarwaxwing.png",
		}
	},

	["WomenShawls001"] = {
		label = "شال نسائي 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls001.png",
		}
	},

	["WomenOutfits56"] = {
		label = "زي نسائي 56",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits56.png",
		}
	},

	["fish_map"] = {
		label = "خريطة الصيد",
		weight = 250,
		stack = true,
		close = true,
		description = "خريطة توضح أماكن الصيد",
		client = {
			image = "fish_map.png",
		}
	},

	["pumpkinseeds"] = {
		label = "بذور اليقطين",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور اليقطين",
		client = {
			image = "pumpkinseeds.png",
		}
	},

	["WomenNecklaces009"] = {
		label = "قلادة نسائية 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces009.png",
		}
	},

	["s_inv_cigcard_act_01x"] = {
		label = "بطاقة السجائر 01",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 01",
		client = {
			image = "s_inv_cigcard_act_01x.png",
		}
	},

	["provision_legendary_beaver_tail"] = {
		label = "ذيل قندس أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "ذيل قندس أسطوري متين.",
		client = {
			image = "provision_legendary_beaver_tail.png",
		}
	},

	["medium_bear_pelt"] = {
		label = "فرو دب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_bear_pelt.png",
		}
	},

	["big_firecracker"] = {
		label = "مفرقعة نارية كبيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "مفرقعة نارية كبيرة",
		client = {
			image = "big_firecracker.png",
		}
	},

	["WomenOutfits50"] = {
		label = "زي نسائي 50",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits50.png",
		}
	},

	["womenoutfit645"] = {
		label = "زي نسائي 645",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit645.png",
		}
	},

	["menoutfit99"] = {
		label = "ملابس الرجال 99",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit99.png",
		}
	},

	["WomenOutfits49"] = {
		label = "زي نسائي 49",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits49.png",
		}
	},

	["animal_poop2"] = {
		label = "التربة",
		weight = 250,
		stack = true,
		close = true,
		description = "التربة",
		client = {
			image = "animal_poop2.png",
		}
	},

	["WomenOutfits46"] = {
		label = "زي نسائي 46",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits46.png",
		}
	},

	["WomenOutfits45"] = {
		label = "زي نسائي 45",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits45.png",
		}
	},

	["consumable_taco"] = {
		label = "تاكو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_taco.png",
		}
	},

	["womenoutfit4"] = {
		label = "زي نسائي 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit4.png",
		}
	},

	["womenoutfit385"] = {
		label = "زي نسائي 385",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit385.png",
		}
	},

	["WomenOutfits43"] = {
		label = "زي نسائي 43",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits43.png",
		}
	},

	["meduim_salligatore_pelt"] = {
		label = "فرو تمساح صغير متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح صغير بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "meduim_salligatore_pelt.png",
		}
	},

	["resource_bag_rock"] = {
		label = "كيس الصخور",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس الصخور",
		client = {
			image = "resource_bag_rock.png",
		}
	},

	["horsearrow"] = {
		label = "سهام الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "سهام مرفقة بالحصان",
		client = {
			image = "horsearrow.png",
		}
	},

	["froglegs"] = {
		label = "سيقان الضفدع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "froglegs.png",
		}
	},

	["horseloadout4"] = {
		label = "حمولة حصان 4",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout4.png",
		}
	},

	["WomenOutfits42"] = {
		label = "زي نسائي 42",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits42.png",
		}
	},

	["WomenOutfit071"] = {
		label = "زي نسائي 071",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit071.png",
		}
	},

	["WomenOutfits41"] = {
		label = "زي نسائي 41",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits41.png",
		}
	},

	["WomenOutfits40"] = {
		label = "زي نسائي 40",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits40.png",
		}
	},

	["womenoutfit181"] = {
		label = "زي نسائي 181",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit181.png",
		}
	},

	["OutfitMen186"] = {
		label = "بدلة رجالية 186",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen186.png",
		}
	},

	["ban3"] = {
		label = "باندانا 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ban3.png",
		}
	},

	["s_inv_cigcard_grl_05x"] = {
		label = "بطاقة السجائر جواهر الجمال 05",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #05",
		client = {
			image = "s_inv_cigcard_grl_05x.png",
		}
	},

	["womenoutfit773"] = {
		label = "زي نسائي 773",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit773.png",
		}
	},

	["WomenOutfits38"] = {
		label = "زي نسائي 38",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits38.png",
		}
	},

	["MenOutfits008"] = {
		label = "زي رجالي 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits008.png",
		}
	},

	["WomenOutfits37"] = {
		label = "زي نسائي 37",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits37.png",
		}
	},

	["perfect_coyote_pelt"] = {
		label = "فرو ذئب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_coyote_pelt.png",
		}
	},

	["WomenOutfits18"] = {
		label = "زي نسائي 18",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits18.png",
		}
	},

	["WomenOutfits35"] = {
		label = "زي نسائي 35",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits35.png",
		}
	},

	["consumable_bread7"] = {
		label = "خبز 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_bread7.png",
		}
	},

	["womenoutfit851"] = {
		label = "زي نسائي 851",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit851.png",
		}
	},

	["mnb_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "mnb_news.png",
		}
	},

	["WomenOutfits32"] = {
		label = "زي نسائي 32",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits32.png",
		}
	},

	["provision_legendary_cougar_fang"] = {
		label = "ناب كوغار أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب قوي من كوغار أسطوري.",
		client = {
			image = "provision_legendary_cougar_fang.png",
		}
	},

	["bee_house_gk_4"] = {
		label = "بيت النحل 4",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 4",
		client = {
			image = "bee_house_gk_4.png",
		}
	},

	["WomenOutfits28"] = {
		label = "زي نسائي 28",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits28.png",
		}
	},

	["WomenOutfits27"] = {
		label = "زي نسائي 27",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits27.png",
		}
	},

	["WomenOutfits26"] = {
		label = "زي نسائي 26",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits26.png",
		}
	},

	["WomenHats204"] = {
		label = "قبعة نسائية 204",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats204.png",
		}
	},

	["WomenOutfits23"] = {
		label = "زي نسائي 23",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits23.png",
		}
	},

	["MenOutfits23"] = {
		label = "زي رجالي 23",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits23.png",
		}
	},

	["WomenOutfits22"] = {
		label = "زي نسائي 22",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits22.png",
		}
	},

	["baghemp_dc"] = {
		label = "Bagged Desert Cough",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the arid and resilient desert landscapes!",
		client = {
			image = "baghemp_dc.png",
		}
	},

	["consumable_milkshake_chocolate"] = {
		label = "شوكولاتة الحليب",
		weight = 250,
		stack = true,
		close = true,
		description = "شوكولاتة الحليب",
		client = {
			image = "consumable_milkshake_chocolate.png",
		}
	},

	["WomenOutfits36"] = {
		label = "زي نسائي 36",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits36.png",
		}
	},

	["weed_sorted"] = {
		label = "حشيش مفروز",
		weight = 180,
		stack = true,
		close = true,
		description = "نُقّي ونُظّف؛ جاهز للتكييس.",
		client = {
			image = "weed_sorted.png",
		}
	},

	["womenoutfit207"] = {
		label = "زي نسائي 207",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit207.png",
		}
	},

	["WomenHats187"] = {
		label = "قبعة نسائية 187",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats187.png",
		}
	},

	["provision_eagle_talon"] = {
		label = "مخلب نسر",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب حاد من نسر.",
		client = {
			image = "provision_eagle_talon.png",
		}
	},

	["OutfitMen080"] = {
		label = "بدلة رجالية 080",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen080.png",
		}
	},

	["poor_deer_pelt"] = {
		label = "فرو غزال رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_deer_pelt.png",
		}
	},

	["womenoutfit280"] = {
		label = "زي نسائي 280",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit280.png",
		}
	},

	["WomenBracelets010"] = {
		label = "سوار نسائي 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets010.png",
		}
	},

	["WomenGloves015"] = {
		label = "قفازات نسائية 015",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves015.png",
		}
	},

	["perfect_panther_pelt"] = {
		label = "فرو نمر ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو نمر بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_panther_pelt.png",
		}
	},

	["WomenOutfits15"] = {
		label = "زي نسائي 15",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits15.png",
		}
	},

	["rijalkanon"] = {
		label = "اعلان  رجال قانون",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "rijalkanon.png",
		}
	},

	["xmashat"] = {
		label = "Xmas Hat",
		weight = 250,
		stack = true,
		close = true,
		description = "Xmas Hat",
		client = {
			image = "xmashat.png",
		}
	},

	["WomenOutfits12"] = {
		label = "زي نسائي 12",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits12.png",
		}
	},

	["WomenHats183"] = {
		label = "قبعة نسائية 183",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats183.png",
		}
	},

	["WomenOutfits11"] = {
		label = "زي نسائي 11",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits11.png",
		}
	},

	["WomenHats042"] = {
		label = "قبعة نسائية 042",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats042.png",
		}
	},

	["hammer02"] = {
		label = "مطرقة 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hammer02.png",
		}
	},

	["WomenOutfits09"] = {
		label = "زي نسائي 09",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits09.png",
		}
	},

	["dryhemp_sp"] = {
		label = "Dry Scarlett Purp",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the vibrant Meadows of Scarlett!",
		client = {
			image = "dryhemp_sp.png",
		}
	},

	["WomenOutfits08"] = {
		label = "زي نسائي 08",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits08.png",
		}
	},

	["WomenOutfit064"] = {
		label = "زي نسائي 064",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit064.png",
		}
	},

	["womenoutfit559"] = {
		label = "زي نسائي 559",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit559.png",
		}
	},

	["s_inv_cigcard_aml_12x"] = {
		label = "بطاقة السجائر أمل 12",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #12",
		client = {
			image = "s_inv_cigcard_aml_12x.png",
		}
	},

	["WomenOutfits04"] = {
		label = "زي نسائي 04",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits04.png",
		}
	},

	["consumable_cupcake_cherry_chocolate"] = {
		label = "كعكة الكرز والشوكولاتة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cupcake_cherry_chocolate.png",
		}
	},

	["consumable_londry_gin"] = {
		label = "جين لندن دراي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب جين لندن دراي.",
		client = {
			image = "consumable_londry_gin.png",
		}
	},

	["WomenOutfits03"] = {
		label = "زي نسائي 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits03.png",
		}
	},

	["WomenBracelets003"] = {
		label = "سوار نسائي 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets003.png",
		}
	},

	["WomenHats128"] = {
		label = "قبعة نسائية 128",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats128.png",
		}
	},

	["grape"] = {
		label = "عنب",
		weight = 250,
		stack = true,
		close = true,
		description = "فاكهة لذيذة تنمو في عناقيد، تُستخدم غالبًا لصنع النبيذ.",
		client = {
			image = "grape.png",
		}
	},

	["goldtable"] = {
		label = "طاولة مستكشف الذهب",
		weight = 250,
		stack = true,
		close = true,
		description = "مستكشف الذهب هو خبير في التعدين والاستكشاف المتخصص في البحث عن رواسب الذهب.",
		client = {
			image = "goldtable.png",
		}
	},

	["womenoutfit297"] = {
		label = "زي نسائي 297",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit297.png",
		}
	},

	["womenoutfit606"] = {
		label = "زي نسائي 606",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit606.png",
		}
	},

	["womenoutfit99"] = {
		label = "زي نسائي 99",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit99.png",
		}
	},

	["consumable_cupcake_chocolate"] = {
		label = "كعكة الشوكولاتة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cupcake_chocolate.png",
		}
	},

	["womenoutfit98"] = {
		label = "زي نسائي 98",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit98.png",
		}
	},

	["match"] = {
		label = "كبريت",
		weight = 250,
		stack = true,
		close = true,
		description = "أداة صغيرة تُستخدم لإشعال النار",
		client = {
			image = "match.png",
		}
	},

	["womenoutfit97"] = {
		label = "زي نسائي 97",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit97.png",
		}
	},

	["womenoutfit96"] = {
		label = "زي نسائي 96",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit96.png",
		}
	},

	["scarecrow"] = {
		label = "فزاعة",
		weight = 250,
		stack = true,
		close = true,
		description = "أداة زراعية تُستخدم لحماية المحاصيل من الطيور والآفات",
		client = {
			image = "scarecrow.png",
		}
	},

	["womenoutfit95"] = {
		label = "زي نسائي 95",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit95.png",
		}
	},

	["womenoutfit572"] = {
		label = "زي نسائي 572",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit572.png",
		}
	},

	["womenoutfit93"] = {
		label = "زي نسائي 93",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit93.png",
		}
	},

	["petwater"] = {
		label = "Pet Water",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "petwater.png",
		}
	},

	["womenoutfit92"] = {
		label = "زي نسائي 92",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit92.png",
		}
	},

	["farol"] = {
		label = "Farol",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "farol.png",
		}
	},

	["OutfitMen055"] = {
		label = "بدلة رجالية 055",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen055.png",
		}
	},

	["OutfitMen091"] = {
		label = "بدلة رجالية 091",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen091.png",
		}
	},

	["womenoutfit9"] = {
		label = "زي نسائي 9",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit9.png",
		}
	},

	["womenoutfit89"] = {
		label = "زي نسائي 89",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit89.png",
		}
	},

	["womenoutfit842"] = {
		label = "زي نسائي 842",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit842.png",
		}
	},

	["womenoutfit87"] = {
		label = "زي نسائي 87",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit87.png",
		}
	},

	["womenoutfit86"] = {
		label = "زي نسائي 86",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit86.png",
		}
	},

	["building_plan_6"] = {
		label = "ورقة بناء بيت 6",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_6.png",
		}
	},

	["womenoutfit338"] = {
		label = "زي نسائي 338",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit338.png",
		}
	},

	["s_inv_cigcard_lnd_11x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 11",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #11",
		client = {
			image = "s_inv_cigcard_lnd_11x.png",
		}
	},

	["womenoutfit854"] = {
		label = "زي نسائي 854",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit854.png",
		}
	},

	["WomenOutfits33"] = {
		label = "زي نسائي 33",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits33.png",
		}
	},

	["OutfitMen050"] = {
		label = "بدلة رجالية 050",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen050.png",
		}
	},

	["WomenOutfit065"] = {
		label = "زي نسائي 065",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit065.png",
		}
	},

	["womenoutfit531"] = {
		label = "زي نسائي 531",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit531.png",
		}
	},

	["womenoutfit847"] = {
		label = "زي نسائي 847",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit847.png",
		}
	},

	["womenoutfit846"] = {
		label = "زي نسائي 846",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit846.png",
		}
	},

	["womenoutfit204"] = {
		label = "زي نسائي 204",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit204.png",
		}
	},

	["womenoutfit845"] = {
		label = "زي نسائي 845",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit845.png",
		}
	},

	["womenoutfit262"] = {
		label = "زي نسائي 262",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit262.png",
		}
	},

	["WomenHats165"] = {
		label = "قبعة نسائية 165",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats165.png",
		}
	},

	["gunbelts"] = {
		label = "أحزمة البنادق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "gunbelts.png",
		}
	},

	["White_Grapes_Seed"] = {
		label = "بذور العنب الأبيض",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لنمو العنب الأبيض",
		client = {
			image = "White_Grapes_Seed.png",
		}
	},

	["s_inv_cigcard_veh_09x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 09",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #09",
		client = {
			image = "s_inv_cigcard_veh_09x.png",
		}
	},

	["womenoutfit844"] = {
		label = "زي نسائي 844",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit844.png",
		}
	},

	["resource_skin_deer_star_2"] = {
		label = "جلد الغزال 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_deer_star_2.png",
		}
	},

	["s_inv_cigcard_inv_10x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 10",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #10",
		client = {
			image = "s_inv_cigcard_inv_10x.png",
		}
	},

	["s_inv_cigcard_inv_01x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 01",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #01",
		client = {
			image = "s_inv_cigcard_inv_01x.png",
		}
	},

	["perfect_cow_pelt"] = {
		label = "فرو بقرة ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بقرة بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_cow_pelt.png",
		}
	},

	["womenoutfit843"] = {
		label = "زي نسائي 843",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit843.png",
		}
	},

	["womenoutfit443"] = {
		label = "زي نسائي 443",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit443.png",
		}
	},

	["womenoutfit88"] = {
		label = "زي نسائي 88",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit88.png",
		}
	},

	["womenoutfit841"] = {
		label = "زي نسائي 841",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit841.png",
		}
	},

	["poor_buck_meat"] = {
		label = "لحم غزال رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_buck_meat.png",
		}
	},

	["marijuana_bud3_untrimmed"] = {
		label = "براعم الماريجوانا 3 غير مقلمة",
		weight = 250,
		stack = true,
		close = true,
		description = "براعم الماريجوانا 3 غير مقلمة",
		client = {
			image = "marijuana_bud3_untrimmed.png",
		}
	},

	["womenoutfit840"] = {
		label = "زي نسائي 840",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit840.png",
		}
	},

	["WomenHats073"] = {
		label = "قبعة نسائية 073",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats073.png",
		}
	},

	["resource_skin_bear_black_star_2"] = {
		label = "جلد الدب الأسود 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_black_star_2.png",
		}
	},

	["womenoutfit839"] = {
		label = "زي نسائي 839",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit839.png",
		}
	},

	["docweaponskit"] = {
		label = "طقم طبي للمصابين بالرصاص",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين بعد تعرضهم لإطلاق نار!",
		client = {
			image = "docweaponskit.png",
		}
	},

	["perfect_skunk_pelt"] = {
		label = "فرو ظربان ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظربان بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_skunk_pelt.png",
		}
	},

	["womenoutfit615"] = {
		label = "زي نسائي 615",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit615.png",
		}
	},

	["womenoutfit249"] = {
		label = "زي نسائي 249",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit249.png",
		}
	},

	["womenoutfit838"] = {
		label = "زي نسائي 838",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit838.png",
		}
	},

	["womenoutfit837"] = {
		label = "زي نسائي 837",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit837.png",
		}
	},

	["womenoutfit256"] = {
		label = "زي نسائي 256",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit256.png",
		}
	},

	["menoutfit8"] = {
		label = "ملابس الرجال 8",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit8.png",
		}
	},

	["MenOutfits015"] = {
		label = "زي رجالي 015",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits015.png",
		}
	},

	["kit_lunging_rope"] = {
		label = "حبل التدريب",
		weight = 250,
		stack = true,
		close = true,
		description = "حبل طويل لتدريب الحصان",
		client = {
			image = "kit_lunging_rope.png",
		}
	},

	["womenoutfit834"] = {
		label = "زي نسائي 834",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit834.png",
		}
	},

	["menoutfit22"] = {
		label = "ملابس الرجال 22",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit22.png",
		}
	},

	["unique_shoovel"] = {
		label = "مجنز فريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_shoovel.png",
		}
	},

	["womenoutfit460"] = {
		label = "زي نسائي 460",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit460.png",
		}
	},

	["Hoof_Hook"] = {
		label = "خطاف الحافر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "Hoof_Hook.png",
		}
	},

	["womenoutfit833"] = {
		label = "زي نسائي 833",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit833.png",
		}
	},

	["womenoutfit404"] = {
		label = "زي نسائي 404",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit404.png",
		}
	},

	["baghemp_ti"] = {
		label = "Bagged Tropical Indica",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush, tropical regions!",
		client = {
			image = "baghemp_ti.png",
		}
	},

	["womenoutfit35"] = {
		label = "زي نسائي 35",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit35.png",
		}
	},

	["lumber_cedar_split_logs"] = {
		label = "جذوع أشجار الأرز المنقسمة",
		weight = 250,
		stack = true,
		close = true,
		description = "جذوع أشجار الأرز المنقسمة",
		client = {
			image = "lumber_cedar_split_logs.png",
		}
	},

	["cigarette_holder"] = {
		label = "حامل سيجارة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cigarette_holder.png",
		}
	},

	["womenoutfit831"] = {
		label = "زي نسائي 831",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit831.png",
		}
	},

	["WomenOutfit083"] = {
		label = "زي نسائي 083",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit083.png",
		}
	},

	["moonshine_interior2"] = {
		label = "Moonshine Interior 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_interior2.png",
		}
	},

	["menoutfit49"] = {
		label = "ملابس الرجال 49",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit49.png",
		}
	},

	["OutfitMen194"] = {
		label = "بدلة رجالية 194",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen194.png",
		}
	},

	["womenoutfit83"] = {
		label = "زي نسائي 83",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit83.png",
		}
	},

	["WomenHats144"] = {
		label = "قبعة نسائية 144",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats144.png",
		}
	},

	["womenoutfit22"] = {
		label = "زي نسائي 22",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit22.png",
		}
	},

	["WomenHats028"] = {
		label = "قبعة نسائية 028",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats028.png",
		}
	},

	["peacepipe"] = {
		label = "أنبوب السلام",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "peacepipe.png",
		}
	},

	["WomenHats174"] = {
		label = "قبعة نسائية 174",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats174.png",
		}
	},

	["womenoutfit828"] = {
		label = "زي نسائي 828",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit828.png",
		}
	},

	["womenoutfit516"] = {
		label = "زي نسائي 516",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit516.png",
		}
	},

	["tabbaco_chicha_hawai"] = {
		label = "تبغ شيشة هاواي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tabbaco_chicha_hawai.png",
		}
	},

	["womenoutfit824"] = {
		label = "زي نسائي 824",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit824.png",
		}
	},

	["womenoutfit822"] = {
		label = "زي نسائي 822",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit822.png",
		}
	},

	["scopemediumboltaction"] = {
		label = "Rifle Boltaction Medium Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopemediumboltaction.png",
		}
	},

	["womenoutfit82"] = {
		label = "زي نسائي 82",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit82.png",
		}
	},

	["resource_skin_moose_star_3"] = {
		label = "فرو الموظ 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_moose_star_3.png",
		}
	},

	["womenoutfit757"] = {
		label = "زي نسائي 757",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit757.png",
		}
	},

	["s_inv_cigcard_lnd_07x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 07",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #07",
		client = {
			image = "s_inv_cigcard_lnd_07x.png",
		}
	},

	["scopemediumcarcano"] = {
		label = "Sniper Rifle Carcano Medium Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopemediumcarcano.png",
		}
	},

	["womenoutfit819"] = {
		label = "زي نسائي 819",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit819.png",
		}
	},

	["marijuana_joint1_5"] = {
		label = "لفافة ماريجوانا 1-5",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-5",
		client = {
			image = "marijuana_joint1_5.png",
		}
	},

	["womenoutfit818"] = {
		label = "زي نسائي 818",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit818.png",
		}
	},

	["perfect_badger_pelt"] = {
		label = "فرو غرير ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غرير بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_badger_pelt.png",
		}
	},

	["provision_horse_flaming_shoes"] = {
		label = "حافرات مشتعلة",
		weight = 250,
		stack = true,
		close = true,
		description = "حافرات نارية للحصان",
		client = {
			image = "provision_horse_flaming_shoes.png",
		}
	},

	["womenoutfit750"] = {
		label = "زي نسائي 750",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit750.png",
		}
	},

	["fotta"] = {
		label = "فوطة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "fotta.png",
		}
	},

	["unique_colt46"] = {
		label = "كولت 46 الفريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_colt46.png",
		}
	},

	["bananaseeds"] = {
		label = "بذور الموز",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور الموز",
		client = {
			image = "bananaseeds.png",
		}
	},

	["womenoutfit814"] = {
		label = "زي نسائي 814",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit814.png",
		}
	},

	["womenoutfit813"] = {
		label = "زي نسائي 813",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit813.png",
		}
	},

	["womenoutfit7"] = {
		label = "زي نسائي 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit7.png",
		}
	},

	["perfect_cow_meat"] = {
		label = "لحم بقرة ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بقرة بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_cow_meat.png",
		}
	},

	["p_finishdcrawd01x_hf"] = {
		label = "طُعم المستنقعات المميز",
		weight = 250,
		stack = true,
		close = true,
		description = "طُعم يُحاكي حركة جراد البحر، يجذب الأسماك المفترسة الكبيرة.",
		client = {
			image = "p_finishdcrawd01x_hf.png",
		}
	},

	["WomenOutfit011"] = {
		label = "زي نسائي 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit011.png",
		}
	},

	["menoutfit87"] = {
		label = "ملابس الرجال 87",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit87.png",
		}
	},

	["provision_iguana_skin"] = {
		label = "جلد الإغوانا",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد مأخوذ من الإغوانا.",
		client = {
			image = "provision_iguana_skin.png",
		}
	},

	["iguana_animal"] = {
		label = "إغوانا",
		weight = 100,
		stack = true,
		close = true,
		description = "إغوانا يمكن استخدامها في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "iguana_animal.png",
		}
	},

	["provision_vulture_feather"] = {
		label = "ريشة النسر",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة مأخوذة من نسر.",
		client = {
			image = "provision_vulture_feather.png",
		}
	},

	["womenoutfit702"] = {
		label = "زي نسائي 702",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit702.png",
		}
	},

	["water_witcher"] = {
		label = "ماء الساحر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "water_witcher.png",
		}
	},

	["womenoutfit810"] = {
		label = "زي نسائي 810",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit810.png",
		}
	},

	["womenoutfit500"] = {
		label = "زي نسائي 500",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit500.png",
		}
	},

	["WomenOutfit037"] = {
		label = "زي نسائي 037",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit037.png",
		}
	},

	["poor_beaver_pelt"] = {
		label = "فرو قندس رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو قندس بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_beaver_pelt.png",
		}
	},

	["hats"] = {
		label = "قبعات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hats.png",
		}
	},

	["WomenHats161"] = {
		label = "قبعة نسائية 161",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats161.png",
		}
	},

	["womenoutfit532"] = {
		label = "زي نسائي 532",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit532.png",
		}
	},

	["womenoutfit613"] = {
		label = "زي نسائي 613",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit613.png",
		}
	},

	["pelican_feathers"] = {
		label = "ريش بجع",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش بجع يُستخدم في أعمال التصنيع.",
		client = {
			image = "pelican_feathers.png",
		}
	},

	["womenoutfit708"] = {
		label = "زي نسائي 708",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit708.png",
		}
	},

	["peyote"] = {
		label = "بيوتي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "peyote.png",
		}
	},

	["womenoutfit807"] = {
		label = "زي نسائي 807",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit807.png",
		}
	},

	["consumable_biscuit_box"] = {
		label = "علبة بسكويت صالحة للأكل",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على بسكويت مقرمش.",
		client = {
			image = "consumable_biscuit_box.png",
		}
	},

	["redpearl"] = {
		label = "لؤلؤة حمراء",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع اللؤلؤة الحمراء بأسعار مرتفعة.",
		client = {
			image = "redpearl.png",
		}
	},

	["womenoutfit805"] = {
		label = "زي نسائي 805",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit805.png",
		}
	},

	["vassoura"] = {
		label = "مقشة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "vassoura.png",
		}
	},

	["s_inv_cigcard_gun_05x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 05",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #05",
		client = {
			image = "s_inv_cigcard_gun_05x.png",
		}
	},

	["flowerarrangement"] = {
		label = "تنسيق الزهور",
		weight = 250,
		stack = true,
		close = true,
		description = "تنسيق الزهور",
		client = {
			image = "flowerarrangement.png",
		}
	},

	["removetattoo"] = {
		label = "إزالة الوشم",
		weight = 250,
		stack = true,
		close = true,
		description = "إزالة الوشم",
		client = {
			image = "removetattoo.png",
		}
	},

	["womenoutfit802"] = {
		label = "زي نسائي 802",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit802.png",
		}
	},

	["cloaks"] = {
		label = "أردية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cloaks.png",
		}
	},

	["perfect_armadillo_pelt"] = {
		label = "فرو أرماديلو ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرماديلو بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_armadillo_pelt.png",
		}
	},

	["womenoutfit801"] = {
		label = "زي نسائي 801",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit801.png",
		}
	},

	["womenoutfit323"] = {
		label = "زي نسائي 323",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit323.png",
		}
	},

	["womenoutfit80"] = {
		label = "زي نسائي 80",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit80.png",
		}
	},

	["wings3"] = {
		label = "أجنحة 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "wings3.png",
		}
	},

	["womenoutfit8"] = {
		label = "زي نسائي 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit8.png",
		}
	},

	["consumable_pineapples_can"] = {
		label = "علبة أناناس",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على قطع الأناناس.",
		client = {
			image = "consumable_pineapples_can.png",
		}
	},

	["resource_bag_salt_rock"] = {
		label = "كيس صخور الملح",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس صخور الملح",
		client = {
			image = "resource_bag_salt_rock.png",
		}
	},

	["OutfitMen191"] = {
		label = "بدلة رجالية 191",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen191.png",
		}
	},

	["small_firecracker"] = {
		label = "مفرقعات صغيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "small_firecracker.png",
		}
	},

	["womenoutfit799"] = {
		label = "زي نسائي 799",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit799.png",
		}
	},

	["s_inv_cigcard_spt_09x"] = {
		label = "بطاقة السجائر أبطال العالم 09",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #09",
		client = {
			image = "s_inv_cigcard_spt_09x.png",
		}
	},

	["sharpeningstone"] = {
		label = "كتاب تسجيل المرضى",
		weight = 250,
		stack = true,
		close = true,
		description = "يُستخدم لتسجيل بيانات المرضى والحالات الطبية ومتابعة التقارير داخل المستشفى.",
		client = {
			image = "sharpeningstone.png",
		}
	},

	["menoutfit95"] = {
		label = "ملابس الرجال 95",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit95.png",
		}
	},

	["kit_hoof_knife"] = {
		label = "سكين حافر",
		weight = 250,
		stack = true,
		close = true,
		description = "أداة لتنظيف حافرات الحصان",
		client = {
			image = "kit_hoof_knife.png",
		}
	},

	["womenoutfit687"] = {
		label = "زي نسائي 687",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit687.png",
		}
	},

	["WomenHats014"] = {
		label = "قبعة نسائية 014",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats014.png",
		}
	},

	["consumable_tea_mint"] = {
		label = "شاي نعناع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tea_mint.png",
		}
	},

	["White_Grapes"] = {
		label = "العنب الأبيض",
		weight = 250,
		stack = true,
		close = true,
		description = "نوع من العنب ذو حبات فاتحة اللون تتراوح بين الأخضر والأصفر. يُستخدم في تناول الطعام الطازج",
		client = {
			image = "White_Grapes.png",
		}
	},

	["womenoutfit797"] = {
		label = "زي نسائي 797",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit797.png",
		}
	},

	["womenoutfit796"] = {
		label = "زي نسائي 796",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit796.png",
		}
	},

	["womenoutfit795"] = {
		label = "زي نسائي 795",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit795.png",
		}
	},

	["animal_robin"] = {
		label = "طائر أبو الحناء",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر أبو الحناء.",
		client = {
			image = "animal_robin.png",
		}
	},

	["s_inv_cigcard_art_09x"] = {
		label = "بطاقة السجائر فن 09",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #09",
		client = {
			image = "s_inv_cigcard_art_09x.png",
		}
	},

	["OutfitMen103"] = {
		label = "بدلة رجالية 103",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen103.png",
		}
	},

	["womenoutfit794"] = {
		label = "زي نسائي 794",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit794.png",
		}
	},

	["Agave"] = {
		label = "",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "Agave.png",
		}
	},

	["resource_skin_armadillo_star_2"] = {
		label = "فرو الأرماديلو 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_armadillo_star_2.png",
		}
	},

	["womenoutfit192"] = {
		label = "زي نسائي 192",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit192.png",
		}
	},

	["womenoutfit793"] = {
		label = "زي نسائي 793",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit793.png",
		}
	},

	["womenoutfit792"] = {
		label = "زي نسائي 792",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit792.png",
		}
	},

	["resource_skin_panther_star_1"] = {
		label = "جلد النمر 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_panther_star_1.png",
		}
	},

	["womenoutfit791"] = {
		label = "زي نسائي 791",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit791.png",
		}
	},

	["WomenHats072"] = {
		label = "قبعة نسائية 072",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats072.png",
		}
	},

	["menoutfit46"] = {
		label = "ملابس الرجال 46",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit46.png",
		}
	},

	["perfect_cougar_pelt"] = {
		label = "فرو أسد الجبل ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أسد الجبل بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_cougar_pelt.png",
		}
	},

	["womenoutfit79"] = {
		label = "زي نسائي 79",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit79.png",
		}
	},

	["womenoutfit396"] = {
		label = "زي نسائي 396",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit396.png",
		}
	},

	["womenoutfit789"] = {
		label = "زي نسائي 789",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit789.png",
		}
	},

	["womenoutfit736"] = {
		label = "زي نسائي 736",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit736.png",
		}
	},

	["jewelry_rings_right"] = {
		label = "خواتم المجوهرات اليمنى",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "jewelry_rings_right.png",
		}
	},

	["hat9"] = {
		label = "قبعة 9",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat9.png",
		}
	},

	["womenoutfit651"] = {
		label = "زي نسائي 651",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit651.png",
		}
	},

	["WomenOutfit041"] = {
		label = "زي نسائي 041",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit041.png",
		}
	},

	["womenoutfit786"] = {
		label = "زي نسائي 786",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit786.png",
		}
	},

	["MenOutfits27"] = {
		label = "زي رجالي 27",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits27.png",
		}
	},

	["womenoutfit169"] = {
		label = "زي نسائي 169",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit169.png",
		}
	},

	["womenoutfit629"] = {
		label = "زي نسائي 629",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit629.png",
		}
	},

	["womenoutfit275"] = {
		label = "زي نسائي 275",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit275.png",
		}
	},

	["bee_house_gk_3"] = {
		label = "بيت النحل 3",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 3",
		client = {
			image = "bee_house_gk_3.png",
		}
	},

	["a_milk"] = {
		label = "حليب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_milk.png",
		}
	},

	["womenoutfit745"] = {
		label = "زي نسائي 745",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit745.png",
		}
	},

	["womenoutfit781"] = {
		label = "زي نسائي 781",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit781.png",
		}
	},

	["provision_legendary_black_bear_fur"] = {
		label = "فراء دب أسود أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء أسود فاخر من دب أسطوري.",
		client = {
			image = "provision_legendary_black_bear_fur.png",
		}
	},

	["womenoutfit780"] = {
		label = "زي نسائي 780",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit780.png",
		}
	},

	["cocaineseed"] = {
		label = "بذور الكوكايين",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cocaineseed.png",
		}
	},

	["womenoutfit78"] = {
		label = "زي نسائي 78",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit78.png",
		}
	},

	["shield03"] = {
		label = "درع 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield03.png",
		}
	},

	["womenoutfit778"] = {
		label = "زي نسائي 778",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit778.png",
		}
	},

	["hat7"] = {
		label = "قبعة 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat7.png",
		}
	},

	["womenoutfit777"] = {
		label = "زي نسائي 777",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit777.png",
		}
	},

	["MenOutfits035"] = {
		label = "زي رجالي 035",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits035.png",
		}
	},

	["womenoutfit776"] = {
		label = "زي نسائي 776",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit776.png",
		}
	},

	["WomenHats031"] = {
		label = "قبعة نسائية 031",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats031.png",
		}
	},

	["resource_skin_panther_star_3"] = {
		label = "جلد النمر 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_panther_star_3.png",
		}
	},

	["womenoutfit772"] = {
		label = "زي نسائي 772",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit772.png",
		}
	},

	["provision_cougar_claw"] = {
		label = "مخلب بوما",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب حاد من البوما.",
		client = {
			image = "provision_cougar_claw.png",
		}
	},

	["womenoutfit771"] = {
		label = "زي نسائي 771",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit771.png",
		}
	},

	["womenoutfit770"] = {
		label = "زي نسائي 770",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit770.png",
		}
	},

	["womenoutfit769"] = {
		label = "زي نسائي 769",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit769.png",
		}
	},

	["womenoutfit768"] = {
		label = "زي نسائي 768",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit768.png",
		}
	},

	["womenoutfit752"] = {
		label = "زي نسائي 752",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit752.png",
		}
	},

	["silvercoin"] = {
		label = "عملة فضية",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع العملة الفضية بأسعار مرتفعة.",
		client = {
			image = "silvercoin.png",
		}
	},

	["womenoutfit298"] = {
		label = "زي نسائي 298",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit298.png",
		}
	},

	["womenoutfit23"] = {
		label = "زي نسائي 23",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit23.png",
		}
	},

	["dryhemp_ll"] = {
		label = "Dry Lagras Lullaby",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the tranquil Lagras Swamps!",
		client = {
			image = "dryhemp_ll.png",
		}
	},

	["provision_cougar_fang"] = {
		label = "ناب بوما",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب قوي مأخوذ من البوما.",
		client = {
			image = "provision_cougar_fang.png",
		}
	},

	["womenoutfit672"] = {
		label = "زي نسائي 672",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit672.png",
		}
	},

	["womenoutfit764"] = {
		label = "زي نسائي 764",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit764.png",
		}
	},

	["jelalipower"] = {
		label = "قوة جيلا لي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "jelalipower.png",
		}
	},

	["ammobolaintertwined"] = {
		label = "ذخيرة بولا متشابكة",
		weight = 250,
		stack = true,
		close = true,
		description = "ذخيرة بولا مع حبال متشابكة، توفر قوة إمساك إضافية.",
		client = {
			image = "ammobolaintertwined.png",
		}
	},

	["HorseTag"] = {
		label = "علامة الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "HorseTag.png",
		}
	},

	["womenoutfit763"] = {
		label = "زي نسائي 763",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit763.png",
		}
	},

	["boost5"] = {
		label = "تعزيز 5",
		weight = 250,
		stack = true,
		close = true,
		description = "تعزيز 5",
		client = {
			image = "boost5.png",
		}
	},

	["rk_coin1"] = {
		label = "Silver Coin",
		weight = 250,
		stack = true,
		close = true,
		description = "A collectible silver coin.",
		client = {
			image = "rk_coin1.png",
		}
	},

	["s_inv_cigcard_lnd_06x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 06",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #06",
		client = {
			image = "s_inv_cigcard_lnd_06x.png",
		}
	},

	["provision_legendary_moose_antler"] = {
		label = "قرن الموظ الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن قوي مأخوذ من موظ أسطوري.",
		client = {
			image = "provision_legendary_moose_antler.png",
		}
	},

	["womenoutfit762"] = {
		label = "زي نسائي 762",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit762.png",
		}
	},

	["resource_nails"] = {
		label = "مسامر",
		weight = 250,
		stack = true,
		close = true,
		description = "مسامر",
		client = {
			image = "resource_nails.png",
		}
	},

	["menoutfit40"] = {
		label = "ملابس الرجال 40",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit40.png",
		}
	},

	["COYOTE_VAR_002"] = {
		label = "ذئب براري أسطوري رمادي",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب براري أسطوري بلون رمادي.",
		client = {
			image = "COYOTE_VAR_002.png",
		}
	},

	["womenoutfit759"] = {
		label = "زي نسائي 759",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit759.png",
		}
	},

	["eee_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "eee_news.png",
		}
	},

	["pomade"] = {
		label = "مرهم الشعر",
		weight = 250,
		stack = true,
		close = true,
		description = "منتج تصفيف للشعر.",
		client = {
			image = "pomade.png",
		}
	},

	["womenoutfit758"] = {
		label = "زي نسائي 758",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit758.png",
		}
	},

	["womenoutfit756"] = {
		label = "زي نسائي 756",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit756.png",
		}
	},

	["WomenOutfit019"] = {
		label = "زي نسائي 019",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit019.png",
		}
	},

	["womenoutfit755"] = {
		label = "زي نسائي 755",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit755.png",
		}
	},

	["womenoutfit754"] = {
		label = "زي نسائي 754",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit754.png",
		}
	},

	["WomenHats201"] = {
		label = "قبعة نسائية 201",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats201.png",
		}
	},

	["docmeleekit"] = {
		label = "طقم طبي للطعن",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين الذين تعرضوا للطعن!",
		client = {
			image = "docmeleekit.png",
		}
	},

	["OutfitMen061"] = {
		label = "بدلة رجالية 061",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen061.png",
		}
	},

	["WomenOutfit080"] = {
		label = "زي نسائي 080",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit080.png",
		}
	},

	["consumable_potent_horse_stimulant"] = {
		label = "منشط قوي للخيول",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط قوي يزيد من طاقة الخيول.",
		client = {
			image = "consumable_potent_horse_stimulant.png",
		}
	},

	["consumable_bread5"] = {
		label = "خبز نشوي",
		weight = 250,
		stack = true,
		close = true,
		description = "خبز نشوي",
		client = {
			image = "consumable_bread5.png",
		}
	},

	["resource_pelt_skunk_star_2"] = {
		label = "فرو الظربان 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_skunk_star_2.png",
		}
	},

	["womenoutfit753"] = {
		label = "زي نسائي 753",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit753.png",
		}
	},

	["fan_02"] = {
		label = "مروحة يدوية",
		weight = 250,
		stack = true,
		close = true,
		description = "مروحة يدوية",
		client = {
			image = "fan_02.png",
		}
	},

	["provision_cormorant_feather"] = {
		label = "ريشة كورمورانت",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة من طائر الكورمورانت.",
		client = {
			image = "provision_cormorant_feather.png",
		}
	},

	["womenoutfit767"] = {
		label = "زي نسائي 767",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit767.png",
		}
	},

	["menoutfit63"] = {
		label = "ملابس الرجال 63",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit63.png",
		}
	},

	["WomenHats086"] = {
		label = "قبعة نسائية 086",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats086.png",
		}
	},

	["consumable_tea_wild_berry"] = {
		label = "شاي التوت البري",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tea_wild_berry.png",
		}
	},

	["WomenBracelets011"] = {
		label = "سوار نسائي 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets011.png",
		}
	},

	["clothe6"] = {
		label = "ملابس 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe6.png",
		}
	},

	["horsemask2"] = {
		label = "قناع حصان 2",
		weight = 250,
		stack = true,
		close = true,
		description = "قناع للحصان",
		client = {
			image = "horsemask2.png",
		}
	},

	["marijuana_joint3_1"] = {
		label = "لفافة ماريجوانا 3-1",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-1",
		client = {
			image = "marijuana_joint3_1.png",
		}
	},

	["womenoutfit816"] = {
		label = "زي نسائي 816",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit816.png",
		}
	},

	["womenoutfit75"] = {
		label = "زي نسائي 75",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit75.png",
		}
	},

	["womenoutfit748"] = {
		label = "زي نسائي 748",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit748.png",
		}
	},

	["boost3"] = {
		label = "تعزيز 3",
		weight = 250,
		stack = true,
		close = true,
		description = "تعزيز 3",
		client = {
			image = "boost3.png",
		}
	},

	["womenoutfit747"] = {
		label = "زي نسائي 747",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit747.png",
		}
	},

	["womenoutfit782"] = {
		label = "زي نسائي 782",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit782.png",
		}
	},

	["OutfitMen042"] = {
		label = "بدلة رجالية 042",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen042.png",
		}
	},

	["womenoutfit151"] = {
		label = "زي نسائي 151",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit151.png",
		}
	},

	["s_inv_cigcard_hrs_08x"] = {
		label = "بطاقة السجائر سلالات الخيول 08",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #08",
		client = {
			image = "s_inv_cigcard_hrs_08x.png",
		}
	},

	["womenoutfit268"] = {
		label = "زي نسائي 268",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit268.png",
		}
	},

	["s_inv_cigcard_aml_06x"] = {
		label = "بطاقة السجائر أمل 06",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #06",
		client = {
			image = "s_inv_cigcard_aml_06x.png",
		}
	},

	["womenoutfit743"] = {
		label = "زي نسائي 743",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit743.png",
		}
	},

	["womenoutfit741"] = {
		label = "زي نسائي 741",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit741.png",
		}
	},

	["cocaine_soaked_bandage"] = {
		label = "Strong Bandage",
		weight = 250,
		stack = true,
		close = true,
		description = "A stronger bandage for serious injuries.",
		client = {
			image = "cocaine_soaked_bandage.png",
		}
	},

	["resource_box_tomatoes"] = {
		label = "صندوق طماطم",
		weight = 250,
		stack = true,
		close = true,
		description = "صندوق طماطم",
		client = {
			image = "resource_box_tomatoes.png",
		}
	},

	["womenoutfit724"] = {
		label = "زي نسائي 724",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit724.png",
		}
	},

	["womenoutfit74"] = {
		label = "زي نسائي 74",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit74.png",
		}
	},

	["womenoutfit738"] = {
		label = "زي نسائي 738",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit738.png",
		}
	},

	["womenoutfit737"] = {
		label = "زي نسائي 737",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit737.png",
		}
	},

	["womenoutfit788"] = {
		label = "زي نسائي 788",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit788.png",
		}
	},

	["consumable_horsemeal"] = {
		label = "طعام حصان قابل للاستهلاك",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_horsemeal.png",
		}
	},

	["womenoutfit735"] = {
		label = "زي نسائي 735",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit735.png",
		}
	},

	["womenoutfit734"] = {
		label = "زي نسائي 734",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit734.png",
		}
	},

	["WomenHats100"] = {
		label = "قبعة نسائية 100",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats100.png",
		}
	},

	["womenoutfit49"] = {
		label = "زي نسائي 49",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit49.png",
		}
	},

	["womenoutfit731"] = {
		label = "زي نسائي 731",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit731.png",
		}
	},

	["womenoutfit730"] = {
		label = "زي نسائي 730",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit730.png",
		}
	},

	["OutfitMen193"] = {
		label = "بدلة رجالية 193",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen193.png",
		}
	},

	["womenoutfit729"] = {
		label = "زي نسائي 729",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit729.png",
		}
	},

	["provision_ring_thorburn_turquoise"] = {
		label = "خاتم توربرن الفيروزي",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم التزويد ثوربورن فيروزي",
		client = {
			image = "provision_ring_thorburn_turquoise.png",
		}
	},

	["womenoutfit728"] = {
		label = "زي نسائي 728",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit728.png",
		}
	},

	["womenoutfit727"] = {
		label = "زي نسائي 727",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit727.png",
		}
	},

	["womenoutfit726"] = {
		label = "زي نسائي 726",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit726.png",
		}
	},

	["ring_red"] = {
		label = "خاتم أحمر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ring_red.png",
		}
	},

	["unique_mooncake"] = {
		label = "كعكة القمر الفريدة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_mooncake.png",
		}
	},

	["OutfitMen155"] = {
		label = "بدلة رجالية 155",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen155.png",
		}
	},

	["provision_coyote_fang"] = {
		label = "ناب ذئب البراري",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب حاد من ذئب البراري.",
		client = {
			image = "provision_coyote_fang.png",
		}
	},

	["pocket_watch_gleaming_brass"] = {
		label = "ساعة جيب نحاسية لامعة",
		weight = 250,
		stack = true,
		close = true,
		description = "ساعة جيب من النحاس اللامع",
		client = {
			image = "pocket_watch_gleaming_brass.png",
		}
	},

	["womenoutfit723"] = {
		label = "زي نسائي 723",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit723.png",
		}
	},

	["p_goldcradlestand01x"] = {
		label = "قاعدة حامل الذهب 01x",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "p_goldcradlestand01x.png",
		}
	},

	["womenoutfit722"] = {
		label = "زي نسائي 722",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit722.png",
		}
	},

	["moonshine_blueflame"] = {
		label = "ضوء القمر اللهب الأزرق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_blueflame.png",
		}
	},

	["womenoutfit720"] = {
		label = "زي نسائي 720",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit720.png",
		}
	},

	["womenoutfit72"] = {
		label = "زي نسائي 72",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit72.png",
		}
	},

	["moonshine_original"] = {
		label = "ضوء القمر الأصلي",
		weight = 250,
		stack = true,
		close = true,
		description = "ضوء القمر الأصلي",
		client = {
			image = "moonshine_original.png",
		}
	},

	["perfect_wolf_pelt"] = {
		label = "فرو ذئب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_wolf_pelt.png",
		}
	},

	["womenoutfit719"] = {
		label = "زي نسائي 719",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit719.png",
		}
	},

	["weddingdress3"] = {
		label = "فستان زفاف 3",
		weight = 250,
		stack = false,
		close = true,
		description = "تصميم ثالث لفستان الزفاف.",
		client = {
			image = "weddingdress3.png",
		}
	},

	["consumable_sugarcube"] = {
		label = "1797 Gold Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "A gold eagle coin from 1797.",
		client = {
			image = "consumable_sugarcube.png",
		}
	},

	["womenoutfit718"] = {
		label = "زي نسائي 718",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit718.png",
		}
	},

	["womenoutfit328"] = {
		label = "زي نسائي 328",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit328.png",
		}
	},

	["womenoutfit717"] = {
		label = "زي نسائي 717",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit717.png",
		}
	},

	["womenoutfit716"] = {
		label = "زي نسائي 716",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit716.png",
		}
	},

	["Stash1"] = {
		label = "Stash 1",
		weight = 250,
		stack = true,
		close = true,
		description = "Item allow you to place your own stash anywhere.",
		client = {
			image = "Stash1.png",
		}
	},

	["WomenHats034"] = {
		label = "قبعة نسائية 034",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats034.png",
		}
	},

	["womenoutfit695"] = {
		label = "زي نسائي 695",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit695.png",
		}
	},

	["consumable_pie_peach"] = {
		label = "فطيرة الخوخ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_pie_peach.png",
		}
	},

	["womenoutfit714"] = {
		label = "زي نسائي 714",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit714.png",
		}
	},

	["consumable_bread_roll"] = {
		label = "لفافة خبز",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة خبز",
		client = {
			image = "consumable_bread_roll.png",
		}
	},

	["womenoutfit713"] = {
		label = "زي نسائي 713",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit713.png",
		}
	},

	["womenoutfit712"] = {
		label = "زي نسائي 712",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit712.png",
		}
	},

	["womenoutfit711"] = {
		label = "زي نسائي 711",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit711.png",
		}
	},

	["womenoutfit709"] = {
		label = "زي نسائي 709",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit709.png",
		}
	},

	["scarfhoodie"] = {
		label = "غطاء رأس مع وشاح",
		weight = 250,
		stack = false,
		close = true,
		description = "غطاء رأس مدمج مع وشاح للدفء",
		client = {
			image = "scarfhoodie.png",
		}
	},

	["resource_pelt_skunk_star_1"] = {
		label = "فرو الظربان 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_skunk_star_1.png",
		}
	},

	["womenoutfit808"] = {
		label = "زي نسائي 808",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit808.png",
		}
	},

	["s_inv_cigcard_veh_04x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 04",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #04",
		client = {
			image = "s_inv_cigcard_veh_04x.png",
		}
	},

	["MenOutfits029"] = {
		label = "زي رجالي 029",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits029.png",
		}
	},

	["womenoutfit707"] = {
		label = "زي نسائي 707",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit707.png",
		}
	},

	["womenoutfit704"] = {
		label = "زي نسائي 704",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit704.png",
		}
	},

	["obj1"] = {
		label = "جيب سيف الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "obj1.png",
		}
	},

	["womenoutfit703"] = {
		label = "زي نسائي 703",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit703.png",
		}
	},

	["provision_legendary_wolf_heart"] = {
		label = "قلب الذئب الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب قوي من ذئب أسطوري.",
		client = {
			image = "provision_legendary_wolf_heart.png",
		}
	},

	["womenoutfit529"] = {
		label = "زي نسائي 529",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit529.png",
		}
	},

	["womenoutfit70"] = {
		label = "زي نسائي 70",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit70.png",
		}
	},

	["weedseed"] = {
		label = "بذور الأعشاب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "weedseed.png",
		}
	},

	["MenOutfits022"] = {
		label = "زي رجالي 022",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits022.png",
		}
	},

	["womenoutfit244"] = {
		label = "زي نسائي 244",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit244.png",
		}
	},

	["womenoutfit698"] = {
		label = "زي نسائي 698",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit698.png",
		}
	},

	["womenoutfit520"] = {
		label = "زي نسائي 520",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit520.png",
		}
	},

	["WomenHats012"] = {
		label = "قبعة نسائية 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats012.png",
		}
	},

	["womenoutfit697"] = {
		label = "زي نسائي 697",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit697.png",
		}
	},

	["WomenOutfit029"] = {
		label = "زي نسائي 029",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit029.png",
		}
	},

	["horseflag"] = {
		label = "علم الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "علم على الحصان",
		client = {
			image = "horseflag.png",
		}
	},

	["WomenBracelets012"] = {
		label = "سوار نسائي 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets012.png",
		}
	},

	["consumable_milkshake_blueberry"] = {
		label = "اللبن المخفوق",
		weight = 250,
		stack = true,
		close = true,
		description = "اللبن المخفوق",
		client = {
			image = "consumable_milkshake_blueberry.png",
		}
	},

	["building_plan_8"] = {
		label = "ورقة بناء بيت 8",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_8.png",
		}
	},

	["womenoutfit696"] = {
		label = "زي نسائي 696",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit696.png",
		}
	},

	["womenoutfit715"] = {
		label = "زي نسائي 715",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit715.png",
		}
	},

	["womenoutfit694"] = {
		label = "زي نسائي 694",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit694.png",
		}
	},

	["womenoutfit693"] = {
		label = "زي نسائي 693",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit693.png",
		}
	},

	["baghemp_sb"] = {
		label = "Bagged Sandy Breeze",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp gathered from the sandy and breezy coastal areas!",
		client = {
			image = "baghemp_sb.png",
		}
	},

	["womenoutfit692"] = {
		label = "زي نسائي 692",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit692.png",
		}
	},

	["WomenHats168"] = {
		label = "قبعة نسائية 168",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats168.png",
		}
	},

	["WomenOutfit079"] = {
		label = "زي نسائي 079",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit079.png",
		}
	},

	["horseloadout2"] = {
		label = "حمولة حصان 2",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout2.png",
		}
	},

	["womenoutfit691"] = {
		label = "زي نسائي 691",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit691.png",
		}
	},

	["womenoutfit690"] = {
		label = "زي نسائي 690",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit690.png",
		}
	},

	["womenoutfit689"] = {
		label = "زي نسائي 689",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit689.png",
		}
	},

	["cuthemp_ck"] = {
		label = "Trimmed Cumberland Kush",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush Cumberland Mountains!",
		client = {
			image = "cuthemp_ck.png",
		}
	},

	["womenoutfit81"] = {
		label = "زي نسائي 81",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit81.png",
		}
	},

	["womenoutfit128"] = {
		label = "زي نسائي 128",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit128.png",
		}
	},

	["consumable_fried_bluegill"] = {
		label = "سمك البلوجيل المقلي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_fried_bluegill.png",
		}
	},

	["dryhemp_bb"] = {
		label = "Dry Bayou Bliss",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the muckiness of the bayou!",
		client = {
			image = "dryhemp_bb.png",
		}
	},

	["womenoutfit377"] = {
		label = "زي نسائي 377",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit377.png",
		}
	},

	["womenoutfit684"] = {
		label = "زي نسائي 684",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit684.png",
		}
	},

	["womenoutfit683"] = {
		label = "زي نسائي 683",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit683.png",
		}
	},

	["consumable_coffee_gnds_reg"] = {
		label = "حبوب قهوة مطحونة",
		weight = 250,
		stack = true,
		close = true,
		description = "حبوب قهوة مطحونة لتحضير مشروب القهوة.",
		client = {
			image = "consumable_coffee_gnds_reg.png",
		}
	},

	["MenOutfits037"] = {
		label = "زي رجالي 037",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits037.png",
		}
	},

	["menoutfit26"] = {
		label = "ملابس الرجال 26",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit26.png",
		}
	},

	["menoutfit50"] = {
		label = "ملابس الرجال 50",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit50.png",
		}
	},

	["WomenGloves019"] = {
		label = "قفازات نسائية 019",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves019.png",
		}
	},

	["womenoutfit681"] = {
		label = "زي نسائي 681",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit681.png",
		}
	},

	["resource_sapphire_uncut"] = {
		label = "ياقوت غير مقطوع",
		weight = 250,
		stack = true,
		close = true,
		description = "ياقوت غير مقطوع",
		client = {
			image = "resource_sapphire_uncut.png",
		}
	},

	["womenoutfit347"] = {
		label = "زي نسائي 347",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit347.png",
		}
	},

	["maquinaescrever"] = {
		label = "Máquina de Escrever",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "maquinaescrever.png",
		}
	},

	["WomenOutfit015"] = {
		label = "زي نسائي 015",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit015.png",
		}
	},

	["resource_pelt_badger_star_3"] = {
		label = "جلد الغرير 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_badger_star_3.png",
		}
	},

	["legendary_buck_meat"] = {
		label = "لحم غزال أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_buck_meat.png",
		}
	},

	["womenoutfit676"] = {
		label = "زي نسائي 676",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit676.png",
		}
	},

	["womenoutfit675"] = {
		label = "زي نسائي 675",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit675.png",
		}
	},

	["perfect_cougar_meat"] = {
		label = "لحم أسد الجبل ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم أسد الجبل بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_cougar_meat.png",
		}
	},

	["WomenHats124"] = {
		label = "قبعة نسائية 124",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats124.png",
		}
	},

	["womenoutfit765"] = {
		label = "زي نسائي 765",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit765.png",
		}
	},

	["chili"] = {
		label = "فلفل حار",
		weight = 250,
		stack = true,
		close = true,
		description = "فلفل حار",
		client = {
			image = "chili.png",
		}
	},

	["consumable_potent_tonic"] = {
		label = "منشط قوي",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط يعزز القدرة الجسدية.",
		client = {
			image = "consumable_potent_tonic.png",
		}
	},

	["womenoutfit670"] = {
		label = "زي نسائي 670",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit670.png",
		}
	},

	["dryhemp_rd"] = {
		label = "Dry Roanoke Dream",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp originating from the rugged Roanoke Ridge!",
		client = {
			image = "dryhemp_rd.png",
		}
	},

	["marijuana_joint2_2"] = {
		label = "لفافة ماريجوانا 2-2",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-2",
		client = {
			image = "marijuana_joint2_2.png",
		}
	},

	["womenoutfit658"] = {
		label = "زي نسائي 658",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit658.png",
		}
	},

	["womenoutfit701"] = {
		label = "زي نسائي 701",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit701.png",
		}
	},

	["womenoutfit667"] = {
		label = "زي نسائي 667",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit667.png",
		}
	},

	["WomenNecklaces025"] = {
		label = "قلادة نسائية 025",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces025.png",
		}
	},

	["womenoutfit665"] = {
		label = "زي نسائي 665",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit665.png",
		}
	},

	["MenOutfits018"] = {
		label = "زي رجالي 018",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits018.png",
		}
	},

	["suspenders"] = {
		label = "حمالات السراويل",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "suspenders.png",
		}
	},

	["womenoutfit664"] = {
		label = "زي نسائي 664",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit664.png",
		}
	},

	["womenoutfit233"] = {
		label = "زي نسائي 233",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit233.png",
		}
	},

	["WomenOutfit043"] = {
		label = "زي نسائي 043",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit043.png",
		}
	},

	["womenoutfit660"] = {
		label = "زي نسائي 660",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit660.png",
		}
	},

	["perfect_peccary_pelt"] = {
		label = "فرو بيكاري ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بيكاري بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_peccary_pelt.png",
		}
	},

	["marijuana_joint3_7"] = {
		label = "لفافة ماريجوانا 3-7",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-7",
		client = {
			image = "marijuana_joint3_7.png",
		}
	},

	["womenoutfit66"] = {
		label = "زي نسائي 66",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit66.png",
		}
	},

	["womenoutfit657"] = {
		label = "زي نسائي 657",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit657.png",
		}
	},

	["womenoutfit656"] = {
		label = "زي نسائي 656",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit656.png",
		}
	},

	["womenoutfit395"] = {
		label = "زي نسائي 395",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit395.png",
		}
	},

	["WomenOutfit036"] = {
		label = "زي نسائي 036",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit036.png",
		}
	},

	["womenoutfit653"] = {
		label = "زي نسائي 653",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit653.png",
		}
	},

	["weddingdress2"] = {
		label = "فستان زفاف 2",
		weight = 250,
		stack = false,
		close = true,
		description = "تصميم مختلف لفستان الزفاف.",
		client = {
			image = "weddingdress2.png",
		}
	},

	["womenoutfit652"] = {
		label = "زي نسائي 652",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit652.png",
		}
	},

	["womenoutfit650"] = {
		label = "زي نسائي 650",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit650.png",
		}
	},

	["OutfitMen120"] = {
		label = "بدلة رجالية 120",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen120.png",
		}
	},

	["womenoutfit143"] = {
		label = "زي نسائي 143",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit143.png",
		}
	},

	["WomenHats118"] = {
		label = "قبعة نسائية 118",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats118.png",
		}
	},

	["womenoutfit648"] = {
		label = "زي نسائي 648",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit648.png",
		}
	},

	["provision_raccoon_fur"] = {
		label = "فراء الراكون",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم مأخوذ من الراكون.",
		client = {
			image = "provision_raccoon_fur.png",
		}
	},

	["WomenGloves009"] = {
		label = "قفازات نسائية 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves009.png",
		}
	},

	["bee_house_gk_1"] = {
		label = "بيت النحل 1",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 1",
		client = {
			image = "bee_house_gk_1.png",
		}
	},

	["furnace"] = {
		label = "فرن",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "furnace.png",
		}
	},

	["menoutfit114"] = {
		label = "ملابس الرجال 114",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit114.png",
		}
	},

	["womenoutfit647"] = {
		label = "زي نسائي 647",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit647.png",
		}
	},

	["vvv_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "vvv_news.png",
		}
	},

	["womenoutfit646"] = {
		label = "زي نسائي 646",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit646.png",
		}
	},

	["womenoutfit644"] = {
		label = "زي نسائي 644",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit644.png",
		}
	},

	["perfect_elk_pelt"] = {
		label = "فرو وعل ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو وعل بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_elk_pelt.png",
		}
	},

	["womenoutfit296"] = {
		label = "زي نسائي 296",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit296.png",
		}
	},

	["womenoutfit642"] = {
		label = "زي نسائي 642",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit642.png",
		}
	},

	["COUGAR_VAR_001"] = {
		label = "كوجر أسطوري ذهبي",
		weight = 250,
		stack = false,
		close = true,
		description = "جلد كوجر أسطوري ذهبي اللون.",
		client = {
			image = "COUGAR_VAR_001.png",
		}
	},

	["Boost_For_Horse"] = {
		label = "تعزيز للحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "Boost_For_Horse.png",
		}
	},

	["marijuana_joint_double1"] = {
		label = "لفافة ماريجوانا مزدوجة 1",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا مزدوجة 1",
		client = {
			image = "marijuana_joint_double1.png",
		}
	},

	["OutfitMen037"] = {
		label = "بدلة رجالية 037",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen037.png",
		}
	},

	["WomenNecklaces002"] = {
		label = "قلادة نسائية 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces002.png",
		}
	},

	["womenoutfit335"] = {
		label = "زي نسائي 335",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit335.png",
		}
	},

	["r_locker6"] = {
		label = "خزنة رقم 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker6.png",
		}
	},

	["womenoutfit339"] = {
		label = "زي نسائي 339",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit339.png",
		}
	},

	["womenoutfit494"] = {
		label = "زي نسائي 494",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit494.png",
		}
	},

	["womenoutfit64"] = {
		label = "زي نسائي 64",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit64.png",
		}
	},

	["womenoutfit111"] = {
		label = "زي نسائي 111",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit111.png",
		}
	},

	["womenoutfit12"] = {
		label = "زي نسائي 12",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit12.png",
		}
	},

	["womenoutfit637"] = {
		label = "زي نسائي 637",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit637.png",
		}
	},

	["horsestim"] = {
		label = "منشط الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط الحصان",
		client = {
			image = "horsestim.png",
		}
	},

	["womenoutfit636"] = {
		label = "زي نسائي 636",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit636.png",
		}
	},

	["legendary_Ewolf_pelt"] = {
		label = "فرو ذئب أسطوري (E)",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب أسطوري من المناطق الشرقية، ذو قيمة عالية للتصنيع.",
		client = {
			image = "legendary_Ewolf_pelt.png",
		}
	},

	["poor_rabbit_pelt"] = {
		label = "فرو أرنب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرنب بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_rabbit_pelt.png",
		}
	},

	["womenoutfit635"] = {
		label = "زي نسائي 635",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit635.png",
		}
	},

	["lumber_oak_sawed_plank"] = {
		label = "لوح خشب البلوط المنشور",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح خشب البلوط المنشور",
		client = {
			image = "lumber_oak_sawed_plank.png",
		}
	},

	["womenoutfit836"] = {
		label = "زي نسائي 836",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit836.png",
		}
	},

	["marijuana_jar1"] = {
		label = "جرة الماريجوانا 1",
		weight = 250,
		stack = true,
		close = true,
		description = "جرة الماريجوانا 1",
		client = {
			image = "marijuana_jar1.png",
		}
	},

	["marijuana_joint2_6"] = {
		label = "لفافة ماريجوانا 2-6",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-6",
		client = {
			image = "marijuana_joint2_6.png",
		}
	},

	["OutfitMen026"] = {
		label = "بدلة رجالية 026",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen026.png",
		}
	},

	["MenOutfits14"] = {
		label = "زي رجالي 14",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits14.png",
		}
	},

	["p_badge"] = {
		label = "Pinkerton Badge",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "p_badge.png",
		}
	},

	["petfood"] = {
		label = "Pet Food",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "petfood.png",
		}
	},

	["womenoutfit632"] = {
		label = "زي نسائي 632",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit632.png",
		}
	},

	["womenoutfit63"] = {
		label = "زي نسائي 63",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit63.png",
		}
	},

	["WomenHats194"] = {
		label = "قبعة نسائية 194",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats194.png",
		}
	},

	["OutfitMen142"] = {
		label = "بدلة رجالية 142",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen142.png",
		}
	},

	["womenoutfit783"] = {
		label = "زي نسائي 783",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit783.png",
		}
	},

	["womenoutfit628"] = {
		label = "زي نسائي 628",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit628.png",
		}
	},

	["dryhemp_dc"] = {
		label = "Dry Desert Cough",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the arid and resilient desert landscapes!",
		client = {
			image = "dryhemp_dc.png",
		}
	},

	["medium_cow_pelt"] = {
		label = "فرو بقرة متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بقرة بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_cow_pelt.png",
		}
	},

	["womenoutfit626"] = {
		label = "زي نسائي 626",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit626.png",
		}
	},

	["neckwear"] = {
		label = "ملابس العنق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "neckwear.png",
		}
	},

	["vasochique"] = {
		label = "Vaso Chique",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "vasochique.png",
		}
	},

	["womenoutfit354"] = {
		label = "زي نسائي 354",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit354.png",
		}
	},

	["womenoutfit625"] = {
		label = "زي نسائي 625",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit625.png",
		}
	},

	["menoutfit61"] = {
		label = "ملابس الرجال 61",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit61.png",
		}
	},

	["womenoutfit622"] = {
		label = "زي نسائي 622",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit622.png",
		}
	},

	["womenoutfit488"] = {
		label = "زي نسائي 488",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit488.png",
		}
	},

	["womenoutfit481"] = {
		label = "زي نسائي 481",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit481.png",
		}
	},

	["OutfitMen030"] = {
		label = "بدلة رجالية 030",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen030.png",
		}
	},

	["Fertilizerpro"] = {
		label = "سماد برو",
		weight = 250,
		stack = true,
		close = true,
		description = "سماد برو هو منتج زراعي متطور مصمم لتعزيز نمو النباتات وزيادة خصوبة التربة",
		client = {
			image = "Fertilizerpro.png",
		}
	},

	["womenoutfit621"] = {
		label = "زي نسائي 621",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit621.png",
		}
	},

	["womenoutfit620"] = {
		label = "زي نسائي 620",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit620.png",
		}
	},

	["OutfitMen065"] = {
		label = "بدلة رجالية 065",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen065.png",
		}
	},

	["MenOutfits22"] = {
		label = "زي رجالي 22",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits22.png",
		}
	},

	["WomenOutfit010"] = {
		label = "زي نسائي 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit010.png",
		}
	},

	["milk_bucket"] = {
		label = "حليب غير مبستر",
		weight = 250,
		stack = true,
		close = true,
		description = "حليب غير مبستر",
		client = {
			image = "milk_bucket.png",
		}
	},

	["s_inv_cigcard_hrs_06x"] = {
		label = "بطاقة السجائر سلالات الخيول 06",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #06",
		client = {
			image = "s_inv_cigcard_hrs_06x.png",
		}
	},

	["womenoutfit263"] = {
		label = "زي نسائي 263",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit263.png",
		}
	},

	["WomenHats058"] = {
		label = "قبعة نسائية 058",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats058.png",
		}
	},

	["womenoutfit617"] = {
		label = "زي نسائي 617",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit617.png",
		}
	},

	["CartTag"] = {
		label = "علامة العربة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "CartTag.png",
		}
	},

	["WomenGloves008"] = {
		label = "قفازات نسائية 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves008.png",
		}
	},

	["womenoutfit576"] = {
		label = "زي نسائي 576",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit576.png",
		}
	},

	["provision_elk_antlers"] = {
		label = "قرون الأيل",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون الأيل الكبيرة.",
		client = {
			image = "provision_elk_antlers.png",
		}
	},

	["womenoutfit538"] = {
		label = "زي نسائي 538",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit538.png",
		}
	},

	["pocket_watch_gold"] = {
		label = "ساعة ذهبية",
		weight = 250,
		stack = true,
		close = true,
		description = "ساعة جيب فاخرة مصنوعة من الذهب.",
		client = {
			image = "pocket_watch_gold.png",
		}
	},

	["womenoutfit610"] = {
		label = "زي نسائي 610",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit610.png",
		}
	},

	["WomenOutfits44"] = {
		label = "زي نسائي 44",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits44.png",
		}
	},

	["womenoutfit273"] = {
		label = "زي نسائي 273",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit273.png",
		}
	},

	["WomenBracelets004"] = {
		label = "سوار نسائي 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets004.png",
		}
	},

	["WomenHats078"] = {
		label = "قبعة نسائية 078",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats078.png",
		}
	},

	["womenoutfit608"] = {
		label = "زي نسائي 608",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit608.png",
		}
	},

	["WomenHats207"] = {
		label = "قبعة نسائية 207",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats207.png",
		}
	},

	["mapa_04"] = {
		label = "الخريطة المفقودة 4",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 4",
		client = {
			image = "mapa_04.png",
		}
	},

	["legendarysaddle"] = {
		label = "سرج أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "سرج نادر",
		client = {
			image = "legendarysaddle.png",
		}
	},

	["WomenOutfits01"] = {
		label = "زي نسائي 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits01.png",
		}
	},

	["MenOutfits16"] = {
		label = "زي رجالي 16",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits16.png",
		}
	},

	["WomenHats019"] = {
		label = "قبعة نسائية 019",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats019.png",
		}
	},

	["OutfitMen025"] = {
		label = "بدلة رجالية 025",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen025.png",
		}
	},

	["bandeira_saudi"] = {
		label = "bandeira saudi",
		weight = 250,
		stack = false,
		close = true,
		description = "bandeira saudi",
		client = {
			image = "bandeira_saudi.png",
		}
	},

	["hat4"] = {
		label = "قبعة 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat4.png",
		}
	},

	["WomenHats130"] = {
		label = "قبعة نسائية 130",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats130.png",
		}
	},

	["lumber_oak_hardwood"] = {
		label = "خشب البلوط الصلب",
		weight = 250,
		stack = true,
		close = true,
		description = "خشب البلوط الصلب",
		client = {
			image = "lumber_oak_hardwood.png",
		}
	},

	["provision_legendary_cougar_claw"] = {
		label = "مخلب كوغار أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب حاد من كوغار أسطوري.",
		client = {
			image = "provision_legendary_cougar_claw.png",
		}
	},

	["poor_apronghorn_meat"] = {
		label = "لحم ظبي رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ظبي بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_apronghorn_meat.png",
		}
	},

	["WomenNecklaces003"] = {
		label = "قلادة نسائية 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces003.png",
		}
	},

	["womenoutfit603"] = {
		label = "زي نسائي 603",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit603.png",
		}
	},

	["WomenOutfit088"] = {
		label = "زي نسائي 088",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit088.png",
		}
	},

	["resource_bag_zinc"] = {
		label = "كيس الزنك",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس الزنك",
		client = {
			image = "resource_bag_zinc.png",
		}
	},

	["womenoutfit397"] = {
		label = "زي نسائي 397",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit397.png",
		}
	},

	["WomenBracelets006"] = {
		label = "سوار نسائي 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets006.png",
		}
	},

	["medium_aligator_meat"] = {
		label = "لحم تمساح متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_aligator_meat.png",
		}
	},

	["provision_cougar_fur"] = {
		label = "فراء بوما",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم مأخوذ من البوما.",
		client = {
			image = "provision_cougar_fur.png",
		}
	},

	["poor_moose_meat"] = {
		label = "لحم موظ رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم موظ بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_moose_meat.png",
		}
	},

	["WomenHats024"] = {
		label = "قبعة نسائية 024",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats024.png",
		}
	},

	["clothingset"] = {
		label = "طقم ملابس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothingset.png",
		}
	},

	["womenoutfit601"] = {
		label = "زي نسائي 601",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit601.png",
		}
	},

	["s_inv_cigcard_act_05x"] = {
		label = "بطاقة السجائر 05",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 05",
		client = {
			image = "s_inv_cigcard_act_05x.png",
		}
	},

	["WomenHats009"] = {
		label = "قبعة نسائية 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats009.png",
		}
	},

	["womenoutfit316"] = {
		label = "زي نسائي 316",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit316.png",
		}
	},

	["OutfitMen102"] = {
		label = "بدلة رجالية 102",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen102.png",
		}
	},

	["p_legendaryfwspinner"] = {
		label = "الطُعم الدوار الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "طُعم خاص مصمم لصيد الأسماك الأسطورية.",
		client = {
			image = "p_legendaryfwspinner.png",
		}
	},

	["womenoutfit600"] = {
		label = "زي نسائي 600",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit600.png",
		}
	},

	["weed_raw"] = {
		label = "حشيش خام",
		weight = 200,
		stack = true,
		close = true,
		description = "محصول لم يُفرز بعد - لا قيمة له قبل الفرز.",
		client = {
			image = "weed_raw.png",
		}
	},

	["womenoutfit60"] = {
		label = "زي نسائي 60",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit60.png",
		}
	},

	["WomenOutfit061"] = {
		label = "زي نسائي 061",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit061.png",
		}
	},

	["tabbaco_chicha_miamour"] = {
		label = "تبغ شيشة ميامور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tabbaco_chicha_miamour.png",
		}
	},

	["womenoutfit598"] = {
		label = "زي نسائي 598",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit598.png",
		}
	},

	["womenoutfit597"] = {
		label = "زي نسائي 597",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit597.png",
		}
	},

	["womenoutfit596"] = {
		label = "زي نسائي 596",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit596.png",
		}
	},

	["legendary_Owolf_pelt"] = {
		label = "فرو ذئب أسطوري (O)",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب أسطوري من المناطق الشمالية، ذو قيمة عالية للتصنيع.",
		client = {
			image = "legendary_Owolf_pelt.png",
		}
	},

	["OutfitMen019"] = {
		label = "بدلة رجالية 019",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen019.png",
		}
	},

	["womenoutfit595"] = {
		label = "زي نسائي 595",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit595.png",
		}
	},

	["provision_coin_1800_five_dollar_eagle"] = {
		label = "1800 Five Dollar Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "A five dollar eagle coin from 1800.",
		client = {
			image = "provision_coin_1800_five_dollar_eagle.png",
		}
	},

	["OutfitMen052"] = {
		label = "بدلة رجالية 052",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen052.png",
		}
	},

	["womenoutfit594"] = {
		label = "زي نسائي 594",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit594.png",
		}
	},

	["MenOutfits04"] = {
		label = "زي رجالي 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits04.png",
		}
	},

	["womenoutfit593"] = {
		label = "زي نسائي 593",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit593.png",
		}
	},

	["s_inv_cigcard_grl_06x"] = {
		label = "بطاقة السجائر جواهر الجمال 06",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #06",
		client = {
			image = "s_inv_cigcard_grl_06x.png",
		}
	},

	["chewing_tobacco"] = {
		label = "تبغ للمضغ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "chewing_tobacco.png",
		}
	},

	["tablepanning"] = {
		label = "Table Panning",
		weight = 250,
		stack = true,
		close = true,
		description = "Table Panning to search for rare items.",
		client = {
			image = "tablepanning.png",
		}
	},

	["perfect_goat_pelt"] = {
		label = "فرو ماعز ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ماعز بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_goat_pelt.png",
		}
	},

	["womenoutfit474"] = {
		label = "زي نسائي 474",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit474.png",
		}
	},

	["womenoutfit592"] = {
		label = "زي نسائي 592",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit592.png",
		}
	},

	["s_inv_cigcard_amer_04x"] = {
		label = "بطاقة السجائر أمريكي 04",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #04",
		client = {
			image = "s_inv_cigcard_amer_04x.png",
		}
	},

	["womenoutfit591"] = {
		label = "زي نسائي 591",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit591.png",
		}
	},

	["womenoutfit59"] = {
		label = "زي نسائي 59",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit59.png",
		}
	},

	["owl_feathers"] = {
		label = "ريش بومة",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش بومة يُستخدم في أعمال التصنيع.",
		client = {
			image = "owl_feathers.png",
		}
	},

	["womenoutfit589"] = {
		label = "زي نسائي 589",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit589.png",
		}
	},

	["resource_pelt_opossum_star_3"] = {
		label = "جلد الأبوسوم 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_opossum_star_3.png",
		}
	},

	["WomenHats035"] = {
		label = "قبعة نسائية 035",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats035.png",
		}
	},

	["womenoutfit586"] = {
		label = "زي نسائي 586",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit586.png",
		}
	},

	["balm_healing"] = {
		label = "Healing Balm",
		weight = 250,
		stack = true,
		close = true,
		description = "A soothing balm for medical treatment.",
		client = {
			image = "balm_healing.png",
		}
	},

	["MenOutfits039"] = {
		label = "زي رجالي 039",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits039.png",
		}
	},

	["womenoutfit585"] = {
		label = "زي نسائي 585",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit585.png",
		}
	},

	["resin"] = {
		label = "الراتنج",
		weight = 250,
		stack = true,
		close = true,
		description = "الراتنج",
		client = {
			image = "resin.png",
		}
	},

	["womenoutfit136"] = {
		label = "زي نسائي 136",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit136.png",
		}
	},

	["MenOutfits29"] = {
		label = "زي رجالي 29",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits29.png",
		}
	},

	["womenoutfit583"] = {
		label = "زي نسائي 583",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit583.png",
		}
	},

	["womenoutfit476"] = {
		label = "زي نسائي 476",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit476.png",
		}
	},

	["womenoutfit582"] = {
		label = "زي نسائي 582",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit582.png",
		}
	},

	["womenoutfit581"] = {
		label = "زي نسائي 581",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit581.png",
		}
	},

	["womenoutfit426"] = {
		label = "زي نسائي 426",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit426.png",
		}
	},

	["womenoutfit579"] = {
		label = "زي نسائي 579",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit579.png",
		}
	},

	["marijuana_joint1_7"] = {
		label = "لفافة ماريجوانا 1-7",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-7",
		client = {
			image = "marijuana_joint1_7.png",
		}
	},

	["marijuana_bud1"] = {
		label = "برعم الماريجوانا 1",
		weight = 250,
		stack = true,
		close = true,
		description = "برعم الماريجوانا 1",
		client = {
			image = "marijuana_bud1.png",
		}
	},

	["provision_ring_pilgrim_moonstone"] = {
		label = "خاتم حجر القمر الحاج",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم حجر القمر الحاج",
		client = {
			image = "provision_ring_pilgrim_moonstone.png",
		}
	},

	["bull_horns"] = {
		label = "قرنان ثور",
		weight = 250,
		stack = true,
		close = true,
		description = "قرنان من ثور يمكن استخدامهما في التصنيع أو الزينة.",
		client = {
			image = "bull_horns.png",
		}
	},

	["womenoutfit578"] = {
		label = "زي نسائي 578",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit578.png",
		}
	},

	["womenoutfit577"] = {
		label = "زي نسائي 577",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit577.png",
		}
	},

	["medium_boar_meat"] = {
		label = "لحم خنزير بري متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم خنزير بري بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_boar_meat.png",
		}
	},

	["womenoutfit616"] = {
		label = "زي نسائي 616",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit616.png",
		}
	},

	["womenoutfit575"] = {
		label = "زي نسائي 575",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit575.png",
		}
	},

	["WomenHats054"] = {
		label = "قبعة نسائية 054",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats054.png",
		}
	},

	["WomenHats045"] = {
		label = "قبعة نسائية 045",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats045.png",
		}
	},

	["perfect_deer_pelt"] = {
		label = "فرو غزال ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_deer_pelt.png",
		}
	},

	["womenoutfit94"] = {
		label = "زي نسائي 94",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit94.png",
		}
	},

	["marijuana_bud3"] = {
		label = "برعم الماريجوانا 3",
		weight = 250,
		stack = true,
		close = true,
		description = "برعم الماريجوانا 3",
		client = {
			image = "marijuana_bud3.png",
		}
	},

	["womenoutfit570"] = {
		label = "زي نسائي 570",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit570.png",
		}
	},

	["statue"] = {
		label = "Estátua",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "statue.png",
		}
	},

	["womenoutfit57"] = {
		label = "زي نسائي 57",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit57.png",
		}
	},

	["s_inv_cigcard_inv_04x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 04",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #04",
		client = {
			image = "s_inv_cigcard_inv_04x.png",
		}
	},

	["WomenOutfit093"] = {
		label = "زي نسائي 093",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit093.png",
		}
	},

	["animal_snakewater"] = {
		label = "ثعبان الماء",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان الماء",
		client = {
			image = "animal_snakewater.png",
		}
	},

	["womenoutfit569"] = {
		label = "زي نسائي 569",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit569.png",
		}
	},

	["OutfitMen181"] = {
		label = "بدلة رجالية 181",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen181.png",
		}
	},

	["womenoutfit568"] = {
		label = "زي نسائي 568",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit568.png",
		}
	},

	["egg_condor"] = {
		label = "بيضة كوندور",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة كوندور.",
		client = {
			image = "egg_condor.png",
		}
	},

	["OutfitMen138"] = {
		label = "بدلة رجالية 138",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen138.png",
		}
	},

	["provision_trinket_pronghorn_antler"] = {
		label = "تعويذة قرن الظبي",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من قرون الظبي.",
		client = {
			image = "provision_trinket_pronghorn_antler.png",
		}
	},

	["womenoutfit362"] = {
		label = "زي نسائي 362",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit362.png",
		}
	},

	["menoutfit72"] = {
		label = "ملابس الرجال 72",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit72.png",
		}
	},

	["WomenHats146"] = {
		label = "قبعة نسائية 146",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats146.png",
		}
	},

	["womenoutfit561"] = {
		label = "زي نسائي 561",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit561.png",
		}
	},

	["goldcoin"] = {
		label = "عملة ذهبية",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع العملة الذهبية بأسعار مرتفعة.",
		client = {
			image = "goldcoin.png",
		}
	},

	["womenoutfit558"] = {
		label = "زي نسائي 558",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit558.png",
		}
	},

	["consumable_horse_reviver"] = {
		label = "منشط الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "دواء لإنعاش الحصان الساقط",
		client = {
			image = "consumable_horse_reviver.png",
		}
	},

	["watermelon"] = {
		label = "بطيخ مقطع",
		weight = 250,
		stack = true,
		close = true,
		description = "بطيخ مقطع",
		client = {
			image = "watermelon.png",
		}
	},

	["womenoutfit557"] = {
		label = "زي نسائي 557",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit557.png",
		}
	},

	["womenoutfit555"] = {
		label = "زي نسائي 555",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit555.png",
		}
	},

	["womenoutfit554"] = {
		label = "زي نسائي 554",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit554.png",
		}
	},

	["womenoutfit553"] = {
		label = "زي نسائي 553",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit553.png",
		}
	},

	["resource_pelt_fox_star_3"] = {
		label = "جلد الثعلب 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_fox_star_3.png",
		}
	},

	["womenoutfit162"] = {
		label = "زي نسائي 162",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit162.png",
		}
	},

	["womenoutfit552"] = {
		label = "زي نسائي 552",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit552.png",
		}
	},

	["womenoutfit551"] = {
		label = "زي نسائي 551",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit551.png",
		}
	},

	["OutfitMen166"] = {
		label = "بدلة رجالية 166",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen166.png",
		}
	},

	["womenoutfit550"] = {
		label = "زي نسائي 550",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit550.png",
		}
	},

	["menoutfit109"] = {
		label = "ملابس الرجال 109",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit109.png",
		}
	},

	["womenoutfit55"] = {
		label = "زي نسائي 55",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit55.png",
		}
	},

	["ammohatchet"] = {
		label = "ذخيرة الفأس المرمي",
		weight = 250,
		stack = true,
		close = true,
		description = "ذخيرة الفأس تُستخدم كسلاح رمي.",
		client = {
			image = "ammohatchet.png",
		}
	},

	["womenoutfit546"] = {
		label = "زي نسائي 546",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit546.png",
		}
	},

	["s_inv_cigcard_lnd_02x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 02",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #02",
		client = {
			image = "s_inv_cigcard_lnd_02x.png",
		}
	},

	["OutfitMen121"] = {
		label = "بدلة رجالية 121",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen121.png",
		}
	},

	["scopeshortwinchester"] = {
		label = "Repeater Winchester Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortwinchester.png",
		}
	},

	["womenoutfit545"] = {
		label = "زي نسائي 545",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit545.png",
		}
	},

	["womenoutfit544"] = {
		label = "زي نسائي 544",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit544.png",
		}
	},

	["clothe4"] = {
		label = "ملابس 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe4.png",
		}
	},

	["womenoutfit191"] = {
		label = "زي نسائي 191",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit191.png",
		}
	},

	["womenoutfit549"] = {
		label = "زي نسائي 549",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit549.png",
		}
	},

	["MenOutfits33"] = {
		label = "زي رجالي 33",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits33.png",
		}
	},

	["WomenOutfit067"] = {
		label = "زي نسائي 067",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit067.png",
		}
	},

	["resource_box_artichokes"] = {
		label = "صندوق القوق",
		weight = 250,
		stack = true,
		close = true,
		description = "صندوق القوق",
		client = {
			image = "resource_box_artichokes.png",
		}
	},

	["womenoutfit540"] = {
		label = "زي نسائي 540",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit540.png",
		}
	},

	["womenoutfit535"] = {
		label = "زي نسائي 535",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit535.png",
		}
	},

	["WomenHats155"] = {
		label = "قبعة نسائية 155",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats155.png",
		}
	},

	["clothe2"] = {
		label = "ملابس 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe2.png",
		}
	},

	["womenoutfit530"] = {
		label = "زي نسائي 530",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit530.png",
		}
	},

	["womenoutfit669"] = {
		label = "زي نسائي 669",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit669.png",
		}
	},

	["womenoutfit528"] = {
		label = "زي نسائي 528",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit528.png",
		}
	},

	["womenoutfit527"] = {
		label = "زي نسائي 527",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit527.png",
		}
	},

	["womenoutfit526"] = {
		label = "زي نسائي 526",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit526.png",
		}
	},

	["bee_house_gk_5"] = {
		label = "بيت النحل 5",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 5",
		client = {
			image = "bee_house_gk_5.png",
		}
	},

	["womenoutfit525"] = {
		label = "زي نسائي 525",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit525.png",
		}
	},

	["womenoutfit523"] = {
		label = "زي نسائي 523",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit523.png",
		}
	},

	["WomenNecklaces011"] = {
		label = "قلادة نسائية 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces011.png",
		}
	},

	["womenoutfit522"] = {
		label = "زي نسائي 522",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit522.png",
		}
	},

	["womenoutfit521"] = {
		label = "زي نسائي 521",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit521.png",
		}
	},

	["r_locker7"] = {
		label = "خزنة رقم 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker7.png",
		}
	},

	["ban1"] = {
		label = "باندانا 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ban1.png",
		}
	},

	["s_inv_cigcard_plt_11x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 1",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #11",
		client = {
			image = "s_inv_cigcard_plt_11x.png",
		}
	},

	["provision_trinket_hawk_talon"] = {
		label = "تعويذة مخلب الصقر",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من مخلب صقر.",
		client = {
			image = "provision_trinket_hawk_talon.png",
		}
	},

	["womenoutfit519"] = {
		label = "زي نسائي 519",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit519.png",
		}
	},

	["womenoutfit468"] = {
		label = "زي نسائي 468",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit468.png",
		}
	},

	["consumable_cigar"] = {
		label = "سيجار",
		weight = 250,
		stack = true,
		close = true,
		description = "سيجار فاخر للاسترخاء.",
		client = {
			image = "consumable_cigar.png",
		}
	},

	["provision_legendary_alligator_skin"] = {
		label = "جلد تمساح أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد نادر من تمساح أسطوري",
		client = {
			image = "provision_legendary_alligator_skin.png",
		}
	},

	["poor_peccary_pelt"] = {
		label = "فرو بيكاري رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بيكاري بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_peccary_pelt.png",
		}
	},

	["medium_skunk_pelt"] = {
		label = "فرو ظربان متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظربان بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_skunk_pelt.png",
		}
	},

	["baghemp_md"] = {
		label = "Bagged Mountain Dew",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp collected from the misty heights of the mountains!",
		client = {
			image = "baghemp_md.png",
		}
	},

	["WomenHats077"] = {
		label = "قبعة نسائية 077",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats077.png",
		}
	},

	["goose_feathers"] = {
		label = "ريش إوز",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش إوز يُستخدم في أعمال التصنيع.",
		client = {
			image = "goose_feathers.png",
		}
	},

	["corojocigar"] = {
		label = "سيجار كوروجو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "corojocigar.png",
		}
	},

	["provision_legendary_beaver_fur"] = {
		label = "فراء قندس أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم من قندس أسطوري.",
		client = {
			image = "provision_legendary_beaver_fur.png",
		}
	},

	["menoutfit96"] = {
		label = "ملابس الرجال 96",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit96.png",
		}
	},

	["womenoutfit517"] = {
		label = "زي نسائي 517",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit517.png",
		}
	},

	["womenoutfit827"] = {
		label = "زي نسائي 827",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit827.png",
		}
	},

	["womenoutfit223"] = {
		label = "زي نسائي 223",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit223.png",
		}
	},

	["firetown"] = {
		label = "نار البلدة",
		weight = 250,
		stack = true,
		close = true,
		description = "نار البلدة",
		client = {
			image = "firetown.png",
		}
	},

	["WomenHats060"] = {
		label = "قبعة نسائية 060",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats060.png",
		}
	},

	["OutfitMen032"] = {
		label = "بدلة رجالية 032",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen032.png",
		}
	},

	["womenoutfit514"] = {
		label = "زي نسائي 514",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit514.png",
		}
	},

	["indian_pipe"] = {
		label = "غليون هندي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "indian_pipe.png",
		}
	},

	["marijuana_joint2"] = {
		label = "لفافة ماريجوانا 2",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2",
		client = {
			image = "marijuana_joint2.png",
		}
	},

	["iur_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "iur_news.png",
		}
	},

	["consumable_can_peaches"] = {
		label = "خوخ معلب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_can_peaches.png",
		}
	},

	["s_inv_cigcard_spt_01x"] = {
		label = "بطاقة السجائر أبطال العالم 01",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #01",
		client = {
			image = "s_inv_cigcard_spt_01x.png",
		}
	},

	["womenoutfit513"] = {
		label = "زي نسائي 513",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit513.png",
		}
	},

	["womenoutfit438"] = {
		label = "زي نسائي 438",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit438.png",
		}
	},

	["OutfitMen145"] = {
		label = "بدلة رجالية 145",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen145.png",
		}
	},

	["weddingdress"] = {
		label = "فستان زفاف",
		weight = 250,
		stack = false,
		close = true,
		description = "فستان زفاف أنيق.",
		client = {
			image = "weddingdress.png",
		}
	},

	["womenoutfit512"] = {
		label = "زي نسائي 512",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit512.png",
		}
	},

	["womenoutfit511"] = {
		label = "زي نسائي 511",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit511.png",
		}
	},

	["bread"] = {
		label = "خبز",
		weight = 250,
		stack = true,
		close = true,
		description = "خبز طازج يشبع الجوع",
		client = {
			image = "bread.png",
		}
	},

	["resource_skin_lizard_star_2"] = {
		label = "جلد السحلية 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_lizard_star_2.png",
		}
	},

	["legendary_fox_meat"] = {
		label = "لحم ثعلب أحمر أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثعلب أحمر أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_fox_meat.png",
		}
	},

	["golden_tonic"] = {
		label = "المنشط الذهبي",
		weight = 250,
		stack = true,
		close = true,
		description = "المنشط الذهبي",
		client = {
			image = "golden_tonic.png",
		}
	},

	["womenoutfit383"] = {
		label = "زي نسائي 383",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit383.png",
		}
	},

	["provision_elk_fur"] = {
		label = "فراء الأيل",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم مأخوذ من الأيل.",
		client = {
			image = "provision_elk_fur.png",
		}
	},

	["womenoutfit361"] = {
		label = "زي نسائي 361",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit361.png",
		}
	},

	["OutfitMen140"] = {
		label = "بدلة رجالية 140",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen140.png",
		}
	},

	["womenoutfit509"] = {
		label = "زي نسائي 509",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit509.png",
		}
	},

	["OutfitMen197"] = {
		label = "بدلة رجالية 197",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen197.png",
		}
	},

	["consumable_plymouth_gin"] = {
		label = "جين بليموث",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب جين بليموث.",
		client = {
			image = "consumable_plymouth_gin.png",
		}
	},

	["WomenHats055"] = {
		label = "قبعة نسائية 055",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats055.png",
		}
	},

	["MenOutfits024"] = {
		label = "زي رجالي 024",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits024.png",
		}
	},

	["a_c_fishrainbowtrout_01_lg"] = {
		label = "Rainbow Trout (Large)",
		weight = 3800,
		stack = true,
		close = true,
		description = "A large Rainbow Trout",
		client = {
			image = "a_c_fishrainbowtrout_01_lg.png",
		}
	},

	["consumable_tea_sage"] = {
		label = "شاي المريمية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tea_sage.png",
		}
	},

	["coffee"] = {
		label = "قهوة",
		weight = 250,
		stack = true,
		close = true,
		description = "قهوة ساخنة منعشة",
		client = {
			image = "coffee.png",
		}
	},

	["clothe10"] = {
		label = "ملابس 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe10.png",
		}
	},

	["womenoutfit507"] = {
		label = "زي نسائي 507",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit507.png",
		}
	},

	["womenoutfit25"] = {
		label = "زي نسائي 25",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit25.png",
		}
	},

	["womenoutfit506"] = {
		label = "زي نسائي 506",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit506.png",
		}
	},

	["womenoutfit505"] = {
		label = "زي نسائي 505",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit505.png",
		}
	},

	["building_plan_7"] = {
		label = "ورقة بناء بيت 7",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_7.png",
		}
	},

	["apiary_honeycomb_gk"] = {
		label = "قرص العسل gk",
		weight = 250,
		stack = true,
		close = true,
		description = "قرص العسل gk",
		client = {
			image = "apiary_honeycomb_gk.png",
		}
	},

	["womenoutfit503"] = {
		label = "زي نسائي 503",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit503.png",
		}
	},

	["womenoutfit133"] = {
		label = "زي نسائي 133",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit133.png",
		}
	},

	["consumable_platter_lobster"] = {
		label = "طبق لوبستر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_platter_lobster.png",
		}
	},

	["womenoutfit50"] = {
		label = "زي نسائي 50",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit50.png",
		}
	},

	["legendary_cougar_meat"] = {
		label = "لحم أسد الجبل أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم أسد الجبل أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_cougar_meat.png",
		}
	},

	["a_egg"] = {
		label = "بيضة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_egg.png",
		}
	},

	["s_inv_cigcard_amer_05x"] = {
		label = "بطاقة السجائر أمريكي 05",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #05",
		client = {
			image = "s_inv_cigcard_amer_05x.png",
		}
	},

	["womenoutfit499"] = {
		label = "زي نسائي 499",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit499.png",
		}
	},

	["womenoutfit130"] = {
		label = "زي نسائي 130",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit130.png",
		}
	},

	["poor_buffalo_meat"] = {
		label = "لحم جاموس رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم جاموس بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_buffalo_meat.png",
		}
	},

	["WomenGloves001"] = {
		label = "قفازات نسائية 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves001.png",
		}
	},

	["WomenOutfit081"] = {
		label = "زي نسائي 081",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit081.png",
		}
	},

	["toad_animal"] = {
		label = "علجوم",
		weight = 100,
		stack = true,
		close = true,
		description = "علجوم صغير يمكن استخدامه في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "toad_animal.png",
		}
	},

	["spawnclassic3"] = {
		label = "classic",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "spawnclassic3.png",
		}
	},

	["OutfitMen095"] = {
		label = "بدلة رجالية 095",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen095.png",
		}
	},

	["womenoutfit493"] = {
		label = "زي نسائي 493",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit493.png",
		}
	},

	["docbandage"] = {
		label = "Doctor Bandage",
		weight = 250,
		stack = true,
		close = true,
		description = "A medical supply used by doctors to revive downed players.",
		client = {
			image = "docbandage.png",
		}
	},

	["weed"] = {
		label = "حشيش",
		weight = 250,
		stack = true,
		close = true,
		description = "حشيش",
		client = {
			image = "weed.png",
		}
	},

	["womenoutfit492"] = {
		label = "زي نسائي 492",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit492.png",
		}
	},

	["womenoutfit490"] = {
		label = "زي نسائي 490",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit490.png",
		}
	},

	["womenoutfit124"] = {
		label = "زي نسائي 124",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit124.png",
		}
	},

	["womenoutfit489"] = {
		label = "زي نسائي 489",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit489.png",
		}
	},

	["cuthemp_bb"] = {
		label = "Trimmed Bayou Bliss",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the muckiness of the bayou!",
		client = {
			image = "cuthemp_bb.png",
		}
	},

	["womenoutfit486"] = {
		label = "زي نسائي 486",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit486.png",
		}
	},

	["WomenOutfit006"] = {
		label = "زي نسائي 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit006.png",
		}
	},

	["womenoutfit485"] = {
		label = "زي نسائي 485",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit485.png",
		}
	},

	["katana03"] = {
		label = "كاتانا 03",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana03.png",
		}
	},

	["WomenOutfit076"] = {
		label = "زي نسائي 076",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit076.png",
		}
	},

	["oil_paper"] = {
		label = "رخصة النفظ ",
		weight = 250,
		stack = false,
		close = true,
		description = "رخصة النفظ ",
		client = {
			image = "oil_paper.png",
		}
	},

	["womenoutfit350"] = {
		label = "زي نسائي 350",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit350.png",
		}
	},

	["OutfitMen002"] = {
		label = "بدلة رجالية 002",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen002.png",
		}
	},

	["provision_pig_skin"] = {
		label = "جلد الخنزير",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد سميك مأخوذ من خنزير.",
		client = {
			image = "provision_pig_skin.png",
		}
	},

	["consumable_donut7"] = {
		label = "دونات 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut7.png",
		}
	},

	["womenoutfit480"] = {
		label = "زي نسائي 480",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit480.png",
		}
	},

	["womenoutfit48"] = {
		label = "زي نسائي 48",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit48.png",
		}
	},

	["womenoutfit479"] = {
		label = "زي نسائي 479",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit479.png",
		}
	},

	["womenoutfit477"] = {
		label = "زي نسائي 477",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit477.png",
		}
	},

	["lumber_cedar_sawed_plank"] = {
		label = "لوح خشب الأرز المنشور",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح خشب الأرز المنشور",
		client = {
			image = "lumber_cedar_sawed_plank.png",
		}
	},

	["OutfitMen167"] = {
		label = "بدلة رجالية 167",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen167.png",
		}
	},

	["WomenHats026"] = {
		label = "قبعة نسائية 026",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats026.png",
		}
	},

	["WomenNecklaces012"] = {
		label = "قلادة نسائية 012",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces012.png",
		}
	},

	["menoutfit70"] = {
		label = "ملابس الرجال 70",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit70.png",
		}
	},

	["womenoutfit472"] = {
		label = "زي نسائي 472",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit472.png",
		}
	},

	["door8"] = {
		label = "مفتاح الباب 8",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door8.png",
		}
	},

	["provision_armadillo_skin"] = {
		label = "جلد أرماديلو",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد أرماديلو",
		client = {
			image = "provision_armadillo_skin.png",
		}
	},

	["womenoutfit62"] = {
		label = "زي نسائي 62",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit62.png",
		}
	},

	["wethemp_ti"] = {
		label = "Wet Tropical Indica",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush, tropical regions!",
		client = {
			image = "wethemp_ti.png",
		}
	},

	["womenoutfit470"] = {
		label = "زي نسائي 470",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit470.png",
		}
	},

	["WomenHats025"] = {
		label = "قبعة نسائية 025",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats025.png",
		}
	},

	["animal_cardinal"] = {
		label = "طائر الكاردينال",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر الكاردينال.",
		client = {
			image = "animal_cardinal.png",
		}
	},

	["bountyhunterlicense"] = {
		label = "رخصة صائد الجوائز",
		weight = 250,
		stack = false,
		close = true,
		description = "رخصة صائد الجوائز",
		client = {
			image = "bountyhunterlicense.png",
		}
	},

	["docverify"] = {
		label = "طقم التحقق من الإصابات",
		weight = 250,
		stack = true,
		close = true,
		description = "استخدم هذه المجموعة للتحقق من المصابين!",
		client = {
			image = "docverify.png",
		}
	},

	["womenoutfit341"] = {
		label = "زي نسائي 341",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit341.png",
		}
	},

	["womenoutfit465"] = {
		label = "زي نسائي 465",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit465.png",
		}
	},

	["s_inv_cigcard_amer_09x"] = {
		label = "بطاقة السجائر أمريكي 09",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #09",
		client = {
			image = "s_inv_cigcard_amer_09x.png",
		}
	},

	["womenoutfit464"] = {
		label = "زي نسائي 464",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit464.png",
		}
	},

	["womenoutfit463"] = {
		label = "زي نسائي 463",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit463.png",
		}
	},

	["OutfitMen083"] = {
		label = "بدلة رجالية 083",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen083.png",
		}
	},

	["womenoutfit461"] = {
		label = "زي نسائي 461",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit461.png",
		}
	},

	["womenoutfit459"] = {
		label = "زي نسائي 459",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit459.png",
		}
	},

	["womenoutfit457"] = {
		label = "زي نسائي 457",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit457.png",
		}
	},

	["WomenOutfit095"] = {
		label = "زي نسائي 095",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit095.png",
		}
	},

	["womenoutfit139"] = {
		label = "زي نسائي 139",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit139.png",
		}
	},

	["OutfitMen176"] = {
		label = "بدلة رجالية 176",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen176.png",
		}
	},

	["provision_legendary_buck_fur"] = {
		label = "فراء الأيل الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم وفاخر من أيل أسطوري.",
		client = {
			image = "provision_legendary_buck_fur.png",
		}
	},

	["menoutfit29"] = {
		label = "ملابس الرجال 29",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit29.png",
		}
	},

	["consumable_soup_chickenveg2"] = {
		label = "حساء الدجاج والخضار 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_soup_chickenveg2.png",
		}
	},

	["womenoutfit101"] = {
		label = "زي نسائي 101",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit101.png",
		}
	},

	["clothe7"] = {
		label = "ملابس 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe7.png",
		}
	},

	["womenoutfit34"] = {
		label = "زي نسائي 34",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit34.png",
		}
	},

	["womenoutfit455"] = {
		label = "زي نسائي 455",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit455.png",
		}
	},

	["womenoutfit454"] = {
		label = "زي نسائي 454",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit454.png",
		}
	},

	["womenoutfit32"] = {
		label = "زي نسائي 32",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit32.png",
		}
	},

	["womenoutfit451"] = {
		label = "زي نسائي 451",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit451.png",
		}
	},

	["womenoutfit450"] = {
		label = "زي نسائي 450",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit450.png",
		}
	},

	["menoutfit71"] = {
		label = "ملابس الرجال 71",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit71.png",
		}
	},

	["womenoutfit533"] = {
		label = "زي نسائي 533",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit533.png",
		}
	},

	["lumber_maple_wood_logs"] = {
		label = "جذوع خشب القيقب",
		weight = 250,
		stack = true,
		close = true,
		description = "جذوع خشب القيقب",
		client = {
			image = "lumber_maple_wood_logs.png",
		}
	},

	["OutfitMen073"] = {
		label = "بدلة رجالية 073",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen073.png",
		}
	},

	["womenoutfit448"] = {
		label = "زي نسائي 448",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit448.png",
		}
	},

	["womenoutfit446"] = {
		label = "زي نسائي 446",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit446.png",
		}
	},

	["wethemp_dc"] = {
		label = "Wet Desert Cough",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the arid and resilient desert landscapes!",
		client = {
			image = "wethemp_dc.png",
		}
	},

	["womenoutfit445"] = {
		label = "زي نسائي 445",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit445.png",
		}
	},

	["WomenHats175"] = {
		label = "قبعة نسائية 175",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats175.png",
		}
	},

	["womenoutfit333"] = {
		label = "زي نسائي 333",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit333.png",
		}
	},

	["provision_belt_buckle_silver"] = {
		label = "إبزيم حزام فضي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشبك فضي",
		client = {
			image = "provision_belt_buckle_silver.png",
		}
	},

	["womenoutfit444"] = {
		label = "زي نسائي 444",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit444.png",
		}
	},

	["WomenNecklaces014"] = {
		label = "قلادة نسائية 014",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces014.png",
		}
	},

	["pistolbarrel"] = {
		label = "ماسوره بيستول",
		weight = 250,
		stack = true,
		close = true,
		description = "ماسوره بيستول",
		client = {
			image = "pistolbarrel.png",
		}
	},

	["WomenHats205"] = {
		label = "قبعة نسائية 205",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats205.png",
		}
	},

	["womenoutfit44"] = {
		label = "زي نسائي 44",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit44.png",
		}
	},

	["portable_canoe"] = {
		label = "كنو محمول",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "portable_canoe.png",
		}
	},

	["WomenGloves014"] = {
		label = "قفازات نسائية 014",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves014.png",
		}
	},

	["womenoutfit439"] = {
		label = "زي نسائي 439",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit439.png",
		}
	},

	["womenoutfit437"] = {
		label = "زي نسائي 437",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit437.png",
		}
	},

	["medium_beaver_meat"] = {
		label = "لحم قندس متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم قندس بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_beaver_meat.png",
		}
	},

	["womenoutfit100"] = {
		label = "زي نسائي 100",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit100.png",
		}
	},

	["womenoutfit435"] = {
		label = "زي نسائي 435",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit435.png",
		}
	},

	["WomenHats056"] = {
		label = "قبعة نسائية 056",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats056.png",
		}
	},

	["womenoutfit434"] = {
		label = "زي نسائي 434",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit434.png",
		}
	},

	["womenoutfit433"] = {
		label = "زي نسائي 433",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit433.png",
		}
	},

	["quartz_uncut"] = {
		label = "خام غير مقطوع",
		weight = 250,
		stack = true,
		close = true,
		description = "خام غير مقطوع",
		client = {
			image = "quartz_uncut.png",
		}
	},

	["womenoutfit431"] = {
		label = "زي نسائي 431",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit431.png",
		}
	},

	["womenoutfit43"] = {
		label = "زي نسائي 43",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit43.png",
		}
	},

	["jmhorya"] = {
		label = "جمهورية",
		weight = 250,
		stack = true,
		close = true,
		description = "جمهورية",
		client = {
			image = "jmhorya.png",
		}
	},

	["womenoutfit429"] = {
		label = "زي نسائي 429",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit429.png",
		}
	},

	["womenoutfit427"] = {
		label = "زي نسائي 427",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit427.png",
		}
	},

	["womenoutfit51"] = {
		label = "زي نسائي 51",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit51.png",
		}
	},

	["womenoutfit424"] = {
		label = "زي نسائي 424",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit424.png",
		}
	},

	["perfect_raccoon_pelt"] = {
		label = "فرو راكون ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو راكون بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_raccoon_pelt.png",
		}
	},

	["womenoutfit733"] = {
		label = "زي نسائي 733",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit733.png",
		}
	},

	["womenoutfit420"] = {
		label = "زي نسائي 420",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit420.png",
		}
	},

	["perfect_blackbear_pelt"] = {
		label = "فرو دب أسود ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب أسود بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_blackbear_pelt.png",
		}
	},

	["masks"] = {
		label = "أقنعة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "masks.png",
		}
	},

	["resource_bones"] = {
		label = "مجموعة عظام",
		weight = 250,
		stack = true,
		close = true,
		description = "مجموعة عظام",
		client = {
			image = "resource_bones.png",
		}
	},

	["provision_legendary_moose_fur"] = {
		label = "فراء الموظ الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء دافئ وسميك من موظ أسطوري.",
		client = {
			image = "provision_legendary_moose_fur.png",
		}
	},

	["consumable_mature_venison_oregano_cooked"] = {
		label = "لحم الغزال المطبوخ",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال ناضج ومطبوخ.",
		client = {
			image = "consumable_mature_venison_oregano_cooked.png",
		}
	},

	["kit_horse_reviver"] = {
		label = "horse reviver",
		weight = 250,
		stack = true,
		close = true,
		description = "A half dime coin from 1800.",
		client = {
			image = "kit_horse_reviver.png",
		}
	},

	["OutfitMen070"] = {
		label = "بدلة رجالية 070",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen070.png",
		}
	},

	["minerhat"] = {
		label = "ضمادة شفاء",
		weight = 250,
		stack = true,
		close = true,
		description = "ضمادة لعلاج اللاعبين عندما تكون نقاط صحتهم منخفضة!",
		client = {
			image = "minerhat.png",
		}
	},

	["s_inv_cigcard_act_11x"] = {
		label = "بطاقة السجائر 11",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 11",
		client = {
			image = "s_inv_cigcard_act_11x.png",
		}
	},

	["womenoutfit42"] = {
		label = "زي نسائي 42",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit42.png",
		}
	},

	["womenoutfit197"] = {
		label = "زي نسائي 197",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit197.png",
		}
	},

	["womenoutfit418"] = {
		label = "زي نسائي 418",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit418.png",
		}
	},

	["womenoutfit417"] = {
		label = "زي نسائي 417",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit417.png",
		}
	},

	["WomenHats046"] = {
		label = "قبعة نسائية 046",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats046.png",
		}
	},

	["womenoutfit416"] = {
		label = "زي نسائي 416",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit416.png",
		}
	},

	["womenoutfit117"] = {
		label = "زي نسائي 117",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit117.png",
		}
	},

	["WomenBracelets005"] = {
		label = "سوار نسائي 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets005.png",
		}
	},

	["womenoutfit415"] = {
		label = "زي نسائي 415",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit415.png",
		}
	},

	["womenoutfit414"] = {
		label = "زي نسائي 414",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit414.png",
		}
	},

	["ujm_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "ujm_news.png",
		}
	},

	["eagle_feathers"] = {
		label = "ريش نسر",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش نسر يُستخدم في أعمال التصنيع.",
		client = {
			image = "eagle_feathers.png",
		}
	},

	["s_inv_cigcard_inv_03x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 03",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #03",
		client = {
			image = "s_inv_cigcard_inv_03x.png",
		}
	},

	["womenoutfit413"] = {
		label = "زي نسائي 413",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit413.png",
		}
	},

	["womenoutfit412"] = {
		label = "زي نسائي 412",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit412.png",
		}
	},

	["womenoutfit411"] = {
		label = "زي نسائي 411",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit411.png",
		}
	},

	["womenoutfit403"] = {
		label = "زي نسائي 403",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit403.png",
		}
	},

	["consumable_alcohol_cranberry_sparkler"] = {
		label = "مشروب كحولي توت بري فوار",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب كحولي توت بري فوار",
		client = {
			image = "consumable_alcohol_cranberry_sparkler.png",
		}
	},

	["womenoutfit175"] = {
		label = "زي نسائي 175",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit175.png",
		}
	},

	["womenoutfit384"] = {
		label = "زي نسائي 384",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit384.png",
		}
	},

	["womenoutfit409"] = {
		label = "زي نسائي 409",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit409.png",
		}
	},

	["womenoutfit408"] = {
		label = "زي نسائي 408",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit408.png",
		}
	},

	["medium_redfox_meat"] = {
		label = "لحم ثعلب أحمر متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثعلب أحمر بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_redfox_meat.png",
		}
	},

	["OutfitMen169"] = {
		label = "بدلة رجالية 169",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen169.png",
		}
	},

	["menoutfit30"] = {
		label = "ملابس الرجال 30",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit30.png",
		}
	},

	["OutfitMen071"] = {
		label = "بدلة رجالية 071",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen071.png",
		}
	},

	["womenoutfit744"] = {
		label = "زي نسائي 744",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit744.png",
		}
	},

	["womenoutfit405"] = {
		label = "زي نسائي 405",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit405.png",
		}
	},

	["WomenHats131"] = {
		label = "قبعة نسائية 131",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats131.png",
		}
	},

	["menoutfit19"] = {
		label = "ملابس الرجال 19",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit19.png",
		}
	},

	["club05"] = {
		label = "عصا 05",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club05.png",
		}
	},

	["womenoutfit832"] = {
		label = "زي نسائي 832",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit832.png",
		}
	},

	["MenOutfits032"] = {
		label = "زي رجالي 032",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits032.png",
		}
	},

	["WomenHats105"] = {
		label = "قبعة نسائية 105",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats105.png",
		}
	},

	["womenoutfit410"] = {
		label = "زي نسائي 410",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit410.png",
		}
	},

	["medium_goat_pelt"] = {
		label = "فرو ماعز متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ماعز بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_goat_pelt.png",
		}
	},

	["womenoutfit607"] = {
		label = "زي نسائي 607",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit607.png",
		}
	},

	["womenoutfit401"] = {
		label = "زي نسائي 401",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit401.png",
		}
	},

	["perfect_fox_pelt"] = {
		label = "فرو ثعلب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثعلب بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_fox_pelt.png",
		}
	},

	["womenoutfit399"] = {
		label = "زي نسائي 399",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit399.png",
		}
	},

	["resource_skin_alligator_star_3"] = {
		label = "جلد التمساح 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_alligator_star_3.png",
		}
	},

	["medium_possum_pelt"] = {
		label = "فرو أبوسوم متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أبوسوم بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_possum_pelt.png",
		}
	},

	["womenoutfit655"] = {
		label = "زي نسائي 655",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit655.png",
		}
	},

	["menoutfit97"] = {
		label = "ملابس الرجال 97",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit97.png",
		}
	},

	["resource_skin_iguana_green_star_2"] = {
		label = "جلد الإغوانا 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_iguana_green_star_2.png",
		}
	},

	["WomenHats112"] = {
		label = "قبعة نسائية 112",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats112.png",
		}
	},

	["womenoutfit392"] = {
		label = "زي نسائي 392",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit392.png",
		}
	},

	["scopeshortcarbine"] = {
		label = "Rifle Carbine Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortcarbine.png",
		}
	},

	["MenOutfits30"] = {
		label = "زي رجالي 30",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits30.png",
		}
	},

	["legendary_alligator_meat"] = {
		label = "لحم تمساح أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_alligator_meat.png",
		}
	},

	["societytoken"] = {
		label = "رمز الجمعية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "societytoken.png",
		}
	},

	["provision_ring_yates_diamond"] = {
		label = "خاتم ييتس الماسي",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم ييتس الماسي",
		client = {
			image = "provision_ring_yates_diamond.png",
		}
	},

	["consumable_alcohol_cranberry_mimosa"] = {
		label = "ميموزا التوت البري الكحولية",
		weight = 250,
		stack = true,
		close = true,
		description = "ميموزا التوت البري الكحولية",
		client = {
			image = "consumable_alcohol_cranberry_mimosa.png",
		}
	},

	["hat6"] = {
		label = "قبعة 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat6.png",
		}
	},

	["WomenGloves004"] = {
		label = "قفازات نسائية 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves004.png",
		}
	},

	["womenoutfit391"] = {
		label = "زي نسائي 391",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit391.png",
		}
	},

	["womenoutfit332"] = {
		label = "زي نسائي 332",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit332.png",
		}
	},

	["womenoutfit390"] = {
		label = "زي نسائي 390",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit390.png",
		}
	},

	["womenoutfit39"] = {
		label = "زي نسائي 39",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit39.png",
		}
	},

	["womenoutfit389"] = {
		label = "زي نسائي 389",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit389.png",
		}
	},

	["womenoutfit388"] = {
		label = "زي نسائي 388",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit388.png",
		}
	},

	["womenoutfit387"] = {
		label = "زي نسائي 387",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit387.png",
		}
	},

	["whooping_feathers"] = {
		label = "ريش Whooping",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش Whooping يُستخدم في أعمال التصنيع.",
		client = {
			image = "whooping_feathers.png",
		}
	},

	["womenoutfit386"] = {
		label = "زي نسائي 386",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit386.png",
		}
	},

	["womenoutfit41"] = {
		label = "زي نسائي 41",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit41.png",
		}
	},

	["womenoutfit510"] = {
		label = "زي نسائي 510",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit510.png",
		}
	},

	["WomenNecklaces017"] = {
		label = "قلادة نسائية 017",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces017.png",
		}
	},

	["tabbaco_chicha_lady"] = {
		label = "تبغ شيشة ليدي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tabbaco_chicha_lady.png",
		}
	},

	["womenoutfit381"] = {
		label = "زي نسائي 381",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit381.png",
		}
	},

	["womenoutfit378"] = {
		label = "زي نسائي 378",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit378.png",
		}
	},

	["menoutfit84"] = {
		label = "ملابس الرجال 84",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit84.png",
		}
	},

	["poor_buck_pelt"] = {
		label = "فرو غزال رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_buck_pelt.png",
		}
	},

	["womenoutfit376"] = {
		label = "زي نسائي 376",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit376.png",
		}
	},

	["womenoutfit375"] = {
		label = "زي نسائي 375",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit375.png",
		}
	},

	["womenoutfit374"] = {
		label = "زي نسائي 374",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit374.png",
		}
	},

	["machete_outlaw_001"] = {
		label = "machete outlaw 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "machete_outlaw_001.png",
		}
	},

	["womenoutfit373"] = {
		label = "زي نسائي 373",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit373.png",
		}
	},

	["birdmeat"] = {
		label = "لحم الطيور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "birdmeat.png",
		}
	},

	["menoutfit86"] = {
		label = "ملابس الرجال 86",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit86.png",
		}
	},

	["OutfitMen014"] = {
		label = "بدلة رجالية 014",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen014.png",
		}
	},

	["womenoutfit174"] = {
		label = "زي نسائي 174",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit174.png",
		}
	},

	["womenoutfit37"] = {
		label = "زي نسائي 37",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit37.png",
		}
	},

	["womenoutfit324"] = {
		label = "زي نسائي 324",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit324.png",
		}
	},

	["itemstable"] = {
		label = "تصنيع الأدوات",
		weight = 250,
		stack = true,
		close = true,
		description = "كتاب لتعلم تصنيع الأدوات.",
		client = {
			image = "itemstable.png",
		}
	},

	["door3"] = {
		label = "مفتاح الباب 3",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door3.png",
		}
	},

	["s_inv_cigcard_amer_02x"] = {
		label = "بطاقة السجائر أمريكي 02",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #02",
		client = {
			image = "s_inv_cigcard_amer_02x.png",
		}
	},

	["goldpearl"] = {
		label = "لؤلؤة ذهبية",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع اللؤلؤة الذهبية بأسعار مرتفعة.",
		client = {
			image = "goldpearl.png",
		}
	},

	["katana06"] = {
		label = "كاتانا 06",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana06.png",
		}
	},

	["womenoutfit301"] = {
		label = "زي نسائي 301",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit301.png",
		}
	},

	["womenoutfit367"] = {
		label = "زي نسائي 367",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit367.png",
		}
	},

	["coolpeace"] = {
		label = "كول بيس",
		weight = 250,
		stack = true,
		close = true,
		description = "كول بيس",
		client = {
			image = "coolpeace.png",
		}
	},

	["provision_goat_hair"] = {
		label = "شعر الماعز",
		weight = 250,
		stack = true,
		close = true,
		description = "شعر مأخوذ من الماعز.",
		client = {
			image = "provision_goat_hair.png",
		}
	},

	["alcoholbottle"] = {
		label = "زجاجة كحول فارغة",
		weight = 250,
		stack = true,
		close = true,
		description = "زجاجة كحول فارغة",
		client = {
			image = "alcoholbottle.png",
		}
	},

	["marijuana_joint1"] = {
		label = "لفافة ماريجوانا 1",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1",
		client = {
			image = "marijuana_joint1.png",
		}
	},

	["womenoutfit366"] = {
		label = "زي نسائي 366",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit366.png",
		}
	},

	["womenoutfit343"] = {
		label = "زي نسائي 343",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit343.png",
		}
	},

	["womenoutfit364"] = {
		label = "زي نسائي 364",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit364.png",
		}
	},

	["menoutfit113"] = {
		label = "ملابس الرجال 113",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit113.png",
		}
	},

	["womenoutfit363"] = {
		label = "زي نسائي 363",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit363.png",
		}
	},

	["womenoutfit564"] = {
		label = "زي نسائي 564",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit564.png",
		}
	},

	["womenoutfit425"] = {
		label = "زي نسائي 425",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit425.png",
		}
	},

	["WomenOutfit0001"] = {
		label = "زي نسائي 0001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit0001.png",
		}
	},

	["egg_gator"] = {
		label = "بيضة تمساح",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة تمساح.",
		client = {
			image = "egg_gator.png",
		}
	},

	["womenoutfit36"] = {
		label = "زي نسائي 36",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit36.png",
		}
	},

	["fixedcamera"] = {
		label = "fixed camera",
		weight = 250,
		stack = false,
		close = true,
		description = "fixed camera",
		client = {
			image = "fixedcamera.png",
		}
	},

	["rat_animal"] = {
		label = "فأر",
		weight = 100,
		stack = true,
		close = true,
		description = "فأر صغير يمكن استخدامه في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "rat_animal.png",
		}
	},

	["womenoutfit18"] = {
		label = "زي نسائي 18",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit18.png",
		}
	},

	["womenoutfit357"] = {
		label = "زي نسائي 357",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit357.png",
		}
	},

	["provision_legendary_panther_eye"] = {
		label = "عين الفهد الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "عين نادرة من فهد أسطوري.",
		client = {
			image = "provision_legendary_panther_eye.png",
		}
	},

	["womenoutfit356"] = {
		label = "زي نسائي 356",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit356.png",
		}
	},

	["treasurebox"] = {
		label = "صندوق الكنز",
		weight = 250,
		stack = false,
		close = true,
		description = "صندوق الكنز",
		client = {
			image = "treasurebox.png",
		}
	},

	["womenoutfit355"] = {
		label = "زي نسائي 355",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit355.png",
		}
	},

	["marijuana_jar3"] = {
		label = "جرة الماريجوانا 3",
		weight = 250,
		stack = true,
		close = true,
		description = "جرة الماريجوانا 3",
		client = {
			image = "marijuana_jar3.png",
		}
	},

	["womenoutfit353"] = {
		label = "زي نسائي 353",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit353.png",
		}
	},

	["womenoutfit352"] = {
		label = "زي نسائي 352",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit352.png",
		}
	},

	["womenoutfit351"] = {
		label = "زي نسائي 351",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit351.png",
		}
	},

	["womenoutfit482"] = {
		label = "زي نسائي 482",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit482.png",
		}
	},

	["womenoutfit349"] = {
		label = "زي نسائي 349",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit349.png",
		}
	},

	["chicken_thigh"] = {
		label = "فخذ دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "فخذ دجاج مقطع",
		client = {
			image = "chicken_thigh.png",
		}
	},

	["womenoutfit68"] = {
		label = "زي نسائي 68",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit68.png",
		}
	},

	["womenoutfit346"] = {
		label = "زي نسائي 346",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit346.png",
		}
	},

	["womenoutfit345"] = {
		label = "زي نسائي 345",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit345.png",
		}
	},

	["walkers_np"] = {
		label = "Walkers Newspaper",
		weight = 250,
		stack = false,
		close = true,
		description = "Newspaper",
		client = {
			image = "walkers_np.png",
		}
	},

	["menoutfit16"] = {
		label = "ملابس الرجال 16",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit16.png",
		}
	},

	["womenoutfit300"] = {
		label = "زي نسائي 300",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit300.png",
		}
	},

	["womenoutfit365"] = {
		label = "زي نسائي 365",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit365.png",
		}
	},

	["womenoutfit342"] = {
		label = "زي نسائي 342",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit342.png",
		}
	},

	["WomenNecklaces024"] = {
		label = "قلادة نسائية 024",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces024.png",
		}
	},

	["womenoutfit340"] = {
		label = "زي نسائي 340",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit340.png",
		}
	},

	["womenoutfit855"] = {
		label = "زي نسائي 855",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit855.png",
		}
	},

	["marijuana_joint1_6"] = {
		label = "لفافة ماريجوانا 1-6",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-6",
		client = {
			image = "marijuana_joint1_6.png",
		}
	},

	["menoutfit66"] = {
		label = "ملابس الرجال 66",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit66.png",
		}
	},

	["womenoutfit334"] = {
		label = "زي نسائي 334",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit334.png",
		}
	},

	["womenoutfit198"] = {
		label = "زي نسائي 198",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit198.png",
		}
	},

	["womenoutfit303"] = {
		label = "زي نسائي 303",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit303.png",
		}
	},

	["womenoutfit330"] = {
		label = "زي نسائي 330",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit330.png",
		}
	},

	["s_inv_cigcard_gun_01x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 01",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #01",
		client = {
			image = "s_inv_cigcard_gun_01x.png",
		}
	},

	["womenoutfit326"] = {
		label = "زي نسائي 326",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit326.png",
		}
	},

	["medium_peccary_meat"] = {
		label = "لحم بيكاري متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بيكاري بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_peccary_meat.png",
		}
	},

	["consumable_chef_groundbeef"] = {
		label = "لحم بقر مفروم من الطباخ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chef_groundbeef.png",
		}
	},

	["Vanille_Seed"] = {
		label = "بذور الفانيليا",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج نبتة الفانيليا.",
		client = {
			image = "Vanille_Seed.png",
		}
	},

	["womenoutfit325"] = {
		label = "زي نسائي 325",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit325.png",
		}
	},

	["Wheat_Seed"] = {
		label = "بذور القمح",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لنمو القمح.",
		client = {
			image = "Wheat_Seed.png",
		}
	},

	["womenoutfit27"] = {
		label = "زي نسائي 27",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit27.png",
		}
	},

	["womenoutfit369"] = {
		label = "زي نسائي 369",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit369.png",
		}
	},

	["womenoutfit321"] = {
		label = "زي نسائي 321",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit321.png",
		}
	},

	["provision_stone"] = {
		label = "حجر",
		weight = 250,
		stack = true,
		close = true,
		description = "حجر طبيعي يمكن استخدامه في البناء أو الصياغة.",
		client = {
			image = "provision_stone.png",
		}
	},

	["womenoutfit106"] = {
		label = "زي نسائي 106",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit106.png",
		}
	},

	["medium_sheep_pelt"] = {
		label = "فرو شاة متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو شاة بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_sheep_pelt.png",
		}
	},

	["womenoutfit318"] = {
		label = "زي نسائي 318",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit318.png",
		}
	},

	["WomenHats089"] = {
		label = "قبعة نسائية 089",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats089.png",
		}
	},

	["womenoutfit312"] = {
		label = "زي نسائي 312",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit312.png",
		}
	},

	["womenoutfit184"] = {
		label = "زي نسائي 184",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit184.png",
		}
	},

	["personalfasttravel"] = {
		label = "سفر سريع شخصي",
		weight = 250,
		stack = true,
		close = true,
		description = "عنصر لإضافة المزيد من نقاط السفر السريع الشخصي.",
		client = {
			image = "personalfasttravel.png",
		}
	},

	["womenoutfit306"] = {
		label = "زي نسائي 306",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit306.png",
		}
	},

	["a_c_fishlakesturgeon_01_lg"] = {
		label = "سمك الحفش بحيرة كبيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك الحفش بحيرة كبيرة",
		client = {
			image = "a_c_fishlakesturgeon_01_lg.png",
		}
	},

	["womenoutfit305"] = {
		label = "زي نسائي 305",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit305.png",
		}
	},

	["womenoutfit331"] = {
		label = "زي نسائي 331",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit331.png",
		}
	},

	["womenoutfit3"] = {
		label = "زي نسائي 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit3.png",
		}
	},

	["WomenOutfit038"] = {
		label = "زي نسائي 038",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit038.png",
		}
	},

	["WomenOutfits02"] = {
		label = "زي نسائي 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits02.png",
		}
	},

	["womenoutfit359"] = {
		label = "زي نسائي 359",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit359.png",
		}
	},

	["s_inv_cigcard_hrs_04x"] = {
		label = "بطاقة السجائر سلالات الخيول 04",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #04",
		client = {
			image = "s_inv_cigcard_hrs_04x.png",
		}
	},

	["WomenHats065"] = {
		label = "قبعة نسائية 065",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats065.png",
		}
	},

	["baking_cake_pan2"] = {
		label = "صينية خبز الكيك2",
		weight = 250,
		stack = true,
		close = true,
		description = "صينية خبز الكيك2",
		client = {
			image = "baking_cake_pan2.png",
		}
	},

	["menoutfit101"] = {
		label = "ملابس الرجال 101",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit101.png",
		}
	},

	["womenoutfit293"] = {
		label = "زي نسائي 293",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit293.png",
		}
	},

	["s_inv_cigcard_aml_02x"] = {
		label = "بطاقة السجائر أمل 02",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #02",
		client = {
			image = "s_inv_cigcard_aml_02x.png",
		}
	},

	["Horse_Shoe"] = {
		label = "حدوة الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "حدوة الحصان",
		client = {
			image = "Horse_Shoe.png",
		}
	},

	["MenOutfits025"] = {
		label = "زي رجالي 025",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits025.png",
		}
	},

	["s_inv_cigcard_gun_03x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 03",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #03",
		client = {
			image = "s_inv_cigcard_gun_03x.png",
		}
	},

	["COUGAR_VAR_003"] = {
		label = "كوجر أسطوري أسود",
		weight = 250,
		stack = false,
		close = true,
		description = "جلد كوجر أسطوري أسود اللون.",
		client = {
			image = "COUGAR_VAR_003.png",
		}
	},

	["shirts_full"] = {
		label = "قمصان كاملة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shirts_full.png",
		}
	},

	["smallpress"] = {
		label = "الطابعة الصغيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "smallpress.png",
		}
	},

	["womenoutfit29"] = {
		label = "زي نسائي 29",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit29.png",
		}
	},

	["womenoutfit224"] = {
		label = "زي نسائي 224",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit224.png",
		}
	},

	["poor_cougar_pelt"] = {
		label = "فرو أسد الجبل رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أسد الجبل بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_cougar_pelt.png",
		}
	},

	["womenoutfit289"] = {
		label = "زي نسائي 289",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit289.png",
		}
	},

	["horsebag1"] = {
		label = "أكياس سكر",
		weight = 250,
		stack = true,
		close = true,
		description = "أكياس على الحصان",
		client = {
			image = "horsebag1.png",
		}
	},

	["horseloadout7"] = {
		label = "حمولة حصان 7",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout7.png",
		}
	},

	["womenoutfit287"] = {
		label = "زي نسائي 287",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit287.png",
		}
	},

	["womenoutfit286"] = {
		label = "زي نسائي 286",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit286.png",
		}
	},

	["knife01"] = {
		label = "سكين 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "knife01.png",
		}
	},

	["womenoutfit19"] = {
		label = "زي نسائي 19",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit19.png",
		}
	},

	["womenoutfit284"] = {
		label = "زي نسائي 284",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit284.png",
		}
	},

	["perfect_boar_meat"] = {
		label = "لحم خنزير بري ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم خنزير بري بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_boar_meat.png",
		}
	},

	["wings4"] = {
		label = "أجنحة 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "wings4.png",
		}
	},

	["consumable_waffles"] = {
		label = "وافل",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_waffles.png",
		}
	},

	["womenoutfit283"] = {
		label = "زي نسائي 283",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit283.png",
		}
	},

	["womenoutfit282"] = {
		label = "زي نسائي 282",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit282.png",
		}
	},

	["animal_snake"] = {
		label = "أفعى",
		weight = 250,
		stack = true,
		close = true,
		description = "أفعى.",
		client = {
			image = "animal_snake.png",
		}
	},

	["zinc_ore"] = {
		label = "خام الزنك",
		weight = 250,
		stack = true,
		close = true,
		description = "خام الزنك",
		client = {
			image = "zinc_ore.png",
		}
	},

	["s_inv_cigcard_art_02x"] = {
		label = "بطاقة السجائر فن 02",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #02",
		client = {
			image = "s_inv_cigcard_art_02x.png",
		}
	},

	["womenoutfit277"] = {
		label = "زي نسائي 277",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit277.png",
		}
	},

	["womenoutfit276"] = {
		label = "زي نسائي 276",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit276.png",
		}
	},

	["womenoutfit272"] = {
		label = "زي نسائي 272",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit272.png",
		}
	},

	["MenOutfits40"] = {
		label = "زي رجالي 40",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits40.png",
		}
	},

	["WomenHats137"] = {
		label = "قبعة نسائية 137",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats137.png",
		}
	},

	["hay"] = {
		label = "تبن",
		weight = 250,
		stack = true,
		close = true,
		description = "تبن لإطعام الحصان",
		client = {
			image = "hay.png",
		}
	},

	["WomenHats107"] = {
		label = "قبعة نسائية 107",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats107.png",
		}
	},

	["a_c_fishsalmonsockeye_01_ml"] = {
		label = "سمك السلمون والسلمون الأحمر",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك السلمون والسلمون الأحمر",
		client = {
			image = "a_c_fishsalmonsockeye_01_ml.png",
		}
	},

	["WomenOutfit072"] = {
		label = "زي نسائي 072",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit072.png",
		}
	},

	["womenoutfit265"] = {
		label = "زي نسائي 265",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit265.png",
		}
	},

	["womenoutfit264"] = {
		label = "زي نسائي 264",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit264.png",
		}
	},

	["lumber_Logs_generic"] = {
		label = "خشب خام",
		weight = 250,
		stack = true,
		close = true,
		description = "سجلات عامة",
		client = {
			image = "lumber_Logs_generic.png",
		}
	},

	["shield05"] = {
		label = "درع 05",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield05.png",
		}
	},

	["resource_pelt_rabbit_star_2"] = {
		label = "جلد الأرنب 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_rabbit_star_2.png",
		}
	},

	["womenoutfit261"] = {
		label = "زي نسائي 261",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit261.png",
		}
	},

	["resource_skin_desert_iguana_star_2"] = {
		label = "جلد الإغوانا الصحراوية 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_desert_iguana_star_2.png",
		}
	},

	["WomenShawls002"] = {
		label = "شال نسائي 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenShawls002.png",
		}
	},

	["medium_apronghorn_meat"] = {
		label = "لحم ظبي متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ظبي بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_apronghorn_meat.png",
		}
	},

	["resource_skin_javelina_boar_star_2"] = {
		label = "فرو بيكاري 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_javelina_boar_star_2.png",
		}
	},

	["resource_box_bananas"] = {
		label = "صندوق الموز",
		weight = 250,
		stack = true,
		close = true,
		description = "صندوق الموز",
		client = {
			image = "resource_box_bananas.png",
		}
	},

	["provision_trinket_wolf_heart"] = {
		label = "تعويذة قلب الذئب",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من قلب ذئب.",
		client = {
			image = "provision_trinket_wolf_heart.png",
		}
	},

	["baghemp_sp"] = {
		label = "Bagged Scarlett Purp",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the vibrant Meadows of Scarlett!",
		client = {
			image = "baghemp_sp.png",
		}
	},

	["boxing"] = {
		label = "Boxing",
		weight = 250,
		stack = true,
		close = true,
		description = "Boxing",
		client = {
			image = "boxing.png",
		}
	},

	["WomenOutfit070"] = {
		label = "زي نسائي 070",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit070.png",
		}
	},

	["womenoutfit251"] = {
		label = "زي نسائي 251",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit251.png",
		}
	},

	["WomenHats006"] = {
		label = "قبعة نسائية 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats006.png",
		}
	},

	["womenoutfit250"] = {
		label = "زي نسائي 250",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit250.png",
		}
	},

	["s_inv_cigcard_hrs_09x"] = {
		label = "بطاقة السجائر سلالات الخيول 09",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #09",
		client = {
			image = "s_inv_cigcard_hrs_09x.png",
		}
	},

	["womenoutfit247"] = {
		label = "زي نسائي 247",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit247.png",
		}
	},

	["WomenHats011"] = {
		label = "قبعة نسائية 011",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats011.png",
		}
	},

	["womenoutfit245"] = {
		label = "زي نسائي 245",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit245.png",
		}
	},

	["womenoutfit699"] = {
		label = "زي نسائي 699",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit699.png",
		}
	},

	["womenoutfit243"] = {
		label = "زي نسائي 243",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit243.png",
		}
	},

	["womenoutfit242"] = {
		label = "زي نسائي 242",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit242.png",
		}
	},

	["machete_outlaw_002"] = {
		label = "machete outlaw 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "machete_outlaw_002.png",
		}
	},

	["womenoutfit24"] = {
		label = "زي نسائي 24",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit24.png",
		}
	},

	["womenoutfit236"] = {
		label = "زي نسائي 236",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit236.png",
		}
	},

	["womenoutfit231"] = {
		label = "زي نسائي 231",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit231.png",
		}
	},

	["womenoutfit230"] = {
		label = "زي نسائي 230",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit230.png",
		}
	},

	["medium_buck_pelt"] = {
		label = "فرو غزال متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_buck_pelt.png",
		}
	},

	["animal_bluejay"] = {
		label = "طائر القيق الأزرق",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر القيق الأزرق.",
		client = {
			image = "animal_bluejay.png",
		}
	},

	["womenoutfit229"] = {
		label = "زي نسائي 229",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit229.png",
		}
	},

	["resource_skin_javelina_boar_star_3"] = {
		label = "فرو بيكاري 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_javelina_boar_star_3.png",
		}
	},

	["mineaxe"] = {
		label = "فأس المنجم",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mineaxe.png",
		}
	},

	["consumable_potent_snake_oil"] = {
		label = "زيت الثعبان القوي",
		weight = 250,
		stack = true,
		close = true,
		description = "زيت الثعبان عالي الجودة لاستخدامات طبية.",
		client = {
			image = "consumable_potent_snake_oil.png",
		}
	},

	["womenoutfit228"] = {
		label = "زي نسائي 228",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit228.png",
		}
	},

	["womenoutfit226"] = {
		label = "زي نسائي 226",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit226.png",
		}
	},

	["OutfitMen106"] = {
		label = "بدلة رجالية 106",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen106.png",
		}
	},

	["womenoutfit225"] = {
		label = "زي نسائي 225",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit225.png",
		}
	},

	["WomenHats126"] = {
		label = "قبعة نسائية 126",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats126.png",
		}
	},

	["Almond_Seed"] = {
		label = "بذور اللوز",
		weight = 250,
		stack = true,
		close = true,
		description = "بذرة يمكن زراعتها لإنبات شجرة اللوز",
		client = {
			image = "Almond_Seed.png",
		}
	},

	["womenoutfit222"] = {
		label = "زي نسائي 222",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit222.png",
		}
	},

	["womenoutfit829"] = {
		label = "زي نسائي 829",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit829.png",
		}
	},

	["wethemp_sp"] = {
		label = "Wet Scarlett Purp",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the vibrant Meadows of Scarlett!",
		client = {
			image = "wethemp_sp.png",
		}
	},

	["s_inv_cigcard_veh_07x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 07",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #07",
		client = {
			image = "s_inv_cigcard_veh_07x.png",
		}
	},

	["womenoutfit216"] = {
		label = "زي نسائي 216",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit216.png",
		}
	},

	["womenoutfit215"] = {
		label = "زي نسائي 215",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit215.png",
		}
	},

	["womenoutfit212"] = {
		label = "زي نسائي 212",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit212.png",
		}
	},

	["pan01"] = {
		label = "مقلاة 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pan01.png",
		}
	},

	["legendary_bear_heart"] = {
		label = "قلب دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب دب أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_bear_heart.png",
		}
	},

	["ironore"] = {
		label = "خام حديد",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن تحويل خام الحديد إلى سبيكة حديد.",
		client = {
			image = "ironore.png",
		}
	},

	["OutfitMen127"] = {
		label = "بدلة رجالية 127",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen127.png",
		}
	},

	["shotgunprint"] = {
		label = "طباعة بندقية الصيد",
		weight = 250,
		stack = true,
		close = true,
		description = "طباعة بندقية الصيد",
		client = {
			image = "shotgunprint.png",
		}
	},

	["consumable_iguana_bits_cooked"] = {
		label = "قطع إغوانا مشوية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_iguana_bits_cooked.png",
		}
	},

	["bucketwater"] = {
		label = "دلو الماء",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "bucketwater.png",
		}
	},

	["womenoutfit21"] = {
		label = "زي نسائي 21",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit21.png",
		}
	},

	["womenoutfit209"] = {
		label = "زي نسائي 209",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit209.png",
		}
	},

	["resource_opal_uncut"] = {
		label = "حجر الأوبال الخام",
		weight = 250,
		stack = true,
		close = true,
		description = "أوبال غير مقطوع",
		client = {
			image = "resource_opal_uncut.png",
		}
	},

	["perfect_rabbit_pelt"] = {
		label = "فرو أرنب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أرنب بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_rabbit_pelt.png",
		}
	},

	["lumber_cedar_hardwood"] = {
		label = "خشب الأرز الصلب",
		weight = 250,
		stack = true,
		close = true,
		description = "خشب الأرز الصلب",
		client = {
			image = "lumber_cedar_hardwood.png",
		}
	},

	["womenoutfit208"] = {
		label = "زي نسائي 208",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit208.png",
		}
	},

	["womenoutfit177"] = {
		label = "زي نسائي 177",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit177.png",
		}
	},

	["womenoutfit205"] = {
		label = "زي نسائي 205",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit205.png",
		}
	},

	["poppyseed"] = {
		label = "بذور الخشخاش",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "poppyseed.png",
		}
	},

	["s_inv_cigcard_aml_04x"] = {
		label = "بطاقة السجائر أمل 04",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #04",
		client = {
			image = "s_inv_cigcard_aml_04x.png",
		}
	},

	["cooper"] = {
		label = "Cooper",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cooper.png",
		}
	},

	["a_c_fishlongnosegar_01_lg"] = {
		label = "سمكة الجار طويلة الأنف",
		weight = 250,
		stack = true,
		close = true,
		description = "سمكة الجار طويلة الأنف",
		client = {
			image = "a_c_fishlongnosegar_01_lg.png",
		}
	},

	["legendary_coyote_meat"] = {
		label = "لحم ذئب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_coyote_meat.png",
		}
	},

	["provision_ring_magnate_turquoise"] = {
		label = "خاتم التزويد المغناطيسي باللون الفيروزي",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم التزويد المغناطيسي باللون الفيروزي",
		client = {
			image = "provision_ring_magnate_turquoise.png",
		}
	},

	["provision_pronghorn_horn"] = {
		label = "قرن الظبي الأمريكي",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن قوي مأخوذ من الظبي الأمريكي.",
		client = {
			image = "provision_pronghorn_horn.png",
		}
	},

	["menoutfit18"] = {
		label = "ملابس الرجال 18",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit18.png",
		}
	},

	["OutfitMen092"] = {
		label = "بدلة رجالية 092",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen092.png",
		}
	},

	["womenoutfit199"] = {
		label = "زي نسائي 199",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit199.png",
		}
	},

	["consumable_soborno"] = {
		label = "سوبورنو",
		weight = 250,
		stack = true,
		close = true,
		description = "سوبورنو",
		client = {
			image = "consumable_soborno.png",
		}
	},

	["womenoutfit419"] = {
		label = "زي نسائي 419",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit419.png",
		}
	},

	["womenoutfit196"] = {
		label = "زي نسائي 196",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit196.png",
		}
	},

	["s_inv_cigcard_hrs_10x"] = {
		label = "بطاقة السجائر سلالات الخيول 10",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #10",
		client = {
			image = "s_inv_cigcard_hrs_10x.png",
		}
	},

	["womenoutfit194"] = {
		label = "زي نسائي 194",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit194.png",
		}
	},

	["consumable_canned_chicken"] = {
		label = "دجاج معلب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_canned_chicken.png",
		}
	},

	["womenoutfit542"] = {
		label = "زي نسائي 542",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit542.png",
		}
	},

	["womenoutfit285"] = {
		label = "زي نسائي 285",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit285.png",
		}
	},

	["boots"] = {
		label = "أحذية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "boots.png",
		}
	},

	["moonshine_interior3"] = {
		label = "Moonshine Interior 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_interior3.png",
		}
	},

	["womenoutfit188"] = {
		label = "زي نسائي 188",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit188.png",
		}
	},

	["fishing_rod_pro"] = {
		label = "Professional Fishing Rod",
		weight = 3000,
		stack = false,
		close = true,
		description = "The finest rod money can buy",
		client = {
			image = "fishing_rod_pro.png",
		}
	},

	["womenoutfit187"] = {
		label = "زي نسائي 187",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit187.png",
		}
	},

	["womenoutfit185"] = {
		label = "زي نسائي 185",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit185.png",
		}
	},

	["womenoutfit311"] = {
		label = "زي نسائي 311",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit311.png",
		}
	},

	["womenoutfit180"] = {
		label = "زي نسائي 180",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit180.png",
		}
	},

	["coins"] = {
		label = "Mixed Coins",
		weight = 250,
		stack = true,
		close = true,
		description = "A collection of mixed coins.",
		client = {
			image = "coins.png",
		}
	},

	["WomenOutfit009"] = {
		label = "زي نسائي 009",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit009.png",
		}
	},

	["consumable_donut4"] = {
		label = "دونات 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut4.png",
		}
	},

	["unique_elote"] = {
		label = "إيلوت فريد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "unique_elote.png",
		}
	},

	["womenoutfit206"] = {
		label = "زي نسائي 206",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit206.png",
		}
	},

	["consumable_chef_butter"] = {
		label = "زبدة من الطباخ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chef_butter.png",
		}
	},

	["womenoutfit176"] = {
		label = "زي نسائي 176",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit176.png",
		}
	},

	["chicken_wing"] = {
		label = "جناح دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "جناح دجاج مقطع",
		client = {
			image = "chicken_wing.png",
		}
	},

	["womenoutfit372"] = {
		label = "زي نسائي 372",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit372.png",
		}
	},

	["consumable_cinnamonbuns"] = {
		label = "لفائف القرفة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cinnamonbuns.png",
		}
	},

	["dryhemp_ck"] = {
		label = "Dry Cumberland Kush",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush Cumberland Mountains!",
		client = {
			image = "dryhemp_ck.png",
		}
	},

	["womenoutfit173"] = {
		label = "زي نسائي 173",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit173.png",
		}
	},

	["provision_coyote_fur"] = {
		label = "فراء ذئب البراري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم مأخوذ من ذئب البراري.",
		client = {
			image = "provision_coyote_fur.png",
		}
	},

	["menoutfit1"] = {
		label = "ملابس الرجال 1",
		weight = 250,
		stack = false,
		close = true,
		description = "ملابس الرجال 1",
		client = {
			image = "menoutfit1.png",
		}
	},

	["Coconut_Seed"] = {
		label = "بذور جوز الهند",
		weight = 250,
		stack = true,
		close = true,
		description = "بذرة يمكن زراعتها لإنبات شجرة جوز الهند.",
		client = {
			image = "Coconut_Seed.png",
		}
	},

	["WomenHats033"] = {
		label = "قبعة نسائية 033",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats033.png",
		}
	},

	["perfect_bighorn_meat"] = {
		label = "لحم كبش ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم كبش بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_bighorn_meat.png",
		}
	},

	["perfect_beaver_pelt"] = {
		label = "فرو قندس ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو قندس بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_beaver_pelt.png",
		}
	},

	["holsters_left"] = {
		label = "حاملات البنادق اليسرى",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "holsters_left.png",
		}
	},

	["womenoutfit784"] = {
		label = "زي نسائي 784",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit784.png",
		}
	},

	["scopeshortcarcano"] = {
		label = "Sniper Rifle Carcano Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortcarcano.png",
		}
	},

	["womenoutfit168"] = {
		label = "زي نسائي 168",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit168.png",
		}
	},

	["womenoutfit167"] = {
		label = "زي نسائي 167",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit167.png",
		}
	},

	["animal_carolinaparakeet"] = {
		label = "ببغاء كارولينا",
		weight = 250,
		stack = true,
		close = true,
		description = "ببغاء كارولينا.",
		client = {
			image = "animal_carolinaparakeet.png",
		}
	},

	["womenoutfit166"] = {
		label = "زي نسائي 166",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit166.png",
		}
	},

	["WomenHats178"] = {
		label = "قبعة نسائية 178",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats178.png",
		}
	},

	["womenoutfit163"] = {
		label = "زي نسائي 163",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit163.png",
		}
	},

	["womenoutfit161"] = {
		label = "زي نسائي 161",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit161.png",
		}
	},

	["OutfitMen069"] = {
		label = "بدلة رجالية 069",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen069.png",
		}
	},

	["womenoutfit160"] = {
		label = "زي نسائي 160",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit160.png",
		}
	},

	["womenoutfit158"] = {
		label = "زي نسائي 158",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit158.png",
		}
	},

	["womenoutfit299"] = {
		label = "زي نسائي 299",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit299.png",
		}
	},

	["menoutfit43"] = {
		label = "ملابس الرجال 43",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit43.png",
		}
	},

	["WomenGloves020"] = {
		label = "قفازات نسائية 020",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves020.png",
		}
	},

	["poor_saligator_meat"] = {
		label = "لحم تمساح رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_saligator_meat.png",
		}
	},

	["mud_bucket"] = {
		label = "دلو الطين",
		weight = 250,
		stack = true,
		close = true,
		description = "دلو الطين",
		client = {
			image = "mud_bucket.png",
		}
	},

	["WomenHats125"] = {
		label = "قبعة نسائية 125",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats125.png",
		}
	},

	["womenoutfit155"] = {
		label = "زي نسائي 155",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit155.png",
		}
	},

	["perfect_apronghorn_meat"] = {
		label = "لحم ظبي ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ظبي بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_apronghorn_meat.png",
		}
	},

	["MenOutfits023"] = {
		label = "زي رجالي 023",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits023.png",
		}
	},

	["womenoutfit154"] = {
		label = "زي نسائي 154",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit154.png",
		}
	},

	["womenoutfit153"] = {
		label = "زي نسائي 153",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit153.png",
		}
	},

	["ammobola"] = {
		label = "ذخيرة بولا",
		weight = 250,
		stack = true,
		close = true,
		description = "ذخيرة بولا تُستخدم للإمساك بالأهداف.",
		client = {
			image = "ammobola.png",
		}
	},

	["lumber_maple_wood_plank"] = {
		label = "لوح خشب القيقب",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح خشب القيقب",
		client = {
			image = "lumber_maple_wood_plank.png",
		}
	},

	["resource_skin_lizard_star_1"] = {
		label = "جلد السحلية 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_lizard_star_1.png",
		}
	},

	["womenoutfit152"] = {
		label = "زي نسائي 152",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit152.png",
		}
	},

	["legendary_fox_pelt"] = {
		label = "فرو ثعلب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثعلب أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_fox_pelt.png",
		}
	},

	["WomenHats210"] = {
		label = "قبعة نسائية 210",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats210.png",
		}
	},

	["womenoutfit15"] = {
		label = "زي نسائي 15",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit15.png",
		}
	},

	["machete_outlaw_003"] = {
		label = "machete outlaw 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "machete_outlaw_003.png",
		}
	},

	["womenoutfit147"] = {
		label = "زي نسائي 147",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit147.png",
		}
	},

	["mp006_p_moonshiner_still01x"] = {
		label = "Moonshine Still 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp006_p_moonshiner_still01x.png",
		}
	},

	["womenoutfit145"] = {
		label = "زي نسائي 145",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit145.png",
		}
	},

	["womenoutfit144"] = {
		label = "زي نسائي 144",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit144.png",
		}
	},

	["womenoutfit65"] = {
		label = "زي نسائي 65",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit65.png",
		}
	},

	["s_inv_cigcard_grl_12x"] = {
		label = "بطاقة السجائر جواهر الجمال 12",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #12",
		client = {
			image = "s_inv_cigcard_grl_12x.png",
		}
	},

	["s_coffeetin01x"] = {
		label = "علبة قهوة",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على مسحوق القهوة.",
		client = {
			image = "s_coffeetin01x.png",
		}
	},

	["phonograph"] = {
		label = "Phonograph",
		weight = 100,
		stack = true,
		close = true,
		description = "Used to play music",
		client = {
			image = "phonograph.png",
		}
	},

	["menoutfit52"] = {
		label = "ملابس الرجال 52",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit52.png",
		}
	},

	["gunbelt_accs"] = {
		label = "إكسسوارات حزام البنادق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "gunbelt_accs.png",
		}
	},

	["OutfitMen143"] = {
		label = "بدلة رجالية 143",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen143.png",
		}
	},

	["womenoutfit140"] = {
		label = "زي نسائي 140",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit140.png",
		}
	},

	["globe"] = {
		label = "Globo",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "globe.png",
		}
	},

	["womenoutfit14"] = {
		label = "زي نسائي 14",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit14.png",
		}
	},

	["womenoutfit584"] = {
		label = "زي نسائي 584",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit584.png",
		}
	},

	["womenoutfit502"] = {
		label = "زي نسائي 502",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit502.png",
		}
	},

	["womenoutfit132"] = {
		label = "زي نسائي 132",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit132.png",
		}
	},

	["s_inv_cigcard_amer_12x"] = {
		label = "بطاقة السجائر أمريكي 12",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #12",
		client = {
			image = "s_inv_cigcard_amer_12x.png",
		}
	},

	["womenoutfit13"] = {
		label = "زي نسائي 13",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit13.png",
		}
	},

	["perfect_bull_pelt"] = {
		label = "فرو ثور ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_bull_pelt.png",
		}
	},

	["womenoutfit127"] = {
		label = "زي نسائي 127",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit127.png",
		}
	},

	["provision_earring_beauchene_ruby"] = {
		label = "قرط بوشين الياقوتي",
		weight = 250,
		stack = true,
		close = true,
		description = "ياقوتة البوشين",
		client = {
			image = "provision_earring_beauchene_ruby.png",
		}
	},

	["OutfitMen114"] = {
		label = "بدلة رجالية 114",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen114.png",
		}
	},

	["WomenHats136"] = {
		label = "قبعة نسائية 136",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats136.png",
		}
	},

	["Sugar_Cane_Seed"] = {
		label = "بذور قصب السكر",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور قصب السكر تُستخدم لزراعة نبات قصب السكر",
		client = {
			image = "Sugar_Cane_Seed.png",
		}
	},

	["womenoutfit123"] = {
		label = "زي نسائي 123",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit123.png",
		}
	},

	["bee_house_gk_6"] = {
		label = "بيت النحل 6",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 6",
		client = {
			image = "bee_house_gk_6.png",
		}
	},

	["womenoutfit120"] = {
		label = "زي نسائي 120",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit120.png",
		}
	},

	["womenoutfit119"] = {
		label = "زي نسائي 119",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit119.png",
		}
	},

	["womenoutfit114"] = {
		label = "زي نسائي 114",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit114.png",
		}
	},

	["womenoutfit112"] = {
		label = "زي نسائي 112",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit112.png",
		}
	},

	["menoutfit47"] = {
		label = "ملابس الرجال 47",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit47.png",
		}
	},

	["womenoutfit638"] = {
		label = "زي نسائي 638",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit638.png",
		}
	},

	["copperbar"] = {
		label = "سبيكة نحاس",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن استخدام سبيكة النحاس في التصنيع.",
		client = {
			image = "copperbar.png",
		}
	},

	["womenoutfit109"] = {
		label = "زي نسائي 109",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit109.png",
		}
	},

	["perfect_bear_pelt"] = {
		label = "فرو دب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_bear_pelt.png",
		}
	},

	["womenoutfit108"] = {
		label = "زي نسائي 108",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit108.png",
		}
	},

	["s_inv_cigcard_grl_10x"] = {
		label = "بطاقة السجائر جواهر الجمال 10",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #10",
		client = {
			image = "s_inv_cigcard_grl_10x.png",
		}
	},

	["womenoutfit107"] = {
		label = "زي نسائي 107",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit107.png",
		}
	},

	["s_inv_cigcard_veh_08x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 08",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #08",
		client = {
			image = "s_inv_cigcard_veh_08x.png",
		}
	},

	["womenoutfit105"] = {
		label = "زي نسائي 105",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit105.png",
		}
	},

	["sugarcane"] = {
		label = "قصب السكر",
		weight = 250,
		stack = true,
		close = true,
		description = "يُستخدم لاستخراج السكر الطبيعي",
		client = {
			image = "sugarcane.png",
		}
	},

	["womenoutfit104"] = {
		label = "زي نسائي 104",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit104.png",
		}
	},

	["womenoutfit103"] = {
		label = "زي نسائي 103",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit103.png",
		}
	},

	["ddd_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "ddd_news.png",
		}
	},

	["a_hay"] = {
		label = "قش",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_hay.png",
		}
	},

	["WomenOutfit059"] = {
		label = "زي نسائي 059",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit059.png",
		}
	},

	["OutfitMen023"] = {
		label = "بدلة رجالية 023",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen023.png",
		}
	},

	["WomenOutfit099"] = {
		label = "زي نسائي 099",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit099.png",
		}
	},

	["provision_boar_skin"] = {
		label = "جلد الخنزير البري",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد خشن مأخوذ من خنزير بري.",
		client = {
			image = "provision_boar_skin.png",
		}
	},

	["backpack4"] = {
		label = "حقيبة تحمل سعة 100",
		weight = 250,
		stack = false,
		close = true,
		description = "حقيبة تحمل سعة 100",
		client = {
			image = "backpack4.png",
		}
	},

	["frog_animal"] = {
		label = "ضفدع",
		weight = 100,
		stack = true,
		close = true,
		description = "ضفدع صغير يمكن استخدامه في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "frog_animal.png",
		}
	},

	["consumable_donut5"] = {
		label = "دونات 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut5.png",
		}
	},

	["marijuana_bud1_untrimmed"] = {
		label = "برعم الماريجوانا 1 غير مقلم",
		weight = 250,
		stack = true,
		close = true,
		description = "برعم الماريجوانا 1 غير مقلم",
		client = {
			image = "marijuana_bud1_untrimmed.png",
		}
	},

	["WomenNecklaces021"] = {
		label = "قلادة نسائية 021",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces021.png",
		}
	},

	["WomenOutfit096"] = {
		label = "زي نسائي 096",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit096.png",
		}
	},

	["animal_chipmunk"] = {
		label = "سنجاب صغير",
		weight = 250,
		stack = true,
		close = true,
		description = "سنجاب صغير.",
		client = {
			image = "animal_chipmunk.png",
		}
	},

	["OutfitMen190"] = {
		label = "بدلة رجالية 190",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen190.png",
		}
	},

	["big_fireworks"] = {
		label = "مفرقعات كبيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "big_fireworks.png",
		}
	},

	["hammer01"] = {
		label = "مطرقة 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hammer01.png",
		}
	},

	["WomenHats062"] = {
		label = "قبعة نسائية 062",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats062.png",
		}
	},

	["consumable_chef_tomato_sauce"] = {
		label = "صلصة الطماطم",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chef_tomato_sauce.png",
		}
	},

	["WomenOutfits19"] = {
		label = "زي نسائي 19",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits19.png",
		}
	},

	["WomenOutfit089"] = {
		label = "زي نسائي 089",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit089.png",
		}
	},

	["WomenOutfit085"] = {
		label = "زي نسائي 085",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit085.png",
		}
	},

	["womenoutfit830"] = {
		label = "زي نسائي 830",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit830.png",
		}
	},

	["medium_bull_pelt"] = {
		label = "فرو ثور متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_bull_pelt.png",
		}
	},

	["WomenOutfit082"] = {
		label = "زي نسائي 082",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit082.png",
		}
	},

	["womenoutfit495"] = {
		label = "زي نسائي 495",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit495.png",
		}
	},

	["poor_oxen_meat"] = {
		label = "لحم ثور رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_oxen_meat.png",
		}
	},

	["WomenOutfit077"] = {
		label = "زي نسائي 077",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit077.png",
		}
	},

	["cuthemp_ti"] = {
		label = "Trimmed Tropical Indica",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp harvested from the lush, tropical regions!",
		client = {
			image = "cuthemp_ti.png",
		}
	},

	["womenoutfit252"] = {
		label = "زي نسائي 252",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit252.png",
		}
	},

	["WomenOutfit008"] = {
		label = "زي نسائي 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit008.png",
		}
	},

	["WomenOutfit068"] = {
		label = "زي نسائي 068",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit068.png",
		}
	},

	["WomenOutfit066"] = {
		label = "زي نسائي 066",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit066.png",
		}
	},

	["OutfitMen118"] = {
		label = "بدلة رجالية 118",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen118.png",
		}
	},

	["WomenOutfits05"] = {
		label = "زي نسائي 05",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits05.png",
		}
	},

	["WomenOutfit063"] = {
		label = "زي نسائي 063",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit063.png",
		}
	},

	["WomenHats198"] = {
		label = "قبعة نسائية 198",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats198.png",
		}
	},

	["key_mayor"] = {
		label = "مفتاح العمدة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "key_mayor.png",
		}
	},

	["a_brush"] = {
		label = "فرشاة",
		weight = 100000,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_brush.png",
		}
	},

	["womenoutfit6"] = {
		label = "زي نسائي 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit6.png",
		}
	},

	["WomenOutfit060"] = {
		label = "زي نسائي 060",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit060.png",
		}
	},

	["WomenGloves013"] = {
		label = "قفازات نسائية 013",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves013.png",
		}
	},

	["provision_legendary_fox_claw"] = {
		label = "مخلب ثعلب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب قوي من ثعلب أسطوري.",
		client = {
			image = "provision_legendary_fox_claw.png",
		}
	},

	["Watering_Can"] = {
		label = "عُلبة سقاية",
		weight = 250,
		stack = true,
		close = true,
		description = "عُلبة السقاية هي أداة زراعية أساسية تستخدم لري المحاصيل.",
		client = {
			image = "Watering_Can.png",
		}
	},

	["womenoutfit102"] = {
		label = "زي نسائي 102",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit102.png",
		}
	},

	["womenoutfit543"] = {
		label = "زي نسائي 543",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit543.png",
		}
	},

	["cheese"] = {
		label = "جبن",
		weight = 250,
		stack = true,
		close = true,
		description = "جبن",
		client = {
			image = "cheese.png",
		}
	},

	["WomenOutfit053"] = {
		label = "زي نسائي 053",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit053.png",
		}
	},

	["WomenOutfit052"] = {
		label = "زي نسائي 052",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit052.png",
		}
	},

	["provision_legendary_boar_tusk"] = {
		label = "ناب خنزير بري أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب نادر من خنزير بري أسطوري.",
		client = {
			image = "provision_legendary_boar_tusk.png",
		}
	},

	["MenOutfits040"] = {
		label = "زي رجالي 040",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits040.png",
		}
	},

	["WomenOutfit051"] = {
		label = "زي نسائي 051",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit051.png",
		}
	},

	["WomenOutfit049"] = {
		label = "زي نسائي 049",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit049.png",
		}
	},

	["s_inv_cigcard_lnd_01x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 01",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #01",
		client = {
			image = "s_inv_cigcard_lnd_01x.png",
		}
	},

	["resource_pelt_muskrat_star_1"] = {
		label = "جلد المسك رات 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_muskrat_star_1.png",
		}
	},

	["consumable_meat_plump_bird_oregano_cooked"] = {
		label = "لحم طائر ممتلئ بالأوريغانو مشوي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_meat_plump_bird_oregano_cooked.png",
		}
	},

	["poor_nraccoon_meat"] = {
		label = "لحم راكون رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم راكون بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_nraccoon_meat.png",
		}
	},

	["womenoutfit662"] = {
		label = "زي نسائي 662",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit662.png",
		}
	},

	["WomenOutfit040"] = {
		label = "زي نسائي 040",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit040.png",
		}
	},

	["WomenOutfit039"] = {
		label = "زي نسائي 039",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit039.png",
		}
	},

	["menoutfit28"] = {
		label = "ملابس الرجال 28",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit28.png",
		}
	},

	["womenoutfit157"] = {
		label = "زي نسائي 157",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit157.png",
		}
	},

	["WomenHats156"] = {
		label = "قبعة نسائية 156",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats156.png",
		}
	},

	["WomenOutfit034"] = {
		label = "زي نسائي 034",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit034.png",
		}
	},

	["WomenOutfit033"] = {
		label = "زي نسائي 033",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit033.png",
		}
	},

	["wethemp_md"] = {
		label = "Wet Mountain Dew",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp collected from the misty heights of the mountains!",
		client = {
			image = "wethemp_md.png",
		}
	},

	["WomenHats079"] = {
		label = "قبعة نسائية 079",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats079.png",
		}
	},

	["shield02"] = {
		label = "درع 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield02.png",
		}
	},

	["WomenOutfit032"] = {
		label = "زي نسائي 032",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit032.png",
		}
	},

	["OutfitMen017"] = {
		label = "بدلة رجالية 017",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen017.png",
		}
	},

	["resource_skin_pronghorn_star_1"] = {
		label = "فرو الظبي 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_pronghorn_star_1.png",
		}
	},

	["WomenOutfit030"] = {
		label = "زي نسائي 030",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit030.png",
		}
	},

	["WomenOutfit026"] = {
		label = "زي نسائي 026",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit026.png",
		}
	},

	["a_medicine"] = {
		label = "دواء الحيوان",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_medicine.png",
		}
	},

	["newspaper1"] = {
		label = "جريدة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "newspaper1.png",
		}
	},

	["WomenOutfit025"] = {
		label = "زي نسائي 025",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit025.png",
		}
	},

	["WomenOutfit022"] = {
		label = "زي نسائي 022",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit022.png",
		}
	},

	["hat300300"] = {
		label = "Hat vip pro 1",
		weight = 250,
		stack = true,
		close = true,
		description = "Hat vip pro 2",
		client = {
			image = "hat300300.png",
		}
	},

	["OutfitMen177"] = {
		label = "بدلة رجالية 177",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen177.png",
		}
	},

	["consumable_canned_carrots"] = {
		label = "جزر معلب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_canned_carrots.png",
		}
	},

	["consumable_meat_stringy_cooked"] = {
		label = "لحم طري مطبوخ",
		weight = 250,
		stack = true,
		close = true,
		description = "قطع لحم طرية مطبوخة.",
		client = {
			image = "consumable_meat_stringy_cooked.png",
		}
	},

	["WomenOutfit020"] = {
		label = "زي نسائي 020",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit020.png",
		}
	},

	["WomenOutfit018"] = {
		label = "زي نسائي 018",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit018.png",
		}
	},

	["coats"] = {
		label = "معاطف",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "coats.png",
		}
	},

	["building_plan_10"] = {
		label = "ورقة بناء بيت 10",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_10.png",
		}
	},

	["WomenOutfit016"] = {
		label = "زي نسائي 016",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit016.png",
		}
	},

	["womenoutfit678"] = {
		label = "زي نسائي 678",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit678.png",
		}
	},

	["womenoutfit471"] = {
		label = "زي نسائي 471",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit471.png",
		}
	},

	["womenoutfit178"] = {
		label = "زي نسائي 178",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit178.png",
		}
	},

	["perfect_buffalo_meat"] = {
		label = "لحم جاموس ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم جاموس بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_buffalo_meat.png",
		}
	},

	["OutfitMen029"] = {
		label = "بدلة رجالية 029",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen029.png",
		}
	},

	["WomenOutfit0002"] = {
		label = "زي نسائي 0002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit0002.png",
		}
	},

	["womenoutfit666"] = {
		label = "زي نسائي 666",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit666.png",
		}
	},

	["WomenHats061"] = {
		label = "قبعة نسائية 061",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats061.png",
		}
	},

	["WomenOutfit097"] = {
		label = "زي نسائي 097",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit097.png",
		}
	},

	["heron_feathers"] = {
		label = "ريش مالك الحزين",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش مالك الحزين يُستخدم في أعمال التصنيع.",
		client = {
			image = "heron_feathers.png",
		}
	},

	["perfect_bigalligatore_pelt"] = {
		label = "فرو تمساح ضخم ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح ضخم بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_bigalligatore_pelt.png",
		}
	},

	["WomenNecklaces018"] = {
		label = "قلادة نسائية 018",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces018.png",
		}
	},

	["resource_pearl"] = {
		label = "لؤلؤة",
		weight = 250,
		stack = true,
		close = true,
		description = "لؤلؤة",
		client = {
			image = "resource_pearl.png",
		}
	},

	["womenoutfit382"] = {
		label = "زي نسائي 382",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit382.png",
		}
	},

	["ring_gold"] = {
		label = "خاتم ذهبي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ring_gold.png",
		}
	},

	["spats"] = {
		label = "سبات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "spats.png",
		}
	},

	["WomenHats017"] = {
		label = "قبعة نسائية 017",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats017.png",
		}
	},

	["WomenGloves021"] = {
		label = "قفازات نسائية 021",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves021.png",
		}
	},

	["WomenNecklaces015"] = {
		label = "قلادة نسائية 015",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces015.png",
		}
	},


	["WomenNecklaces013"] = {
		label = "قلادة نسائية 013",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces013.png",
		}
	},

	["press_np"] = {
		label = "مكبس NP",
		weight = 250,
		stack = true,
		close = true,
		description = "مكبس NP",
		client = {
			image = "press_np.png",
		}
	},

	["WomenNecklaces010"] = {
		label = "قلادة نسائية 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces010.png",
		}
	},

	["WomenNecklaces008"] = {
		label = "قلادة نسائية 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces008.png",
		}
	},

	["WomenNecklaces007"] = {
		label = "قلادة نسائية 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces007.png",
		}
	},

	["WomenOutfits53"] = {
		label = "زي نسائي 53",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits53.png",
		}
	},

	["WomenNecklaces005"] = {
		label = "قلادة نسائية 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces005.png",
		}
	},

	["WomenNecklaces004"] = {
		label = "قلادة نسائية 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces004.png",
		}
	},

	["resource_pelt_beaver_star_2"] = {
		label = "جلد القندس 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_beaver_star_2.png",
		}
	},

	["tickettrain"] = {
		label = "تذكرة قطار",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tickettrain.png",
		}
	},

	["womenoutfit640"] = {
		label = "زي نسائي 640",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit640.png",
		}
	},

	["oil_barrel"] = {
		label = "برميل النفط",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "oil_barrel.png",
		}
	},

	["WomenHats209"] = {
		label = "قبعة نسائية 209",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats209.png",
		}
	},

	["WomenHats208"] = {
		label = "قبعة نسائية 208",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats208.png",
		}
	},

	["animal_toad"] = {
		label = "علجوم",
		weight = 250,
		stack = true,
		close = true,
		description = "علجوم.",
		client = {
			image = "animal_toad.png",
		}
	},

	["s_inv_cigcard_spt_11x"] = {
		label = "بطاقة السجائر أبطال العالم 11",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #11",
		client = {
			image = "s_inv_cigcard_spt_11x.png",
		}
	},

	["provision_legendary_talisman_alligator"] = {
		label = "تميمة التمساح الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "تميمة قوية مأخوذة من تمساح أسطوري.",
		client = {
			image = "provision_legendary_talisman_alligator.png",
		}
	},

	["womenoutfit402"] = {
		label = "زي نسائي 402",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit402.png",
		}
	},

	["WomenHats206"] = {
		label = "قبعة نسائية 206",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats206.png",
		}
	},

	["womenoutfit440"] = {
		label = "زي نسائي 440",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit440.png",
		}
	},

	["WomenOutfits25"] = {
		label = "زي نسائي 25",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits25.png",
		}
	},

	["WomenHats203"] = {
		label = "قبعة نسائية 203",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats203.png",
		}
	},

	["WomenHats200"] = {
		label = "قبعة نسائية 200",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats200.png",
		}
	},

	["WomenHats199"] = {
		label = "قبعة نسائية 199",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats199.png",
		}
	},

	["WomenOutfit062"] = {
		label = "زي نسائي 062",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit062.png",
		}
	},

	["resource_skin_pronghorn_star_2"] = {
		label = "فرو الظبي 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_pronghorn_star_2.png",
		}
	},

	["womenoutfit156"] = {
		label = "زي نسائي 156",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit156.png",
		}
	},

	["cigarette_indigo"] = {
		label = "سيجارة إنديغو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cigarette_indigo.png",
		}
	},

	["s_inv_cigcard_plt_02x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #02",
		client = {
			image = "s_inv_cigcard_plt_02x.png",
		}
	},

	["s_inv_cigcard_spt_12x"] = {
		label = "بطاقة السجائر أبطال العالم 12",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #12",
		client = {
			image = "s_inv_cigcard_spt_12x.png",
		}
	},

	["r_locker9"] = {
		label = "خزنة رقم 9",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker9.png",
		}
	},

	["BreederFix"] = {
		label = "Breeder Fix",
		weight = 250,
		stack = false,
		close = true,
		description = "Breede rFix",
		client = {
			image = "BreederFix.png",
		}
	},

	["COYOTE_VAR_003"] = {
		label = "ذئب براري أسطوري أسود",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب براري أسطوري بلون أسود.",
		client = {
			image = "COYOTE_VAR_003.png",
		}
	},

	["poor_bighorn_meat"] = {
		label = "لحم كبش رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم كبش بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_bighorn_meat.png",
		}
	},

	["provision_belt_buckle_platinum"] = {
		label = "إبزيم حزام بلاتيني",
		weight = 250,
		stack = true,
		close = true,
		description = "مشبك بلاتيني",
		client = {
			image = "provision_belt_buckle_platinum.png",
		}
	},

	["WomenOutfits17"] = {
		label = "زي نسائي 17",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits17.png",
		}
	},

	["WomenHats182"] = {
		label = "قبعة نسائية 182",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats182.png",
		}
	},

	["resource_pelt_beaver_star_1"] = {
		label = "جلد القندس 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_beaver_star_1.png",
		}
	},

	["WomenGloves007"] = {
		label = "قفازات نسائية 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves007.png",
		}
	},

	["WomenHats181"] = {
		label = "قبعة نسائية 181",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats181.png",
		}
	},

	["WomenHats180"] = {
		label = "قبعة نسائية 180",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats180.png",
		}
	},

	["WomenHats179"] = {
		label = "قبعة نسائية 179",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats179.png",
		}
	},

	["s_inv_cigcard_plt_12x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 1",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #12",
		client = {
			image = "s_inv_cigcard_plt_12x.png",
		}
	},

	["dryhemp_mm"] = {
		label = "Dry Montana Mist",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the crisp air of Montana plains!",
		client = {
			image = "dryhemp_mm.png",
		}
	},

	["WomenHats173"] = {
		label = "قبعة نسائية 173",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats173.png",
		}
	},

	["MenOutfits38"] = {
		label = "زي رجالي 38",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits38.png",
		}
	},

	["WomenHats170"] = {
		label = "قبعة نسائية 170",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats170.png",
		}
	},

	["WomenHats169"] = {
		label = "قبعة نسائية 169",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats169.png",
		}
	},

	["WomenHats163"] = {
		label = "قبعة نسائية 163",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats163.png",
		}
	},

	["s_inv_cigcard_veh_01x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 01",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #01",
		client = {
			image = "s_inv_cigcard_veh_01x.png",
		}
	},

	["consumable_chef_cheedar_cheese"] = {
		label = "جبن شيدر من الطباخ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chef_cheedar_cheese.png",
		}
	},

	["s_inv_cigcard_gun_10x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 10",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #10",
		client = {
			image = "s_inv_cigcard_gun_10x.png",
		}
	},

	["womenoutfit685"] = {
		label = "زي نسائي 685",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit685.png",
		}
	},

	["docburnedkit"] = {
		label = "طقم طبي للحروق",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين المصابين بالحروق!",
		client = {
			image = "docburnedkit.png",
		}
	},

	["qwe_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "qwe_news.png",
		}
	},

	["WomenHats160"] = {
		label = "قبعة نسائية 160",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats160.png",
		}
	},

	["WomenHats159"] = {
		label = "قبعة نسائية 159",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats159.png",
		}
	},

	["WomenHats158"] = {
		label = "قبعة نسائية 158",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats158.png",
		}
	},

	["WomenHats157"] = {
		label = "قبعة نسائية 157",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats157.png",
		}
	},

	["WomenOutfit035"] = {
		label = "زي نسائي 035",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit035.png",
		}
	},

	["womenoutfit45"] = {
		label = "زي نسائي 45",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit45.png",
		}
	},

	["meduim_oxen_meat"] = {
		label = "لحم ثور متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "meduim_oxen_meat.png",
		}
	},

	["OutfitMen062"] = {
		label = "بدلة رجالية 062",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen062.png",
		}
	},

	["WomenHats153"] = {
		label = "قبعة نسائية 153",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats153.png",
		}
	},

	["WomenHats150"] = {
		label = "قبعة نسائية 150",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats150.png",
		}
	},

	["WomenHats149"] = {
		label = "قبعة نسائية 149",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats149.png",
		}
	},

	["provision_trinket_iguana_scale"] = {
		label = "تعويذة قشور الإغوانا",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من قشور الإغوانا.",
		client = {
			image = "provision_trinket_iguana_scale.png",
		}
	},

	["WomenHats148"] = {
		label = "قبعة نسائية 148",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats148.png",
		}
	},

	["womenoutfit562"] = {
		label = "زي نسائي 562",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit562.png",
		}
	},

	["WomenHats142"] = {
		label = "قبعة نسائية 142",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats142.png",
		}
	},

	["WomenHats141"] = {
		label = "قبعة نسائية 141",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats141.png",
		}
	},

	["resource_skin_iguana_green_star_3"] = {
		label = "جلد الإغوانا 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_iguana_green_star_3.png",
		}
	},

	["OutfitMen173"] = {
		label = "بدلة رجالية 173",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen173.png",
		}
	},

	["WomenHats119"] = {
		label = "قبعة نسائية 119",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats119.png",
		}
	},

	["womenoutfit358"] = {
		label = "زي نسائي 358",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit358.png",
		}
	},

	["WomenHats138"] = {
		label = "قبعة نسائية 138",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats138.png",
		}
	},

	["OutfitMen009"] = {
		label = "بدلة رجالية 009",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen009.png",
		}
	},

	["WomenHats134"] = {
		label = "قبعة نسائية 134",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats134.png",
		}
	},

	["WomenHats133"] = {
		label = "قبعة نسائية 133",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats133.png",
		}
	},

	["OutfitMen063"] = {
		label = "بدلة رجالية 063",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen063.png",
		}
	},

	["womenoutfit604"] = {
		label = "زي نسائي 604",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit604.png",
		}
	},

	["womenoutfit673"] = {
		label = "زي نسائي 673",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit673.png",
		}
	},

	["bronzecoin"] = {
		label = "عملة برونزية",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع العملة البرونزية بأسعار مرتفعة.",
		client = {
			image = "bronzecoin.png",
		}
	},

	["menoutfit104"] = {
		label = "ملابس الرجال 104",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit104.png",
		}
	},

	["consumable_meat_prime_beef_cooked"] = {
		label = "لحم بقر مشوي ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_meat_prime_beef_cooked.png",
		}
	},

	["menoutfit88"] = {
		label = "ملابس الرجال 88",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit88.png",
		}
	},

	["WomenHats123"] = {
		label = "قبعة نسائية 123",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats123.png",
		}
	},

	["WomenHats122"] = {
		label = "قبعة نسائية 122",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats122.png",
		}
	},

	["WomenHats140"] = {
		label = "قبعة نسائية 140",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats140.png",
		}
	},

	["provision_meat_mature_venison"] = {
		label = "لحم الغزال الناضج",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال ناضج وطري.",
		client = {
			image = "provision_meat_mature_venison.png",
		}
	},

	["katana05"] = {
		label = "كاتانا 05",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana05.png",
		}
	},

	["s_inv_cigcard_gun_09x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 09",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #09",
		client = {
			image = "s_inv_cigcard_gun_09x.png",
		}
	},

	["cleaver01"] = {
		label = "سكين تقطيع 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cleaver01.png",
		}
	},

	["poor_elk_meat"] = {
		label = "لحم وعل رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم وعل بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_elk_meat.png",
		}
	},

	["womenoutfit649"] = {
		label = "زي نسائي 649",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit649.png",
		}
	},

	["WomenHats117"] = {
		label = "قبعة نسائية 117",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats117.png",
		}
	},

	["provision_raven_feather"] = {
		label = "ريشة الغراب",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة سوداء مأخوذة من غراب.",
		client = {
			image = "provision_raven_feather.png",
		}
	},

	["WomenHats114"] = {
		label = "قبعة نسائية 114",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats114.png",
		}
	},

	["WomenHats113"] = {
		label = "قبعة نسائية 113",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats113.png",
		}
	},

	["womenoutfit393"] = {
		label = "زي نسائي 393",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit393.png",
		}
	},

	["resource_skin_moose_star_1"] = {
		label = "فرو الموظ 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_moose_star_1.png",
		}
	},

	["door5"] = {
		label = "مفتاح الباب 5",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door5.png",
		}
	},

	["WomenOutfits29"] = {
		label = "زي نسائي 29",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits29.png",
		}
	},

	["OutfitMen028"] = {
		label = "بدلة رجالية 028",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen028.png",
		}
	},

	["WomenHats106"] = {
		label = "قبعة نسائية 106",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats106.png",
		}
	},

	["door6"] = {
		label = "مفتاح الباب 6",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door6.png",
		}
	},

	["WomenHats102"] = {
		label = "قبعة نسائية 102",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats102.png",
		}
	},

	["WomenHats101"] = {
		label = "قبعة نسائية 101",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats101.png",
		}
	},

	["butchertable"] = {
		label = "طاولة الجزار",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "butchertable.png",
		}
	},

	["s_inv_cigcard_art_06x"] = {
		label = "بطاقة السجائر فن 06",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #06",
		client = {
			image = "s_inv_cigcard_art_06x.png",
		}
	},

	["OutfitMen126"] = {
		label = "بدلة رجالية 126",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen126.png",
		}
	},

	["MenOutfits13"] = {
		label = "زي رجالي 13",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits13.png",
		}
	},

	["womenoutfit422"] = {
		label = "زي نسائي 422",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit422.png",
		}
	},

	["WomenHats097"] = {
		label = "قبعة نسائية 097",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats097.png",
		}
	},

	["backpack1"] = {
		label = "حقيبة تحمل سعة 200",
		weight = 250,
		stack = false,
		close = true,
		description = " حقيبة تحمل سعة 200",
		client = {
			image = "backpack1.png",
		}
	},

	["house_key31"] = {
		label = "مفتاح المنزل رقم 31",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "house_key31.png",
		}
	},

	["womenoutfit210"] = {
		label = "زي نسائي 210",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit210.png",
		}
	},

	["resource_skin_deer_star_3"] = {
		label = "جلد الغزال 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_deer_star_3.png",
		}
	},

	["WomenHats092"] = {
		label = "قبعة نسائية 092",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats092.png",
		}
	},

	["womenoutfit317"] = {
		label = "زي نسائي 317",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit317.png",
		}
	},

	["WomenHats088"] = {
		label = "قبعة نسائية 088",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats088.png",
		}
	},

	["egg_vulture"] = {
		label = "بيضة نسر",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة نسر.",
		client = {
			image = "egg_vulture.png",
		}
	},

	["consumable_apricots_can"] = {
		label = "علبة مشمش صالحة للأكل",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على مشمش.",
		client = {
			image = "consumable_apricots_can.png",
		}
	},

	["animal_oriole_baltimore"] = {
		label = "طائر الأوريول بالتيمور",
		weight = 250,
		stack = true,
		close = true,
		description = "طائر الأوريول بالتيمور.",
		client = {
			image = "animal_oriole_baltimore.png",
		}
	},

	["WomenHats082"] = {
		label = "قبعة نسائية 082",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats082.png",
		}
	},

	["WomenHats081"] = {
		label = "قبعة نسائية 081",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats081.png",
		}
	},

	["snakes_e"] = {
		label = "ثعبان (e)",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان من النوع e، يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "snakes_e.png",
		}
	},

	["fishing_rod_advanced"] = {
		label = "Advanced Fishing Rod",
		weight = 2800,
		stack = false,
		close = true,
		description = "Better quality rod for experienced fishermen",
		client = {
			image = "fishing_rod_advanced.png",
		}
	},

	["womenoutfit518"] = {
		label = "زي نسائي 518",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit518.png",
		}
	},

	["OutfitMen022"] = {
		label = "بدلة رجالية 022",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen022.png",
		}
	},

	["resource_wagon_wheel"] = {
		label = "عجلة عربة",
		weight = 250,
		stack = true,
		close = true,
		description = "عجلة عربة",
		client = {
			image = "resource_wagon_wheel.png",
		}
	},

	["WomenHats074"] = {
		label = "قبعة نسائية 074",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats074.png",
		}
	},

	["Erythroxylum_Seed"] = {
		label = "بذور الإيريثروكسيلوم",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج نبات الإيريثروكسيلوم.",
		client = {
			image = "Erythroxylum_Seed.png",
		}
	},

	["WomenHats071"] = {
		label = "قبعة نسائية 071",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats071.png",
		}
	},

	["WomenHats069"] = {
		label = "قبعة نسائية 069",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats069.png",
		}
	},

	["WomenHats068"] = {
		label = "قبعة نسائية 068",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats068.png",
		}
	},

	["WomenHats067"] = {
		label = "قبعة نسائية 067",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats067.png",
		}
	},

	["WomenHats066"] = {
		label = "قبعة نسائية 066",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats066.png",
		}
	},

	["WomenNecklaces023"] = {
		label = "قلادة نسائية 023",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces023.png",
		}
	},

	["WomenHats059"] = {
		label = "قبعة نسائية 059",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats059.png",
		}
	},

	["ban2"] = {
		label = "باندانا 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ban2.png",
		}
	},

	["provision_owl_feather"] = {
		label = "ريشة بومة",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة نادرة من بومة.",
		client = {
			image = "provision_owl_feather.png",
		}
	},

	["WomenHats057"] = {
		label = "قبعة نسائية 057",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats057.png",
		}
	},

	["OutfitMen049"] = {
		label = "بدلة رجالية 049",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen049.png",
		}
	},

	["WomenHats053"] = {
		label = "قبعة نسائية 053",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats053.png",
		}
	},

	["WomenHats002"] = {
		label = "قبعة نسائية 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats002.png",
		}
	},

	["WomenHats047"] = {
		label = "قبعة نسائية 047",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats047.png",
		}
	},

	["womenoutfit574"] = {
		label = "زي نسائي 574",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit574.png",
		}
	},

	["consumable_peas_can"] = {
		label = "علبة البازلاء",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على البازلاء.",
		client = {
			image = "consumable_peas_can.png",
		}
	},

	["WomenHats044"] = {
		label = "قبعة نسائية 044",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats044.png",
		}
	},

	["WomenHats041"] = {
		label = "قبعة نسائية 041",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats041.png",
		}
	},

	["provision_beaver_fur"] = {
		label = "فراء القندس",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم مأخوذ من قندس.",
		client = {
			image = "provision_beaver_fur.png",
		}
	},

	["WomenHats040"] = {
		label = "قبعة نسائية 040",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats040.png",
		}
	},

	["womenoutfit76"] = {
		label = "زي نسائي 76",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit76.png",
		}
	},

	["WomenHats038"] = {
		label = "قبعة نسائية 038",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats038.png",
		}
	},

	["crawfish_animal"] = {
		label = "جمبري",
		weight = 250,
		stack = true,
		close = true,
		description = "جمبري يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "crawfish_animal.png",
		}
	},

	["wings2"] = {
		label = "أجنحة 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "wings2.png",
		}
	},

	["OutfitMen081"] = {
		label = "بدلة رجالية 081",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen081.png",
		}
	},

	["womenoutfit270"] = {
		label = "زي نسائي 270",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit270.png",
		}
	},

	["WomenHats036"] = {
		label = "قبعة نسائية 036",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats036.png",
		}
	},

	["womenoutfit587"] = {
		label = "زي نسائي 587",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit587.png",
		}
	},

	["womenoutfit171"] = {
		label = "زي نسائي 171",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit171.png",
		}
	},

	["womenoutfit775"] = {
		label = "زي نسائي 775",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit775.png",
		}
	},

	["WomenHats030"] = {
		label = "قبعة نسائية 030",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats030.png",
		}
	},

	["womenoutfit47"] = {
		label = "زي نسائي 47",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit47.png",
		}
	},

	["consumable_cupcake_buttercream"] = {
		label = "كعكة بكريمة الزبدة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_cupcake_buttercream.png",
		}
	},

	["resource_pelt_peccary_star_3"] = {
		label = "فرو بيكاري 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_peccary_star_3.png",
		}
	},

	["provision_buck_antlers"] = {
		label = "قرون الغزال",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون مأخوذة من غزال.",
		client = {
			image = "provision_buck_antlers.png",
		}
	},

	["OutfitMen152"] = {
		label = "بدلة رجالية 152",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen152.png",
		}
	},

	["OutfitMen008"] = {
		label = "بدلة رجالية 008",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen008.png",
		}
	},

	["WomenHats023"] = {
		label = "قبعة نسائية 023",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats023.png",
		}
	},

	["parrot_feathers"] = {
		label = "ريش ببغاء",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش ببغاء يُستخدم في أعمال التصنيع.",
		client = {
			image = "parrot_feathers.png",
		}
	},

	["womenoutfit825"] = {
		label = "زي نسائي 825",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit825.png",
		}
	},

	["horseloadout6"] = {
		label = "حمولة حصان 6",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout6.png",
		}
	},

	["WomenHats018"] = {
		label = "قبعة نسائية 018",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats018.png",
		}
	},

	["marijuana_jar2"] = {
		label = "جرة الماريجوانا 2",
		weight = 250,
		stack = true,
		close = true,
		description = "جرة الماريجوانا 2",
		client = {
			image = "marijuana_jar2.png",
		}
	},

	["WomenNecklaces016"] = {
		label = "قلادة نسائية 016",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces016.png",
		}
	},

	["provision_legendary_panther_fur"] = {
		label = "فراء الفهد الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء فاخر وناعم من فهد أسطوري.",
		client = {
			image = "provision_legendary_panther_fur.png",
		}
	},

	["law_news"] = {
		label = "جريدة جبنة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "law_news.png",
		}
	},

	["cuthemp_sb"] = {
		label = "Trimmed Sandy Breeze",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp gathered from the sandy and breezy coastal areas!",
		client = {
			image = "cuthemp_sb.png",
		}
	},

	["provision_javelina_tusk"] = {
		label = "ناب الجافلينا",
		weight = 250,
		stack = true,
		close = true,
		description = "ناب حاد مأخوذ من الجافلينا.",
		client = {
			image = "provision_javelina_tusk.png",
		}
	},

	["WomenHats016"] = {
		label = "قبعة نسائية 016",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats016.png",
		}
	},

	["WomenHats010"] = {
		label = "قبعة نسائية 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats010.png",
		}
	},

	["WomenHats008"] = {
		label = "قبعة نسائية 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats008.png",
		}
	},

	["WomenHats007"] = {
		label = "قبعة نسائية 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats007.png",
		}
	},

	["WomenHats004"] = {
		label = "قبعة نسائية 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats004.png",
		}
	},

	["OutfitMen059"] = {
		label = "بدلة رجالية 059",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen059.png",
		}
	},

	["resource_snake_skin_western_rattlesnake_star_2"] = {
		label = "جلد أفعى الغربية المجلجلة 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_western_rattlesnake_star_2.png",
		}
	},

	["OutfitMen079"] = {
		label = "بدلة رجالية 079",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen079.png",
		}
	},

	["WomenHats003"] = {
		label = "قبعة نسائية 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats003.png",
		}
	},

	["WomenHats051"] = {
		label = "قبعة نسائية 051",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats051.png",
		}
	},

	["WomenHats001"] = {
		label = "قبعة نسائية 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats001.png",
		}
	},

	["clothes"] = {
		label = "ملابس",
		weight = 250,
		stack = true,
		close = true,
		description = "ملابس",
		client = {
			image = "clothes.png",
		}
	},

	["vests"] = {
		label = "صدريات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "vests.png",
		}
	},

	["resource_skin_deer_star_1"] = {
		label = "جلد الغزال 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_deer_star_1.png",
		}
	},

	["OutfitMen165"] = {
		label = "بدلة رجالية 165",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen165.png",
		}
	},

	["coffeeseeds"] = {
		label = "بذور القهوة",
		weight = 250,
		stack = true,
		close = true,
		description = "بذرة يمكن زراعتها لإنبات نبات القهوة",
		client = {
			image = "coffeeseeds.png",
		}
	},

	["OutfitMen108"] = {
		label = "بدلة رجالية 108",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen108.png",
		}
	},

	["consumable_strawberries_can"] = {
		label = "علبة فراولة",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على الفراولة.",
		client = {
			image = "consumable_strawberries_can.png",
		}
	},

	["OutfitMen172"] = {
		label = "بدلة رجالية 172",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen172.png",
		}
	},

	["menoutfit33"] = {
		label = "ملابس الرجال 33",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit33.png",
		}
	},

	["womenoutfit751"] = {
		label = "زي نسائي 751",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit751.png",
		}
	},

	["s_inv_cigcard_lnd_05x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 05",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #05",
		client = {
			image = "s_inv_cigcard_lnd_05x.png",
		}
	},

	["WomenHats171"] = {
		label = "قبعة نسائية 171",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats171.png",
		}
	},

	["MenOutfits06"] = {
		label = "زي رجالي 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits06.png",
		}
	},

	["fairypower"] = {
		label = "قوة الجنية",
		weight = 250,
		stack = true,
		close = true,
		description = "قوة الجنية",
		client = {
			image = "fairypower.png",
		}
	},

	["OutfitMen051"] = {
		label = "بدلة رجالية 051",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen051.png",
		}
	},

	["Cotton_Seed"] = {
		label = "بذور القطن",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج نبات القطن.",
		client = {
			image = "Cotton_Seed.png",
		}
	},

	["bat01"] = {
		label = "مضرب 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "bat01.png",
		}
	},

	["al-rotcherd"] = {
		label = "قبيلة آل روتشلد",
		weight = 250,
		stack = false,
		close = true,
		description = "قبيلة آل روتشلد",
		client = {
			image = "al-rotcherd.png",
		}
	},

	["womenoutfit812"] = {
		label = "زي نسائي 812",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit812.png",
		}
	},

	["Broccoli_Seed"] = {
		label = "بذور البروكلي",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات البروكلي.",
		client = {
			image = "Broccoli_Seed.png",
		}
	},

	["katana02"] = {
		label = "كاتانا 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana02.png",
		}
	},

	["womenoutfit467"] = {
		label = "زي نسائي 467",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit467.png",
		}
	},

	["resource_snake_skin_boa_star_2"] = {
		label = "جلد الثعبان البواء 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_boa_star_2.png",
		}
	},

	["wild_rip"] = {
		label = "تمزق بري",
		weight = 250,
		stack = true,
		close = true,
		description = "تمزق بري.",
		client = {
			image = "wild_rip.png",
		}
	},

	["menoutfit81"] = {
		label = "ملابس الرجال 81",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit81.png",
		}
	},

	["provision_legendary_coyote_fur"] = {
		label = "فراء ذئب بري أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء فاخر من ذئب بري أسطوري.",
		client = {
			image = "provision_legendary_coyote_fur.png",
		}
	},

	["OutfitMen101"] = {
		label = "بدلة رجالية 101",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen101.png",
		}
	},

	["s_inv_cigcard_spt_06x"] = {
		label = "بطاقة السجائر أبطال العالم 06",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #06",
		client = {
			image = "s_inv_cigcard_spt_06x.png",
		}
	},

	["a_c_fishchannelcatfish_01_xl"] = {
		label = "Channel Catfish (Extra Large)",
		weight = 250,
		stack = true,
		close = true,
		description = "Channel Catfish (Extra Large)",
		client = {
			image = "a_c_fishchannelcatfish_01_xl.png",
		}
	},

	["womenoutfit798"] = {
		label = "زي نسائي 798",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit798.png",
		}
	},

	["consumable_horchata"] = {
		label = "هورشاتا",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_horchata.png",
		}
	},

	["s_inv_cigcard_inv_02x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 02",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #02",
		client = {
			image = "s_inv_cigcard_inv_02x.png",
		}
	},

	["provision_trinket_heron_feather"] = {
		label = "تعويذة ريش البلشون",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من ريش طائر البلشون.",
		client = {
			image = "provision_trinket_heron_feather.png",
		}
	},

	["provision_earring_ursula_citrine"] = {
		label = "قرط أورسولا سيترين",
		weight = 250,
		stack = true,
		close = true,
		description = "قرط أورسولا سيترين",
		client = {
			image = "provision_earring_ursula_citrine.png",
		}
	},

	["cuthemp_sp"] = {
		label = "Trimmed Scarlett Purp",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp cultivated in the vibrant Meadows of Scarlett!",
		client = {
			image = "cuthemp_sp.png",
		}
	},

	["WomenGloves023"] = {
		label = "قفازات نسائية 023",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves023.png",
		}
	},

	["womenoutfit248"] = {
		label = "زي نسائي 248",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit248.png",
		}
	},

	["menoutfit59"] = {
		label = "ملابس الرجال 59",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit59.png",
		}
	},

	["s_inv_cigcard_grl_11x"] = {
		label = "بطاقة السجائر جواهر الجمال 11",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #11",
		client = {
			image = "s_inv_cigcard_grl_11x.png",
		}
	},

	["WomenOutfit091"] = {
		label = "زي نسائي 091",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit091.png",
		}
	},

	["mp006_p_moonshiner_still03x"] = {
		label = "Moonshine Still 7",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "mp006_p_moonshiner_still03x.png",
		}
	},

	["s_inv_cigcard_grl_03x"] = {
		label = "بطاقة السجائر جواهر الجمال 03",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #03",
		client = {
			image = "s_inv_cigcard_grl_03x.png",
		}
	},

	["horsetrain"] = {
		label = "سوط التدريب",
		weight = 250,
		stack = true,
		close = true,
		description = "يستخدم لتدريب الخيول",
		client = {
			image = "horsetrain.png",
		}
	},

	["MenOutfits038"] = {
		label = "زي رجالي 038",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits038.png",
		}
	},

	["s_inv_cigcard_act_03x"] = {
		label = "بطاقة السجائر 03",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 03",
		client = {
			image = "s_inv_cigcard_act_03x.png",
		}
	},

	["resource_pelt_fox_star_1"] = {
		label = "جلد الثعلب 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_fox_star_1.png",
		}
	},

	["catalog"] = {
		label = "كتالوج المتجر.",
		weight = 250,
		stack = false,
		close = true,
		description = "كتالوج المتجر.",
		client = {
			image = "catalog.png",
		}
	},

	["consumable_donut6"] = {
		label = "دونات 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_donut6.png",
		}
	},

	["marijuana_joint1_3"] = {
		label = "لفافة ماريجوانا 1-3",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-3",
		client = {
			image = "marijuana_joint1_3.png",
		}
	},

	["womenoutfit368"] = {
		label = "زي نسائي 368",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit368.png",
		}
	},

	["WomenHats177"] = {
		label = "قبعة نسائية 177",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats177.png",
		}
	},

	["s_inv_cigcard_plt_01x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #01",
		client = {
			image = "s_inv_cigcard_plt_01x.png",
		}
	},

	["WomenHats039"] = {
		label = "قبعة نسائية 039",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats039.png",
		}
	},

	["MenOutfits017"] = {
		label = "زي رجالي 017",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits017.png",
		}
	},

	["OutfitMen047"] = {
		label = "بدلة رجالية 047",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen047.png",
		}
	},

	["letter"] = {
		label = "رسالة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "letter.png",
		}
	},

	["menoutfit31"] = {
		label = "ملابس الرجال 31",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit31.png",
		}
	},

	["stake02"] = {
		label = "وتد 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "stake02.png",
		}
	},

	["MenOutfits007"] = {
		label = "زي رجالي 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits007.png",
		}
	},

	["resource_pelt_peccary_star_2"] = {
		label = "فرو بيكاري 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_peccary_star_2.png",
		}
	},

	["MenOutfits002"] = {
		label = "زي رجالي 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits002.png",
		}
	},

	["menoutfit14"] = {
		label = "ملابس الرجال 14",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit14.png",
		}
	},

	["provision_trinket_condor_beak"] = {
		label = "تعويذة منقار الكندور",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من منقار كندور.",
		client = {
			image = "provision_trinket_condor_beak.png",
		}
	},

	["lumber_maplesawed_plank"] = {
		label = "لوح من خشب القيقب",
		weight = 250,
		stack = true,
		close = true,
		description = "لوح من خشب القيقب",
		client = {
			image = "lumber_maplesawed_plank.png",
		}
	},

	["soap"] = {
		label = "صابون",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "soap.png",
		}
	},

	["womenoutfit254"] = {
		label = "زي نسائي 254",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit254.png",
		}
	},

	["womenoutfit142"] = {
		label = "زي نسائي 142",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit142.png",
		}
	},

	["OutfitMen178"] = {
		label = "بدلة رجالية 178",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen178.png",
		}
	},

	["OutfitMen046"] = {
		label = "بدلة رجالية 046",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen046.png",
		}
	},

	["sumac_lemonade"] = {
		label = "ليمونادة السماق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sumac_lemonade.png",
		}
	},

	["resource_skin_bear_black_star_3"] = {
		label = "جلد الدب الأسود 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_black_star_3.png",
		}
	},

	["poor_bear_meat"] = {
		label = "لحم دب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_bear_meat.png",
		}
	},

	["a_water"] = {
		label = "ماء",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "a_water.png",
		}
	},

	["wings1"] = {
		label = "أجنحة 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "wings1.png",
		}
	},

	["medium_wolf_meat"] = {
		label = "لحم ذئب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_wolf_meat.png",
		}
	},

	["menoutfit79"] = {
		label = "ملابس الرجال 79",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit79.png",
		}
	},

	["womenoutfit336"] = {
		label = "زي نسائي 336",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit336.png",
		}
	},

	["bidaouipower"] = {
		label = "قوة الكابوس",
		weight = 250,
		stack = true,
		close = true,
		description = "قوة الكابوس",
		client = {
			image = "bidaouipower.png",
		}
	},

	["provision_saltstone"] = {
		label = "حجر الملح",
		weight = 250,
		stack = true,
		close = true,
		description = "كتلة من حجر الملح.",
		client = {
			image = "provision_saltstone.png",
		}
	},

	["consumable_tres_leches"] = {
		label = "تريس ليشيس",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_tres_leches.png",
		}
	},

	["building_plan_9"] = {
		label = "ورقة بناء بيت 9",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_9.png",
		}
	},

	["resource_pelt_peccary_star_1"] = {
		label = "فرو بيكاري 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_peccary_star_1.png",
		}
	},

	["womenoutfit290"] = {
		label = "زي نسائي 290",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit290.png",
		}
	},

	["WomenOutfit098"] = {
		label = "زي نسائي 098",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit098.png",
		}
	},

	["announcpaper"] = {
		label = "ورقة الإعلانات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "announcpaper.png",
		}
	},

	["resource_skin_alligator_star_2"] = {
		label = "جلد التمساح 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_alligator_star_2.png",
		}
	},

	["tickettattoo"] = {
		label = "تذكرة الوشم",
		weight = 250,
		stack = true,
		close = true,
		description = "تذكرة الوشم",
		client = {
			image = "tickettattoo.png",
		}
	},

	["baitbrid"] = {
		label = "طُعم الطائر",
		weight = 250,
		stack = true,
		close = true,
		description = "طُعم الطائر",
		client = {
			image = "baitbrid.png",
		}
	},

	["scopemediumspringfield"] = {
		label = "Rifle Springfield Medium Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopemediumspringfield.png",
		}
	},

	["womenoutfit10"] = {
		label = "زي نسائي 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit10.png",
		}
	},

	["medium_buffalo_meat"] = {
		label = "لحم جاموس متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم جاموس بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_buffalo_meat.png",
		}
	},

	["items_bell"] = {
		label = "جرس",
		weight = 100000,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "items_bell.png",
		}
	},

	["WomenOutfit017"] = {
		label = "زي نسائي 017",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit017.png",
		}
	},

	["marijuana_joint_double3"] = {
		label = "لفافة ماريجوانا مزدوجة 3",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا مزدوجة 3",
		client = {
			image = "marijuana_joint_double3.png",
		}
	},

	["legendary_elk_pelt"] = {
		label = "فرو وعل أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو وعل أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_elk_pelt.png",
		}
	},

	["qad_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "qad_news.png",
		}
	},

	["resource_ruby"] = {
		label = "ياقوت",
		weight = 250,
		stack = true,
		close = true,
		description = "ياقوت",
		client = {
			image = "resource_ruby.png",
		}
	},

	["sandwich"] = {
		label = "شطيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "شطيرة",
		client = {
			image = "sandwich.png",
		}
	},

	["menoutfit35"] = {
		label = "ملابس الرجال 35",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit35.png",
		}
	},

	["womenoutfit627"] = {
		label = "زي نسائي 627",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit627.png",
		}
	},

	["resource_pelt_badger_star_2"] = {
		label = "جلد الغرير 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_badger_star_2.png",
		}
	},

	["meduim_bigalligatore_pelt"] = {
		label = "فرو تمساح ضخم متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو تمساح ضخم بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "meduim_bigalligatore_pelt.png",
		}
	},

	["medium_cougar_meat"] = {
		label = "لحم أسد الجبل متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم أسد الجبل بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_cougar_meat.png",
		}
	},

	["Bubba_Kush_Seed"] = {
		label = "بذور بوبا كوش",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات بوبا كوش.",
		client = {
			image = "Bubba_Kush_Seed.png",
		}
	},

	["resource_skin_panther_star_2"] = {
		label = "جلد النمر 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_panther_star_2.png",
		}
	},

	["womenoutfit721"] = {
		label = "زي نسائي 721",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit721.png",
		}
	},

	["resource_skin_ram_star_2"] = {
		label = "جلد الكبش 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_ram_star_2.png",
		}
	},

	["resource_skin_lizard_star_3"] = {
		label = "جلد السحلية 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_lizard_star_3.png",
		}
	},

	["marijuana_joint2_3"] = {
		label = "لفافة ماريجوانا 2-3",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-3",
		client = {
			image = "marijuana_joint2_3.png",
		}
	},

	["baghemp_db"] = {
		label = "Bagged Dragons Breath",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the fiery lands of legend and myth!",
		client = {
			image = "baghemp_db.png",
		}
	},

	["lumber_resource_cork"] = {
		label = "مورد الفلين",
		weight = 250,
		stack = true,
		close = true,
		description = "مورد الفلين",
		client = {
			image = "lumber_resource_cork.png",
		}
	},

	["WomenHats109"] = {
		label = "قبعة نسائية 109",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats109.png",
		}
	},

	["nom_item_ici"] = {
		label = "الاسم بالعربي",
		weight = 250,
		stack = true,
		close = true,
		description = "وصف العنصر بالعربي",
		client = {
			image = "nom_item_ici.png",
		}
	},

	["resource_skin_cougar_star_3"] = {
		label = "جلد الكوجر 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_cougar_star_3.png",
		}
	},

	["snakes_b"] = {
		label = "ثعبان (b)",
		weight = 250,
		stack = true,
		close = true,
		description = "ثعبان من النوع b، يمكن استخدامه في التصنيع أو كعنصر نادر.",
		client = {
			image = "snakes_b.png",
		}
	},

	["bat02"] = {
		label = "مضرب 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "bat02.png",
		}
	},

	["iguanadesert_animal"] = {
		label = "إغوانا صحراوية",
		weight = 100,
		stack = true,
		close = true,
		description = "إغوانا صحراوية يمكن استخدامها في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "iguanadesert_animal.png",
		}
	},

	["womenoutfit253"] = {
		label = "زي نسائي 253",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit253.png",
		}
	},

	["WomenBracelets008"] = {
		label = "سوار نسائي 008",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets008.png",
		}
	},

	["opium"] = {
		label = "أفيون",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "opium.png",
		}
	},

	["menoutfit38"] = {
		label = "ملابس الرجال 38",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit38.png",
		}
	},

	["MenOutfits28"] = {
		label = "زي رجالي 28",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits28.png",
		}
	},

	["womenoutfit803"] = {
		label = "زي نسائي 803",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit803.png",
		}
	},

	["chesta"] = {
		label = "الصندوق 1",
		weight = 250,
		stack = true,
		close = true,
		description = "الصندوق 1",
		client = {
			image = "chesta.png",
		}
	},

	["resource_pelt_raccoon_star_2"] = {
		label = "جلد الراكون 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_raccoon_star_2.png",
		}
	},

	["provision_ring_bosque_emerald"] = {
		label = "خاتم زمرد بوسكي",
		weight = 250,
		stack = true,
		close = true,
		description = "خاتم زمرد بوسكي",
		client = {
			image = "provision_ring_bosque_emerald.png",
		}
	},

	["collector_card_box"] = {
		label = "صندوق بطاقة جامع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "collector_card_box.png",
		}
	},

	["smallcrate"] = {
		label = "صندوق صغير",
		weight = 250,
		stack = true,
		close = true,
		description = "صندوق صغير",
		client = {
			image = "smallcrate.png",
		}
	},

	["consumable_boiledegg"] = {
		label = "بيضة مسلوقة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_boiledegg.png",
		}
	},

	["legendary_beaver_meat"] = {
		label = "لحم قندس أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم قندس أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_beaver_meat.png",
		}
	},

	["menoutfit39"] = {
		label = "ملابس الرجال 39",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit39.png",
		}
	},

	["MenOutfits021"] = {
		label = "زي رجالي 021",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits021.png",
		}
	},

	["OutfitMen097"] = {
		label = "بدلة رجالية 097",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen097.png",
		}
	},

	["hookah01"] = {
		label = "شيشة 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hookah01.png",
		}
	},

	["womenoutfit271"] = {
		label = "زي نسائي 271",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit271.png",
		}
	},

	["womenoutfit462"] = {
		label = "زي نسائي 462",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit462.png",
		}
	},

	["provision_pronghorn_fur"] = {
		label = "فراء الظبي الأمريكي",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء خفيف مأخوذ من الظبي الأمريكي.",
		client = {
			image = "provision_pronghorn_fur.png",
		}
	},

	["legendary_beaver_pelt"] = {
		label = "فرو قندس أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو قندس أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_beaver_pelt.png",
		}
	},

	["Ceai"] = {
		label = "شاي  ",
		weight = 250,
		stack = true,
		close = true,
		description = "الشاي  يُعتبر أحد أكثر المشروبات استهلاكًا في العالم",
		client = {
			image = "Ceai.png",
		}
	},

	["baghemp_rd"] = {
		label = "Bagged Roanoke Dream",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp originating from the rugged Roanoke Ridge!",
		client = {
			image = "baghemp_rd.png",
		}
	},

	["frame"] = {
		label = "إطار",
		weight = 250,
		stack = false,
		close = true,
		description = "إطار",
		client = {
			image = "frame.png",
		}
	},

	["cuthemp_db"] = {
		label = "Trimmed Dragons Breath",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the fiery lands of legend and myth!",
		client = {
			image = "cuthemp_db.png",
		}
	},

	["womenoutfit484"] = {
		label = "زي نسائي 484",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit484.png",
		}
	},

	["lumber_maple_hardwood"] = {
		label = "خشب القيقب الصلب",
		weight = 250,
		stack = true,
		close = true,
		description = "خشب القيقب الصلب",
		client = {
			image = "lumber_maple_hardwood.png",
		}
	},

	["provision_sheep_wool"] = {
		label = "صوف الخروف",
		weight = 250,
		stack = true,
		close = true,
		description = "صوف مأخوذ من خروف.",
		client = {
			image = "provision_sheep_wool.png",
		}
	},

	["WomenNecklaces006"] = {
		label = "قلادة نسائية 006",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenNecklaces006.png",
		}
	},

	["WomenOutfit057"] = {
		label = "زي نسائي 057",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit057.png",
		}
	},

	["womenoutfit449"] = {
		label = "زي نسائي 449",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit449.png",
		}
	},

	["resource_bag_coal"] = {
		label = "كيس الفحم ",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس الفحم ",
		client = {
			image = "resource_bag_coal.png",
		}
	},

	["provision_bear_fur"] = {
		label = "فراء الدب",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء سميك مأخوذ من دب.",
		client = {
			image = "provision_bear_fur.png",
		}
	},

	["legendary_cougar_pelt"] = {
		label = "فرو أسد الجبل أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أسد الجبل أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_cougar_pelt.png",
		}
	},

	["horseloasout3"] = {
		label = "حمولة حصان 3",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloasout3.png",
		}
	},

	["p_ambtentgrass01x"] = {
		label = "p_ambtentgrass01x",
		weight = 250,
		stack = false,
		close = true,
		description = "p_ambtentgrass01x",
		client = {
			image = "p_ambtentgrass01x.png",
		}
	},

	["racecreator"] = {
		label = "منشئ السباق",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "racecreator.png",
		}
	},

	["cigarette_matches"] = {
		label = "أعواد ثقاب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cigarette_matches.png",
		}
	},

	["menoutfit85"] = {
		label = "ملابس الرجال 85",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit85.png",
		}
	},

	["brass_bar"] = {
		label = "بار نحاسي",
		weight = 250,
		stack = true,
		close = true,
		description = "بار نحاسي",
		client = {
			image = "brass_bar.png",
		}
	},

	["womenoutfit61"] = {
		label = "زي نسائي 61",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit61.png",
		}
	},

	["herbsbench"] = {
		label = "طاولة الأعشاب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "herbsbench.png",
		}
	},

	["MenOutfits014"] = {
		label = "زي رجالي 014",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits014.png",
		}
	},

	["mapa_03"] = {
		label = "الخريطة المفقودة 3",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 3",
		client = {
			image = "mapa_03.png",
		}
	},

	["gilamonster_animal"] = {
		label = "وحش جيلا",
		weight = 100,
		stack = true,
		close = true,
		description = "وحش جيلا سام يمكن استخدامه في التصنيع أو التحضير الكيميائي.",
		client = {
			image = "gilamonster_animal.png",
		}
	},

	["carcanoprint"] = {
		label = "كاركانو برينت",
		weight = 250,
		stack = true,
		close = true,
		description = "كاركانو برينت",
		client = {
			image = "carcanoprint.png",
		}
	},

	["health_tonic"] = {
		label = "منشط الصحة",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط الصحة",
		client = {
			image = "health_tonic.png",
		}
	},

	["medium_boar_pelt"] = {
		label = "فرو خنزير بري متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو خنزير بري بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_boar_pelt.png",
		}
	},

	["WomenHats037"] = {
		label = "قبعة نسائية 037",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats037.png",
		}
	},

	["womenoutfit56"] = {
		label = "زي نسائي 56",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit56.png",
		}
	},

	["resource_quartz"] = {
		label = "سبيكة الكوارتز",
		weight = 250,
		stack = true,
		close = true,
		description = "سبيكة الكوارتز",
		client = {
			image = "resource_quartz.png",
		}
	},

	["medium_moose_meat"] = {
		label = "لحم موظ متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم موظ بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_moose_meat.png",
		}
	},

	["clothe3"] = {
		label = "ملابس 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "clothe3.png",
		}
	},

	["blackmulberry_seedx"] = {
		label = "بذور التوت الأسود",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات التوت الأسود",
		client = {
			image = "blackmulberry_seedx.png",
		}
	},

	["katana04"] = {
		label = "كاتانا 04",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "katana04.png",
		}
	},

	["OutfitMen094"] = {
		label = "بدلة رجالية 094",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen094.png",
		}
	},

	["outfit"] = {
		label = "ملابس",
		weight = 250,
		stack = true,
		close = true,
		description = "",
		client = {
			image = "outfit.png",
		}
	},

	["OutfitMen039"] = {
		label = "بدلة رجالية 039",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen039.png",
		}
	},

	["womenoutfit571"] = {
		label = "زي نسائي 571",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit571.png",
		}
	},

	["building_plan_2"] = {
		label = "ورقة بناء بيت 2",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_2.png",
		}
	},

	["chaps"] = {
		label = "شعب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "chaps.png",
		}
	},

	["hat100100"] = {
		label = "Hat vip",
		weight = 250,
		stack = true,
		close = true,
		description = "Hat vip",
		client = {
			image = "hat100100.png",
		}
	},

	["bread6"] = {
		label = "خبز 6",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "bread6.png",
		}
	},

	["OutfitMen098"] = {
		label = "بدلة رجالية 098",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen098.png",
		}
	},

	["ricx_leg_animal_guide"] = {
		label = "Legendary Animal Guide Book",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ricx_leg_animal_guide.png",
		}
	},

	["saddlestandard"] = {
		label = "سرج عادي",
		weight = 250,
		stack = true,
		close = true,
		description = "سرج قياسي",
		client = {
			image = "saddlestandard.png",
		}
	},

	["duck_feathers"] = {
		label = "ريش بط",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش بط يُستخدم في أعمال التصنيع.",
		client = {
			image = "duck_feathers.png",
		}
	},

	["consumable_carib_rum"] = {
		label = "روم كاريبي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب روم كاريبي.",
		client = {
			image = "consumable_carib_rum.png",
		}
	},

	["treasuregold"] = {
		label = "ذهب الكنز",
		weight = 250,
		stack = true,
		close = true,
		description = "ذهب الكنز",
		client = {
			image = "treasuregold.png",
		}
	},

	["provision_legendary_elk_fur"] = {
		label = "فراء الأيل الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم من أيل أسطوري.",
		client = {
			image = "provision_legendary_elk_fur.png",
		}
	},

	["resource_snake_skin_western_rattlesnake_star_1"] = {
		label = "جلد أفعى الغربية المجلجلة 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_western_rattlesnake_star_1.png",
		}
	},

	["provision_panther_fur"] = {
		label = "فراء الفهد",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم ومميز مأخوذ من فهد.",
		client = {
			image = "provision_panther_fur.png",
		}
	},

	["dryhemp_db"] = {
		label = "Dry Dragons Breath",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the fiery lands of legend and myth!",
		client = {
			image = "dryhemp_db.png",
		}
	},

	["menoutfit110"] = {
		label = "ملابس الرجال 110",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit110.png",
		}
	},

	["MenOutfits08"] = {
		label = "زي رجالي 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits08.png",
		}
	},

	["OutfitMen093"] = {
		label = "بدلة رجالية 093",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen093.png",
		}
	},

	["provision_legendary_ram_hide"] = {
		label = "جلد كبش أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد نادر من كبش أسطوري.",
		client = {
			image = "provision_legendary_ram_hide.png",
		}
	},

	["s_inv_cigcard_veh_10x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 10",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #10",
		client = {
			image = "s_inv_cigcard_veh_10x.png",
		}
	},

	["chestb"] = {
		label = "الصندوق 2",
		weight = 250,
		stack = true,
		close = true,
		description = "الصندوق 2",
		client = {
			image = "chestb.png",
		}
	},

	["s_inv_cigcard_hrs_11x"] = {
		label = "بطاقة السجائر سلالات الخيول 11",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #11",
		client = {
			image = "s_inv_cigcard_hrs_11x.png",
		}
	},

	["womenoutfit203"] = {
		label = "زي نسائي 203",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit203.png",
		}
	},

	["womenoutfit688"] = {
		label = "زي نسائي 688",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit688.png",
		}
	},

	["womenoutfit487"] = {
		label = "زي نسائي 487",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit487.png",
		}
	},

	["bottlemarket"] = {
		label = "بقايا الزجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "بقايا الزجاج",
		client = {
			image = "bottlemarket.png",
		}
	},

	["indian_tobacco"] = {
		label = "تبغ هندي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "indian_tobacco.png",
		}
	},

	["consumable_cookie_christmas"] = {
		label = "كوكيز عيد الميلاد",
		weight = 250,
		stack = true,
		close = true,
		description = "كوكيز عيد الميلاد",
		client = {
			image = "consumable_cookie_christmas.png",
		}
	},

	["s_inv_cigcard_act_02x"] = {
		label = "بطاقة السجائر 02",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 02",
		client = {
			image = "s_inv_cigcard_act_02x.png",
		}
	},

	["seed_cannabis"] = {
		label = "بذور حشيش",
		weight = 100000,
		stack = false,
		close = true,
		description = "بذرة تزرع للحصول على النبتة",
		client = {
			image = "seed_cannabis.png",
		}
	},

	["provision_fox_fur"] = {
		label = "فراء ثعلب",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ثعلب فاخر.",
		client = {
			image = "provision_fox_fur.png",
		}
	},

	["nativeoutfit"] = {
		label = "زي تقليدي",
		weight = 250,
		stack = false,
		close = true,
		description = "زي تقليدي.",
		client = {
			image = "nativeoutfit.png",
		}
	},

	["resource_skin_bear_grizzly_star_3"] = {
		label = "جلد الدب الأشيب 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_grizzly_star_3.png",
		}
	},

	["womenoutfit612"] = {
		label = "زي نسائي 612",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit612.png",
		}
	},

	["indian_pipe_2"] = {
		label = "غليون هندي 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "indian_pipe_2.png",
		}
	},

	["carrot"] = {
		label = "جزر",
		weight = 250,
		stack = true,
		close = true,
		description = "جزر",
		client = {
			image = "carrot.png",
		}
	},

	["womenoutfit466"] = {
		label = "زي نسائي 466",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit466.png",
		}
	},

	["s_inv_cigcard_amer_11x"] = {
		label = "بطاقة السجائر أمريكي 11",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #11",
		client = {
			image = "s_inv_cigcard_amer_11x.png",
		}
	},

	["consumable_tonic"] = {
		label = "منشط",
		weight = 250,
		stack = true,
		close = true,
		description = "منشط",
		client = {
			image = "consumable_tonic.png",
		}
	},

	["kcondorb"] = {
		label = "منقار الكندور",
		weight = 250,
		stack = true,
		close = true,
		description = "منقار الكندور",
		client = {
			image = "kcondorb.png",
		}
	},

	["medium_blackbear_pelt"] = {
		label = "فرو دب أسود متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب أسود بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_blackbear_pelt.png",
		}
	},

	["provision_coin_1700_new_yorke_token"] = {
		label = "1700 New York Token",
		weight = 250,
		stack = true,
		close = true,
		description = "A coin token from New York, dated 1700.",
		client = {
			image = "provision_coin_1700_new_yorke_token.png",
		}
	},

	["birdalert"] = {
		label = "تنبيه الطيور",
		weight = 250,
		stack = true,
		close = true,
		description = "يجب على اللاعب أن يحمل هذا معه لتنبيه الطبيب عند إصابته!",
		client = {
			image = "birdalert.png",
		}
	},

	["provision_buffalo_fur"] = {
		label = "فراء الجاموس",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء كثيف مأخوذ من جاموس.",
		client = {
			image = "provision_buffalo_fur.png",
		}
	},

	["WomenOutfit090"] = {
		label = "زي نسائي 090",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit090.png",
		}
	},

	["horsepoop"] = {
		label = "براز الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "براز الحصان",
		client = {
			image = "horsepoop.png",
		}
	},

	["provision_belt_buckle_gold"] = {
		label = "إبزيم حزام ذهبي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشبك ذهبي",
		client = {
			image = "provision_belt_buckle_gold.png",
		}
	},

	["steel_bar"] = {
		label = "سبيكة فولاذي",
		weight = 250,
		stack = true,
		close = true,
		description = "سبيكة فولاذي",
		client = {
			image = "steel_bar.png",
		}
	},

	["marijuana_joint1_2"] = {
		label = "لفافة ماريجوانا 1-2",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-2",
		client = {
			image = "marijuana_joint1_2.png",
		}
	},

	["womenoutfit150"] = {
		label = "زي نسائي 150",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit150.png",
		}
	},

	["gloves"] = {
		label = "قفازات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "gloves.png",
		}
	},

	["consumable_milkshake_chocolate_mint"] = {
		label = "ميلك شيك شوكولاتة نعناع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_milkshake_chocolate_mint.png",
		}
	},

	["poor_wolf_meat"] = {
		label = "لحم ذئب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_wolf_meat.png",
		}
	},

	["anejocigar"] = {
		label = "سيجار أنيخو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "anejocigar.png",
		}
	},

	["shper_rich"] = {
		label = "شبر فاخر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shper_rich.png",
		}
	},

	["provision_jewelry_drop_earring"] = {
		label = "قرط متدلي",
		weight = 250,
		stack = true,
		close = true,
		description = "قرط جميل بتصميم متدلي.",
		client = {
			image = "provision_jewelry_drop_earring.png",
		}
	},

	["poor_redfox_meat"] = {
		label = "لحم ثعلب أحمر رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثعلب أحمر بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_redfox_meat.png",
		}
	},

	["WomenHats162"] = {
		label = "قبعة نسائية 162",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats162.png",
		}
	},

	["womenoutfit541"] = {
		label = "زي نسائي 541",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit541.png",
		}
	},

	["menoutfit42"] = {
		label = "ملابس الرجال 42",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit42.png",
		}
	},

	["consumable_poison_tonic"] = {
		label = "سم الثعبان",
		weight = 250,
		stack = true,
		close = true,
		description = "سم الثعبان",
		client = {
			image = "consumable_poison_tonic.png",
		}
	},

	["pipe_3"] = {
		label = "غليون الأفيون",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pipe_3.png",
		}
	},

	["womenoutfit671"] = {
		label = "زي نسائي 671",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit671.png",
		}
	},

	["s_inv_cigcard_aml_01x"] = {
		label = "بطاقة السجائر أمل 01",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #01",
		client = {
			image = "s_inv_cigcard_aml_01x.png",
		}
	},

	["COUGAR_VAR_002"] = {
		label = "كوجر أسطوري رمادي",
		weight = 250,
		stack = false,
		close = true,
		description = "جلد كوجر أسطوري رمادي اللون.",
		client = {
			image = "COUGAR_VAR_002.png",
		}
	},

	["saber02"] = {
		label = "سابر 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "saber02.png",
		}
	},

	["medium_blackbear_meat"] = {
		label = "لحم دب أسود متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب أسود بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_blackbear_meat.png",
		}
	},

	["r_locker5"] = {
		label = "خزنة رقم 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "r_locker5.png",
		}
	},

	["adrenaline"] = {
		label = "أدرينalin",
		weight = 250,
		stack = true,
		close = true,
		description = "أدرينalin",
		client = {
			image = "adrenaline.png",
		}
	},

	["coats_closed"] = {
		label = "معاطف مغلقة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "coats_closed.png",
		}
	},

	["womenoutfit407"] = {
		label = "زي نسائي 407",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit407.png",
		}
	},

	["joint"] = {
		label = "سيجارة ملفوفة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "joint.png",
		}
	},

	["womenoutfit149"] = {
		label = "زي نسائي 149",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit149.png",
		}
	},

	["menoutfit67"] = {
		label = "ملابس الرجال 67",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit67.png",
		}
	},

	["marijuana_joint1_1"] = {
		label = "لفافة ماريجوانا 1-1",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 1-1",
		client = {
			image = "marijuana_joint1_1.png",
		}
	},

	["Cannabis_Seed"] = {
		label = "بذور القنب",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات نبات القنب.",
		client = {
			image = "Cannabis_Seed.png",
		}
	},

	["OutfitMen084"] = {
		label = "بدلة رجالية 084",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen084.png",
		}
	},

	["s_inv_cigcard_spt_03x"] = {
		label = "بطاقة السجائر أبطال العالم 03",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #03",
		client = {
			image = "s_inv_cigcard_spt_03x.png",
		}
	},

	["s_inv_cigcard_lnd_12x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 12",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #12",
		client = {
			image = "s_inv_cigcard_lnd_12x.png",
		}
	},

	["seed_watermelon"] = {
		label = "بذور البطيخ",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور البطيخ",
		client = {
			image = "seed_watermelon.png",
		}
	},

	["gauntlets"] = {
		label = "قفازات درع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "gauntlets.png",
		}
	},

	["resource_pelt_beaver_star_3"] = {
		label = "جلد القندس 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_beaver_star_3.png",
		}
	},

	["consumable_meat_succulent_fish_cooked"] = {
		label = "سمك طري مطبوخ",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك طري مطبوخ بشكل مثالي.",
		client = {
			image = "consumable_meat_succulent_fish_cooked.png",
		}
	},

	["Chamomile_Seed"] = {
		label = "بذور البابونج",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنبات نبات البابونج",
		client = {
			image = "Chamomile_Seed.png",
		}
	},

	["legfoxs1"] = {
		label = "جلد الثعلب أوتا",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "legfoxs1.png",
		}
	},

	["consumable_candy_bag"] = {
		label = "كيس حلوى",
		weight = 250,
		stack = true,
		close = true,
		description = "كيس مليء بالحلوى اللذيذة.",
		client = {
			image = "consumable_candy_bag.png",
		}
	},

	["OutfitMen085"] = {
		label = "بدلة رجالية 085",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen085.png",
		}
	},

	["womenoutfit498"] = {
		label = "زي نسائي 498",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit498.png",
		}
	},

	["mapa_02"] = {
		label = "الخريطة المفقودة 2   ",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 2   ",
		client = {
			image = "mapa_02.png",
		}
	},

	["consumable_chef_bacon_sandwich"] = {
		label = "ساندويتش لحم مقدد من الطباخ",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_chef_bacon_sandwich.png",
		}
	},

	["poor_bull_meat"] = {
		label = "لحم ثور رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ثور بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_bull_meat.png",
		}
	},

	["al-najed"] = {
		label = "اعلان  القبيلة",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "al-najed.png",
		}
	},

	["horseblanket"] = {
		label = "بطانية سرج",
		weight = 250,
		stack = true,
		close = true,
		description = "بطانية للسرج",
		client = {
			image = "horseblanket.png",
		}
	},

	["ammomoonshinejug"] = {
		label = "ذخيرة جرة المونشاين",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ammomoonshinejug.png",
		}
	},

	["chicken_breast"] = {
		label = "صدر دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "صدر دجاج مقطع",
		client = {
			image = "chicken_breast.png",
		}
	},

	["perfect_wolf_meat"] = {
		label = "لحم ذئب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_wolf_meat.png",
		}
	},

	["perfect_moose_meat"] = {
		label = "لحم موظ ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم موظ بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_moose_meat.png",
		}
	},

	["resource_skin_buck_star_1"] = {
		label = "فراء الغزال 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buck_star_1.png",
		}
	},

	["OutfitMen146"] = {
		label = "بدلة رجالية 146",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen146.png",
		}
	},

	["s_inv_cigcard_gun_07x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 07",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #07",
		client = {
			image = "s_inv_cigcard_gun_07x.png",
		}
	},

	["poor_sheep_meat"] = {
		label = "لحم شاة رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم شاة بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_sheep_meat.png",
		}
	},

	["OutfitMen149"] = {
		label = "بدلة رجالية 149",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen149.png",
		}
	},

	["WomenHats154"] = {
		label = "قبعة نسائية 154",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats154.png",
		}
	},

	["womenoutfit856"] = {
		label = "زي نسائي 856",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit856.png",
		}
	},

	["hat8"] = {
		label = "قبعة 8",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat8.png",
		}
	},

	["skillet"] = {
		label = "مقلاة",
		weight = 250,
		stack = true,
		close = true,
		description = "مقلاة",
		client = {
			image = "skillet.png",
		}
	},

	["MenOutfits01"] = {
		label = "زي رجالي 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits01.png",
		}
	},

	["womenoutfit360"] = {
		label = "زي نسائي 360",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit360.png",
		}
	},

	["pants"] = {
		label = "بنطلون",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pants.png",
		}
	},

	["OutfitMen187"] = {
		label = "بدلة رجالية 187",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen187.png",
		}
	},

	["poor_cow_meat"] = {
		label = "لحم بقرة رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بقرة بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_cow_meat.png",
		}
	},

	["consumable_whiskey"] = {
		label = "ويسكي",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب ويسكي.",
		client = {
			image = "consumable_whiskey.png",
		}
	},

	["OutfitMen183"] = {
		label = "بدلة رجالية 183",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen183.png",
		}
	},

	["smeltedgold"] = {
		label = "الذهب المصهور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "smeltedgold.png",
		}
	},

	["law_np"] = {
		label = "قانون NP",
		weight = 250,
		stack = true,
		close = true,
		description = "قانون NP",
		client = {
			image = "law_np.png",
		}
	},

	["omertapower"] = {
		label = "قوة أومerta",
		weight = 250,
		stack = true,
		close = true,
		description = "قوة أومerta",
		client = {
			image = "omertapower.png",
		}
	},

	["consumable_mash_blackberry"] = {
		label = "هريس التوت الأسود",
		weight = 250,
		stack = true,
		close = true,
		description = "هريس التوت الأسود",
		client = {
			image = "consumable_mash_blackberry.png",
		}
	},

	["MenOutfits020"] = {
		label = "زي رجالي 020",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits020.png",
		}
	},

	["egg_duck"] = {
		label = "بيضة بطة",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة بطة.",
		client = {
			image = "egg_duck.png",
		}
	},

	["s_inv_cigcard_plt_05x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #05",
		client = {
			image = "s_inv_cigcard_plt_05x.png",
		}
	},

	["OutfitMen162"] = {
		label = "بدلة رجالية 162",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen162.png",
		}
	},

	["s_inv_cigcard_veh_03x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 03",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #03",
		client = {
			image = "s_inv_cigcard_veh_03x.png",
		}
	},

	["OutfitMen160"] = {
		label = "بدلة رجالية 160",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen160.png",
		}
	},

	["legendary_bhr_antlers"] = {
		label = "قرون كبش أسطورية",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون كبش أسطورية، يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "legendary_bhr_antlers.png",
		}
	},

	["MenOutfits17"] = {
		label = "زي رجالي 17",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits17.png",
		}
	},

	["provision_legendary_fox_fur"] = {
		label = "فراء ثعلب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم وثمين من ثعلب أسطوري.",
		client = {
			image = "provision_legendary_fox_fur.png",
		}
	},

	["horsetorch"] = {
		label = "شعلة الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "شعلة على الحصان",
		client = {
			image = "horsetorch.png",
		}
	},

	["poor_oxen_pelt"] = {
		label = "فرو ثور رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_oxen_pelt.png",
		}
	},

	["OutfitMen159"] = {
		label = "بدلة رجالية 159",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen159.png",
		}
	},

	["OutfitMen153"] = {
		label = "بدلة رجالية 153",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen153.png",
		}
	},

	["wethemp_bb"] = {
		label = "Wet Bayou Bliss",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the muckiness of the bayou!",
		client = {
			image = "wethemp_bb.png",
		}
	},

	["consumable_frog_legs"] = {
		label = "أرجل الضفادع",
		weight = 250,
		stack = true,
		close = true,
		description = "أرجل الضفادع",
		client = {
			image = "consumable_frog_legs.png",
		}
	},

	["buffalo_horn"] = {
		label = "قرن جاموس",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن جاموس يمكن استخدامه في التصنيع أو الزينة.",
		client = {
			image = "buffalo_horn.png",
		}
	},

	["MenOutfits36"] = {
		label = "زي رجالي 36",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits36.png",
		}
	},

	["WomenHats094"] = {
		label = "قبعة نسائية 094",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats094.png",
		}
	},

	["COYOTE_VAR_001"] = {
		label = "ذئب براري أسطوري ذهبي",
		weight = 250,
		stack = false,
		close = true,
		description = "ذئب براري أسطوري بلون ذهبي.",
		client = {
			image = "COYOTE_VAR_001.png",
		}
	},

	["marijuana_joint3"] = {
		label = "لفافة ماريجوانا 3",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3",
		client = {
			image = "marijuana_joint3.png",
		}
	},

	["MenOutfits32"] = {
		label = "زي رجالي 32",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits32.png",
		}
	},

	["provision_legendary_panther_heart"] = {
		label = "قلب الفهد الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب قوي من فهد أسطوري.",
		client = {
			image = "provision_legendary_panther_heart.png",
		}
	},

	["resource_skin_buck_star_2"] = {
		label = "فراء الغزال 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buck_star_2.png",
		}
	},

	["OutfitMen134"] = {
		label = "بدلة رجالية 134",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen134.png",
		}
	},

	["consumable_soup_duck"] = {
		label = "شوربة البط",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_soup_duck.png",
		}
	},

	["medium_sheep_meat"] = {
		label = "لحم شاة متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم شاة بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_sheep_meat.png",
		}
	},

	["s_inv_cigcard_act_10x"] = {
		label = "بطاقة السجائر 10",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 10",
		client = {
			image = "s_inv_cigcard_act_10x.png",
		}
	},

	["provision_cow_hide"] = {
		label = "جلد بقرة",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد بقرة قوي ومتين.",
		client = {
			image = "provision_cow_hide.png",
		}
	},

	["mulberry"] = {
		label = "توت",
		weight = 250,
		stack = true,
		close = true,
		description = "توت",
		client = {
			image = "mulberry.png",
		}
	},

	["OutfitMen090"] = {
		label = "بدلة رجالية 090",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen090.png",
		}
	},

	["madurocigar"] = {
		label = "سيجار مادورو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "madurocigar.png",
		}
	},

	["poor_bighornram_pelt"] = {
		label = "فرو كبش رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو كبش بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_bighornram_pelt.png",
		}
	},

	["medium_badger_pelt"] = {
		label = "فرو غرير متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غرير بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_badger_pelt.png",
		}
	},

	["OutfitMen036"] = {
		label = "بدلة رجالية 036",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen036.png",
		}
	},

	["consumable_moonshine_raspberry"] = {
		label = "توت العليق القمري",
		weight = 250,
		stack = true,
		close = true,
		description = "توت العليق القمري",
		client = {
			image = "consumable_moonshine_raspberry.png",
		}
	},

	["menoutfit2"] = {
		label = "ملابس الرجال 2",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit2.png",
		}
	},

	["coalchicha"] = {
		label = "فحم الشيشة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "coalchicha.png",
		}
	},

	["resource_skin_alligator_star_1"] = {
		label = "جلد التمساح 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_alligator_star_1.png",
		}
	},

	["MenOutfits036"] = {
		label = "زي رجالي 036",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits036.png",
		}
	},

	["provision_muskrat_scentgland"] = {
		label = "غدة رائحة الجرذ المسكي",
		weight = 250,
		stack = true,
		close = true,
		description = "غدة تحتوي على رائحة مميزة.",
		client = {
			image = "provision_muskrat_scentgland.png",
		}
	},

	["OutfitMen109"] = {
		label = "بدلة رجالية 109",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen109.png",
		}
	},

	["OutfitMen086"] = {
		label = "بدلة رجالية 086",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen086.png",
		}
	},

	["provision_trinket_bear_heart"] = {
		label = "تعويذة قلب الدب",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب دب يستخدم كتعويذة.",
		client = {
			image = "provision_trinket_bear_heart.png",
		}
	},

	["OutfitMen110"] = {
		label = "بدلة رجالية 110",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen110.png",
		}
	},

	["WomenGloves002"] = {
		label = "قفازات نسائية 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves002.png",
		}
	},

	["s_inv_cigcard_act_06x"] = {
		label = "بطاقة السجائر 06",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 06",
		client = {
			image = "s_inv_cigcard_act_06x.png",
		}
	},

	["OutfitMen105"] = {
		label = "بدلة رجالية 105",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen105.png",
		}
	},

	["womenoutfit110"] = {
		label = "زي نسائي 110",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit110.png",
		}
	},

	["male_outfitminer"] = {
		label = "ملابس المناجم ذكر",
		weight = 250,
		stack = false,
		close = true,
		description = "ملابس المناجم",
		client = {
			image = "male_outfitminer.png",
		}
	},

	["resource_pelt_coyote_star_1"] = {
		label = "فراء ذئب البراري 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_coyote_star_1.png",
		}
	},

	["womenoutfit348"] = {
		label = "زي نسائي 348",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit348.png",
		}
	},

	["mapa_01"] = {
		label = "الخريطة المفقودة 1  ",
		weight = 250,
		stack = true,
		close = true,
		description = "الخريطة المفقودة 1  ",
		client = {
			image = "mapa_01.png",
		}
	},

	["apiary_bee_gk"] = {
		label = "نحل المنحل",
		weight = 250,
		stack = true,
		close = true,
		description = "نحل المنحل",
		client = {
			image = "apiary_bee_gk.png",
		}
	},

	["menoutfit89"] = {
		label = "ملابس الرجال 89",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit89.png",
		}
	},

	["OutfitMen150"] = {
		label = "بدلة رجالية 150",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen150.png",
		}
	},

	["OutfitMen043"] = {
		label = "بدلة رجالية 043",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen043.png",
		}
	},

	["poor_elk_pelt"] = {
		label = "فرو وعل رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو وعل بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_elk_pelt.png",
		}
	},

	["medium_bighorn_meat"] = {
		label = "لحم كبش متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم كبش بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_bighorn_meat.png",
		}
	},

	["OutfitMen041"] = {
		label = "بدلة رجالية 041",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen041.png",
		}
	},

	["menoutfit48"] = {
		label = "ملابس الرجال 48",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit48.png",
		}
	},

	["door1"] = {
		label = "مفتاح الباب 1",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door1.png",
		}
	},

	["OutfitMen033"] = {
		label = "بدلة رجالية 033",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen033.png",
		}
	},

	["Repair_Kit"] = {
		label = "عدة إصلاح",
		weight = 250,
		stack = true,
		close = true,
		description = "يستخدم لإصلاح العربة",
		client = {
			image = "Repair_Kit.png",
		}
	},

	["OutfitMen007"] = {
		label = "بدلة رجالية 007",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen007.png",
		}
	},

	["menoutfit51"] = {
		label = "ملابس الرجال 51",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit51.png",
		}
	},

	["seagull_feathers"] = {
		label = "ريش نورس",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش نورس يُستخدم في أعمال التصنيع.",
		client = {
			image = "seagull_feathers.png",
		}
	},

	["womenoutfit605"] = {
		label = "زي نسائي 605",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit605.png",
		}
	},

	["OutfitMen171"] = {
		label = "بدلة رجالية 171",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen171.png",
		}
	},

	["moonshine_red"] = {
		label = "ضوء القمر الأحمر",
		weight = 250,
		stack = true,
		close = true,
		description = "ضوء القمر الأحمر",
		client = {
			image = "moonshine_red.png",
		}
	},

	["WomenOutfit031"] = {
		label = "زي نسائي 031",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit031.png",
		}
	},

	["s_inv_cigcard_veh_02x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 02",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #02",
		client = {
			image = "s_inv_cigcard_veh_02x.png",
		}
	},

	["poor_cougar_meat"] = {
		label = "لحم أسد الجبل رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم أسد الجبل بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_cougar_meat.png",
		}
	},

	["menoutfit23"] = {
		label = "ملابس الرجال 23",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit23.png",
		}
	},

	["consumable_honeycomb_candy"] = {
		label = "حلوى العسل",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_honeycomb_candy.png",
		}
	},

	["consumable_horse_ointment"] = {
		label = "مرهم الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "مرهم لعلاج جروح الحصان",
		client = {
			image = "consumable_horse_ointment.png",
		}
	},

	["perfect_buck_meat"] = {
		label = "لحم غزال ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_buck_meat.png",
		}
	},

	["menoutfit94"] = {
		label = "ملابس الرجال 94",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit94.png",
		}
	},

	["building_plan_4"] = {
		label = "ورقة بناء بيت 4",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_4.png",
		}
	},

	["consumable_moonshine_alaskan"] = {
		label = "لغو ألاسكا",
		weight = 250,
		stack = true,
		close = true,
		description = "لغو ألاسكا",
		client = {
			image = "consumable_moonshine_alaskan.png",
		}
	},

	["s_inv_cigcard_inv_07x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 07",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #07",
		client = {
			image = "s_inv_cigcard_inv_07x.png",
		}
	},

	["womenoutfit291"] = {
		label = "زي نسائي 291",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit291.png",
		}
	},

	["emypy_mud_bucket"] = {
		label = "دلو طين فارغ",
		weight = 250,
		stack = true,
		close = true,
		description = "دلو طين فارغ",
		client = {
			image = "emypy_mud_bucket.png",
		}
	},

	["vulture_feathers"] = {
		label = "ريش نسر قمام",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش نسر قمام يُستخدم في أعمال التصنيع.",
		client = {
			image = "vulture_feathers.png",
		}
	},

	["egg_loon"] = {
		label = "بيضة لون",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة لون.",
		client = {
			image = "egg_loon.png",
		}
	},

	["marijuana_joint3_6"] = {
		label = "لفافة ماريجوانا 3-6",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-6",
		client = {
			image = "marijuana_joint3_6.png",
		}
	},

	["consumable_mash_american"] = {
		label = "هريس أمريكي",
		weight = 250,
		stack = true,
		close = true,
		description = "هريس أمريكي",
		client = {
			image = "consumable_mash_american.png",
		}
	},

	["club02"] = {
		label = "عصا 02",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "club02.png",
		}
	},

	["boot_accessories"] = {
		label = "إكسسوارات الأحذية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "boot_accessories.png",
		}
	},

	["provision_legendary_trinket_ram_horn"] = {
		label = "قرن الكبش الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن الكبش الأسطوري",
		client = {
			image = "provision_legendary_trinket_ram_horn.png",
		}
	},

	["consumable_pie_banana_cream"] = {
		label = "فطيرة كريمة الموز",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_pie_banana_cream.png",
		}
	},

	["consumable_herbal_medicine"] = {
		label = "دواء عشبي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_herbal_medicine.png",
		}
	},

	["goodbyliquor"] = {
		label = "وداعا للخمور",
		weight = 250,
		stack = true,
		close = true,
		description = "وداعا للخمور",
		client = {
			image = "goodbyliquor.png",
		}
	},

	["consumable_bread4"] = {
		label = "خبز 4",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_bread4.png",
		}
	},

	["poor_raccoon_pelt"] = {
		label = "فرو راكون رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو راكون بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_raccoon_pelt.png",
		}
	},

	["hat2"] = {
		label = "قبعة 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat2.png",
		}
	},

	["a_c_fishlargemouthbass_01_lg"] = {
		label = "سمك باس الفم الكبير",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك باس الفم الكبير",
		client = {
			image = "a_c_fishlargemouthbass_01_lg.png",
		}
	},

	["menoutfit9"] = {
		label = "ملابس الرجال 9",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit9.png",
		}
	},

	["resource_pelt_rabbit_star_3"] = {
		label = "جلد الأرنب 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_rabbit_star_3.png",
		}
	},

	["baking_muffin_pan"] = {
		label = "صينية خبز الكعك",
		weight = 250,
		stack = true,
		close = true,
		description = "صينية خبز الكعك",
		client = {
			image = "baking_muffin_pan.png",
		}
	},

	["OutfitMen045"] = {
		label = "بدلة رجالية 045",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen045.png",
		}
	},

	["provision_trinket_gilamonster_tooth"] = {
		label = "تعويذة سن وحش جيلا",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من سن وحش جيلا.",
		client = {
			image = "provision_trinket_gilamonster_tooth.png",
		}
	},

	["OutfitMen048"] = {
		label = "بدلة رجالية 048",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen048.png",
		}
	},

	["OutfitMen058"] = {
		label = "بدلة رجالية 058",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen058.png",
		}
	},

	["womenoutfit849"] = {
		label = "زي نسائي 849",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit849.png",
		}
	},

	["moonshine_interior5"] = {
		label = "Moonshine Interior 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_interior5.png",
		}
	},

	["OutfitMen057"] = {
		label = "بدلة رجالية 057",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen057.png",
		}
	},

	["resource_skin_javelina_boar_star_1"] = {
		label = "فرو بيكاري 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_javelina_boar_star_1.png",
		}
	},

	["machete_outlaw_004"] = {
		label = "machete outlaw 004",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "machete_outlaw_004.png",
		}
	},

	["OutfitMen076"] = {
		label = "بدلة رجالية 076",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen076.png",
		}
	},

	["womenoutfit432"] = {
		label = "زي نسائي 432",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit432.png",
		}
	},

	["menoutfit13"] = {
		label = "ملابس الرجال 13",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit13.png",
		}
	},

	["menoutfit55"] = {
		label = "ملابس الرجال 55",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit55.png",
		}
	},

	["OutfitMen107"] = {
		label = "بدلة رجالية 107",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen107.png",
		}
	},

	["loon_feathers"] = {
		label = "ريش غواص",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش غواص يُستخدم في أعمال التصنيع.",
		client = {
			image = "loon_feathers.png",
		}
	},

	["MenOutfits05"] = {
		label = "زي رجالي 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits05.png",
		}
	},

	["indigo"] = {
		label = "تبغ إنديغو",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "indigo.png",
		}
	},

	["womenoutfit436"] = {
		label = "زي نسائي 436",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit436.png",
		}
	},

	["OutfitMen112"] = {
		label = "بدلة رجالية 112",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen112.png",
		}
	},

	["OutfitMen113"] = {
		label = "بدلة رجالية 113",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen113.png",
		}
	},

	["cigaretteholder"] = {
		label = "حامل سيجارة",
		weight = 250,
		stack = true,
		close = true,
		description = "حامل سيجارة",
		client = {
			image = "cigaretteholder.png",
		}
	},

	["OutfitMen124"] = {
		label = "بدلة رجالية 124",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen124.png",
		}
	},

	["OutfitMen129"] = {
		label = "بدلة رجالية 129",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen129.png",
		}
	},

	["OutfitMen130"] = {
		label = "بدلة رجالية 130",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen130.png",
		}
	},

	["coffeesugar"] = {
		label = "سكر القهوة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "coffeesugar.png",
		}
	},

	["OutfitMen133"] = {
		label = "بدلة رجالية 133",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen133.png",
		}
	},

	["menoutfit62"] = {
		label = "ملابس الرجال 62",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit62.png",
		}
	},

	["womenoutfit565"] = {
		label = "زي نسائي 565",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit565.png",
		}
	},

	["qgh_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "qgh_news.png",
		}
	},

	["OutfitMen151"] = {
		label = "بدلة رجالية 151",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen151.png",
		}
	},

	["cuthemp_ll"] = {
		label = "Trimmed Lagras Lullaby",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the tranquil Lagras Swamps!",
		client = {
			image = "cuthemp_ll.png",
		}
	},

	["consumable_meat_snake_cooked"] = {
		label = "لحم أفعى مشوي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_meat_snake_cooked.png",
		}
	},

	["ugh_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "ugh_news.png",
		}
	},

	["marijuana_joint3_5"] = {
		label = "لفافة ماريجوانا 3-5",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-5",
		client = {
			image = "marijuana_joint3_5.png",
		}
	},

	["a_c_fishsmallmouthbass_01_lg"] = {
		label = "سمك باس صغير الفم",
		weight = 250,
		stack = true,
		close = true,
		description = "سمك باس صغير الفم",
		client = {
			image = "a_c_fishsmallmouthbass_01_lg.png",
		}
	},

	["petbox"] = {
		label = "Pet Box",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "petbox.png",
		}
	},

	["pack_cigarette_empty"] = {
		label = "علبة سجائر فارغة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "pack_cigarette_empty.png",
		}
	},

	["WomenHats193"] = {
		label = "قبعة نسائية 193",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats193.png",
		}
	},

	["shovel"] = {
		label = "مجرفة المنقب",
		weight = 250,
		stack = true,
		close = true,
		description = "مجرفة تُستخدم في التنقيب وجمع الكنوز",
		client = {
			image = "shovel.png",
		}
	},

	["menoutfit32"] = {
		label = "ملابس الرجال 32",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit32.png",
		}
	},

	["resource_skin_snake_blacktail_rattlesnake_star_3"] = {
		label = "جلد أفعى ذات الذيل الأسود 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_snake_blacktail_rattlesnake_star_3.png",
		}
	},

	["s_inv_cigcard_gun_11x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 11",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #11",
		client = {
			image = "s_inv_cigcard_gun_11x.png",
		}
	},

	["s_inv_cigcard_gun_08x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 08",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #08",
		client = {
			image = "s_inv_cigcard_gun_08x.png",
		}
	},

	["perfect_buck_pelt"] = {
		label = "فرو غزال ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غزال بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_buck_pelt.png",
		}
	},

	["OutfitMen189"] = {
		label = "بدلة رجالية 189",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen189.png",
		}
	},

	["WomenHats020"] = {
		label = "قبعة نسائية 020",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats020.png",
		}
	},

	["provision_legendary_alligator_tooth"] = {
		label = "سن التمساح الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "سن التمساح الأسطوري",
		client = {
			image = "provision_legendary_alligator_tooth.png",
		}
	},

	["paintcan"] = {
		label = "علبة طلاء",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "paintcan.png",
		}
	},

	["provision_coin_1795_half_eagle"] = {
		label = "1795 Half Eagle",
		weight = 250,
		stack = true,
		close = true,
		description = "A half eagle gold coin from 1795.",
		client = {
			image = "provision_coin_1795_half_eagle.png",
		}
	},

	["legendary_bear_pelt"] = {
		label = "فرو دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_bear_pelt.png",
		}
	},

	["liquor"] = {
		label = "خمور",
		weight = 250,
		stack = true,
		close = true,
		description = "خمور",
		client = {
			image = "liquor.png",
		}
	},

	["horsebuff"] = {
		label = "تعزيز الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "تعزيز الحصان",
		client = {
			image = "horsebuff.png",
		}
	},

	["ce_opal"] = {
		label = "حجر العقيق",
		weight = 250,
		stack = true,
		close = true,
		description = "حجر العقيق",
		client = {
			image = "ce_opal.png",
		}
	},

	["collector_card"] = {
		label = "بطاقة جامع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "collector_card.png",
		}
	},

	["perfect_coyote_meat"] = {
		label = "لحم ذئب ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_coyote_meat.png",
		}
	},

	["medium_pronghorn_pelt"] = {
		label = "فرو ظبي متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظبي بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_pronghorn_pelt.png",
		}
	},

	["menoutfit36"] = {
		label = "ملابس الرجال 36",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit36.png",
		}
	},

	["medium_cougar_pelt"] = {
		label = "فرو أسد الجبل متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو أسد الجبل بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_cougar_pelt.png",
		}
	},

	["tabbaco_chicha_love"] = {
		label = "تبغ شيشة الحب",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "tabbaco_chicha_love.png",
		}
	},


	["OutfitMen168"] = {
		label = "بدلة رجالية 168",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen168.png",
		}
	},

	["provision_hawk_feather"] = {
		label = "ريشة صقر",
		weight = 250,
		stack = true,
		close = true,
		description = "ريشة حادة وقوية مأخوذة من صقر.",
		client = {
			image = "provision_hawk_feather.png",
		}
	},

	["animal_crab"] = {
		label = "سلطعون",
		weight = 250,
		stack = true,
		close = true,
		description = "سلطعون.",
		client = {
			image = "animal_crab.png",
		}
	},

	["legendary_moose_pelt"] = {
		label = "فرو موظ أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو موظ أسطوري نادر وثمين للغاية لأعمال التصنيع والتجارة.",
		client = {
			image = "legendary_moose_pelt.png",
		}
	},

	["perfect_peccary_meat"] = {
		label = "لحم بيكاري ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بيكاري بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_peccary_meat.png",
		}
	},

	["falltree"] = {
		label = "شجرة مقطوعة",
		weight = 250,
		stack = false,
		close = true,
		description = "يمكن استخدام الشجرة في مهنة الحطاب.",
		client = {
			image = "falltree.png",
		}
	},

	["OutfitMen184"] = {
		label = "بدلة رجالية 184",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen184.png",
		}
	},

	["womenoutfit725"] = {
		label = "زي نسائي 725",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit725.png",
		}
	},

	["poor_badger_pelt"] = {
		label = "فرو غرير رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو غرير بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_badger_pelt.png",
		}
	},

	["consumable_smores"] = {
		label = "سيمور",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_smores.png",
		}
	},

	["poor_boar_pelt"] = {
		label = "فرو خنزير بري رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو خنزير بري بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_boar_pelt.png",
		}
	},

	["MenOutfits010"] = {
		label = "زي رجالي 010",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits010.png",
		}
	},

	["resource_skin_buffalo_star_2"] = {
		label = "جلد البيسون 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buffalo_star_2.png",
		}
	},

	["poor_blackbear_pelt"] = {
		label = "فرو دب أسود رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب أسود بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_blackbear_pelt.png",
		}
	},

	["poor_bull_pelt"] = {
		label = "فرو ثور رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ثور بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_bull_pelt.png",
		}
	},

	["OutfitMen072"] = {
		label = "بدلة رجالية 072",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen072.png",
		}
	},

	["wethemp_sb"] = {
		label = "Wet Sandy Breeze",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp gathered from the sandy and breezy coastal areas!",
		client = {
			image = "wethemp_sb.png",
		}
	},

	["consumable_baked_beans_can"] = {
		label = "علبة فاصولياء مطبوخة",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة فاصولياء مطبوخة جاهزة للأكل.",
		client = {
			image = "consumable_baked_beans_can.png",
		}
	},

	["perfect_moose_pelt"] = {
		label = "فرو موظ ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو موظ بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_moose_pelt.png",
		}
	},

	["poor_coyote_meat"] = {
		label = "لحم ذئب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_coyote_meat.png",
		}
	},

	["r_locker1"] = {
		label = "الخزانة 1",
		weight = 250,
		stack = true,
		close = true,
		description = "الخزانة 1",
		client = {
			image = "r_locker1.png",
		}
	},

	["WomenOutfits16"] = {
		label = "زي نسائي 16",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits16.png",
		}
	},

	["WomenOutfit048"] = {
		label = "زي نسائي 048",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit048.png",
		}
	},

	["consumable_sweet_corn_can"] = {
		label = "علبة ذرة حلوة",
		weight = 250,
		stack = true,
		close = true,
		description = "علبة تحتوي على الذرة الحلوة.",
		client = {
			image = "consumable_sweet_corn_can.png",
		}
	},

	["consumable_oldtom_gin"] = {
		label = "جين أولد توم",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب جين أولد توم.",
		client = {
			image = "consumable_oldtom_gin.png",
		}
	},

	["consumable_mash_soborno"] = {
		label = "هريس سوبورنو",
		weight = 250,
		stack = true,
		close = true,
		description = "هريس سوبورنو",
		client = {
			image = "consumable_mash_soborno.png",
		}
	},

	["poor_peccary_meat"] = {
		label = "لحم بيكاري رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم بيكاري بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_peccary_meat.png",
		}
	},

	["consumable_steak_veg"] = {
		label = "ستيك مع الخضار",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_steak_veg.png",
		}
	},

	["provision_raven_claw"] = {
		label = "مخلب الغراب",
		weight = 250,
		stack = true,
		close = true,
		description = "مخلب حاد مأخوذ من غراب.",
		client = {
			image = "provision_raven_claw.png",
		}
	},

	["s_inv_cigcard_aml_07x"] = {
		label = "بطاقة السجائر أمل 07",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #07",
		client = {
			image = "s_inv_cigcard_aml_07x.png",
		}
	},

	["WomenBracelets002"] = {
		label = "سوار نسائي 002",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenBracelets002.png",
		}
	},

	["s_inv_cigcard_grl_02x"] = {
		label = "بطاقة السجائر جواهر الجمال 02",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #02",
		client = {
			image = "s_inv_cigcard_grl_02x.png",
		}
	},

	["WomenHats195"] = {
		label = "قبعة نسائية 195",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats195.png",
		}
	},

	["r_locker3"] = {
		label = "الخزانة رقم 3",
		weight = 250,
		stack = true,
		close = true,
		description = "الخزانة رقم 3",
		client = {
			image = "r_locker3.png",
		}
	},

	["medium_goat_meat"] = {
		label = "لحم ماعز متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ماعز بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_goat_meat.png",
		}
	},

	["horseloadout1"] = {
		label = "حمولة حصان 1",
		weight = 250,
		stack = true,
		close = true,
		description = "معدات إضافية للحصان",
		client = {
			image = "horseloadout1.png",
		}
	},

	["consumable_cigarette_box_cheap"] = {
		label = "سجائر رخيصة",
		weight = 250,
		stack = true,
		close = true,
		description = "سجائر للاسترخاء.",
		client = {
			image = "consumable_cigarette_box_cheap.png",
		}
	},

	["WomenGloves005"] = {
		label = "قفازات نسائية 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenGloves005.png",
		}
	},

	["powerpacino"] = {
		label = "فـوريـا ال بـاتشيـنو",
		weight = 250,
		stack = true,
		close = true,
		description = "فـوريـا ال بـاتشيـنو",
		client = {
			image = "powerpacino.png",
		}
	},

	["menoutfit25"] = {
		label = "ملابس الرجال 25",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit25.png",
		}
	},

	["womenoutfit811"] = {
		label = "زي نسائي 811",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit811.png",
		}
	},

	["provision_bear_heart"] = {
		label = "قلب الدب",
		weight = 250,
		stack = true,
		close = true,
		description = "قلب دب ضخم.",
		client = {
			image = "provision_bear_heart.png",
		}
	},

	["bucket"] = {
		label = "دلو ماء",
		weight = 250,
		stack = true,
		close = true,
		description = "دلو ماء يُستخدم كحاوية متعددة الاستخدامات مملوءة بالماء العذب.",
		client = {
			image = "bucket.png",
		}
	},

	["clothe21"] = {
		label = "ملابس 21",
		weight = 250,
		stack = false,
		close = true,
		description = "ملابس 21.",
		client = {
			image = "clothe21.png",
		}
	},

	["resource_skin_bear_black_star_1"] = {
		label = "جلد الدب الأسود 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_black_star_1.png",
		}
	},

	["resource_hammer"] = {
		label = "مطرقة",
		weight = 250,
		stack = true,
		close = true,
		description = "مطرقة",
		client = {
			image = "resource_hammer.png",
		}
	},

	["WomenHats188"] = {
		label = "قبعة نسائية 188",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats188.png",
		}
	},

	["door7"] = {
		label = "مفتاح الباب 7",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "door7.png",
		}
	},

	["provision_alligator_skin"] = {
		label = "جلد التمساح",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد تمساح متين.",
		client = {
			image = "provision_alligator_skin.png",
		}
	},

	["provision_buffalo_horn"] = {
		label = "قرن الجاموس",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن صلب مأخوذ من جاموس.",
		client = {
			image = "provision_buffalo_horn.png",
		}
	},

	["female_outfitminer"] = {
		label = "ملابس  المناجم أنثى",
		weight = 250,
		stack = false,
		close = true,
		description = "ملابس  مناجم",
		client = {
			image = "female_outfitminer.png",
		}
	},

	["poor_moose_pelt"] = {
		label = "فرو موظ رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو موظ بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_moose_pelt.png",
		}
	},

	["panskin1"] = {
		label = "درع باستر ",
		weight = 250,
		stack = false,
		close = true,
		description = "درع باستر سكروجس بان",
		client = {
			image = "panskin1.png",
		}
	},

	["consumable_mash_raspberry"] = {
		label = "هريس التوت",
		weight = 250,
		stack = true,
		close = true,
		description = "هريس التوت",
		client = {
			image = "consumable_mash_raspberry.png",
		}
	},

	["OutfitMen044"] = {
		label = "بدلة رجالية 044",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen044.png",
		}
	},

	["OutfitMen020"] = {
		label = "بدلة رجالية 020",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen020.png",
		}
	},

	["provision_earring_dutchess_emerald"] = {
		label = "قرط دوقة الزمرد",
		weight = 250,
		stack = true,
		close = true,
		description = "قرط الزمرد الهولندي",
		client = {
			image = "provision_earring_dutchess_emerald.png",
		}
	},

	["cuthemp_dc"] = {
		label = "Trimmed Desert Cough",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp sourced from the arid and resilient desert landscapes!",
		client = {
			image = "cuthemp_dc.png",
		}
	},

	["breedpills"] = {
		label = "حبوب التزاوج",
		weight = 250,
		stack = true,
		close = true,
		description = "يستخدم لبدء تزاوج الخيول",
		client = {
			image = "breedpills.png",
		}
	},

	["womenoutfit2"] = {
		label = "زي نسائي 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit2.png",
		}
	},

	["MenOutfits001"] = {
		label = "زي رجالي 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits001.png",
		}
	},

	["womenoutfit508"] = {
		label = "زي نسائي 508",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit508.png",
		}
	},

	["provision_horse_shoes"] = {
		label = "حافرات الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "حافرات عادية للحصان",
		client = {
			image = "provision_horse_shoes.png",
		}
	},

	["perfect_deer_meat"] = {
		label = "لحم غزال ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم غزال بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_deer_meat.png",
		}
	},

	["provision_javelina_skin"] = {
		label = "جلد الجافلينا",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد مأخوذ من الجافلينا.",
		client = {
			image = "provision_javelina_skin.png",
		}
	},

	["provision_legendary_bear_fur"] = {
		label = "فراء دب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء كثيف من دب أسطوري.",
		client = {
			image = "provision_legendary_bear_fur.png",
		}
	},

	["womenoutfit504"] = {
		label = "زي نسائي 504",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit504.png",
		}
	},

	["provision_legendary_beaver_scentgland"] = {
		label = "غدة رائحة قندس أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "غدة رائحة قوية من قندس أسطوري.",
		client = {
			image = "provision_legendary_beaver_scentgland.png",
		}
	},

	["WomenOutfits52"] = {
		label = "زي نسائي 52",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits52.png",
		}
	},

	["menoutfit20"] = {
		label = "ملابس الرجال 20",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit20.png",
		}
	},

	["provision_legendary_buffalo_horn"] = {
		label = "قرن الجاموس الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قرن قوي مأخوذ من جاموس أسطوري.",
		client = {
			image = "provision_legendary_buffalo_horn.png",
		}
	},

	["poor_goat_pelt"] = {
		label = "فرو ماعز رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ماعز بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_goat_pelt.png",
		}
	},

	["provision_legendary_elk_antlers"] = {
		label = "قرون الأيل الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون رائعة من أيل أسطوري.",
		client = {
			image = "provision_legendary_elk_antlers.png",
		}
	},

	["frog legs"] = {
		label = "أرجل الضفدع",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "frog legs.png",
		}
	},

	["OutfitMen078"] = {
		label = "بدلة رجالية 078",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen078.png",
		}
	},

	["OutfitMen013"] = {
		label = "بدلة رجالية 013",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen013.png",
		}
	},

	["menoutfit77"] = {
		label = "ملابس الرجال 77",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit77.png",
		}
	},

	["resource_pelt_badger_star_1"] = {
		label = "جلد الغرير 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_badger_star_1.png",
		}
	},

	["OutfitMen038"] = {
		label = "بدلة رجالية 038",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen038.png",
		}
	},

	["provision_moose_fur"] = {
		label = "فراء الموظ",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء ناعم من الموظ.",
		client = {
			image = "provision_moose_fur.png",
		}
	},

	["crystal"] = {
		label = "بلورة",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع البلورة بأسعار مرتفعة.",
		client = {
			image = "crystal.png",
		}
	},

	["provision_rabbit_pelt"] = {
		label = "جلد الأرنب",
		weight = 250,
		stack = true,
		close = true,
		description = "جلد ناعم مأخوذ من أرنب.",
		client = {
			image = "provision_rabbit_pelt.png",
		}
	},

	["womenoutfit122"] = {
		label = "زي نسائي 122",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit122.png",
		}
	},

	["consumable_moonshine"] = {
		label = "زهرة لغو",
		weight = 250,
		stack = true,
		close = true,
		description = "زهرة لغو",
		client = {
			image = "consumable_moonshine.png",
		}
	},

	["provision_trinket_shark_toth"] = {
		label = "تعويذة سن القرش",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من سن قرش.",
		client = {
			image = "provision_trinket_shark_toth.png",
		}
	},

	["provision_legendary_buck_antlers"] = {
		label = "قرون الأيل الأسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون قوية ونادرة لأيل أسطوري.",
		client = {
			image = "provision_legendary_buck_antlers.png",
		}
	},

	["hat5"] = {
		label = "قبعة 5",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat5.png",
		}
	},

	["horselantern"] = {
		label = "فانوس الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "فانوس للحصان",
		client = {
			image = "horselantern.png",
		}
	},

	["moonshine_yellow"] = {
		label = "لون ضوء القمر الأصفر",
		weight = 250,
		stack = true,
		close = true,
		description = "لون ضوء القمر الأصفر",
		client = {
			image = "moonshine_yellow.png",
		}
	},

	["womenoutfit202"] = {
		label = "زي نسائي 202",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit202.png",
		}
	},

	["menoutfit78"] = {
		label = "ملابس الرجال 78",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit78.png",
		}
	},

	["s_inv_cigcard_lnd_03x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 03",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #03",
		client = {
			image = "s_inv_cigcard_lnd_03x.png",
		}
	},

	["poor_aligator_meat"] = {
		label = "لحم تمساح رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم تمساح بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_aligator_meat.png",
		}
	},

	["perfect_buffalo_pelt"] = {
		label = "فرو جاموس ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو جاموس بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_buffalo_pelt.png",
		}
	},

	["provision_skunk_fur"] = {
		label = "فراء الظربان",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء مأخوذ من الظربان.",
		client = {
			image = "provision_skunk_fur.png",
		}
	},

	["OutfitMen154"] = {
		label = "بدلة رجالية 154",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen154.png",
		}
	},

	["resource_skin_bear_grizzly_star_1"] = {
		label = "جلد الدب الأشيب 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_grizzly_star_1.png",
		}
	},

	["menoutfit82"] = {
		label = "ملابس الرجال 82",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit82.png",
		}
	},

	["womenoutfit266"] = {
		label = "زي نسائي 266",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit266.png",
		}
	},

	["OutfitMen125"] = {
		label = "بدلة رجالية 125",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen125.png",
		}
	},

	["OutfitMen040"] = {
		label = "بدلة رجالية 040",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen040.png",
		}
	},

	["womenoutfit633"] = {
		label = "زي نسائي 633",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit633.png",
		}
	},

	["p_FinisdFishlure01x_hf"] = {
		label = "طُعم السمك المميز",
		weight = 250,
		stack = true,
		close = true,
		description = "طُعم سمك متعدد الاستخدامات مصمم لجذب مجموعة متنوعة من أنواع المياه العذبة.",
		client = {
			image = "p_FinisdFishlure01x_hf.png",
		}
	},

	["p_scissors01x"] = {
		label = "مقص",
		weight = 250,
		stack = true,
		close = true,
		description = "مقص لقص الحشيش",
		client = {
			image = "p_scissors01x.png",
		}
	},

	["menoutfit76"] = {
		label = "ملابس الرجال 76",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit76.png",
		}
	},

	["contract"] = {
		label = "عقد",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "contract.png",
		}
	},

	["quail_feathers"] = {
		label = "ريش سمان",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش سمان يُستخدم في أعمال التصنيع.",
		client = {
			image = "quail_feathers.png",
		}
	},

	["docsnakekit"] = {
		label = "طقم طبي لدغة الأفعى",
		weight = 250,
		stack = true,
		close = true,
		description = "تحتاج هذا لعلاج اللاعبين بعد لدغات الأفاعي!",
		client = {
			image = "docsnakekit.png",
		}
	},

	["perfect_goat_meat"] = {
		label = "لحم ماعز ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ماعز بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_goat_meat.png",
		}
	},

	["hat3"] = {
		label = "قبعة 3",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat3.png",
		}
	},

	["consumable_moonshine_blackberry"] = {
		label = "مشروب التوت الأسود",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب التوت الأسود",
		client = {
			image = "consumable_moonshine_blackberry.png",
		}
	},

	["consumable_alcohol_eggnog"] = {
		label = "نبيذ البيض الكحولي",
		weight = 250,
		stack = true,
		close = true,
		description = "نبيذ البيض الكحولي",
		client = {
			image = "consumable_alcohol_eggnog.png",
		}
	},

	["s_inv_cigcard_hrs_07x"] = {
		label = "بطاقة السجائر سلالات الخيول 07",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #07",
		client = {
			image = "s_inv_cigcard_hrs_07x.png",
		}
	},

	["WomenHats139"] = {
		label = "قبعة نسائية 139",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats139.png",
		}
	},

	["reddiamond"] = {
		label = "ماس أحمر",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع الماس الأحمر في السوق.",
		client = {
			image = "reddiamond.png",
		}
	},

	["redfooted_feathers"] = {
		label = "ريش أطيش أحمر القدمين",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش أطيش أحمر القدمين يُستخدم في أعمال التصنيع.",
		client = {
			image = "redfooted_feathers.png",
		}
	},

	["womenoutfit806"] = {
		label = "زي نسائي 806",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit806.png",
		}
	},

	["s_inv_cigcard_art_01x"] = {
		label = "بطاقة السجائر فن 01",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #01",
		client = {
			image = "s_inv_cigcard_art_01x.png",
		}
	},

	["repair_moonshine"] = {
		label = "إصلاح آلة صناعة مشروب المونشاين",
		weight = 250,
		stack = true,
		close = true,
		description = "إصلاح آلة صناعة مشروب المونشاين",
		client = {
			image = "repair_moonshine.png",
		}
	},

	["poor_bear_pelt"] = {
		label = "فرو دب رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو دب بجودة رديئة، يُستخدم في أعمال التصنيع الأساسية.",
		client = {
			image = "poor_bear_pelt.png",
		}
	},

	["WomenHats110"] = {
		label = "قبعة نسائية 110",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats110.png",
		}
	},

	["cookingcampfire"] = {
		label = "طبخ على نار المخيم",
		weight = 250,
		stack = true,
		close = true,
		description = "كتاب لتعلم الطبخ على نار المخيم.",
		client = {
			image = "cookingcampfire.png",
		}
	},

	["provision_trinket_shark_tooth"] = {
		label = "تعويذة سن القرش",
		weight = 250,
		stack = true,
		close = true,
		description = "تعويذة مصنوعة من سن قرش.",
		client = {
			image = "provision_trinket_shark_tooth.png",
		}
	},

	["Chamomile"] = {
		label = "البابونج ",
		weight = 250,
		stack = true,
		close = true,
		description = "نبات طبي معروف بزهوره البيضاء والصفراء، ويستخدم في تحضير الشاي",
		client = {
			image = "Chamomile.png",
		}
	},

	["OutfitMen074"] = {
		label = "بدلة رجالية 074",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen074.png",
		}
	},

	["marijuana_joint3_2"] = {
		label = "لفافة ماريجوانا 3-2",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 3-2",
		client = {
			image = "marijuana_joint3_2.png",
		}
	},

	["hat200200"] = {
		label = "Hat vip pro",
		weight = 250,
		stack = true,
		close = true,
		description = "Hat vip pro",
		client = {
			image = "hat200200.png",
		}
	},

	["resource_empty_jar"] = {
		label = "جرة فارغة",
		weight = 250,
		stack = true,
		close = true,
		description = "جرة فارغة",
		client = {
			image = "resource_empty_jar.png",
		}
	},

	["resource_horseshoe_nail"] = {
		label = "مسمار حدوة الحصان",
		weight = 250,
		stack = true,
		close = true,
		description = "مسمار حدوة الحصان",
		client = {
			image = "resource_horseshoe_nail.png",
		}
	},

	["womenoutfit760"] = {
		label = "زي نسائي 760",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit760.png",
		}
	},

	["building_plan_1"] = {
		label = "ورقة بناء بيت 1",
		weight = 250,
		stack = true,
		close = true,
		description = "Building Plan",
		client = {
			image = "building_plan_1.png",
		}
	},

	["womenoutfit677"] = {
		label = "زي نسائي 677",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit677.png",
		}
	},

	["MenOutfits016"] = {
		label = "زي رجالي 016",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits016.png",
		}
	},

	["WomenHats076"] = {
		label = "قبعة نسائية 076",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats076.png",
		}
	},

	["WomenOutfits39"] = {
		label = "زي نسائي 39",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfits39.png",
		}
	},

	["medium_peccary_pelt"] = {
		label = "فرو بيكاري متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو بيكاري بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_peccary_pelt.png",
		}
	},

	["womenoutfit634"] = {
		label = "زي نسائي 634",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit634.png",
		}
	},

	["baking_bread_pan"] = {
		label = "مقلاة الخبز",
		weight = 250,
		stack = true,
		close = true,
		description = "مقلاة الخبز",
		client = {
			image = "baking_bread_pan.png",
		}
	},

	["WomenOutfit047"] = {
		label = "زي نسائي 047",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit047.png",
		}
	},

	["s_inv_cigcard_art_07x"] = {
		label = "بطاقة السجائر فن 07",
		weight = 250,
		stack = true,
		close = true,
		description = "فنانين #07",
		client = {
			image = "s_inv_cigcard_art_07x.png",
		}
	},

	["resource_pelt_muskrat_star_2"] = {
		label = "جلد المسك رات 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_muskrat_star_2.png",
		}
	},

	["s_inv_cigcard_plt_10x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 1",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #10",
		client = {
			image = "s_inv_cigcard_plt_10x.png",
		}
	},

	["legendary_onwolf_meat"] = {
		label = "لحم ذئب أسطوري",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ذئب أسطوري نادر وعالي القيمة.",
		client = {
			image = "legendary_onwolf_meat.png",
		}
	},

	["womenoutfit588"] = {
		label = "زي نسائي 588",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit588.png",
		}
	},

	["consumable_canned_corn"] = {
		label = "ذرة معلبة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_canned_corn.png",
		}
	},

	["cuthemp_is"] = {
		label = "Trimmed Indigenous Sativa",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp grown from native strains in pristine environments!",
		client = {
			image = "cuthemp_is.png",
		}
	},

	["s_inv_cigcard_inv_11x"] = {
		label = "بطاقة السجائر الاختراعات المدهشة 11",
		weight = 250,
		stack = true,
		close = true,
		description = "الاختراعات المدهشة #11",
		client = {
			image = "s_inv_cigcard_inv_11x.png",
		}
	},

	["resource_pelt_wolf_star_2"] = {
		label = "جلد الذئب 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_wolf_star_2.png",
		}
	},

	["medicinebook"] = {
		label = "كتاب تسجيل المرضى",
		weight = 250,
		stack = true,
		close = true,
		description = "يُستخدم لتسجيل بيانات المرضى والحالات الطبية ومتابعة التقارير داخل المستشفى.",
		client = {
			image = "medicinebook.png",
		}
	},

	["womenoutfit641"] = {
		label = "زي نسائي 641",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit641.png",
		}
	},

	["resource_skin_armadillo_star_1"] = {
		label = "فرو الأرماديلو 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_armadillo_star_1.png",
		}
	},

	["lumber_cedar_wood_logs"] = {
		label = "جذوع خشب الأرز",
		weight = 250,
		stack = true,
		close = true,
		description = "جذوع خشب الأرز",
		client = {
			image = "lumber_cedar_wood_logs.png",
		}
	},

	["menoutfit17"] = {
		label = "ملابس الرجال 17",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit17.png",
		}
	},

	["resource_skin_bear_grizzly_star_2"] = {
		label = "جلد الدب الأشيب 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_bear_grizzly_star_2.png",
		}
	},

	["womenoutfit469"] = {
		label = "زي نسائي 469",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit469.png",
		}
	},

	["s_inv_cigcard_aml_10x"] = {
		label = "بطاقة السجائر أمل 10",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #10",
		client = {
			image = "s_inv_cigcard_aml_10x.png",
		}
	},

	["printphoto"] = {
		label = "طباعة صورة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "printphoto.png",
		}
	},

	["womenoutfit131"] = {
		label = "زي نسائي 131",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit131.png",
		}
	},

	["s_inv_cigcard_aml_03x"] = {
		label = "بطاقة السجائر أمل 03",
		weight = 250,
		stack = true,
		close = true,
		description = "حيوانات أمريكا الشمالية #03",
		client = {
			image = "s_inv_cigcard_aml_03x.png",
		}
	},

	["elk_antlers"] = {
		label = "قرون وعل",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون وعل يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "elk_antlers.png",
		}
	},

	["moose_antlers"] = {
		label = "قرون موظ",
		weight = 250,
		stack = true,
		close = true,
		description = "قرون موظ يمكن استخدامها في التصنيع أو الزينة.",
		client = {
			image = "moose_antlers.png",
		}
	},

	["opt_news"] = {
		label = "جريدة المهرجين",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "opt_news.png",
		}
	},

	["resource_skin_cougar_star_2"] = {
		label = "جلد الكوجر 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_cougar_star_2.png",
		}
	},

	["consumable_seafood_platter"] = {
		label = "طبق مأكولات بحرية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_seafood_platter.png",
		}
	},

	["resource_skin_elk_star_1"] = {
		label = "جلد الأيل 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_elk_star_1.png",
		}
	},

	["resource_skin_elk_star_2"] = {
		label = "جلد الأيل 2*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_elk_star_2.png",
		}
	},

	["OutfitMen117"] = {
		label = "بدلة رجالية 117",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen117.png",
		}
	},

	["marijuana_joint2_7"] = {
		label = "لفافة ماريجوانا 2-7",
		weight = 250,
		stack = true,
		close = true,
		description = "لفافة ماريجوانا 2-7",
		client = {
			image = "marijuana_joint2_7.png",
		}
	},

	["womenoutfit790"] = {
		label = "زي نسائي 790",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit790.png",
		}
	},

	["Orange_Seed"] = {
		label = "بذور البرتقال",
		weight = 250,
		stack = true,
		close = true,
		description = "بذور يمكن زراعتها لإنتاج شجرة البرتقال.",
		client = {
			image = "Orange_Seed.png",
		}
	},

	["menoutfit64"] = {
		label = "ملابس الرجال 64",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit64.png",
		}
	},

	["resource_skin_pronghorn_star_3"] = {
		label = "فرو الظبي 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_pronghorn_star_3.png",
		}
	},

	["screwdriver"] = {
		label = "Screwdriver",
		weight = 250,
		stack = true,
		close = true,
		description = "Tool for attach scope to weapon",
		client = {
			image = "screwdriver.png",
		}
	},

	["resource_snake_skin_boa_star_3"] = {
		label = "جلد الثعبان البواء 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_snake_skin_boa_star_3.png",
		}
	},

	["cobbler_strawberry"] = {
		label = "كوبلر الفراولة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "cobbler_strawberry.png",
		}
	},

	["jqd_news"] = {
		label = "جريدة الاخوه السوفيت",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "jqd_news.png",
		}
	},

	["ruby"] = {
		label = "ياقوت",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع الياقوت بأسعار مرتفعة.",
		client = {
			image = "ruby.png",
		}
	},

	["sheriffbook"] = {
		label = "كتاب الشريف",
		weight = 250,
		stack = true,
		close = true,
		description = "كتاب الشريف",
		client = {
			image = "sheriffbook.png",
		}
	},

	["WomenOutfit007"] = {
		label = "زي نسائي 007",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenOutfit007.png",
		}
	},

	["s_inv_cigcard_amer_07x"] = {
		label = "بطاقة السجائر أمريكي 07",
		weight = 250,
		stack = true,
		close = true,
		description = "أمريكيون بارزون #07",
		client = {
			image = "s_inv_cigcard_amer_07x.png",
		}
	},

	["MenOutfits02"] = {
		label = "زي رجالي 2",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits02.png",
		}
	},

	["WomenHats191"] = {
		label = "قبعة نسائية 191",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats191.png",
		}
	},

	["womenoutfit785"] = {
		label = "زي نسائي 785",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit785.png",
		}
	},

	["OutfitMen034"] = {
		label = "بدلة رجالية 034",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen034.png",
		}
	},

	["WomenHats132"] = {
		label = "قبعة نسائية 132",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats132.png",
		}
	},

	["scopelongcarcano"] = {
		label = "Sniper Rifle Carcano Long Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopelongcarcano.png",
		}
	},

	["qqq_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "qqq_news.png",
		}
	},

	["womenoutfit821"] = {
		label = "زي نسائي 821",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit821.png",
		}
	},

	["stash_box"] = {
		label = "Stash Box",
		weight = 250,
		stack = false,
		close = true,
		description = "Use it to place a stash at your current location",
		client = {
			image = "stash_box.png",
		}
	},

	["medium_nraccoon_meat"] = {
		label = "لحم راكون متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم راكون بجودة متوسطة، مناسب للطهي.",
		client = {
			image = "medium_nraccoon_meat.png",
		}
	},

	["consumable_cognac"] = {
		label = "كونياك",
		weight = 250,
		stack = true,
		close = true,
		description = "مشروب الكونياك.",
		client = {
			image = "consumable_cognac.png",
		}
	},

	["survival_guitar_001"] = {
		label = "survival guitar 001",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "survival_guitar_001.png",
		}
	},

	["perfect_pronghorn_pelt"] = {
		label = "فرو ظبي ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ظبي بجودة ممتازة، ذو قيمة عالية في التصنيع.",
		client = {
			image = "perfect_pronghorn_pelt.png",
		}
	},

	["scopemediumrollingblock"] = {
		label = "Sniper Rifle Rolling Block Medium Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopemediumrollingblock.png",
		}
	},

	["chicha_repair_kit"] = {
		label = "عدة إصلاح الشيشة",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "chicha_repair_kit.png",
		}
	},

	["scopeshortevans"] = {
		label = "Repeater Evans Short Scope",
		weight = 250,
		stack = true,
		close = true,
		description = "Attachable Weapon Scope",
		client = {
			image = "scopeshortevans.png",
		}
	},

	["poor_goat_meat"] = {
		label = "لحم ماعز رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم ماعز بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_goat_meat.png",
		}
	},

	["OutfitMen119"] = {
		label = "بدلة رجالية 119",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen119.png",
		}
	},

	["womenoutfit817"] = {
		label = "زي نسائي 817",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit817.png",
		}
	},

	["shield07"] = {
		label = "درع 07",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "shield07.png",
		}
	},

	["unique_pineapple_cocktail"] = {
		label = "كوكتيل",
		weight = 250,
		stack = true,
		close = true,
		description = "كوكتيل",
		client = {
			image = "unique_pineapple_cocktail.png",
		}
	},

	["skirts"] = {
		label = "تنورات",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "skirts.png",
		}
	},

	["egg_goose"] = {
		label = "بيضة إوزة",
		weight = 250,
		stack = true,
		close = true,
		description = "بيضة إوزة.",
		client = {
			image = "egg_goose.png",
		}
	},

	["small_fireworks"] = {
		label = "الألعاب النارية الصغيرة",
		weight = 250,
		stack = true,
		close = true,
		description = "الألعاب النارية الصغيرة",
		client = {
			image = "small_fireworks.png",
		}
	},

	["resource_pelt_coyote_star_3"] = {
		label = "فراء ذئب البراري 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_coyote_star_3.png",
		}
	},

	["resource_pelt_raccoon_star_3"] = {
		label = "جلد الراكون 3*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_pelt_raccoon_star_3.png",
		}
	},

	["burialoil"] = {
		label = "زيت عطر الدفن",
		weight = 250,
		stack = true,
		close = true,
		description = "زيت عطر الدفن",
		client = {
			image = "burialoil.png",
		}
	},

	["s_inv_cigcard_act_07x"] = {
		label = "بطاقة السجائر 07",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 07",
		client = {
			image = "s_inv_cigcard_act_07x.png",
		}
	},

	["OutfitMen067"] = {
		label = "بدلة رجالية 067",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen067.png",
		}
	},

	["Stash2"] = {
		label = "Stash 2",
		weight = 250,
		stack = true,
		close = true,
		description = "Item allow you to place your own stash anywhere.",
		client = {
			image = "Stash2.png",
		}
	},

	["consumable_friedtater"] = {
		label = "بطاطا مقلية",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "consumable_friedtater.png",
		}
	},

	["bee_house_gk_2"] = {
		label = "بيت النحل 2",
		weight = 250,
		stack = true,
		close = true,
		description = "بيت النحل 2",
		client = {
			image = "bee_house_gk_2.png",
		}
	},

	["perfect_nraccoon_meat"] = {
		label = "لحم راكون ممتاز",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم راكون بجودة ممتازة، مثالي للأطباق عالية الجودة.",
		client = {
			image = "perfect_nraccoon_meat.png",
		}
	},

	["sugarseed"] = {
		label = "بذور السكر",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sugarseed.png",
		}
	},


	["survival_banjo_003"] = {
		label = "survival banjo 003",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "survival_banjo_003.png",
		}
	},

	["sword01"] = {
		label = "سيف 01",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "sword01.png",
		}
	},

	["s_inv_cigcard_veh_11x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 11",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #11",
		client = {
			image = "s_inv_cigcard_veh_11x.png",
		}
	},

	["ammohatchetcleaver"] = {
		label = "ذخيرة الفأس القاطع",
		weight = 250,
		stack = true,
		close = true,
		description = "ذخيرة الفأس القاطع.",
		client = {
			image = "ammohatchetcleaver.png",
		}
	},

	["s_inv_cigcard_act_08x"] = {
		label = "بطاقة السجائر 08",
		weight = 250,
		stack = true,
		close = true,
		description = "نجوم المسرح 08",
		client = {
			image = "s_inv_cigcard_act_08x.png",
		}
	},

	["identitycard"] = {
		label = "بطاقة الهوية",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "identitycard.png",
		}
	},

	["s_inv_cigcard_plt_06x"] = {
		label = "بطاقة السجائر النباتات البرية في أمريكا الشمالية 0",
		weight = 250,
		stack = true,
		close = true,
		description = "النباتات البرية في أمريكا الشمالية #06",
		client = {
			image = "s_inv_cigcard_plt_06x.png",
		}
	},

	["womenoutfit294"] = {
		label = "زي نسائي 294",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit294.png",
		}
	},

	["s_inv_cigcard_veh_06x"] = {
		label = "بطاقة السجائر عجائب السفر والمواصلات 06",
		weight = 250,
		stack = true,
		close = true,
		description = "عجائب السفر والمواصلات #06",
		client = {
			image = "s_inv_cigcard_veh_06x.png",
		}
	},

	["resource_skin_buffalo_star_1"] = {
		label = "جلد البيسون 1*",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "resource_skin_buffalo_star_1.png",
		}
	},

	["revolverprint"] = {
		label = "طباعة المسدس الدوار",
		weight = 250,
		stack = true,
		close = true,
		description = "طباعة المسدس الدوار",
		client = {
			image = "revolverprint.png",
		}
	},

	["womenoutfit406"] = {
		label = "زي نسائي 406",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit406.png",
		}
	},

	["medium_moose_pelt"] = {
		label = "فرو موظ متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو موظ بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_moose_pelt.png",
		}
	},

	["consumable_milkshake_strawberry"] = {
		label = "حليب الفراولة",
		weight = 250,
		stack = true,
		close = true,
		description = "حليب الفراولة",
		client = {
			image = "consumable_milkshake_strawberry.png",
		}
	},

	["remyWring"] = {
		label = "خاتم ريمي",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "remyWring.png",
		}
	},

	["ricx_beartrap"] = {
		label = "Hunting Trap",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "ricx_beartrap.png",
		}
	},

	["stringedmeat"] = {
		label = "لحم مجفف بالخيوط",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "stringedmeat.png",
		}
	},

	["poor_blackbear_meat"] = {
		label = "لحم دب أسود رديء",
		weight = 250,
		stack = true,
		close = true,
		description = "لحم دب أسود بجودة رديئة، مناسب للاستهلاك الأساسي.",
		client = {
			image = "poor_blackbear_meat.png",
		}
	},

	["blackberry"] = {
		label = "توت أسود",
		weight = 250,
		stack = true,
		close = true,
		description = "توت أسود",
		client = {
			image = "blackberry.png",
		}
	},

	["wethemp_db"] = {
		label = "Wet Dragons Breath",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp derived from the fiery lands of legend and myth!",
		client = {
			image = "wethemp_db.png",
		}
	},

	["lumber_maple_split_logs"] = {
		label = "جذوع شجر القيقب المنقسمة",
		weight = 250,
		stack = true,
		close = true,
		description = "جذوع شجر القيقب المنقسمة",
		client = {
			image = "lumber_maple_split_logs.png",
		}
	},

	["WomenHats087"] = {
		label = "قبعة نسائية 087",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "WomenHats087.png",
		}
	},

	["s_inv_cigcard_grl_08x"] = {
		label = "بطاقة السجائر جواهر الجمال 08",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #08",
		client = {
			image = "s_inv_cigcard_grl_08x.png",
		}
	},

	["s_inv_cigcard_grl_09x"] = {
		label = "بطاقة السجائر جواهر الجمال 09",
		weight = 250,
		stack = true,
		close = true,
		description = "جواهر الجمال #09",
		client = {
			image = "s_inv_cigcard_grl_09x.png",
		}
	},

	["gunoil2"] = {
		label = "زيت السلاح",
		weight = 250,
		stack = true,
		close = true,
		description = "زيت السلاح",
		client = {
			image = "gunoil2.png",
		}
	},

	["s_inv_cigcard_gun_06x"] = {
		label = "بطاقة السجائر رعاة البقر والخارجين عن القانون 06",
		weight = 250,
		stack = true,
		close = true,
		description = "رعاة البقر والخارجين عن القانون #06",
		client = {
			image = "s_inv_cigcard_gun_06x.png",
		}
	},

	["moonshine_interior1"] = {
		label = "Moonshine Interior 1",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "moonshine_interior1.png",
		}
	},

	["s_inv_cigcard_hrs_12x"] = {
		label = "بطاقة السجائر سلالات الخيول 12",
		weight = 250,
		stack = true,
		close = true,
		description = "سلالات الخيول #12",
		client = {
			image = "s_inv_cigcard_hrs_12x.png",
		}
	},

	["copperore"] = {
		label = "خام نحاس",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن تحويل خام النحاس إلى سبيكة نحاس.",
		client = {
			image = "copperore.png",
		}
	},

	["menoutfit65"] = {
		label = "ملابس الرجال 65",
		weight = 250,
		stack = false,
		close = true,
		description = "nice item",
		client = {
			image = "menoutfit65.png",
		}
	},

	["a_c_fishchannelcatfish_01_lg"] = {
		label = "Channel Catfish (Large)",
		weight = 4500,
		stack = true,
		close = true,
		description = "A large Channel Catfish",
		client = {
			image = "a_c_fishchannelcatfish_01_lg.png",
		}
	},

	["OutfitMen066"] = {
		label = "بدلة رجالية 066",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen066.png",
		}
	},

	["campchair"] = {
		label = "كرسي المعسكر",
		weight = 250,
		stack = true,
		close = true,
		description = "كرسي المعسكر",
		client = {
			image = "campchair.png",
		}
	},

	["resource_charcoal"] = {
		label = "صخر البارود",
		weight = 250,
		stack = true,
		close = true,
		description = "صخر البارود ",
		client = {
			image = "resource_charcoal.png",
		}
	},

	["saphire"] = {
		label = "ياقوت أزرق",
		weight = 250,
		stack = true,
		close = true,
		description = "يمكن بيع الياقوت الأزرق في السوق.",
		client = {
			image = "saphire.png",
		}
	},

	["OutfitMen016"] = {
		label = "بدلة رجالية 016",
		weight = 250,
		stack = false,
		close = true,
		description = "بدلة أنيقة للسيد المحترم",
		client = {
			image = "OutfitMen016.png",
		}
	},

	["consumable_chef_sourcream"] = {
		label = "الكريمة الحامضة",
		weight = 250,
		stack = true,
		close = true,
		description = "الكريمة الحامضة",
		client = {
			image = "consumable_chef_sourcream.png",
		}
	},

	["hat10"] = {
		label = "قبعة 10",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "hat10.png",
		}
	},

	["pheasant_feathers"] = {
		label = "ريش تدرج",
		weight = 100,
		stack = true,
		close = true,
		description = "ريش تدرج يُستخدم في أعمال التصنيع.",
		client = {
			image = "pheasant_feathers.png",
		}
	},

	["tooth"] = {
		label = "سن حيوان",
		weight = 250,
		stack = true,
		close = true,
		description = "سن من حيوان، يمكن استخدامه في التصنيع أو التجارة.",
		client = {
			image = "tooth.png",
		}
	},

	["tqz_news"] = {
		label = "جريدة",
		weight = 1000,
		stack = true,
		close = true,
		description = "قطعة جريدة تستخدم .",
		client = {
			image = "tqz_news.png",
		}
	},

	["medium_wolf_pelt"] = {
		label = "فرو ذئب متوسط",
		weight = 250,
		stack = true,
		close = true,
		description = "فرو ذئب بجودة متوسطة، مناسب لأعمال التصنيع.",
		client = {
			image = "medium_wolf_pelt.png",
		}
	},

	["chicken_feather"] = {
		label = "ريش دجاج",
		weight = 250,
		stack = true,
		close = true,
		description = "ريش دجاج ناعم",
		client = {
			image = "chicken_feather.png",
		}
	},

	["wethemp_is"] = {
		label = "Wet Indigenous Sativa",
		weight = 250,
		stack = true,
		close = true,
		description = "Hemp grown from native strains in pristine environments!",
		client = {
			image = "wethemp_is.png",
		}
	},

	["consumable_potent_horse_medicine"] = {
		label = "دواء قوي للخيول",
		weight = 250,
		stack = true,
		close = true,
		description = "دواء منشط يعزز صحة الخيول.",
		client = {
			image = "consumable_potent_horse_medicine.png",
		}
	},

	["provision_opossum_fur"] = {
		label = "فراء الأبوسوم",
		weight = 250,
		stack = true,
		close = true,
		description = "فراء مأخوذ من حيوان الأبوسوم.",
		client = {
			image = "provision_opossum_fur.png",
		}
	},

	["s_inv_cigcard_spt_08x"] = {
		label = "بطاقة السجائر أبطال العالم 08",
		weight = 250,
		stack = true,
		close = true,
		description = "أبطال العالم #08",
		client = {
			image = "s_inv_cigcard_spt_08x.png",
		}
	},

	["womenoutfit211"] = {
		label = "زي نسائي 211",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "womenoutfit211.png",
		}
	},

	["s_inv_cigcard_lnd_09x"] = {
		label = "بطاقة السجائر مناظر ومدن أمريكا 09",
		weight = 250,
		stack = true,
		close = true,
		description = "مناظر طبيعية ومدن أمريكا #09",
		client = {
			image = "s_inv_cigcard_lnd_09x.png",
		}
	},

	["MenOutfits005"] = {
		label = "زي رجالي 005",
		weight = 250,
		stack = true,
		close = true,
		description = "nice item",
		client = {
			image = "MenOutfits005.png",
		}
	},
}