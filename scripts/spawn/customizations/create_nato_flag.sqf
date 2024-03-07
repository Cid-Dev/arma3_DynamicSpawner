params [
	[ "_trigger", objNull, [ objNull ] ],
	"_createMarkerFlag"
];

private _triggerId = (_trigger getVariable "CID_triggerDatas") get "TriggerId";

private _flagPosition = getPos _trigger;

_trigger setVariable [ "_flag", [ _triggerId, _flagPosition, "flag_NATO" ] call _createMarkerFlag ];