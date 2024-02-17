#define NUMBER_OF_PARTS 10

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions"
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = (triggerText _trigger) splitString "_";
private _delete_group_and_its_members = _functions get "delete_group_and_its_members";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _handleClearedTrigger = _trigger getVariable "_clearedZoneHandler";
	terminate _handleClearedTrigger;
	
	private _groupsToDespawn = _trigger getVariable "_groupsToDespawn";
	//{ _debugGroups pushBack groupId _x; } forEach _spawnedGroups;

	for "_i" from count _groupsToDespawn - 1 to 0 step -1 do {
		private _groupToDelete = _groupsToDespawn deleteAt _i;
		_groupToDelete call _delete_group_and_its_members;
	};

	_trigger setVariable [ "_groupsToDespawn", _groupsToDespawn ];

	private _detection_trigger = _trigger getVariable "_detection_trigger";
	if (!isNil '_detection_trigger') then
	{
		_trigger setVariable [ "_detection_trigger", nil ];
		deleteVehicle _detection_trigger;
	};

	private _extraScriptDeactivated = _trigger getVariable '_extraScriptDeactivated';
	private _extraScriptParamsDeactivated = _trigger getVariable '_extraScriptParamsDeactivated';
	private _customScriptParams = [ _trigger, _functions ];
	_customScriptParams append _extraScriptParamsDeactivated;
	_customScriptParams call _extraScriptDeactivated;
};