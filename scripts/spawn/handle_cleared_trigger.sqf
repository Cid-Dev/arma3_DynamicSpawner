params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	[ "_extraScriptClearedTrigger", {}, [ {} ]],
	[ "_extraScriptClearedTriggerParams", [], [[]] ],
	[ "_deleteEverythingOnceCleared", true, [ true]],
	"_cleanupTrigger"
];

private _groupsTypeToDespawn = _trigger getVariable "_groupsToDespawn";
private _contains_alive_squads = _functions get "contains_alive_squads";

waitUntil
{
	sleep 10;
	private _stopCondition = true;
	{
		private _groupsToDespawn = _groupsTypeToDespawn get _x;
		_stopCondition = _stopCondition && { isNil "_groupsToDespawn" || { !([ _groupsToDespawn, _functions ] call _contains_alive_squads) } };
	} forEach [ "infantry", "vehicle", "air" ];
	_stopCondition;
};

private _customScriptParams = [ _trigger, _functions ];
_customScriptParams append _extraScriptClearedTriggerParams;
_customScriptParams call _extraScriptClearedTrigger;

if (_deleteEverythingOnceCleared) then
{
	_trigger call _cleanupTrigger;
};

diag_log "zone cleared!";