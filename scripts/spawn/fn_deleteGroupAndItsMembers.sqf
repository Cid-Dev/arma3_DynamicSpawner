params [ "_group" ];

private _units = units _group;
private _vehiclesToDelete = [];

{
	private _unit = _x;
	private _vehicle = objectParent _unit;
	if (isNull _vehicle) then {
		deleteVehicle _unit;
	}
	else
	{
		_vehicle deleteVehicleCrew _unit;
		_vehiclesToDelete pushBackUnique _vehicle;
	};
} forEach _units;

{
	private _vehicle = _x;
	if (count (crew _vehicle) == 0) then
	{
		deleteVehicle _vehicle;
	};
} forEach _vehiclesToDelete;

deleteGroup _group;