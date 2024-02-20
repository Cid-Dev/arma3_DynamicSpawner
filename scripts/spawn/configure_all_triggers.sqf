#include "spawn_constants.hpp"

private _triggerScript = compile preprocessFileLineNumbers "scripts\spawn\configure_trigger.sqf";
private _functions = createHashMapFromArray [
	[ "checkSides", compile preprocessFileLineNumbers "scripts\spawn\check_sides.sqf" ],
	[ "get_n_random_elements_from_array", compile preprocessFileLineNumbers "scripts\utils\get_n_random_elements_from_array.sqf" ],
	[ "string_to_side", compile preprocessFileLineNumbers "scripts\spawn\string_to_side.sqf" ],
	[ "delete_group_and_its_members", compile preprocessFileLineNumbers "scripts\spawn\delete_group_and_its_members.sqf" ],
	[ "contains_alive_squads", compile preprocessFileLineNumbers "scripts\spawn\contains_alive_squads.sqf" ],
	[ "contains_alive_units", compile preprocessFileLineNumbers "scripts\spawn\contains_alive_units.sqf" ],
	[ "string_array_to_int_array", compile preprocessFileLineNumbers "scripts\utils\string_array_to_int_array.sqf" ],
	[ "loop_waypoints_to_a_group", compile preprocessFileLineNumbers "scripts\spawn\loop_waypoints_to_a_group.sqf" ],
	[ "loop_waypoints_to_a_group_file_path", "scripts\spawn\loop_waypoints_to_a_group.sqf" ]
];
private _activationCallback = compile preprocessFileLineNumbers "scripts\spawn\spawn_trigger_activated.sqf";
private _deactivationCallback = compile preprocessFileLineNumbers "scripts\spawn\spawn_trigger_deactivated.sqf";
private _handleClearedTrigger = compile preprocessFileLineNumbers "scripts\spawn\handle_cleared_trigger.sqf";
private _cleanupTrigger = compile preprocessFileLineNumbers "scripts\spawn\cleanup_trigger.sqf";

// --------------- Customizations ---------------

private _extraScript = compile preprocessFileLineNumbers "scripts\spawn\customizations\custom_script_create_trigger.sqf";
private _extraScriptParams =
[
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_csat_flag.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_flag.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_occupied_marker_zone.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_zone.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_nato_flag.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\zone_cleared.sqf"
];

private _extraScriptActivated = {};
private _extraScriptParamsActivated = [];

private _extraScriptDeactivated = {};
private _extraScriptParamsDeactivated = [];

private _extraScriptClearedTrigger = compile preprocessFileLineNumbers "scripts\spawn\customizations\zone_cleared.sqf";
private _extraScriptClearedTriggerParams =
[
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_nato_flag.sqf",
	compile preprocessFileLineNumbers "scripts\spawn\customizations\create_marker_flag.sqf"
];

private _deleteEverythingOnceCleared = true;

private _configGroups = configFile >> "CfgGroups";
private _eastGroups = _configGroups >>  "East";
private _eastGroupOPF_F = _eastGroups >> "OPF_F";
private _eastGroupOPF_FInfantry = _eastGroupOPF_F >> "Infantry";
private _eastGroupOPF_FMechanized = _eastGroupOPF_F >> "Mechanized";
private _eastGroupOPF_FArmored = _eastGroupOPF_F >> "Armored";

private _groups = createHashMapFromArray [
	[
		"EAST", createHashMapFromArray [
			[
				"INFANTRY", [
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
				"VEHICLE", [
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
				"AIR", [
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

// ----------------------------------------------

private _all_spawn_triggers = (allMissionObjects "EmptyDetector") select { triggerText _x regexMatch TRIGGER_NAME_PATTERN };
private _length = count _all_spawn_triggers;

for "_i" from 0 to _length - 1 do
{
	private _trigger = _all_spawn_triggers select _i;
	diag_log format [ "Setting up trigger %1 if needed.", triggerText _trigger ];

	[
		_trigger,
		_functions,
		_groups,
		_activationCallback,
		_deactivationCallback,
		_extraScript,
		_extraScriptParams,
		_handleClearedTrigger,
		_extraScriptClearedTrigger,
		_extraScriptClearedTriggerParams,
		_deleteEverythingOnceCleared,
		_cleanupTrigger,
		_extraScriptActivated,
		_extraScriptParamsActivated,
		_extraScriptDeactivated,
		_extraScriptParamsDeactivated
	] call _triggerScript;
};