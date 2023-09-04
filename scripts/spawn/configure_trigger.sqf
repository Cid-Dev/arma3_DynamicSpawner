#define NUMBER_OF_PARTS 10
#define INDEX_OF_ACTIVATION_SIDE 1
#define INDEX_OF_SPAWN_SIDE 2

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	"_groups",
	"_activationCallback",
	"_deactivationCallback",
	[ "_extraScript", {}, [ {} ]],
	[ "_extraScriptParams", [], [[]] ],
	"_handleClearedTrigger",
	[ "_extraScriptClearedTrigger", {}, [ {} ]],
	[ "_extraScriptClearedTriggerParams", [], [[]] ],
	[ "_deleteEverythingOnceCleared", true, [ true ] ],
	"_cleanupTrigger"
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = (triggerText _trigger) splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _activationSide = _triggerDatas select INDEX_OF_ACTIVATION_SIDE;
	private _spawnSide = _triggerDatas select INDEX_OF_SPAWN_SIDE;
	diag_log format [ "Checking activation side %1 and spawn side %2 of trigger.", _activationSide, _spawnSide ];
	[ _activationSide, _spawnSide ] call (_functions get "checkSides");
	_selectedSideSpawnGroups = _groups get _spawnSide;



	diag_log format [ "Setting up activation side (%1) of trigger.", _activationSide ];
	_trigger setTriggerActivation [ _activationSide, "PRESENT", true ];
	diag_log "Setting up trigger.";
	_trigger setTriggerStatements [
		"this",
		
		"private _functions = thisTrigger getVariable '_functions';
		private _activationCallback = thisTrigger getVariable '_activationCallback';
		private _cleanupTrigger = thisTrigger getVariable '_cleanupTrigger';
		[ thisTrigger, _functions, _cleanupTrigger ] call _activationCallback;",

		"private _functions = thisTrigger getVariable '_functions';
		private _deactivationCallback = thisTrigger getVariable '_deactivationCallback';
		[ thisTrigger, _functions ] call _deactivationCallback;"
	];
	_trigger setVariable [ "_functions", _functions ];
	_trigger setVariable [ "_groups", _selectedSideSpawnGroups ];
	_trigger setVariable [ "_activationCallback", _activationCallback ];
	_trigger setVariable [ "_deactivationCallback", _deactivationCallback ];
	_trigger setVariable [ "_handleClearedTrigger", _handleClearedTrigger ];
	_trigger setVariable [ "_extraScriptClearedTrigger", _extraScriptClearedTrigger ];
	_trigger setVariable [ "_extraScriptClearedTriggerParams", _extraScriptClearedTriggerParams ];
	_trigger setVariable [ "_deleteEverythingOnceCleared", _deleteEverythingOnceCleared ];
	_trigger setVariable [ "_cleanupTrigger", _cleanupTrigger ];
	_trigger setVariable [ "_groupsToDespawn", [] ];
	if !(isNil "_extraScript") then
	{
		private _customScriptParams = [ _trigger, _functions ];
		_customScriptParams append _extraScriptParams;
		_customScriptParams call _extraScript;
	};
}
else
{
	diag_log format [ "Trigger %1 doesn't need to be set up.", triggerText _trigger ];
};