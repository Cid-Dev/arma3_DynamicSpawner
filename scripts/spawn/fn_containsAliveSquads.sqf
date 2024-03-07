params [
	[ "_groups", [], [ [] ] ]
];

_groups findIf { _x call CID_fnc_containsAliveUnits } != -1;