#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ]
];

private _points = _trigger getVariable "_trigger_points";

private _spawnpoints = _points get "spawnpoints";
private _waypoints = _points get "waypoints";

private _pointsToDelete = _spawnpoints get "infantry";
_pointsToDelete append (_spawnpoints get "vehicle");
_pointsToDelete append (_spawnpoints get "air");
_pointsToDelete append (_waypoints get "infantry");
_pointsToDelete append (_waypoints get "vehicle");
_pointsToDelete append (_waypoints get "air");

{
	deleteVehicle _x;
} forEach _pointsToDelete;

private _detection_trigger = _trigger getVariable "_detection_trigger";
if (!isNil '_detection_trigger') then
{
	_trigger setVariable [ "_detection_trigger", nil ];
	deleteVehicle _detection_trigger;
};

deleteVehicle _trigger;