params [
	[ "_trigger", objNull, [ objNull ] ]
];

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

[ _trigger, "TriggerDeactivated" ] call CID_fnc_customScript;