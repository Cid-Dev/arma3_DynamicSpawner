#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ]
];

private _groupsTypeToDespawn = _trigger getVariable "_groupsToDespawn";

waitUntil
{
	sleep 10;

	!([ "infantry", "vehicle", "air" ] findIf {
		private _groupsToDespawn = _groupsTypeToDespawn get _x;
		!isNil "_groupsToDespawn" && { ([ _groupsToDespawn ] call CID_fnc_containsAliveSquads) }
	} != -1);
};

[ _trigger, "TriggerCleared" ] call CID_fnc_customScript;

if (([ "TriggerDeletionOnceCleared", DELETE_TRIGGER_ONCE_CLEARED_YES ] call BIS_fnc_getParamValue) == DELETE_TRIGGER_ONCE_CLEARED_YES) then
{
	_trigger call CID_fnc_cleanupTrigger;
};