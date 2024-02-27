#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ],
	[
		"_groups",
		createHashMapFromArray
		[
			[
				"EAST", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"WEST", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"CIV", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"GUER", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			]
		],
		[ createHashMap ]
	],
	[
		"_customScripts",
		createHashMapFromArray
		[
			[
				"TriggerCreation", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
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
					[ "Script", {} ],
					[ "Params", [] ]
				]
			]
		],
		[ createHashMap ]
	]
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = (triggerText _trigger) splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _activationSide = _triggerDatas select INDEX_OF_ACTIVATION_SIDE;
	private _spawnSide = _triggerDatas select INDEX_OF_SPAWN_SIDE;
	diag_log format [ "Checking activation side %1 and spawn side %2 of trigger.", _activationSide, _spawnSide ];
	[ _activationSide, _spawnSide ] call CID_fnc_checkSides;
	_selectedSideSpawnGroups = _groups get _spawnSide;

	private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;
	diag_log "Getting all spawn points related to the trigger.";
	private _allInfantrySpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_SPAWN_POINT_%1_", _triggerId ] >= 0};
	private _allVehicleSpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_SPAWN_POINT_%1_", _triggerId ] >= 0};
	private _allAirSpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "AIR_SPAWN_POINT_%1_", _triggerId ] >= 0};

	diag_log "Getting all waypoints related to the trigger.";
	private _allInfantryWaypoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_WAYPOINT_%1_", _triggerId ] >= 0};
	private _allVehicleWaypoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_WAYPOINT_%1_", _triggerId ] >= 0};

	private _trigger_points = createHashMapFromArray [
		[
			"spawnpoints", createHashMapFromArray [
				[ "infantry", _allInfantrySpawnPoints ],
				[ "vehicle", _allVehicleSpawnPoints ],
				[ "air", _allAirSpawnPoints ]
			]
		],
		[
			"waypoints", createHashMapFromArray [
				[ "infantry", _allInfantryWaypoints ],
				[ "vehicle", _allVehicleWaypoints ]
			]
		]
	];

	diag_log format [ "Setting up activation side (%1) of trigger.", _activationSide ];
	_trigger setTriggerActivation [ _activationSide, "PRESENT", true ];
	diag_log "Setting up trigger.";
	_trigger setTriggerStatements [
		"this",
		
		"thisTrigger spawn CID_fnc_dynamicSpawnerActivated;",

		"thisTrigger spawn CID_fnc_dynamicSpawnerDeactivated;"
	];
	_trigger setVariable [ "_groups", _selectedSideSpawnGroups ];
	_trigger setVariable [ "_trigger_points", _trigger_points ];
	_trigger setVariable [ "_customScripts", _customScripts ];
	_trigger setVariable [ "_groupsToDespawn", createHashMap ];

	[ _trigger, "TriggerCreation" ] call CID_fnc_customScript;
}
else
{
	diag_log format [ "Trigger %1 doesn't need to be set up.", triggerText _trigger ];
};