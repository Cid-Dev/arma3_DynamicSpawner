params [
	[ "_trigger", objNull, [ objNull ] ],
	"_functions",
	"_createCsatFlag",
	"_createMarkerFlag",
	"_createOccupiedMarkerZone",
	"_createMarkerZone"
];

[ _trigger, _createMarkerFlag ] call _createCsatFlag;

[ _trigger, _createMarkerZone ] call _createOccupiedMarkerZone;