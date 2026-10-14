-- Labels are dictionary keys ('<key>' or '<key> <number>'): the client translates them
-- into the player's language when the stash opens.
return {
	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'evidence_1',
		label = 'evidence_location 1',
		owner = true,
		slots = 500,
		weight = 4000000,
		groups = shared.police
	},

	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'evidence_2',
		label = 'evidence_location 2',
		owner = true,
		slots = 500,
		weight = 4000000,
		groups = shared.police
	},

	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'evidence_3',
		label = 'evidence_location 3',
		owner = true,
		slots = 500,
		weight = 4000000,
		groups = shared.police
	},

	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'evidence_4',
		label = 'evidence_location 4',
		owner = true,
		slots = 500,
		weight = 4000000,
		groups = shared.police
	},

	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'evidence_5',
		label = 'evidence_location 5',
		owner = true,
		slots = 500,
		weight = 4000000,
		groups = shared.police
	},

	-- The officer's personal locker
	{
		name = 'policelocker',
		label = 'personal_locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = shared.police
	},

	-- The rubbish bin
	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'policetrash',
		label = 'trash',
		slots = 300,
		weight = 4000000,
		groups = shared.police
	},

	-- The shared locker for all the police
	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'police_shared_stash',
		label = 'police_shared_stash',
		slots = 300,
		weight = 500000,
		groups = shared.police
	},

	-- The first-aid locker
	{
		coords = vec3(0.0, 0.0, 0.0),
		name = 'emslocker',
		label = 'ems_personal_locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['doctor'] = 0} -- w_medic's job (was 'ambulance')
	},
}

