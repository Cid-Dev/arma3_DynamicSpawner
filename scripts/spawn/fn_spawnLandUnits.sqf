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

for "_i" from 0 to _amountOfLandUnitsToSpawn do {

	private _ranks = [];
	private _selectedGroup = _landUnitsGroup select _i;
	if (typeName _selectedGroup != typeName configFile) then
	{
		for "_j" from 0 to (count _selectedGroup) - 1 do
		{
			_ranks pushBack (floor random (_maxRank - _minRank)) + _minRank;
		};

		_ranks sort false;
	};

	private _groupToSpawn = [
		getPosATL (_landUnitsSpawnPoints select _i),
		_spawnSide,
		_selectedGroup,
		[],
		_ranks,
		[],
		[],
		[],
		floor random 360,
		false
	] call BIS_fnc_spawnGroup;

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