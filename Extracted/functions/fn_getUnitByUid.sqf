/*
	Author: Nelson Duarte

	Description:
	Returns object belonging to given UID

	Parameter(s):
	0: STRING - The UID of object

	Returns:
	OBJECT
*/
// Parameters
private ["_uid"];
_uid = _this param [0, "", [""]];

// The shooter
private "_unit";
_unit = objNull;

// Go through all units and find matching UID
{
	if (getPlayerUid _x == _uid) exitWith
	{
		_unit = _x;
	};
} forEach allUnits + allDeadMen;

// Return
_unit;