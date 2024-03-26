params [
	"_airGroups",
	"_airSpawnPoints",
	"_trigger"
];

private _airUnitsGroups = [ _airGroups, count _airSpawnPoints, false ] call CID_fnc_getNRandomElementsFromArray;

private _amountOfAirUnitsToSpawn = count _airUnitsGroups - 1;
private _airGroups = [];
if (_amountOfAirUnitsToSpawn >= 0) then
{
	private _spawnSide = ((_trigger getVariable "CID_triggerDatas") get "SpawnSide") call CID_fnc_stringToSide;
	private _detection_trigger = _trigger getVariable "_detection_trigger";

	for "_i" from 0 to _amountOfAirUnitsToSpawn do {

		private _spawnPointPosition = getPosATL (_airSpawnPoints select _i);

		private _spawnedAircraft = [
			[ _spawnPointPosition select 0, _spawnPointPosition select 1, 1000 ],
			_spawnPointPosition getDir _trigger,
			_airUnitsGroups select _i,
			_spawnSide
		] call BIS_fnc_spawnVehicle;

		private _groupToSpawn = _spawnedAircraft select 2;

		_groupToSpawn setCombatMode "RED";
		
		_groupToSpawn setBehaviourStrong "SAFE";
		_groupToSpawn setSpeedMode "LIMITED";

		_groupToSpawn deleteGroupWhenEmpty true;

		_airGroups pushBack _groupToSpawn;

		private _triggerPosition = getPos _trigger;

		private _loiterAltitude = [ 75, 200] select ((_airUnitsGroups select _i) isKindOf "PLANE");
		private _waypoint = _groupToSpawn addWaypoint [ _triggerPosition, 0 ];
		_waypoint setWaypointType "LOITER";
		_waypoint setWaypointLoiterType "CIRCLE_L";
		_waypoint setWaypointLoiterRadius 500;
		_waypoint setWaypointLoiterAltitude _loiterAltitude;

		_groupToSpawn setVariable [ "CID_LoiterPosition", _triggerPosition ];
		_groupToSpawn setVariable [ "CID_LoiterAltitude", _loiterAltitude ];

		_groupToSpawn addEventHandler ["EnemyDetected", {
			params ["_group", "_newTarget"];

			private _currentWaypoints = waypoints _group;

			{
				private _waypoint = _x;
				private _type = waypointType _waypoint;
				if (_type in [ '', 'LOITER', 'MOVE' ]) then
				{
					deleteWaypoint _waypoint;
				};
			} forEachReversed _currentWaypoints;

			private _detectedUnitPosition = getPosASL _newTarget;

			private _waypoint = _group addWaypoint [ _detectedUnitPosition, 0 ];
			_waypoint setWaypointType 'SAD';

			private _loiterPosition = _group getVariable "CID_LoiterPosition";
			private _loiterAltitude = _group getVariable "CID_LoiterAltitude";
			private _loiterWaypoint = _group addWaypoint [ _loiterPosition, 0 ];
			_loiterWaypoint setWaypointType "LOITER";
			_loiterWaypoint setWaypointLoiterType "CIRCLE_L";
			_loiterWaypoint setWaypointLoiterRadius 500;
			_loiterWaypoint setWaypointLoiterAltitude _loiterAltitude;
		}];

		_groupToSpawn call CID_fnc_setGroupCleanUp;
	};

	_detection_trigger setVariable [ "_airGroups", _airGroups ];
};
_airGroups;