
/*
	File: spawnGroup.sqf
	Author: Joris-Jan van 't Land, modified by Thomas Ryan

	Description:
	Function which handles the spawning of a dynamic group of characters.
	The composition of the group can be passed to the function.
	Alternatively a number can be passed and the function will spawn that
	amount of characters with a random type.

	Parameter(s):
	_this select 0: the group's starting position (Array)
	_this select 1: the group's side (Side)
	_this select 2: can be three different types:
		- list of character types (Array)
		- amount of characters (Number)
		- CfgGroups entry (Config)
	_this select 3: (optional) list of relative positions (Array)
	_this select 4: (optional) list of ranks (Array)
	_this select 5: (optional) skill range (Array)
	_this select 6: (optional) ammunition count range (Array)
	_this select 7: (optional) randomization controls (Array)
		0: amount of mandatory units (Number)
		1: spawn chance for the remaining units (Number)
	_this select 8: (optional) azimuth (Number)
	_this select 9: (optional) force precise position (Bool, default: true).
	_this select 10: (optional) max. number of vehicles (Number, default: 10e10).

	Returns:
	The group (Group)
*/

//Validate parameter count
if ((count _this) < 3) exitWith {debugLog "Log: [spawnGroup] Function requires at leat 3 parameters!"; grpNull};

private ["_pos", "_side"];
_pos = _this param [0, [], [[]]];
_side = _this param [1, sideUnknown, [sideUnknown]];

private ["_chars", "_charsType", "_types"];
_chars = _this param [2, [], [[], 0, configFile]];
_charsType = typeName _chars;
if (_charsType == (typeName [])) then
{
	_types = _chars;
}
else
{
	if (_charsType == (typeName 0)) then
	{
		//Only a count was given, so ask this function for a good composition.
		_types = [_side, _chars] call BIS_fnc_returnGroupComposition;
	}
	else
	{
		if (_charsType == (typeName configFile)) then
		{
			_types = [];
		};
	};
};

private ["_positions", "_ranks", "_skillRange", "_ammoRange", "_randomControls","_precisePosition","_maxVehicles"];
_positions = _this param [3, [], [[]]];
_ranks = _this param [4, [], [[]]];
_skillRange = _this param [5, [], [[]]];
_ammoRange = _this param [6, [], [[]]];
_randomControls = _this param [7, [-1, 1], [[]]];
_precisePosition = _this param [9,true,[true]];
_maxVehicles = _this param [10,10e10,[123]];

//Fetch the random controls.
private ["_minUnits", "_chance"];
_minUnits = _randomControls param [0, -1, [0]];
_chance = _randomControls param [1, 1, [0]];

private ["_azimuth"];
_azimuth = _this param [8, 0, [0]];

