params [ "_activationSide", "_spawnSide" ];

if !(_activationSide call CID_fnc_checkSide) then { throw format [ "%1 is not an allowed side for activation", _activationSide ]; };
if !(_spawnSide call CID_fnc_checkSide) then { throw format [ "%1 is not an allowed side for spawn", _spawnSide ]; };