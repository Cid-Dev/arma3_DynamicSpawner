params [
	"_trigger",
	[
		"_customizationName",
		"",
		[ "" ]
	],
	[
		"_triggerCustomParams",
		[],
		[ [] ]
	]
];

private _customScripts = _trigger getVariable [ "_customScripts", createHashMap ];

private _triggerCustomizations = _customScripts get _customizationName;
if (!isNil "_triggerCustomizations") then
{
	private _triggerCustomizationsScript = _triggerCustomizations get "Script";
	if (!isNil "_triggerCustomizationsScript") then
	{
		private _triggerCustomFinalParams = [ _trigger ];
		_triggerCustomFinalParams append _triggerCustomParams;

		private _triggerCustomizationsParams = _triggerCustomizations get "Params";
		if (!isNil "_triggerCustomizationsParams") then
		{
			_triggerCustomFinalParams append _triggerCustomizationsParams;
		};

		_triggerCustomFinalParams call _triggerCustomizationsScript;
	};
};