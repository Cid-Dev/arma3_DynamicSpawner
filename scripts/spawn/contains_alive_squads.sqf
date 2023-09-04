params [
	[ "_groups", [], [ [] ] ],
	"_functions"
];

private _amountOfGroups = count _groups - 1;
private _contains_alive_units = _functions get "contains_alive_units";
private _result = false;
for "_i" from 0 to _amountOfGroups do 
{
	if ((_groups select _i) call _contains_alive_units) exitWith
	{
		_result = true;
	};
};
_result;