params [
	"_id",
	"_position",
	"_size",
	"_angle",
	"_shape", 
	"_color",
	"_brush"
];

private _marker = createMarkerLocal [ format [ "GeneratedMarkerZone_%1", _id ], _position ];
_marker setMarkerBrushLocal _brush;
_marker setMarkerColorLocal _color;
_marker setMarkerDirLocal _angle;
_marker setMarkerShapeLocal _shape;
_marker setMarkerSize _size;

_marker;