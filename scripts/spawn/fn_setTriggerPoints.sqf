params [
	[ "_trigger", objNull, [ objNull ] ]
];

private _triggerId = (_trigger getVariable "CID_triggerDatas") get "TriggerId";

private _allInfantrySpawnPoints = [ "INFANTRY", "SPAWN_POINT", _triggerId ] call CID_fnc_fetchTriggerPoint;
private _allVehicleSpawnPoints = [ "VEHICLE", "SPAWN_POINT", _triggerId ] call CID_fnc_fetchTriggerPoint;
private _allAirSpawnPoints = [ "AIR", "SPAWN_POINT", _triggerId ] call CID_fnc_fetchTriggerPoint;

private _allInfantryWaypoints = [ "INFANTRY", "WAYPOINT", _triggerId ] call CID_fnc_fetchTriggerPoint;
private _allVehicleWaypoints = [ "VEHICLE", "WAYPOINT", _triggerId ] call CID_fnc_fetchTriggerPoint;
private _allAirWaypoints = [ "AIR", "WAYPOINT", _triggerId ] call CID_fnc_fetchTriggerPoint;

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
			[ "vehicle", _allVehicleWaypoints ],
			[ "air", _allAirWaypoints ]
		]
	]
];

_trigger setVariable [ "_trigger_points", _trigger_points ];