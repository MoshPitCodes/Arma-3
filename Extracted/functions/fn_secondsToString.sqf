/*
	Author: Joris-Jan van 't Land (based on work in fn_timeToString)
	
	Description:
	Convert seconds to formatted string.
	
	Parameter(s):
	_this select 0: <scalar> time in seconds
	_this select 1 (Optional): <string> format
		"HH"			- Hours
		"HH:MM"			- Hours:Minutes
		"HH:MM:SS"		- Hours:Minutes:Seconds (Default)
		"HH:MM:SS.MS"	- Hours:Minutes:Seconds:Milliseconds
		"MM"			- Minutes
		"MM:SS"			- Minutes:Seconds
		"MM:SS.MS"		- Minutes:Seconds:Milliseconds
		"SS.MS"			- Seconds:Milliseconds
	_this select 2 (Optional): <boolean> return as Array (default: false)
	
	Returns:
	String or Array of Strings
*/

private ["_sec", "_format", "_asArray", "_time", "_min", "_hour", "_sec", "_msec"];
_sec = _this param [0, 0, [0]];
_format = _this param [1, "HH:MM:SS", [""]];
_asArray = _this param [2, false, [true]];
_time = "";

_hour = 0;
if (_format in ["HH", "HH:MM", "HH:MM:SS", "HH:MM:SS.MS"]) then
{
	_hour = floor (_sec / 3600);
	_sec = _sec % 3600;
};
_min =  floor (_sec / 60);
_sec = _sec % 60;
_msec = floor ((_sec % 1) * 1000);
_sec = floor (_sec);

_hour = (if (_hour <= 9) then {"0"} else {""}) + (str _hour);
_min = (if (_min <= 9) then {"0"} else {""}) + (str _min);
_sec = (if (_sec <= 9) then {"0"} else {""}) + (str _sec);
if (_msec <= 99) then 
{
	if (_msec <= 9) then 
	{
		_msec = "00" + (str _msec);
	} 
	else 
	{
		_msec = "0" + (str _msec);
	};
};

if (_asArray) then 
{
	switch _format do
	{
		case "HH": {_time = [_hour];};
		case "HH:MM": {_time = [_hour, _min];};
		case "HH:MM:SS": {_time = [_hour, _min, _sec];};
		case "HH:MM:SS.MS": {_time = [_hour, _min, _sec, _msec];};
		case "MM": {_time = [_min];};
		case "MM:SS": {_time = [_min, _sec];};
		case "MM:SS.MS": {_time = [_min, _sec, _msec];};
		case "SS.MS": {_time = [_sec, _msec];};
	};
} 
else 
{
	switch _format do
	{
		case "HH": {_time = _hour;};
		case "HH:MM": {_time = format ["%1:%2", _hour, _min];};
		case "HH:MM:SS": {_time = format ["%1:%2:%3", _hour, _min, _sec];};
		case "HH:MM:SS.MS": {_time = format ["%1:%2:%3.%4", _hour, _min, _sec, _msec];};
		case "MM": {_time = _min;};
		case "MM:SS": {_time = format ["%1:%2", _min, _sec];};
		case "MM:SS.MS": {_time = format ["%1:%2.%3", _min, _sec, _msec];};
		case "SS.MS": {_time = format ["%1.%2", _sec, _msec];};
	};
};

_time