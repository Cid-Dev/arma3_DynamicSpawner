params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	[ "_extraScriptClearedTrigger", {}, [ {} ]],
	[ "_extraScriptClearedTriggerParams", [], [[]] ],
	[ "_deleteEverythingOnceCleared", true, [ true]],
	"_cleanupTrigger"
];

private _groupsToDespawn = _trigger getVariable "_groupsToDespawn";
private _amountOfGroupsToDespawn = count _groupsToDespawn - 1;
private _contains_alive_squads = _functions get "contains_alive_squads";

waitUntil
{
	sleep 10;
	isNil "_groupsToDespawn" || { !([ _groupsToDespawn, _functions ] call _contains_alive_squads) };
};

if (!isNil "_extraScriptClearedTrigger") then
{
	
	private _customScriptParams = [ _trigger, _functions ];
	_customScriptParams append _extraScriptClearedTriggerParams;
	_customScriptParams call _extraScriptClearedTrigger;
};

if (_deleteEverythingOnceCleared) then
{
	_trigger call _cleanupTrigger;
};

diag_log "zone cleared!";