params [
	"_group"
];

private _result = false;
if (!isNil "_group") then {
	private _units = units _group;
	private _amountOfUnits = count _units - 1;
	for "_i" from 0 to _amountOfUnits do 
	{
		if (alive (_units select _i)) exitWith
		{
			_result = true;
		};
	};
};
_result;