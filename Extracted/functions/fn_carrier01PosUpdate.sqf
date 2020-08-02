/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a sub function designed to update dynamic aircraft carriers position in EDEN editor. Carrier consists of multiple sub-objects that are linked together bnased on precise memory point positions in 3D space.
	Function will update initial object positions when player drggs the object in EDEN editor.

	Exucution:
	- Call from EH on the main carrier base model (blank model with momory points and reference config).

		Example:
		class Eventhandlers
		{
			init = "_this call BIS_fnc_Carrier01Init";								//main init fnc, will assemble carrier in game
			AttributesChanged3DEN = "_this call BIS_fnc_Carrier01EdenInit";			//function to update objects position in EDEN editor if attributes changed by player
			Dragged3DEN = "_this call BIS_fnc_Carrier01PosUpdate";					//function to update objects position in EDEN editor if attributes changed by player
			RegisteredToWorld3DEN = "_this call BIS_fnc_Carrier01EdenInit";			//initial EDEN init fnc (main init is still called)
			UnregisteredFromWorld3DEN = "_this call BIS_fnc_Carrier01EdenDelete";	//function  to delete all carrier objects in EDEN editor
		};

	Requirments:
	- An array of carrier parts/objects as a variable attached to main carrier base. This array is created by main BIS_fnc_Carrier01Init.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: carrier Base/object
		and
		1: array of objects in variable in base objects namespace ["bis_carrierParts", []];


	Returns: nothing
	Result: Aircraft Carrier's possition is updated in EDEN editor.

*/

if (!isServer) exitWith {};

private ["_dummy","_carrierPartPos"];

private _carrierBase = param [0, objNull];

private _carrierPartsArray = _carrierBase getVariable ["bis_carrierParts", []];
private _carrierDir = getdir _carrierBase;
private _carrierPitchBank = _carrierBase call BIS_fnc_getPitchBank;
_carrierPitchBank params [["_carrierPitch",0],["_carrierBank",0]];

{
	_dummy = _x select 0;
	_dummy setDir _carrierDir;
	[_dummy, _carrierPitch, _carrierBank] call BIS_fnc_setPitchBank;
	_carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));
	_dummy setPosWorld _carrierPartPos;

} foreach _carrierPartsArray;