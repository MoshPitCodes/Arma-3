/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zem�nek

Description: Returns time synced between server and clients
*/

if (isMultiplayer) then {
	serverTime;
} else {
	time;
};