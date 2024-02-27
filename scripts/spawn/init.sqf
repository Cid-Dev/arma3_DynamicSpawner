// ---------------------------------------------------------- Customize here ----------------------------------------------------------

private _configGroups = configFile >> "CfgGroups";
private _eastGroups = _configGroups >>  "East";
private _eastGroupOPF_F = _eastGroups >> "OPF_F";
private _eastGroupOPF_FInfantry = _eastGroupOPF_F >> "Infantry";
private _eastGroupOPF_FMechanized = _eastGroupOPF_F >> "Mechanized";
private _eastGroupOPF_FArmored = _eastGroupOPF_F >> "Armored";

private _groups = createHashMapFromArray
[
	[
		"EAST", createHashMapFromArray
		[
			[
				"INFANTRY",
				[
					_eastGroupOPF_FInfantry >> "OIA_InfSquad",
					_eastGroupOPF_FInfantry >> "OIA_InfSquad_Weapons",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam_AT",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam_AA",
					_eastGroupOPF_FInfantry >> "OIA_InfSentry",
					_eastGroupOPF_FInfantry >> "OI_reconTeam",
					_eastGroupOPF_FInfantry >> "OI_reconPatrol",
					_eastGroupOPF_FInfantry >> "OI_reconSentry",
					_eastGroupOPF_FInfantry >> "OI_SniperTeam",
					_eastGroupOPF_FInfantry >> "OIA_InfAssault",
					_eastGroupOPF_FInfantry >> "OIA_ReconSquad",
					_eastGroupOPF_FInfantry >> "O_InfTeam_AT_Heavy"
				]
			],
			[
				"VEHICLE",
				[
					_eastGroupOPF_FMechanized >> "OIA_MechInfSquad",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_AT",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_AA",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_Support",
					_eastGroupOPF_FArmored >> "OIA_TankPlatoon",
					_eastGroupOPF_FArmored >> "OIA_TankPlatoon_AA",
					_eastGroupOPF_FArmored >> "OIA_TankSection",
					_eastGroupOPF_FArmored >> "OIA_SPGPlatoon_Scorcher",
					_eastGroupOPF_FArmored >> "OIA_SPGSection_Scorcher",
					_eastGroupOPF_FArmored >> "O_TankSection_Heavy",
					_eastGroupOPF_FArmored >> "O_TankPlatoon_Heavy"
				]
			],
			[
				"AIR",
				[
					"O_Heli_Light_02_F",
					"O_Heli_Light_02_v2_F",
					"O_Heli_Attack_02_F",
					"O_Heli_Attack_02_black_F",
					"O_Plane_CAS_02_F",
					"O_T_VTOL_02_infantry_F",
					"O_T_VTOL_02_vehicle_F",
					"O_T_VTOL_02_infantry_hex_F",
					"O_T_VTOL_02_infantry_ghex_F",
					"O_T_VTOL_02_infantry_grey_F",
					"O_T_VTOL_02_vehicle_hex_F",
					"O_T_VTOL_02_vehicle_grey_F",
					"O_Plane_Fighter_02_F",
					"O_Plane_Fighter_02_Stealth_F",
					"O_Plane_CAS_02_Cluster_F",
					"O_Plane_Fighter_02_Cluster_F"
				]
			]
		]
	]
];

private _customScripts = createHashMapFromArray
[
	[
		"TriggerCreation", createHashMapFromArray
		[
			[
				"Script",
				compile preprocessFileLineNumbers "scripts\spawn\customizations\custom_script_create_trigger.sqf"
			],
			[
				"Params",
				[
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_csat_flag.sqf",
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_flag.sqf",
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_occupied_marker_zone.sqf",
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_zone.sqf"
				]
			]
		]
	],
	[
		"TriggerActivated", createHashMapFromArray
		[
			[ "Script", {} ],
			[ "Params", [] ]
		]
	],
	[
		"TriggerDeactivated", createHashMapFromArray
		[
			[ "Script", {} ],
			[ "Params", [] ]
		]
	],
	[
		"TriggerDetected", createHashMapFromArray
		[
			[ "Script", {} ],
			[ "Params", [] ]
		]
	],
	[
		"TriggerUndetected", createHashMapFromArray
		[
			[ "Script", {} ],
			[ "Params", [] ]
		]
	],
	[
		"TriggerCleared", createHashMapFromArray
		[
			[
				"Script",
				compile preprocessFileLineNumbers "scripts\spawn\customizations\zone_cleared.sqf"
			],
			[
				"Params",
				[
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_nato_flag.sqf",
					compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_flag.sqf"
				]
			]
		]
	]
];

// ------------------------------------------------------------------------------------------------------------------------------------

private _configure_all_triggers_script_handler = [ _groups, _customScripts ] execVM "scripts\spawn\configure_all_triggers.sqf";
waitUntil
{
	scriptDone _configure_all_triggers_script_handler;
};