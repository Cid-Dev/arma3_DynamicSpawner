params [ "_group" ];

private _units = units _group;
private _amount_of_units = count _units - 1;
for "_i" from 0 to _amount_of_units do
{
	deleteVehicle (_units select _i);
};

deleteGroup _group;