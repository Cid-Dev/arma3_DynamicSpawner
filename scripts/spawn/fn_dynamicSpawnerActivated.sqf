#include "spawn_constants.hpp"

// DynamicSpawn_WEST_EAST_5_6,8_2_4_1_1_1
params [
	[ "_trigger", objNull, [ objNull ] ]
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = _trigger getVariable "CID_triggerDatas";

private _activationSide = _triggerDatas get "ActivationSide";
private _spawnSide = (_triggerDatas get "SpawnSide") call CID_fnc_stringToSide;

private _detection_trigger = _trigger getVariable "_detection_trigger";

private _AmountsOfInfantrySquads = _triggerDatas get "AmountsOfInfantrySquads";
private _AmountsOfVehicleSquads = _triggerDatas get "AmountsOfVehicleSquads";
private _AmountsOfAirSquads = _triggerDatas get "AmountsOfAirSquads";

private _AmountsOfInfantryWaypoints = _triggerDatas get "AmountsOfInfantryWaypoints";
private _AmountsOfVehicleWaypoints = _triggerDatas get "AmountsOfVehicleWaypoints";

private _points = _trigger getVariable "_trigger_points";

private _spawnpoints = _points get "spawnpoints";

private _allInfantrySpawnPoints = _spawnpoints get "infantry";
private _allVehicleSpawnPoints = _spawnpoints get "vehicle";
private _allAirSpawnPoints = _spawnpoints get "air";

private _waypoints = _points get "waypoints";

private _allInfantryWaypoints = _waypoints get "infantry";
private _allVehicleWaypoints = _waypoints get "vehicle";

private _AmountOfInfantrySquads = _AmountsOfInfantrySquads call BIS_fnc_randomInt;
private _infantrySpawnPoints = [ _allInfantrySpawnPoints, _AmountOfInfantrySquads ] call CID_fnc_getNRandomElementsFromArray;

private _AmountOfVehicleSquads = _AmountsOfVehicleSquads call BIS_fnc_randomInt;
private _vehicleSpawnPoints = [ _allVehicleSpawnPoints, _AmountOfVehicleSquads ] call CID_fnc_getNRandomElementsFromArray;

private _AmountOfAirSquads = _AmountsOfAirSquads call BIS_fnc_randomInt;
private _airSpawnPoints = [ _allAirSpawnPoints, _AmountOfAirSquads ] call CID_fnc_getNRandomElementsFromArray;

private _groups = _trigger getVariable "_groups";
private _spawnedGroupsTypes = _trigger getVariable "_groupsToDespawn";

private _infantryGroups = [
	"INFANTRY",
	_groups,
	_infantrySpawnPoints,
	_spawnSide,
	RANK_PRIVATE,
	RANK_CAPTAIN,
	_AmountsOfInfantryWaypoints,
	_allInfantryWaypoints
] call CID_fnc_spawnLandUnits;

private _vehicleGroups = [
	"VEHICLE",
	_groups,
	_vehicleSpawnPoints,
	_spawnSide,
	RANK_LIEUTENANT,
	RANK_MAJOR,
	_AmountsOfVehicleWaypoints,
	_allVehicleWaypoints
] call CID_fnc_spawnLandUnits;


private _airGroups = [ _groups get "AIR", _airSpawnPoints, _trigger ] call CID_fnc_spawnAirUnits;

_spawnedGroupsTypes insert [ [ "infantry", _infantryGroups ], [ "vehicle", _vehicleGroups ], [ "air", _airGroups ] ];

_trigger setVariable [ "_groupsToDespawn", _spawnedGroupsTypes ];

[ _trigger, "TriggerActivated" ] call CID_fnc_customScript;

private _handleClearedTriggerScriptHandler = _trigger spawn CID_fnc_handleClearedTrigger;
_trigger setVariable [ "_handleClearedTriggerScriptHandler", _handleClearedTriggerScriptHandler ];