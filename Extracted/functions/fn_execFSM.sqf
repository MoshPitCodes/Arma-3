params [["_args1", []], "_args2"];

// --- input format: "fsm" or ["fsm"]
if (isNil "_args2" && _args1 isEqualType "") exitWith {[] execFSM _args1};

// --- input format: [param, "fsm"]
if (!isNil "_args2" && {_args2 isEqualType ""}) exitWith {_args1 execFSM _args2}; 

// --- error and suggest supported format
[_this, "isEqualTypeParams", [nil, ""]] call (missionNamespace getVariable "BIS_fnc_errorParamsType");

-1
