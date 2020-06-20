/*
NNS, original from 'Escape from Malden'
Populate guard post with 2 CSAT units

Example: _null = post call BIS_fnc_NNS_populatePost_CSAT;
*/

// Params
params [
	["_post",objNull,[objNull]]
];

// Check for validity
if (isNull _post) exitWith {[format["BIS_fnc_NNS_populatePost_CSAT : Non-existing post %1 used!",_post]] call BIS_fnc_NNS_debugOutput; []};
if !(alive _post) exitWith {["BIS_fnc_NNS_populateCargoHQ_CSAT : Guard post is destroyed!"] call BIS_fnc_NNS_debugOutput; []};

[format["BIS_fnc_NNS_populatePost_CSAT : %1",player distance2d _post]] call BIS_fnc_NNS_debugOutput; //debug

// Create group on the post
_grp01 = createGroup east;
_grp01 setFormDir ((getDir _post) - 180);

_pos01 = _post getRelPos [2,135];
_pos01 set [2, ((getPosASL _post select 2) + 4.4)];
_pos02 = _post getRelPos [2,225];
_pos02 set [2, ((getPosASL _post select 2) + 4.4)];

_unit01 = _grp01 createUnit [selectRandom ["O_soldier_GL_F","O_HeavyGunner_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01 setPosASL _pos01;
_unit02 = _grp01 createUnit [selectRandom ["O_soldier_F","O_soldier_AR_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit02 setPosASL _pos02;

{
	_x setUnitPos "Up";
	_x disableAI "Path";
	_x setDir ((getDir _post) - 180);
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x enableGunLights "forceOn"; //turn on flashlight
} forEach [_unit01,_unit02];

_grp01 enableDynamicSimulation true;
_grp01 allowFleeing 0;
_grp01 enableGunLights "forceOn"; //turn on flashlight

//return units created
[_unit01,_unit02]