//Check parameter validity.
//TODO: Check for valid skill and ammo ranges?
if ((typeName _pos) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Position (0) should be an Array!"; grpNull};
if ((count _pos) < 2) exitWith {debugLog "Log: [spawnGroup] Position (0) should contain at least 2 elements!"; grpNull};
if ((typeName _side) != (typeName sideEnemy)) exitWith {debugLog "Log: [spawnGroup] Side (1) should be of type Side!"; grpNull};
if ((typeName _positions) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] List of relative positions (3) should be an Array!"; grpNull};
if ((typeName _ranks) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] List of ranks (4) should be an Array!"; grpNull};
if ((typeName _skillRange) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Skill range (5) should be an Array!"; grpNull};
if ((typeName _ammoRange) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Ammo range (6) should be an Array!"; grpNull};
if ((typeName _randomControls) != (typeName [])) exitWith {debugLog "Log: [spawnGroup] Random controls (7) should be an Array!"; grpNull};
if ((typeName _minUnits) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Mandatory units (7 select 0) should be a Number!"; grpNull};
if ((typeName _chance) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Spawn chance (7 select 1) should be a Number!"; grpNull};
if ((typeName _azimuth) != (typeName 0)) exitWith {debugLog "Log: [spawnGroup] Azimuth (8) should be a Number!"; grpNull};
if ((_minUnits != -1) && (_minUnits < 1)) exitWith {debugLog "Log: [spawnGroup] Mandatory units (7 select 0) should be at least 1!"; grpNull};
if ((_chance < 0) || (_chance > 1)) exitWith {debugLog "Log: [spawnGroup] Spawn chance (7 select 1) should be between 0 and 1!"; grpNull};
if (((count _positions) > 0) && ((count _types) != (count _positions))) exitWith {debugLog "Log: [spawnGroup] List of positions (3) should contain an equal amount of elements to the list of types (2)!"; grpNull};
if (((count _ranks) > 0) && ((count _types) != (count _ranks))) exitWith {debugLog "Log: [spawnGroup] List of ranks (4) should contain an equal amount of elements to the list of types (2)!"; grpNull};

//Convert a CfgGroups entry to types, positions and ranks.
if (_charsType == (typeName configFile)) then
{
	_ranks = [];
	_positions = [];

	for "_i" from 0 to ((count _chars) - 1) do
	{
		private ["_item"];
		_item = _chars select _i;

		if (isClass _item) then
		{
			_types = _types + [getText(_item >> "vehicle")];
			_ranks = _ranks + [getText(_item >> "rank")];
			_positions = _positions + [getArray(_item >> "position")];
		};
	};
};

private ["_grp","_vehicles","_isMan","_type"];
_grp = createGroup _side;
_vehicles = 0;		//spawned vehicles count

//Create the units according to the selected types.
for "_i" from 0 to ((count _types) - 1) do
{
	//Check if max. of vehicles was already spawned
	_type = _types select _i;
	_isMan = getNumber(configFile >> "CfgVehicles" >> _type >> "isMan") == 1;

	if !(_isMan) then
	{
		_vehicles = _vehicles + 1;
	};

	if (_vehicles > _maxVehicles) exitWith {};

	//See if this unit should be skipped.
	private ["_skip"];
	_skip = false;
	if (_minUnits != -1) then
	{
		//Has the mandatory minimum been reached?
		if (_i > (_minUnits - 1)) then
		{
			//Has the spawn chance been satisfied?
			if ((random 1) > _chance) then {_skip = true};
		};
	};

	if (!_skip) then
	{
		private ["_unit"];

		//If given, use relative position.
		private ["_itemPos"];
		if ((count _positions) > 0) then
		{
			private ["_relPos"];
			_relPos = _positions select _i;
			_itemPos = [(_pos select 0) + (_relPos select 0), (_pos select 1) + (_relPos select 1)];
		}
		else
		{
			_itemPos = _pos;
		};

		//Is this a character or vehicle?
		if (_isMan) then
		{
			_unit = _grp createUnit [_type, _itemPos, [], 0, "FORM"];
			_unit setDir _azimuth;
		}
		else
		{
			_unit = ([_itemPos, _azimuth, _type, _grp, _precisePosition] call BIS_fnc_spawnVehicle) select 0;
		};

		//If given, set the unit's rank.
		if ((count _ranks) > 0) then
		{
			[_unit,_ranks select _i] call bis_fnc_setRank;
		};

		//If a range was given, set a random skill.
		if ((count _skillRange) > 0) then
		{
			private ["_minSkill", "_maxSkill", "_diff"];
			_minSkill = _skillRange select 0;
			_maxSkill = _skillRange select 1;
			_diff = _maxSkill - _minSkill;

			_unit setUnitAbility (_minSkill + (random _diff));
		};

		//If a range was given, set a random ammo count.
		if ((count _ammoRange) > 0) then
		{
			private ["_minAmmo", "_maxAmmo", "_diff"];
			_minAmmo = _ammoRange select 0;
			_maxAmmo = _ammoRange select 1;
			_diff = _maxAmmo - _minAmmo;

			_unit setVehicleAmmo (_minAmmo + (random _diff));
		};
	};
};


//--- Sort group members by ranks (the same as 2D editor does it)
private ["_newGrp"];
_newGrp = createGroup _side;
while {count units _grp > 0} do {
	private ["_maxRank","_unit"];
	_maxRank = -1;
	_unit = objnull;
	{
		_rank = rankid _x;
		if (_rank > _maxRank || (_rank == _maxRank && (group effectivecommander vehicle _unit == _newGrp) && effectivecommander vehicle _x == _x)) then {_maxRank = _rank; _unit = _x;};
	} foreach units _grp;
	[_unit] joinsilent _newGrp;
};
_newGrp selectleader (units _newGrp select 0);
deletegroup _grp;

_newGrp