params [ "_activationSide", "_spawnSide" ];

private _checkSide = compile preprocessFileLineNumbers "scripts\spawn\check_side.sqf";

if !(_activationSide call _checkSide) then { throw format [ "%1 is not an allowed side for activation", _activationSide ]; };
if !(_spawnSide call _checkSide) then { throw format [ "%1 is not an allowed side for spawn", _spawnSide ]; };