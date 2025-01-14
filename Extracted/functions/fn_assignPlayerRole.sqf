/*
	Author: Joris-Jan van 't Land

	Description:
	Ensures the player can only get in the specific vehicle role

	Parameter(s):
	_this select 0: vehicle (Object)
	_this select 1: role (String)
	_this select 2: index / path (Scalar or Array)

	Returns:
	Bool
*/

private ["_veh", "_role", "_index"];
_veh = _this param [0, objNull, [objNull]];
_role = _this param [1, "driver", ["", []]];
_index = _this param [2, -1, [0, []]];

switch _role do 
{
	case "driver": {player assignAsDriver _veh;};
	case "gunner": {player assignAsGunner _veh;};
	case "commander": {player assignAsCommander _veh;};
	case "cargo": 
	{
		if (((typeName _index) == (typeName [])) || (_index < 0)) then 
		{
			player assignAsCargo _veh;
		} 
		else 
		{
			player assignAsCargo [_veh, _index];
		};
	};
	case "turret": 
	{
		if ((typeName _index) == (typeName 0)) then {_index = [_index]};
		player assignAsTurret [_veh, _index];
	};
};

[player] orderGetIn true; //TODO: not really necessary?
_veh lock 3; //Lock all but the assigned roles for player

true