#include "spawn_constants.hpp"

params [
	"_hashMapKey",
	"_groups",
	"_landUnitsSpawnPoints",
	"_spawnSide",
	"_minRank",
	"_maxRank",
	"_AmountsOfLandUnitsWaypoints",
	"_allLandUnitsWaypoints"
];

private _landUnitsGroup = [ _groups get _hashMapKey, count _landUnitsSpawnPoints, false ] call CID_fnc_getNRandomElementsFromArray;
private _amountOfLandUnitsToSpawn = count _landUnitsGroup - 1;
private _spawnedGroups = [];

for "_i" from 0 to _amountOfLandUnitsToSpawn do
{
	private _selectedGroup = _landUnitsGroup select _i;
	private _center = getPosATL (_landUnitsSpawnPoints select _i);

	private _classes = if (typeName _selectedGroup == typeName configFile) then
	{
		(_selectedGroup call BIS_fnc_getCfgSubClasses) apply { getText (_selectedGroup >> _x >> "vehicle") };
	}
	else
	{
		_selectedGroup;
	};

	private _azimuth = floor random 360;
	private _groupToSpawn = createGroup [ _spawnSide, true ];

	{
		private _position = _center findEmptyPosition [ 10, 100, _x ];
		if ((count _position) > 0) then
		{
			if (_x isKindOf "Man") then
			{
				_x createUnit [ _position, _groupToSpawn, "", DEFAULT_SKILL ]; // need last argument : rank
			}
			else
			{
				[ _position, _azimuth, _x, _groupToSpawn ] call BIS_fnc_spawnVehicle params ["_vehicle", "_crew", "_group"];
			};
		};
		// performance sleep to avoid FPS drops on server https://forums.bohemia.net/forums/topic/170230-whether-to-use-bis_fnc_spawngroup-or-createunit/
		private _AdditionalUnitCreationDelay = ((abs(50 - diag_fps) / (50 - 10))^2) * 1.337;
		sleep(_AdditionalUnitCreationDelay);
	} forEach _classes;

	_groupToSpawn setBehaviourStrong "SAFE";
	_groupToSpawn setSpeedMode "LIMITED";
	_groupToSpawn deleteGroupWhenEmpty true;

	_groupToSpawn call CID_fnc_setGroupCleanUp;

	_spawnedGroups pushBack _groupToSpawn;

	private _AmountOfLandUnitsWaypoints = _AmountsOfLandUnitsWaypoints call BIS_fnc_randomInt;
	
	private _waypoints = [ _allLandUnitsWaypoints, _AmountOfLandUnitsWaypoints ] call CID_fnc_getNRandomElementsFromArray;
	
	_groupToSpawn setVariable [ "_waypoints", _waypoints ];

	[ _groupToSpawn, 0 ] call CID_fnc_loopWaypointsToAGroup;
};
_spawnedGroups;