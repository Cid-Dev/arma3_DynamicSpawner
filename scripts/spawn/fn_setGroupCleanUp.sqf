params [
	"_group"
];

private _units = units _group;

{
	_x addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		
		// remove body after 10 minutes
		_unit spawn {
			params [ "_unitToRemove" ];
			sleep 600;
			if (!isNil "_unitToRemove" && { !isNull _unitToRemove && { !alive _unitToRemove } }) then
			{
				private _vehicle = objectParent _unit;
				if (isNull _vehicle) then
				{
					deleteVehicle _unitToRemove;
				}
				else
				{
					_vehicle deleteVehicleCrew _unitToRemove;
				};
			};
		};
	}];
} forEach _units;

private _groupVehicles = [ _group, false] call BIS_fnc_groupVehicles;

{
	_x addEventHandler ["Killed", {
		params ["_vehicle", "_killer", "_instigator", "_useEffects"];

		_vehicle spawn {
			params [ "_vehicleToRemove" ];

			sleep 600;
			if (!isNil "_vehicleToRemove" && { !isNull _vehicleToRemove && { !alive _vehicleToRemove } }) then
			{
				// eject all units from destroyed vehicle
				{
					moveOut _x;
				} forEach crew _vehicleToRemove;
			};
			deleteVehicle _vehicleToRemove;
		};
	}];
} forEach _groupVehicles;