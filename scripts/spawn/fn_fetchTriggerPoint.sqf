params [
	[ "_typeOfSquad", "", [ "" ] ],
	[ "_typeOfPoint", "", [ "" ] ],
	[ "_triggerId", 0, [ 0 ] ]
];

allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "%1_%2_%3_", _typeOfSquad, _typeOfPoint, _triggerId ] >= 0};