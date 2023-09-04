#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ]
];

if (!isNull _trigger) then 
{
	private _triggerText = triggerText _trigger;
	diag_log format [ "Trigger %1 being cleaned up.", _triggerText ];

	private _triggerDatas = _triggerText splitString "_";
	diag_log format [ "Trigger datas : %1", str _triggerDatas ];
	if (count _triggerDatas == NUMBER_OF_PARTS && { _triggerDatas select 0 == "DynamicSpawn" }) then
	{
		private _triggerId = _triggerDatas select INDEX_OF_TRIGGER_ID;

		diag_log "Getting all spawn points related to the trigger.";
		private _allTriggerLogic = allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_SPAWN_POINT_%1", _triggerId ] >= 0};
		_allTriggerLogic append (allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_SPAWN_POINT_%1", _triggerId ] >= 0});
		_allTriggerLogic append (allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "AIR_SPAWN_POINT_%1", _triggerId ] >= 0});

		diag_log "Getting all waypoints related to the trigger.";
		_allTriggerLogic append (allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "INFANTRY_WAYPOINT_%1", _triggerId ] >= 0});
		_allTriggerLogic append (allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "VEHICLE_WAYPOINT_%1", _triggerId ] >= 0});
		_allTriggerLogic append (allMissionObjects "Logic" select {toUpper vehicleVarName _x find format [ "AIR_WAYPOINT_%1", _triggerId ] >= 0});

		diag_log "Deleting all found game logic items.";
		private _length = count _allTriggerLogic - 1;
		for "_i" from 0 to _length do 
		{
			deleteVehicle (_allTriggerLogic select _i);
		};

		diag_log "Deleting trigger.";
		deleteVehicle _trigger;
	};	
};