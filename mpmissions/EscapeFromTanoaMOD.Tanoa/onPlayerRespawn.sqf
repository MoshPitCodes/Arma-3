//NNS : varible to ignore unit for compute group center
player setVariable ["recovery",true,true];
[] spawn {sleep 5; player setVariable ["recovery",false,true];};

//NNS : suspend distance travel record
player setVariable ["distance_traveled_suspended",true,false];
[] spawn {sleep 11; player setVariable ["distance_traveled_suspended",false,false];};

//NNS : move player respawn
if (vehicle player == player) then { //not spawned in vehicle
	_old_pos = getPos player; //initial position
	_new_pos = [_old_pos, 0, 50, 4, 0, 0.5, 0] call BIS_fnc_findSafePos; //select new position under 50m, random direction
	if (_old_pos distance2D _new_pos > 50) then {_new_pos = _old_pos getPos [random 10, random 360];}; //BIS_fnc_findSafePos failed
	player setpos [_new_pos select 0, _new_pos select 1, 0]; //move player
	player setDir ((player getRelDir _old_pos)+(getDir player)); //direction to initial position
};

// If respawn tickets were disabled, remove the initial ticket for each of the players
if (missionNamespace getVariable "BIS_respawnTickets" == 0) then {[(_this select 0),-1] call BIS_fnc_respawnTickets};

// Delete the dead body if all players are far away
_null = (_this select 1) execVM "Scripts\BuryCorpse.sqf";

//NNS : allow player to heal and repair
if (BIS_loadoutLevel == 0) then {
	player setUnitTrait ["Medic",true];
	player setUnitTrait ["Engineer",true];
};

//NNS : stamina
if !(BIS_stamina) then {player enablestamina false;};

_tmp_saved_loadout = player getVariable["tmp_saved_loadout",[]];
if (uniform player == "U_C_Poloshirt_stripped" && {count _tmp_saved_loadout > 0}) then { //NNS : restore old loadout : O_Saved_Loadout selected
	removeAllWeapons player;
	removeGoggles player;
	removeHeadgear player;
	removeVest player;
	removeUniform player;
	removeAllAssignedItems player;
	clearAllItemsFromBackpack player;
	removeBackpack player;
	player setUnitLoadout(_tmp_saved_loadout);
	if ((player ammo (primaryWeapon player)) < 15) then {player setAmmo [primaryWeapon player, 15];}; //refill primary weapon magazine a bit if low ammo
	["God", "Previous loadout restored, Main magazine refilled"] call BIS_fnc_showSubtitle;
} else {
	_null = execVM 'scripts\PlayerLimitEquipment.sqf'; //NNS : Limit equipment
};

