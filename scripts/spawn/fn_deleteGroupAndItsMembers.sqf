params [ "_group" ];

private _units = units _group;
private _amount_of_units = count _units - 1;
private _vehiclesToDelete = [];

for "_i" from 0 to _amount_of_units do
{
	private _unit = _units select _i;
	private _vehicle = objectParent _unit;
	if (isNull _vehicle) then {
		deleteVehicle _unit;
	}
	else
	{
		_vehicle deleteVehicleCrew _unit;
		if !(_vehicle in _vehiclesToDelete) then
		{
			_vehiclesToDelete pushBack _vehicle;
		};
	};
};

for "_i" from 0 to count _vehiclesToDelete - 1 do
{
	private _vehicle = _vehiclesToDelete select _i;
	if (count (crew _vehicle) == 0) then
	{
		deleteVehicle _vehicle;
	};
};

deleteGroup _group;