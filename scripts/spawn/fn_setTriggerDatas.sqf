#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ]
];

if (isNull _trigger) then
{
	throw "A non-null object was expected for the trigger.";
};

private _triggerDatas = (triggerText _trigger) splitString "_";
if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
{
	private _activationSide = _triggerDatas select INDEX_OF_ACTIVATION_SIDE;
	private _spawnSide = _triggerDatas select INDEX_OF_SPAWN_SIDE;
	
	[ _activationSide, _spawnSide ] call CID_fnc_checkSides;

	private _triggerId = parseNumber (_triggerDatas select INDEX_OF_TRIGGER_ID);

	private _AmountsOfInfantrySquads = (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_SQUADS) call CID_fnc_extractValueOfPoint;
	private _AmountsOfVehicleSquads = (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_SQUADS) call CID_fnc_extractValueOfPoint;
	private _AmountsOfAirSquads = (_triggerDatas select INDEX_OF_AMOUNT_OF_AIR_SQUADS) call CID_fnc_extractValueOfPoint;

	private _AmountsOfInfantryWaypoints = (_triggerDatas select INDEX_OF_AMOUNT_OF_INFANTRY_WAYPOINTS) call CID_fnc_extractValueOfPoint;
	private _AmountsOfVehicleWaypoints = (_triggerDatas select INDEX_OF_AMOUNT_OF_VEHICLE_WAYPOINTS) call CID_fnc_extractValueOfPoint;
	private _AmountsOfAirWaypoints = (_triggerDatas select INDEX_OF_AMOUNT_OF_AIR_WAYPOINTS) call CID_fnc_extractValueOfPoint;

	_trigger setVariable [
		"CID_triggerDatas",
		createHashMapFromArray [
			[ "SpawnSide", _spawnSide ],
			[ "ActivationSide", _activationSide ],
			[ "TriggerId", _triggerId ],
			[ "AmountsOfInfantrySquads", _AmountsOfInfantrySquads ],
			[ "AmountsOfVehicleSquads", _AmountsOfVehicleSquads ],
			[ "AmountsOfAirSquads", _AmountsOfAirSquads ],
			[ "AmountsOfInfantryWaypoints", _AmountsOfInfantryWaypoints ],
			[ "AmountsOfVehicleWaypoints", _AmountsOfVehicleWaypoints ],
			[ "AmountsOfAirWaypoints", _AmountsOfAirWaypoints ]
		]
	];
};