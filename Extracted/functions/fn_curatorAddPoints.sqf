private ["_curator","_add","_points"];
_curator = _this param [0,objnull,[objnull]];
_add = _this param [1,0,[0]];

_points = _curator getvariable ["bis_fnc_curatorSystem_points",0];
_points = (_points + _add) max 0 min 1;
_curator setvariable ["bis_fnc_curatorSystem_points",_points];

_points