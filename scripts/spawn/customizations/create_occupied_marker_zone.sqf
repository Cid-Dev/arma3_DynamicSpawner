#define INDEX_OF_X 0
#define INDEX_OF_Y 1
#define INDEX_OF_ANGLE 2
#define INDEX_OF_IS_RECTANGLE 3

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_createMarkerZone"
];

private _triggerId = (_trigger getVariable "CID_triggerDatas") get "TriggerId";

private _triggerArea = triggerArea _trigger;
private _triggerSize = [ _triggerArea select INDEX_OF_X, _triggerArea select INDEX_OF_Y ];
private _triggerAngle = _triggerArea select INDEX_OF_ANGLE;
private _triggerShape = if (_triggerArea select INDEX_OF_IS_RECTANGLE) then
{
	"RECTANGLE";
}
else
{
	"ELLIPSE";
};

private _zonePosition = getPos _trigger;

_trigger setVariable [ "_zone", [ _triggerId, _zonePosition, _triggerSize, _triggerAngle, _triggerShape, "colorOPFOR", "SolidBorder" ] call _createMarkerZone ];