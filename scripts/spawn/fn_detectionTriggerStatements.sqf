// DynamicSpawn_WEST_EAST_5_6,8_2_4_1_1_1
params [
	[ "_detectionTrigger", objNull, [ objNull ] ],
	[ "_detectedUnits", [], [ [] ] ]
];

private _airGroups = _detectionTrigger getVariable '_airGroups';
private _triggerPosition = getPos _detectionTrigger;

{
	private _group = _x;
	if (_group call CID_fnc_containsAliveUnits) then
	{
		{
			private _detectedUnit = _x;
			private _detectedUnitPosition = getPos _detectedUnit;
			private _waypoint = _group addWaypoint [ _detectedUnitPosition, 0 ];
			_waypoint setWaypointType 'SAD';

			private _index = currentWaypoint _group;
			private _type = waypointType [ _group, _index ];

			for '_i' from (count waypoints _group - 1) to (_index + 1) step -1 do {
				if (waypointType [ _group, _i ] in [ '', 'LOITER' ]) then
				{
					deleteWaypoint [ _group, _i ];
				};
			};

			if (_type in [ '', 'LOITER' ]) then
			{
				_group setCurrentWaypoint [ _group, _index + 1 ];
			};
		} forEach _detectedUnits;

		private _loiterWaypoint = _group addWaypoint [ [ _triggerPosition select 0, _triggerPosition select 1, 250 ], 0 ];
		_loiterWaypoint setWaypointType 'LOITER';
		_loiterWaypoint setWaypointLoiterType 'CIRCLE_L';
		_loiterWaypoint setWaypointLoiterRadius 500;
	};
} forEach _airGroups;

[ _detectionTrigger, 'TriggerDetected' ] call CID_fnc_customScript;