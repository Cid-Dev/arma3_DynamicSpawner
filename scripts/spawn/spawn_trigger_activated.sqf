#include "spawn_constants.hpp"

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
	private _AmountsOfInfantryWaypoints = [ _AmountsOfInfantryWaypointsStr ] call _string_array_to_int_array;
	if (count _AmountsOfInfantryWaypoints == 1) then
	{
		_AmountsOfInfantryWaypoints pushBack (_AmountsOfInfantryWaypoints select 0);
	};

	private _AmountsOfVehicleWaypointsStr = (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_WAYPOINTS) splitString ",";
	private _AmountsOfVehicleWaypoints = [ _AmountsOfVehicleWaypointsStr ] call _string_array_to_int_array;
	if (count _AmountsOfVehicleWaypoints == 1) then
	{
		_AmountsOfVehicleWaypoints pushBack (_AmountsOfVehicleWaypoints select 0);
	};

	private _points = _trigger getVariable "_trigger_points";

	private _spawnpoints = _points get "spawnpoints";

	private _allInfantrySpawnPoints = _spawnpoints get "infantry";
	private _allVehicleSpawnPoints = _spawnpoints get "vehicle";
	private _allAirSpawnPoints = _spawnpoints get "air";

	private _waypoints = _points get "waypoints";

	private _allInfantryWaypoints = _waypoints get "infantry";
	private _allVehicleWaypoints = _waypoints get "vehicle";

	private _get_n_random_elements_from_array = _functions get "get_n_random_elements_from_array";

	diag_log "Getting the desired amount of spawn points for each squads types (caped by the amount of available points).";
	private _infantrySpawnPoints = [ _allInfantrySpawnPoints, _AmountOfInfantrySquads ] call _get_n_random_elements_from_array;
	private _vehicleSpawnPoints = [ _allVehicleSpawnPoints, _AmountOfVehicleSquads ] call _get_n_random_elements_from_array;
	private _airSpawnPoints = [ _allAirSpawnPoints, _AmountOfAirSquads ] call _get_n_random_elements_from_array;
	diag_log format [ "Got %1 infantry squads spawn points, %2 vehicle squads spawn points and %3 air squads spawn points.", str count _infantrySpawnPoints, str count _vehicleSpawnPoints, str count _airSpawnPoints ];

	private _groups = _trigger getVariable "_groups";
	private _spawnedGroups = _trigger getVariable "_groupsToDespawn";
	private _loop_waypoints_to_a_group = _functions get "loop_waypoints_to_a_group";
	private _loop_waypoints_to_a_group_file_path = _functions get "loop_waypoints_to_a_group_file_path";

	private _spawnLandUnits = {
		params [
			"_typeOfSquadForLogMessage",
			"_hashMapKey",
			"_groups",
			"_landUnitsSpawnPoints",
			"_get_n_random_elements_from_array",
			"_spawnSide",
			"_minRank",
			"_maxRank",
			"_spawnedGroups",
			"_AmountsOfLandUnitsWaypoints",
			"_allLandUnitsWaypoints",
			"_loop_waypoints_to_a_group_file_path",
			"_loop_waypoints_to_a_group"
		];
		diag_log format [ "Spawning %1 squads.", _typeOfSquadForLogMessage ];
		private _landUnitsGroup = [ _groups get _hashMapKey, count _landUnitsSpawnPoints, false ] call _get_n_random_elements_from_array;
		private _amountOfLandUnitsToSpawn = count _landUnitsGroup - 1;
		for "_i" from 0 to _amountOfLandUnitsToSpawn do {
			diag_log format [ "Spawning group %1.", str _i ];
			private _groupToSpawn = [
				getPosATL (_landUnitsSpawnPoints select _i),
				_spawnSide,
				_landUnitsGroup select _i,
				[],
				[],
				[ _minRank, _maxRank ],
				[],
				[],
				floor random 360
			] call BIS_fnc_spawnGroup;
			_groupToSpawn deleteGroupWhenEmpty true;
			diag_log format [ "Group %1 is %2.", str _i, groupId _groupToSpawn ];
			_spawnedGroups pushBack _groupToSpawn;

			diag_log "Getting amount of different waypoints.";
			private _AmountOfLandUnitsWaypoints = _AmountsOfLandUnitsWaypoints call BIS_fnc_randomInt;
			diag_log format [ "%1 %2 waypoints are going to be used.", str _AmountOfLandUnitsWaypoints, _typeOfSquadForLogMessage ];
			private _waypoints = [ _allLandUnitsWaypoints, _AmountOfLandUnitsWaypoints ] call _get_n_random_elements_from_array;
			_groupToSpawn setVariable [ "_waypoints", _waypoints ];
			_groupToSpawn setVariable [ "_loop_waypoints_to_a_group_file_path", _loop_waypoints_to_a_group_file_path ];
			diag_log "Setting up waypoints.";
			[ _groupToSpawn, 0 ] call _loop_waypoints_to_a_group;
		};
	};

	[
		"infantry",
		"INFANTRY",
		_groups,
		_infantrySpawnPoints,
		_get_n_random_elements_from_array,
		_spawnSide,
		RANK_PRIVATE,
		RANK_CAPTAIN,
		_spawnedGroups,
		_AmountsOfInfantryWaypoints,
		_allInfantryWaypoints,
		_loop_waypoints_to_a_group_file_path,
		_loop_waypoints_to_a_group
	] call _spawnLandUnits;

	[
		"vehicle",
		"VEHICLE",
		_groups,
		_vehicleSpawnPoints,
		_get_n_random_elements_from_array,
		_spawnSide,
		RANK_LIEUTENANT,
		RANK_MAJOR,
		_spawnedGroups,
		_AmountsOfVehicleWaypoints,
		_allVehicleWaypoints,
		_loop_waypoints_to_a_group_file_path,
		_loop_waypoints_to_a_group
	] call _spawnLandUnits;


	diag_log "Spawning air vehicles.";
	private _airUnitsGroup = [ _groups get "AIR", count _airSpawnPoints, false ] call _get_n_random_elements_from_array;
	private _amountOfAirUnitsToSpawn = count _airUnitsGroup - 1;
	if (_amountOfAirUnitsToSpawn >= 0) then
	{
		private _detection_trigger = createTrigger [ "EmptyDetector", getPos _trigger ];
		_triggerArea = triggerArea _trigger;
		_detection_trigger setTriggerArea _triggerArea;
		_detection_trigger setTriggerActivation [ _activationSide, format [ "%1 D", _spawnSide ], true ];
		_detection_trigger setTriggerStatements [
			"this",
			
			"private _groups = thisTrigger getVariable '_groups';
			private _contains_alive_units = thisTrigger getVariable '_contains_alive_units';
			private _triggerPosition = getPos thisTrigger;
			
			for '_i' from 0 to count _groups - 1 do {
				private _group = _groups select _i;
				if (_group call _contains_alive_units) then
				{
					for '_j' from 0 to count thisList - 1 do {
						private _detectedUnit = thisList select _j;
						private _detectedUnitPosition = getPos _detectedUnit;
						private _waypoint = _group addWaypoint [ [ _detectedUnitPosition select 0, _detectedUnitPosition select 1, 250 ], 0 ];
						_waypoint setWaypointType 'SAD';

						private _index = currentWaypoint _group;
						private _type = waypointType [ _group, _index ];

						for '_k' from (count waypoints _group - 1) to (_index + 1) step -1 do {
							if (waypointType [ _group, _k ] in [ '', 'LOITER' ]) then
							{
								deleteWaypoint [ _group, _k ];
							};
						};

						if (_type in [ '', 'LOITER' ]) then
						{
							_group setCurrentWaypoint [ _group, _index + 1 ];
						};
					};
					private _loiterWaypoint = _group addWaypoint [ [ _triggerPosition select 0, _triggerPosition select 1, 250 ], 0 ];
					_loiterWaypoint setWaypointType 'LOITER';
					_loiterWaypoint setWaypointLoiterType 'CIRCLE_L';
					_loiterWaypoint setWaypointLoiterRadius 500;
				};
			};",
			
			""
		];

		private _airGroups = [];

		for "_i" from 0 to _amountOfAirUnitsToSpawn do {
			diag_log format [ "Spawning group %1.", str _i ];
			private _spawnPointPosition = getPosATL (_airSpawnPoints select _i);

			private _spawnedAircraft = [
				[ _spawnPointPosition select 0, _spawnPointPosition select 1, 1000 ],
				_spawnPointPosition getDir _trigger,
				_airUnitsGroup select _i,
				_spawnSide
			] call BIS_fnc_spawnVehicle;

			private _groupToSpawn = _spawnedAircraft select 2;

			_groupToSpawn setCombatMode "RED";

			_groupToSpawn deleteGroupWhenEmpty true;
			diag_log format [ "Group %1 is %2.", str _i, groupId _groupToSpawn ];
			_spawnedGroups pushBack _groupToSpawn;
			_airGroups pushBack _groupToSpawn;

			private _triggerPosition = getPos _trigger;

			private _waypoint = _groupToSpawn addWaypoint [ [ _triggerPosition select 0, _triggerPosition select 1, 250 ], 0 ];
			_waypoint setWaypointType "LOITER";
			_waypoint setWaypointLoiterType "CIRCLE_L";
			_waypoint setWaypointLoiterRadius 500;
		};

		private _contains_alive_units = _functions get 'contains_alive_units';
		_detection_trigger setVariable [ "_groups", _airGroups ];
		_detection_trigger setVariable [ "_contains_alive_units", _contains_alive_units ];

		_trigger setVariable [ "_detection_trigger", _detection_trigger ];
	};
	_trigger setVariable [ "_groupsToDespawn", _spawnedGroups ];
	private _spawnedGroups = _trigger getVariable "_groupsToDespawn";

	private _handleClearedTrigger = _trigger getVariable "_handleClearedTrigger";
	private _extraScriptClearedTrigger = _trigger getVariable "_extraScriptClearedTrigger";
	private _extraScriptClearedTriggerParams = _trigger getVariable "_extraScriptClearedTriggerParams";
	private _deleteEverythingOnceCleared = _trigger getVariable "_deleteEverythingOnceCleared";

	private _extraScriptActivated = _trigger getVariable '_extraScriptActivated';
	private _extraScriptParamsActivated = _trigger getVariable '_extraScriptParamsActivated';
	private _customScriptParams = [ _trigger, _functions ];
	_customScriptParams append _extraScriptParamsActivated;
	_customScriptParams call _extraScriptActivated;

	private _clearedZoneHandler = [ _trigger, _functions, _extraScriptClearedTrigger, _extraScriptClearedTriggerParams, _deleteEverythingOnceCleared, _cleanupTrigger ] spawn _handleClearedTrigger;
	_trigger setVariable [ "_clearedZoneHandler", _clearedZoneHandler ];
};