params [
	[ "_trigger", objNull, [ objNull ] ]
];

private _triggerDatas = _trigger getVariable "CID_triggerDatas";

private _activationSide = _triggerDatas get "ActivationSide";
private _spawnSide = _triggerDatas get "SpawnSide";

private _detection_trigger = createTrigger [ "EmptyDetector", getPos _trigger ];
private _triggerArea = triggerArea _trigger;
_detection_trigger setTriggerArea _triggerArea;
_detection_trigger setTriggerActivation [ _activationSide, format [ "%1 D", _spawnSide ], true ];
_detection_trigger setTriggerStatements [
	"this && { triggerActivated (thisTrigger getVariable '_trigger') }",
	
	"[ thisTrigger, thisList ] call CID_fnc_detectionTriggerStatements;",
	
	"[ thisTrigger, 'TriggerUndetected' ] call CID_fnc_customScript;"
];

private _customScripts = _trigger getVariable '_customScripts';
_detection_trigger setVariable [ "_customScripts", _customScripts ];
_detection_trigger setVariable [ "_trigger", _trigger ];

_trigger setVariable [ "_detection_trigger", _detection_trigger ];