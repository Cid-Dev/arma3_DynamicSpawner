params [
	[ "_inputArray", [], [ [ ] ] ]
];

private _result = [];
private _length = count _inputArray - 1;
for "_i" from 0 to _length do
{
	_result pushBack (parseNumber (_inputArray select _i));
};
_result;