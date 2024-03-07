params [
	"_group"
];

!isNil "_group" && (units _group) findIf { alive _x } != -1;