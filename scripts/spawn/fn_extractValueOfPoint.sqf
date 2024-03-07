params [
	[ "_triggerData", "", [ "" ] ],
	[ "_index", 0, [ 0 ] ]
];

private _AmountsOfPointsStr = _triggerData splitString ",";
private _AmountsOfPoints = [ _AmountsOfPointsStr ] call CID_fnc_stringArrayToIntArray;
if (count _AmountsOfPoints == 1) then
{
	_AmountsOfPoints pushBack (_AmountsOfPoints select 0);
};

_AmountsOfPoints;