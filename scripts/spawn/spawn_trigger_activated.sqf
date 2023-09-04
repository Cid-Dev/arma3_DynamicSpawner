#define NUMBER_OF_PARTS 10
#define INDEX_OF_ACTIVATION_SIDE 1
#define INDEX_OF_SPAWN_SIDE 2
#define INDEX_OF_AMOUNT_OF_INFANTRY_SQUADS 3
#define INDEX_OF_AMOUNT_OF_INFANTRY_WAYPOINTS 4
#define INDEX_OF_AMOUNT_OF_VEHICLE_SQUADS 5
#define INDEX_OF_AMOUNT_OF_VEHICLE_WAYPOINTS 6
#define INDEX_OF_AMOUNT_OF_AIR_SQUADS 7
#define INDEX_OF_AMOUNT_OF_AIR_WAYPOINTS 8
#define INDEX_OF_TRIGGER_ID 9
#define RANK_PRIVATE 0
#define RANK_CAPTAIN 4
// DynamicSpawn_WEST_EAST_5_6,8_2_4_1_1_1
params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	"_cleanupTrigger"
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerText = triggerText _trigger;
diag_log format [ "Trigger %1 activated.", _triggerText ];

private _triggerDatas = _triggerText splitString "_";
diag_log format [ "Trigger datas : %1", str _triggerDatas ];
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _checkSides = _functions get "checkSides";
	private _activationSide = _triggerDatas select INDEX_OF_ACTIVATION_SIDE;
	private _spawnSideName = _triggerDatas select INDEX_OF_SPAWN_SIDE;
	diag_log format [ "Checking activation side %1 and spawn side %2 of trigger.", _activationSide, _spawnSide ];
	[ _activationSide, _spawnSideName ] call _checkSides;

	private _string_to_side = _functions get "string_to_side";
	private _spawnSide = _spawnSideName call _string_to_side;

	diag_log "Getting amount of different squads.";
	private _AmountOfInfantrySquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_SQUADS);
	private _AmountOfVehicleSquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_SQUADS);
	private _AmountOfAirSquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_AIR_SQUADS);
	diag_log format [ "%1 infantry squads, %2 vehicle squads and %3 air squads are going to be spawned.", str _AmountOfInfantrySquads, str _AmountOfVehicleSquads, str _AmountOfAirSquads ];
	private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;

	
	private _string_array_to_int_array = _functions get "string_array_to_int_array";
	private _AmountsOfInfantryWaypointsStr = (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_WAYPOINTS) splitString ",";
	diag_log format [ "inf wp : %1", str _AmountsOfInfantryWaypointsStr ];
	private _AmountsOfInfantryWaypoints = [ _AmountsOfInfantryWaypointsStr ] call _string_array_to_int_array;
	if (count _AmountsOfInfantryWaypoints == 1) then
	{
		_AmountsOfInfantryWaypoints pushBack (_AmountsOfInfantryWaypoints select 0);
	};

