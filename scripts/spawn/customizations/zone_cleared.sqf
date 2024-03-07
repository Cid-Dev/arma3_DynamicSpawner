params [
	[ "_trigger", objNull, [ objNull ] ],
	"_createNatoFlag",
	"_createMarkerFlag"
];

private _zoneMarker = _trigger getVariable "_zone";
private _opforFlag = _trigger getVariable "_flag";
deleteMarker _zoneMarker;
deleteMarker _opforFlag;
[ _trigger, _createMarkerFlag ] call _createNatoFlag;
hint "Zone cleared !";