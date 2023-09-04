params [
	"_id",
	"_position",
	"_flag"
];

private _marker = createMarkerLocal [ format [ "GeneratedMarkerFlag_%1", _id ], _position ];
_marker setMarkerType _flag;

_marker;