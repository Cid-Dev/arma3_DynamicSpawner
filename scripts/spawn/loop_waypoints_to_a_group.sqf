params [ "_group", "_waypointIndex" ];

private _waypoints = _group getVariable "_waypoints";
private _loop_waypoints_to_a_group_file_path = _group getVariable "_loop_waypoints_to_a_group_file_path";

while {(count (waypoints _group)) > 1} do
{
	deleteWaypoint ((waypoints _group) select 0);
};

private _realAmountOfWaypoints = count _waypoints - 1;
for "_i" from 0 to _realAmountOfWaypoints do
{
	private _waypoint = _group addWaypoint [ getPosATL (_waypoints select _i), 0 ];
	_waypoint setWaypointType "MOVE";
	if (_i == _realAmountOfWaypoints && { _realAmountOfWaypoints > 0 }) then
	{
		_waypoint = _group addWaypoint [ getPosATL (_waypoints select _i), 0 ];
		_waypoint setWaypointType "SCRIPTED";
		[ _group, _realAmountOfWaypoints + 2 ] setWaypointScript _loop_waypoints_to_a_group_file_path;
	};
};