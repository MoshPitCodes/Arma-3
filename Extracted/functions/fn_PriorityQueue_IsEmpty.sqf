/*
	Author: Zozo

	Description:
	Checks if the Queue is empty

	Parameters:
	_handle:INT - Queue handle (get it with BIS_fnc_PriorityQueue_Init)

	Returns:
	_empty:BOOL - true if the Queue is empty

	Syntax:
	_empty:BOOL = [_handle] call BIS_fnc_PriorityQueue_IsEmpty;

	Example:
	_isTheQueueEmpty = [_priorityQueue_1] call BIS_fnc_PriorityQueue_IsEmpty;
*/

#include "..\priorityQueue_defines.inc"
params [ "_handle" ];
isNil {QUEUES} || {ACTUAL_QUEUE_SIZE(_handle) == 0}
