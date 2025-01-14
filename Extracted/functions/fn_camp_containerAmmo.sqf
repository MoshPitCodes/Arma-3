/*
	Author: Jiri Wainar

	Description:
	Returns a consolidated array with all container's magazine ammo. Ammunition in loaded magazines is included.

	Example:
	[[_magazine1class:string,_ammoCount:number],...] = [_container:object,_weaponFilter:string] call BIS_fnc_camp_containerAmmo;
*/

private["_container","_weapon","_ammoAll","_magazines","_type","_data"];

_container = [_this, 0, player, ["",objNull]] call bis_fnc_param;
_weapon    = [_this, 1, "", [""]] call bis_fnc_param;

_ammoAll = [];

if (typeName _container == typeName "") then
{
	_container = missionNamespace getVariable [_container, objNull];
};

_magazines = magazinesAmmoCargo _container;

//add magazines in weapons
{
	_data = _x;

	{
		if (_forEachIndex > 0 && {typeName _x == typeName []} && {count _x > 0}) then
		{
			_magazines set [count _magazines, _x];
		};
	}
	forEach _data;
}
forEach (weaponsItemsCargo _container);

//process magazines & ammo
{
	_ammoAll = [_ammoAll,toLower(_x select 0),_x select 1] call BIS_fnc_addToPairs;
}
forEach _magazines;

//if weapon filter is not defined, return all ammo
if (_weapon == "") exitWith {_ammoAll};

private["_fittingMagazines","_defaultMagazine","_ammoFiltered"];

_fittingMagazines = [_weapon] call bis_fnc_compatibleMagazines;

{
	_fittingMagazines set [_forEachIndex, toLower _x];
}
forEach _fittingMagazines;

if (count _fittingMagazines == 0) exitWith {[]};

_ammoFiltered = [];

private["_class","_count"];

{
	_class = _x select 0;
	_count = _x select 1;

	if (true) then
	{
		if !(_class in _fittingMagazines) exitWith {};

		_ammoFiltered set [count _ammoFiltered,_x];
	};
}
forEach _ammoAll;

_ammoFiltered