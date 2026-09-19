-----------------------------------------------------------------------------------------------------------------
------------------------------------ Item use animations (RDR3) -------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- An item's client.anim / client.prop may name an entry of these tables instead of carrying
-- the dictionary and the model itself. The dictionaries are RDR3 animation dictionaries and
-- the models are RDR3 props.
-----------------------------------------------------------------------------------------------------------------

return {
	anim = {
		['eating'] = { dict = 'mech_inventory@eating@multi_bite@sphere_d8-2_sandwich', clip = 'quick_right_hand' },
		['drinking'] = { dict = 'mech_inventory@drinking@bottle_cylinder_d1-3_h30-5_neck_a15_c_d1-25', clip = 'quick_right_hand' },
	},
	prop = {
		['bread'] = { model = `p_bread05x`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
		['bottle'] = { model = `p_bottlebeer01x`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
	}
}