/*
	private _AmountsOfVehicleWaypoints = ((_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_WAYPOINTS) splitString ",") call _string_array_to_int_array;
	if (count _AmountsOfVehicleWaypoints == 1) then
	{
		_AmountsOfVehicleWaypoints pushBack (_AmountsOfVehicleWaypoints select 0);
	};
	//private _AmountOfVehicleWaypoints = _AmountsOfVehicleWaypoints call BIS_fnc_randomInt;

	private _AmountsOfAirWaypoints = ((_triggerDatas select INDEX_OF_AMOUNT_OF_AIR_WAYPOINTS) splitString ",") call _string_array_to_int_array;
	if (count _AmountsOfAirWaypoints == 1) then
	{
		_AmountsOfAirWaypoints pushBack (_AmountsOfAirWaypoints select 0);
	};
	//private _AmountOfAirWaypoints = _AmountsOfAirWaypoints call BIS_fnc_randomInt;
*/
	diag_log "Getting all spawn points related to the trigger.";
	private _allInfantrySpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_SPAWN_POINT_%1", _triggerId ] >= 0};
	private _allVehicleSpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_SPAWN_POINT_%1", _triggerId ] >= 0};
	private _allAirSpawnPoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "AIR_SPAWN_POINT_%1", _triggerId ] >= 0};

	diag_log "Getting all waypoints related to the trigger.";
	private _allInfantryWaypoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_WAYPOINT_%1", _triggerId ] >= 0};
	private _allVehicleWaypoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_WAYPOINT_%1", _triggerId ] >= 0};
	private _allAirWaypoints = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "AIR_WAYPOINT_%1", _triggerId ] >= 0};

	private _get_n_random_elements_from_array = _functions get "get_n_random_elements_from_array";

	diag_log "Getting the desired amount of spawn points for each squads types (caped by the amount of available points).";
	private _infantrySpawnPoints = [ _allInfantrySpawnPoints, _AmountOfInfantrySquads ] call _get_n_random_elements_from_array;
	private _vehicleSpawnPoints = [ _allVehicleSpawnPoints, _AmountOfVehicleSquads ] call _get_n_random_elements_from_array;
	private _airSpawnPoints = [ _allAirSpawnPoints, _AmountOfAirSquads ] call _get_n_random_elements_from_array;
	diag_log format [ "Got %1 infantry squads spawn points, %2 vehicle squads spawn points and %3 air squads spawn points.", str count _infantrySpawnPoints, str count _vehicleSpawnPoints, str count _airSpawnPoints ];

	diag_log "Getting the desired amount of waypoints for each squads types (caped by the amount of available points).";
	//private _triggerDatas = _triggerText splitString "_";
	diag_log format [ "Got %1 infantry squads waypoints, %2 vehicle squads waypoints and %3 air squads waypoints.", str count _infantrySpawnPoints, str count _vehicleSpawnPoints, str count _airSpawnPoints ];

	diag_log "Spawning infantry squads.";
	private _groups = _trigger getVariable "_groups";
	private _infantryGroups = [ _groups get "INFANTRY", count _infantrySpawnPoints, false ] call _get_n_random_elements_from_array;
	private _amountOfInfantryGroupsToSpawn = count _infantryGroups - 1;

	private _spawnedGroups = _trigger getVariable "_groupsToDespawn";
	private _loop_waypoints_to_a_group = _functions get "loop_waypoints_to_a_group";
	private _loop_waypoints_to_a_group_file_path = _functions get "loop_waypoints_to_a_group_file_path";

	for "_i" from 0 to _amountOfInfantryGroupsToSpawn do {
		diag_log format [ "Spawning group %1.", str _i ];
		private _groupToSpawn = [
			getPosATL (_infantrySpawnPoints select _i),
			_spawnSide,
			_infantryGroups select _i,
			[],
			[],
			[ RANK_PRIVATE, RANK_CAPTAIN ],
			[],
			[],
			floor random 360
		] call BIS_fnc_spawnGroup;
		_groupToSpawn deleteGroupWhenEmpty true;
		diag_log format [ "Group %1 is %2.", str _i, groupId _groupToSpawn ];
		_spawnedGroups pushBack _groupToSpawn;

		diag_log "Getting amount of different waypoints.";
		private _AmountOfInfantryWaypoints = _AmountsOfInfantryWaypoints call BIS_fnc_randomInt;
		diag_log format [ "%1 infantry waypoints are going to be used.", str _AmountOfInfantryWaypoints ];
		private _waypoints = [ _allInfantryWaypoints, _AmountOfInfantryWaypoints ] call _get_n_random_elements_from_array;
		_groupToSpawn setVariable [ "_waypoints", _waypoints ];
		_groupToSpawn setVariable [ "_loop_waypoints_to_a_group_file_path", _loop_waypoints_to_a_group_file_path ];
		diag_log "Setting up waypoints.";
		[ _groupToSpawn, 0 ] call _loop_waypoints_to_a_group;
	};
	_trigger setVariable [ "_groupsToDespawn", _spawnedGroups ];
	private _spawnedGroups = _trigger getVariable "_groupsToDespawn";

	private _handleClearedTrigger = _trigger getVariable "_handleClearedTrigger";
	private _extraScriptClearedTrigger = _trigger getVariable "_extraScriptClearedTrigger";
	private _extraScriptClearedTriggerParams = _trigger getVariable "_extraScriptClearedTriggerParams";
	private _deleteEverythingOnceCleared = _trigger getVariable "_deleteEverythingOnceCleared";
	private _clearedZoneHandler = [ _trigger, _functions, _extraScriptClearedTrigger, _extraScriptClearedTriggerParams, _deleteEverythingOnceCleared, _cleanupTrigger ] spawn _handleClearedTrigger;
	_trigger setVariable [ "_clearedZoneHandler", _clearedZoneHandler ];
};