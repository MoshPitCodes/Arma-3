private _a 		= _this param [0, [0.0, 0.0, 0.0], [[]]];
private _b 		= _this param [1, [0.0, 0.0, 0.0], [[]]];
private _alpha 	= _this param [2, 0.0, [0.0]];
private _exp 	= _this param [3, 2.0, [0.0]];

[
	[_a select 0, _b select 0, _alpha, _exp] call BIS_fnc_easeIn,
	[_a select 1, _b select 1, _alpha, _exp] call BIS_fnc_easeIn,
	[_a select 2, _b select 2, _alpha, _exp] call BIS_fnc_easeIn
];