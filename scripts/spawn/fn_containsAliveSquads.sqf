params [
	[ "_groups", [], [ [] ] ]
];

private _amountOfGroups = count _groups - 1;
private _result = false;
for "_i" from 0 to _amountOfGroups do 
{
	if ((_groups select _i) call CID_fnc_containsAliveUnits) exitWith
	{
		_result = true;
	};
};
_result;