#define NUMBER_OF_PARTS 10
#define INDEX_OF_TRIGGER_ID 9

params [
	[ "_trigger", objNull, [ objNull ] ],
	"_createMarkerFlag"
];

private _triggerText = triggerText _trigger;
private _triggerDatas = _triggerText splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;

	private _flagPosition = getPos _trigger;

	_trigger setVariable [ "_flag", [ _triggerId, _flagPosition, "flag_CSAT" ] call _createMarkerFlag ];
}