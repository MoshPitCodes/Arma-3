waitUntil {!isNull (missionNamespace getVariable ["BIS_comms", objNull])};

//[BIS_comms, "Destroy", nil, nil, "alive _target && player distance _target < 6", "alive _target && player distance _target < 6", nil, {playSound "ReadoutHideClick1"}, {(_this select 0) setDamage 1; playSound3D ["A3\Missions_F_Bootcamp\data\sounds\assemble_target.wss", (_this select 0), FALSE, getPosASL (_this select 0), 5, 1, 100]}, nil, nil, 5] call BIS_fnc_holdActionAdd;