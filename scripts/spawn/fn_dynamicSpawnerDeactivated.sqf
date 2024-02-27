#define NUMBER_OF_PARTS 10

params [
	[ "_trigger", objNull, [ objNull ] ]
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = (triggerText _trigger) splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _handleClearedTriggerScriptHandler = _trigger getVariable "_handleClearedTriggerScriptHandler";
	terminate _handleClearedTriggerScriptHandler;
	
	private _groupsTypeToDespawn = _trigger getVariable "_groupsToDespawn";

	{
		private _groupsToDespawn = _groupsTypeToDespawn get _x;
		if (!isNil "_groupsToDespawn") then
		{
			for "_i" from count _groupsToDespawn - 1 to 0 step -1 do {
				private _groupToDelete = _groupsToDespawn deleteAt _i;
				_groupToDelete call CID_fnc_deleteGroupAndItsMembers;
			};

			_groupsTypeToDespawn set [ _x, _groupsToDespawn ];
		};
	} forEach [ "infantry", "vehicle", "air" ];

	_trigger setVariable [ "_groupsToDespawn", _groupsTypeToDespawn ];

	private _detection_trigger = _trigger getVariable "_detection_trigger";
	if (!isNil '_detection_trigger') then
	{
		_trigger setVariable [ "_detection_trigger", nil ];
		deleteVehicle _detection_trigger;
	};

	[ _trigger, "TriggerDeactivated" ] call CID_fnc_customScript;
};