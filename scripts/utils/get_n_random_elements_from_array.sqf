params [
	[ "_inputArray", [], [ [ ] ] ],
	[ "_amountOfElements", 0, [ 0 ] ],
	[ "_shouldBeDistinct", true, [ true ] ]
];

private _result = [];
private _inputArrayCopy = +_inputArray;
while {count _result < _amountOfElements && { count _inputArrayCopy > 0 }} do {
	if (_shouldBeDistinct) then {
		_result pushBack (_inputArrayCopy deleteAt (floor random count _inputArrayCopy));
	}
	else
	{
		_result pushBack (_inputArrayCopy select floor random count _inputArrayCopy);
	};
};
_result;