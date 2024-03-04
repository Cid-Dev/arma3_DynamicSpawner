#include "spawn_constants.hpp"

// DynamicSpawn_WEST_EAST_5_6,8_2_4_1_1_1
params [
	[ "_trigger", objNull, [ objNull ] ]
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
	private _activationSide = _triggerDatas select INDEX_OF_ACTIVATION_SIDE;
	private _spawnSideName = _triggerDatas select INDEX_OF_SPAWN_SIDE;
	[ _activationSide, _spawnSideName ] call CID_fnc_checkSides;

	private _spawnSide = _spawnSideName call CID_fnc_stringToSide;

	diag_log format [ "Checking activation side %1 and spawn side %2 of trigger.", _activationSide, _spawnSide ];

	
	private _detection_trigger = createTrigger [ "EmptyDetector", getPos _trigger ];
	_triggerArea = triggerArea _trigger;
	_detection_trigger setTriggerArea _triggerArea;
	_detection_trigger setTriggerActivation [ _activationSide, format [ "%1 D", _spawnSide ], true ];
	_detection_trigger setTriggerStatements [
		"this",
		
		"private _airGroups = thisTrigger getVariable '_airGroups';
		private _triggerPosition = getPos thisTrigger;
		
		for '_i' from 0 to count _airGroups - 1 do {
			private _group = _airGroups select _i;
			if (_group call CID_fnc_containsAliveUnits) then
			{
				for '_j' from 0 to count thisList - 1 do {
					private _detectedUnit = thisList select _j;
					private _detectedUnitPosition = getPos _detectedUnit;
					private _waypoint = _group addWaypoint [ _detectedUnitPosition, 0 ];
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
		};

		[ thisTrigger, 'TriggerDetected' ] call CID_fnc_customScript;",
		
		"[ thisTrigger, 'TriggerUndetected' ] call CID_fnc_customScript;"
	];

	private _customScripts = _trigger getVariable '_customScripts';
	_detection_trigger setVariable [ "_customScripts", _customScripts ];
	_detection_trigger setVariable [ "_trigger", _trigger ];

	_trigger setVariable [ "_detection_trigger", _detection_trigger ];

	diag_log "Getting amount of different squads.";
	private _AmountOfInfantrySquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_SQUADS);
	private _AmountOfVehicleSquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_SQUADS);
	private _AmountOfAirSquads = parseNumber (_triggerDatas select INDEX_OF_AMOUNT_OF_AIR_SQUADS);
	diag_log format [ "%1 infantry squads, %2 vehicle squads and %3 air squads are going to be spawned.", str _AmountOfInfantrySquads, str _AmountOfVehicleSquads, str _AmountOfAirSquads ];
	private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;

	private _AmountsOfInfantryWaypointsStr = (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_WAYPOINTS) splitString ",";
	private _AmountsOfInfantryWaypoints = [ _AmountsOfInfantryWaypointsStr ] call CID_fnc_stringArrayToIntArray;
	if (count _AmountsOfInfantryWaypoints == 1) then
	{
		_AmountsOfInfantryWaypoints pushBack (_AmountsOfInfantryWaypoints select 0);
	};

	private _AmountsOfVehicleWaypointsStr = (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_WAYPOINTS) splitString ",";
	private _AmountsOfVehicleWaypoints = [ _AmountsOfVehicleWaypointsStr ] call CID_fnc_stringArrayToIntArray;
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

	diag_log "Getting the desired amount of spawn points for each squads types (caped by the amount of available points).";
	private _infantrySpawnPoints = [ _allInfantrySpawnPoints, _AmountOfInfantrySquads ] call CID_fnc_getNRandomElementsFromArray;
	private _vehicleSpawnPoints = [ _allVehicleSpawnPoints, _AmountOfVehicleSquads ] call CID_fnc_getNRandomElementsFromArray;
	private _airSpawnPoints = [ _allAirSpawnPoints, _AmountOfAirSquads ] call CID_fnc_getNRandomElementsFromArray;
	diag_log format [ "Got %1 infantry squads spawn points, %2 vehicle squads spawn points and %3 air squads spawn points.", str count _infantrySpawnPoints, str count _vehicleSpawnPoints, str count _airSpawnPoints ];

	private _groups = _trigger getVariable "_groups";
	private _spawnedGroupsTypes = _trigger getVariable "_groupsToDespawn";

	private _spawnLandUnits = {
		params [
			"_typeOfSquadForLogMessage",
			"_hashMapKey",
			"_groups",
			"_landUnitsSpawnPoints",
			"_spawnSide",
			"_minRank",
			"_maxRank",
			"_AmountsOfLandUnitsWaypoints",
			"_allLandUnitsWaypoints"
		];
		diag_log format [ "Spawning %1 squads.", _typeOfSquadForLogMessage ];
		private _landUnitsGroup = [ _groups get _hashMapKey, count _landUnitsSpawnPoints, false ] call CID_fnc_getNRandomElementsFromArray;
		private _amountOfLandUnitsToSpawn = count _landUnitsGroup - 1;
		private _spawnedGroups = [];

		for "_i" from 0 to _amountOfLandUnitsToSpawn do {
			diag_log format [ "Spawning group %1.", str _i ];
			private _ranks = [];
			private _selectedGroup = _landUnitsGroup select _i;
			if (typeName _selectedGroup != typeName configFile) then
			{
				for "_j" from 0 to (count _selectedGroup) - 1 do
				{
					_ranks pushBack (floor random (_maxRank - _minRank)) + _minRank;
				};

				_ranks sort false;
			};

			private _groupToSpawn = [
				getPosATL (_landUnitsSpawnPoints select _i),
				_spawnSide,
				_selectedGroup,
				[],
				_ranks,
				[],
				[],
				[],
				floor random 360
			] call BIS_fnc_spawnGroup;

			diag_log format [ "generated %1", _groupToSpawn];

			_groupToSpawn setBehaviourStrong "SAFE";
			_groupToSpawn setSpeedMode "LIMITED";
			_groupToSpawn deleteGroupWhenEmpty true;

			private _units = units _groupToSpawn;
			for "_j" from 0 to (count _units) - 1 do
			{
				diag_log format [ "setting up body removal for unit %1", _j];

				(_units select _j) addEventHandler ["Killed", {
					params ["_unit", "_killer", "_instigator", "_useEffects"];
					
					// remove body after 10 minutes
					_unit spawn {
						params [ "_unitToRemove" ];
						sleep 600;
						if (!isNil "_unitToRemove" && { !isNull _unitToRemove && { !alive _unitToRemove } }) then
						{
							deleteVehicle _unitToRemove;
						}
					};
				}];
			};

			diag_log format [ "Group %1 is %2.", str _i, groupId _groupToSpawn ];
			_spawnedGroups pushBack _groupToSpawn;

			diag_log "Getting amount of different waypoints.";
			private _AmountOfLandUnitsWaypoints = _AmountsOfLandUnitsWaypoints call BIS_fnc_randomInt;
			diag_log format [ "%1 %2 waypoints are going to be used.", str _AmountOfLandUnitsWaypoints, _typeOfSquadForLogMessage ];
			private _waypoints = [ _allLandUnitsWaypoints, _AmountOfLandUnitsWaypoints ] call CID_fnc_getNRandomElementsFromArray;
			diag_log format [ "waypoints %1", _waypoints];
			_groupToSpawn setVariable [ "_waypoints", _waypoints ];
			diag_log "Setting up waypoints.";
			[ _groupToSpawn, 0 ] call CID_fnc_loopWaypointsToAGroup;
		};
		_spawnedGroups;
	};

	private _infantryGroups = [
		"infantry",
		"INFANTRY",
		_groups,
		_infantrySpawnPoints,
		_spawnSide,
		RANK_PRIVATE,
		RANK_CAPTAIN,
		_AmountsOfInfantryWaypoints,
		_allInfantryWaypoints
	] call _spawnLandUnits;

	private _vehicleGroups = [
		"vehicle",
		"VEHICLE",
		_groups,
		_vehicleSpawnPoints,
		_spawnSide,
		RANK_LIEUTENANT,
		RANK_MAJOR,
		_AmountsOfVehicleWaypoints,
		_allVehicleWaypoints
	] call _spawnLandUnits;


	diag_log "Spawning air vehicles.";
	private _airUnitsGroup = [ _groups get "AIR", count _airSpawnPoints, false ] call CID_fnc_getNRandomElementsFromArray;
	private _amountOfAirUnitsToSpawn = count _airUnitsGroup - 1;
	private _airGroups = [];
	if (_amountOfAirUnitsToSpawn >= 0) then
	{
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
			
			_groupToSpawn setBehaviourStrong "SAFE";
			_groupToSpawn setSpeedMode "LIMITED";

			_groupToSpawn deleteGroupWhenEmpty true;
			diag_log format [ "Group %1 is %2.", str _i, groupId _groupToSpawn ];
			_airGroups pushBack _groupToSpawn;

			private _triggerPosition = getPos _trigger;

			private _waypoint = _groupToSpawn addWaypoint [ [ _triggerPosition select 0, _triggerPosition select 1, 250 ], 0 ];
			_waypoint setWaypointType "LOITER";
			_waypoint setWaypointLoiterType "CIRCLE_L";
			_waypoint setWaypointLoiterRadius 500;
		};

		_detection_trigger setVariable [ "_airGroups", _airGroups ];
	};

	_spawnedGroupsTypes insert [ [ "infantry", _infantryGroups ], [ "vehicle", _vehicleGroups ], [ "air", _airGroups ] ];

	_trigger setVariable [ "_groupsToDespawn", _spawnedGroupsTypes ];

	[ _trigger, "TriggerActivated" ] call CID_fnc_customScript;

	private _handleClearedTriggerScriptHandler = _trigger spawn CID_fnc_handleClearedTrigger;
	_trigger setVariable [ "_handleClearedTriggerScriptHandler", _handleClearedTriggerScriptHandler ];
};
