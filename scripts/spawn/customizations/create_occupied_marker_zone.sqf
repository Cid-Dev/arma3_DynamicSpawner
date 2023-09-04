#include "..\spawn_constants.hpp"

#define INDEX_OF_X 0
#define INDEX_OF_Y 1
#define INDEX_OF_ANGLE 2
#define INDEX_OF_IS_RECTANGLE 3

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_createMarkerZone"
];

private _triggerText = triggerText _trigger;
private _triggerDatas = _triggerText splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;

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
}