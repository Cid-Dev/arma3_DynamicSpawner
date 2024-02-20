#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	"_groups",
	"_activationCallback",
	"_deactivationCallback",
	[ "_extraScript", {}, [ {} ]],
	[ "_extraScriptParams", [], [[]] ],
	"_handleClearedTrigger",
	[ "_extraScriptClearedTrigger", {}, [ {} ]],
	[ "_extraScriptClearedTriggerParams", [], [[]] ],
	[ "_deleteEverythingOnceCleared", true, [ true ] ],
	"_cleanupTrigger",
	[ "_extraScriptActivated", {}, [ {} ]],
	[ "_extraScriptParamsActivated", [], [[]] ],
	[ "_extraScriptDeactivated", {}, [ {} ]],
	[ "_extraScriptParamsDeactivated", [], [[]] ]
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
	[ _activationSide, _spawnSide ] call (_functions get "checkSides");
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
		
		"private _functions = thisTrigger getVariable '_functions';
		private _activationCallback = thisTrigger getVariable '_activationCallback';
		private _cleanupTrigger = thisTrigger getVariable '_cleanupTrigger';
		[ thisTrigger, _functions, _cleanupTrigger ] spawn _activationCallback;",

		"private _functions = thisTrigger getVariable '_functions';
		private _deactivationCallback = thisTrigger getVariable '_deactivationCallback';
		[ thisTrigger, _functions ] spawn _deactivationCallback;"
	];
	_trigger setVariable [ "_functions", _functions ];
	_trigger setVariable [ "_groups", _selectedSideSpawnGroups ];
	_trigger setVariable [ "_activationCallback", _activationCallback ];
	_trigger setVariable [ "_trigger_points", _trigger_points ];
	_trigger setVariable [ "_deactivationCallback", _deactivationCallback ];
	_trigger setVariable [ "_handleClearedTrigger", _handleClearedTrigger ];
	_trigger setVariable [ "_extraScriptClearedTrigger", _extraScriptClearedTrigger ];
	_trigger setVariable [ "_extraScriptClearedTriggerParams", _extraScriptClearedTriggerParams ];
	_trigger setVariable [ "_deleteEverythingOnceCleared", _deleteEverythingOnceCleared ];
	_trigger setVariable [ "_cleanupTrigger", _cleanupTrigger ];
	_trigger setVariable [ "_extraScriptActivated", _extraScriptActivated ];
	_trigger setVariable [ "_extraScriptParamsActivated", _extraScriptParamsActivated ];
	_trigger setVariable [ "_extraScriptDeactivated", _extraScriptDeactivated ];
	_trigger setVariable [ "_extraScriptParamsDeactivated", _extraScriptParamsDeactivated ];
	_trigger setVariable [ "_groupsToDespawn", createHashMap ];
	private _customScriptParams = [ _trigger, _functions ];
	_customScriptParams append _extraScriptParams;
	_customScriptParams call _extraScript;
}
else
{
	diag_log format [ "Trigger %1 doesn't need to be set up.", triggerText _trigger ];
};