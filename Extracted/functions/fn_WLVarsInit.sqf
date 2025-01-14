/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zem�nek

Description: Init variables.
*/

BIS_WL_sidesPool = [
	EAST,
	WEST,
	RESISTANCE
];
BIS_WL_cfgVehs = configFile >> "CfgVehicles";
BIS_WL_cfgWpns = configFile >> "CfgWeapons";
BIS_WL_cfgMags = configFile >> "CfgMagazines";
BIS_WL_cfgWrld = configFile >> "CfgWorlds" >> worldName;
BIS_WL_cfgMods = configFile >> "CfgMods";
BIS_WL_cfgHints = configFile >> "CfgHints" >> "VehicleList";
BIS_WL_cfgGroups = configFile >> "CfgGroups";
BIS_WL_cfgIndepGrps = BIS_WL_cfgGroups >> "Indep";
BIS_WL_resetVoting = FALSE;
BIS_WL_AIVotingReset = FALSE;
BIS_WL_recalculateIncome = TRUE;
BIS_WL_purchaseMenuVisible = FALSE;
BIS_WL_selectionTimeout = _this getVariable "VotingTimeout";
BIS_WL_fundsPayoffTimeout = 60;
BIS_WL_startCP = _this getVariable "StartCP";
BIS_WL_spawnedRemovalTime = 600;
BIS_WL_scanCost = 350; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "Scan"); if (_overridenCost > 0) then {BIS_WL_scanCost = _overridenCost};
BIS_WL_scanDuration = 30;
BIS_WL_vehicleSpan = _this getVariable "VehicleSpan";
BIS_WL_AICanVote = _this getVariable "AIVoting";
BIS_WL_arsenalEnabled = _this getVariable "ArsenalEnabled";
BIS_WL_forcedProgress = _this getVariable "Progress";
BIS_WL_FTEnabled = _this getVariable "FTEnabled";
BIS_WL_scanEnabled = _this getVariable "ScanEnabled";
BIS_WLVotingResetEnabled = _this getVariable "VotingResetEnabled";
BIS_WLTeamBalanceEnabled = _this getVariable "TeamBalanceEnabled";
BIS_WL_fatigueEnabled = _this getVariable "FatigueEnabled";
BIS_WL_CPIncomeMult = _this getVariable "CPMultiplier";
BIS_WL_shoppingList = _this getVariable "AssetList";
if (BIS_WL_shoppingList == "") then {BIS_WL_shoppingList = "['A3DefaultAll']"};
//BIS_WL_shoppingList = call compile [BIS_WL_shoppingList, TRUE];
BIS_WL_shoppingList = call compile BIS_WL_shoppingList;
BIS_WL_maxSubordinates = _this getVariable ["MaxSubordinates", 9];
BIS_WL_scanCooldown = _this getVariable ["ScanCooldown", 0];
BIS_WL_maxCP = _this getVariable ["MaxCP", -1];
if (BIS_WL_maxCP < 0) then {BIS_WL_maxCP = 10e10};
BIS_WL_mapSize = getNumber (BIS_WL_cfgWrld >> "Grid" >> "offsetY");
BIS_WL_dropCost = 25; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "Airdrop"); if (_overridenCost > 0) then {BIS_WL_dropCost = _overridenCost};
BIS_WL_FTCost = 50; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "FastTravel"); if (_overridenCost > 0) then {BIS_WL_FTCost = _overridenCost};
BIS_WL_lastLoadoutCost = 50; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "LastLoadout"); if (_overridenCost > 0) then {BIS_WL_lastLoadoutCost = _overridenCost};
BIS_WL_arsenalCost = 1000; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "Arsenal"); if (_overridenCost > 0) then {BIS_WL_arsenalCost = _overridenCost};
BIS_WL_transferCost = 500; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "FundsTransfer"); if (_overridenCost > 0) then {BIS_WL_transferCost = _overridenCost};
BIS_WL_votingResetCost = 2000; _overridenCost = getNumber (missionConfigFile >> "CfgWLAssetCostOverride" >> "ResetVoting"); if (_overridenCost > 0) then {BIS_WL_votingResetCost = _overridenCost};
BIS_WL_votingResetTimeout = 300;
BIS_RET_WL_autonomous_limit = 3;
BIS_WL_newlySelectedSector = objNull;
BIS_WL_markerIndex = 1;
BIS_WL_allWarlords = +(playableUnits + switchableUnits) select {(side group _x) in [WEST, EAST]};
BIS_WL_recentlyPurchasedAssets = [];
addMissionEventHandler ["EntityRespawned", {
	BIS_WL_allWarlords = BIS_WL_allWarlords - [_this # 1];
	if ((side group _x) in [WEST, EAST]) then {
		BIS_WL_allWarlords pushBackUnique (_this # 0)
	};
	if (isServer) then {
		_this spawn BIS_WL_spawnProtectionCode;
	};
}];
BIS_WL_friendlyFireVehicleProtectionCode = {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	_owner = _unit getVariable ["BIS_WL_itemOwner", objNull];
	if (_instigator != _owner && side group _instigator == side group _owner && group _instigator != group _owner) then {
		0
	};
};
BIS_WL_vehicleLockCode = {
	params ["_item", "_initialLock"];
	_item lock _initialLock;
	_actionHandle = _item addAction [if (_initialLock) then {localize "STR_A3_cfgvehicles_miscunlock_f_0"} else {localize "STR_A3_cfgvehicles_misclock_f_0"}, {(_this select 0) removeAction (_this select 2); if (locked (_this select 0) == 2) then {(_this select 0) lock FALSE} else {(_this select 0) lock TRUE}}, [], if (_initialLock) then {100} else {-19}, if (_initialLock) then {TRUE} else {FALSE}, FALSE, "", "alive _target && _target in ((_this getVariable ['BIS_WL_pointer', objNull]) getVariable ['BIS_WL_purchased', []])", 50, TRUE];
	[_item, _actionHandle] spawn {
		params ["_item", "_actionHandle"];
		_prevLock = locked _item;
		while {alive _item} do {
			sleep 0.25;
			if (locked _item != _prevLock) then {
				_item removeAction _actionHandle;
				_prevLock = locked _item;
				_actionHandle = _item addAction [if (_prevLock == 2) then {localize "STR_A3_cfgvehicles_miscunlock_f_0"} else {localize "STR_A3_cfgvehicles_misclock_f_0"}, {(_this select 0) removeAction (_this select 2); if (locked (_this select 0) == 2) then {(_this select 0) lock FALSE} else {(_this select 0) lock TRUE}}, [], if (_prevLock == 2) then {100} else {-19}, if (_prevLock == 2) then {TRUE} else {FALSE}, FALSE, "", "alive _target && _target in ((_this getVariable ['BIS_WL_pointer', objNull]) getVariable ['BIS_WL_purchased', []])", 50, TRUE];
			};
		};
	};
};
[] spawn {while {TRUE} do {{BIS_WL_allWarlords pushBackUnique _x} forEach ((playableUnits + switchableUnits) select {(side group _x) in [WEST, EAST]}); sleep 5}};
if (isServer) then {
	BIS_WL_factionsPool = [_this getVariable "FactionOPFOR", _this getVariable "FactionBLUFOR", _this getVariable "FactionIndep"];
	BIS_WL_unitsPool = [];
	BIS_WL_punishmentDuration = 60;
	BIS_WL_friendlyFirePunishPool = [];
	BIS_WL_disconnectedVotes_WEST = [];
	BIS_WL_disconnectedVotes_EAST = [];
	BIS_WL_mortarUnits = [
		"B_support_Mort_F",
		"B_support_AMort_F",
		"B_T_Support_Mort_F",
		"B_T_Support_AMort_F",
		"I_support_Mort_F",
		"I_support_AMort_F",
		"O_support_Mort_F",
		"O_support_AMort_F",
		"O_T_Support_Mort_F",
		"O_T_Support_AMort_F"
	];
	{
		_faction = _this getVariable (["FactionOPFOR", "FactionBLUFOR", "FactionIndep"] # _forEachIndex);
		_factionUnits = [];
		_groupTypes = "TRUE" configClasses (BIS_WL_cfgGroups >> ["East", "West", "Indep"] # _forEachIndex >> _faction);
		{
			_groupClasses = "TRUE" configClasses _x;
			{
				_unitClasses = "TRUE" configClasses _x;
				_includesVehicles = FALSE;
				_groupUnits = [];
				{
					_unitClass = getText (_x >> "vehicle");
					if (toLower getText (BIS_WL_cfgVehs >> _unitClass >> "simulation") == "soldier") then {
						if (toLower getText (BIS_WL_cfgVehs >> _unitClass >> "vehicleClass") != "mendiver" && !(_unitClass in BIS_WL_mortarUnits)) then {
							_groupUnits pushBackUnique _unitClass;
						};
					} else {
						_includesVehicles = TRUE;
					};
				} forEach _unitClasses;
				if !(_includesVehicles) then {{_factionUnits pushBackUnique _x} forEach _groupUnits};
			} forEach _groupClasses;
		} forEach _groupTypes;
		_factionUnits append (("TRUE" configClasses (missionConfigFile >> "CfgWLFactionAssets" >> ["East", "West", "Indep"] # _forEachIndex >> "InfantryUnits")) apply {configName _x});
		BIS_WL_unitsPool pushBack _factionUnits;
	} forEach BIS_WL_sidesPool;
	//BIS_WL_grpPool_infantry = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Infantry")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "InfantryGroups" >> "groups")) apply {call compile [format ["BIS_WL_cfgGroups >> %1", _x], TRUE]});
	//BIS_WL_grpPool_motorized = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Motorized")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "MotorizedGroups" >> "groups")) apply {call compile [format ["BIS_WL_cfgGroups >> %1", _x], TRUE]});
	//BIS_WL_grpPool_mechanized = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Mechanized")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "MechanizedGroups" >> "groups")) apply {call compile [format ["BIS_WL_cfgGroups >> %1", _x], TRUE]});
	//BIS_WL_grpPool_armored = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Armored")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "ArmoredGroups" >> "groups")) apply {call compile [format ["BIS_WL_cfgGroups >> %1", _x], TRUE]});
	BIS_WL_grpPool_infantry = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Infantry")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "InfantryGroups" >> "groups")) apply {call compile format ["BIS_WL_cfgGroups >> %1", _x]});
	BIS_WL_grpPool_motorized = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Motorized")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "MotorizedGroups" >> "groups")) apply {call compile format ["BIS_WL_cfgGroups >> %1", _x]});
	BIS_WL_grpPool_mechanized = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Mechanized")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "MechanizedGroups" >> "groups")) apply {call compile format ["BIS_WL_cfgGroups >> %1", _x]});
	BIS_WL_grpPool_armored = ("TRUE" configClasses (BIS_WL_cfgIndepGrps >> BIS_WL_factionsPool # 2 >> "Armored")) + ((getArray (missionConfigFile >> "CfgWLFactionAssets" >> "INDEP" >> "ArmoredGroups" >> "groups")) apply {call compile format ["BIS_WL_cfgGroups >> %1", _x]});
	BIS_WL_grpPool_patrols = BIS_WL_grpPool_motorized + BIS_WL_grpPool_mechanized;
	/*BIS_WL_planeLitterClasses = [];
	{
		BIS_WL_planeLitterClasses pushBackUnique getText (_x >> "EjectionSystem" >> "EjectionSeatClass");
		BIS_WL_planeLitterClasses pushBackUnique getText (_x >> "EjectionSystem" >> "CanopyClass");
	} forEach ("getNumber (_x >> 'scope') == 2" configClasses BIS_WL_cfgVehs);
	BIS_WL_planeLitterClasses = BIS_WL_planeLitterClasses - [""];*/
	BIS_WL_spawnProtectionCode = {
		params ["_unit"];
		_t = time + 180;
		_timeout = time + 5;
		waitUntil {time > _timeout || (side group _unit) in [WEST, EAST]};
		if ((side group _unit) in [WEST, EAST]) then {
			_base = missionNamespace getVariable format ["BIS_WL_base_%1", side group _unit];
			if ([_unit, _base, TRUE] call BIS_fnc_WLInSectorArea && !(_base in [BIS_WL_currentSector_WEST, BIS_WL_currentSector_EAST])) then {
				[_unit, FALSE] remoteExec ["allowDamage", _unit];
				waitUntil {!alive _unit || time > _t || !([_unit, _base, TRUE] call BIS_fnc_WLInSectorArea) || (_base in [BIS_WL_currentSector_WEST, BIS_WL_currentSector_EAST])};
				[_unit, TRUE] remoteExec ["allowDamage", _unit];
			};
		};
	};
};
if !(isDedicated) then {
	BIS_WL_dropPool = [];
	BIS_WL_markerIndex = 1;
	BIS_WL_hintArray = ["", "", "", "", "", "", "", "", "", "", ""];
	BIS_WL_hintPrio_voteReset = 0;
	BIS_WL_hintPrio_voteSector = 1;
	BIS_WL_hintPrio_services = 2;
	BIS_WL_hintPrio_basket = 3;
	BIS_WL_hintPrio_deployDefence = 4;
	BIS_WL_hintPrio_airDrop = 5;
	BIS_WL_hintPrio_fastTravel = 6;
	BIS_WL_hintPrio_sectorScan = 7;
	BIS_WL_hintPrio_noFunds = 8;
	BIS_WL_hintPrio_baseVulnerable = 9;
	BIS_WL_hintPrio_saved = 10;
	BIS_WL_currentSelection = "";
	BIS_WL_drawEH = -1;
	BIS_WL_lastLoadout = [];
	BIS_WL_loadoutApplied = FALSE;
	BIS_WL_matesAvailable = floor (BIS_WL_maxSubordinates / 2);
	BIS_WL_matesInBasket = 0;
	BIS_WL_vehsInBasket = 0;
	BIS_WL_servicesAvailable = [];
	BIS_WL_iconDrawArray = [];
	BIS_WL_iconDrawArrayMap = [];
	BIS_WL_baseFTDisabled = FALSE;
	BIS_WL_CDShown = FALSE;
	BIS_WL_airstrips = [];
	BIS_WL_revealArr = [];
	BIS_WL_markersAlpha = (_this getVariable "MarkersTransparency") * 0.25;
	BIS_WL_playersAlpha = (_this getVariable "PlayersTransparency") * 0.25;
	BIS_WL_voice = _this getVariable "Voice";
	BIS_WL_music = _this getVariable "Music";
	BIS_WL_hoverPlayed = FALSE;
	BIS_WL_hoverAnimated = FALSE;
	BIS_WL_localized_m = localize "STR_A3_rscdisplayarcademap_meters";
	BIS_WL_localized_km = localize "STR_A3_WL_unit_km";
	BIS_WL_seizingBar_progress = [];
	BIS_WL_seizingBar_progress_prev = [];
	BIS_WL_seizingBar_progress_loop = scriptNull;
	BIS_WL_votingBar_progress = [];
	BIS_WL_votingBar_progress_prev = [];
	BIS_WL_votingBar_progress_loop = scriptNull;
	BIS_WL_sectorVotingReset_WEST = FALSE;
	BIS_WL_sectorVotingReset_EAST = FALSE;
	BIS_WL_sectorVotingResetName_WEST = "";
	BIS_WL_sectorVotingResetName_EAST = "";
	BIS_WL_travelling = FALSE;
	BIS_WL_factionAppropriateUniforms = "getNumber (_x >> 'scope') == 2" configClasses BIS_WL_cfgWpns;
	BIS_WL_factionAppropriateUniforms = (BIS_WL_factionAppropriateUniforms select {player isUniformAllowed configName _x}) apply {configName _x};
	BIS_WL_mortarBackpacks = [
		"B_Mortar_01_support_F",
		"B_Mortar_01_weapon_F",
		"B_Mortar_01_support_grn_F",
		"B_Mortar_01_Weapon_grn_F",
		"I_Mortar_01_support_F",
		"I_Mortar_01_weapon_F",
		"I_E_Mortar_01_support_F",
		"I_E_Mortar_01_weapon_F",
		"O_Mortar_01_support_F",
		"O_Mortar_01_weapon_F",
		"B_Respawn_Sleeping_bag_blue_F",
		"B_Respawn_Sleeping_bag_brown_F",
		"B_Respawn_TentDome_F",
		"B_Patrol_Respawn_bag_F",
		"B_Respawn_Sleeping_bag_F",
		"B_Respawn_TentA_F",
		"C_IDAP_UGV_02_Demining_backpack_F",
		"I_UGV_02_Demining_backpack_F",
		"O_UGV_02_Demining_backpack_F",
		"I_E_UGV_02_Demining_backpack_F",
		"B_UGV_02_Demining_backpack_F",
		"I_UGV_02_Science_backpack_F",
		"O_UGV_02_Science_backpack_F",
		"I_E_UGV_02_Science_backpack_F",
		"B_UGV_02_Science_backpack_F",
		"I_E_Mortar_01_Weapon_F"
	];
	{
		_class = _x;
		_stripArr = [];
		_runwayPos = getArray (_class >> "ilsPosition");
		{
			if (typeName _x == typeName "") then {_runwayPos set [_forEachIndex, parseNumber _x]};
		} forEach _runwayPos;
		if (count _runwayPos > 0) then {
			_incArr = getArray (_class >> "ilsDirection");
			if (count _incArr == 3) then {
				_runwayPos resize 2;
				_runwayPos pushBack 0;
				_stripArr pushBack _runwayPos;
				_incArr deleteAt 1;
				_incArr pushBack 0;
				_incArr = _incArr vectorMultiply 3500;
				_planeSpawnPos = _runwayPos vectorAdd _incArr;
				_stripArr pushBack _planeSpawnPos;
				_stripArr pushBack ([_planeSpawnPos, _runwayPos] call BIS_fnc_dirTo);
				BIS_WL_airstrips pushBack _stripArr;
			};
		};
	} forEach ([configFile >> "CfgWorlds" >> worldName] + ("TRUE" configClasses (BIS_WL_cfgWrld >> "SecondaryAirports")));
	BIS_WL_sectorColors = [
		[profileNamespace getVariable ["Map_OPFOR_R", 0], profileNamespace getVariable ["Map_OPFOR_G", 1], profileNamespace getVariable ["Map_OPFOR_B", 1], 0.8],
		[profileNamespace getVariable ["Map_BLUFOR_R", 0], profileNamespace getVariable ["Map_BLUFOR_G", 1], profileNamespace getVariable ["Map_BLUFOR_B", 1], 0.8],
		[profileNamespace getVariable ["Map_Independent_R", 0], profileNamespace getVariable ["Map_Independent_G", 1], profileNamespace getVariable ["Map_Independent_B", 1], 0.8]
	];
	if (side group player == EAST) then {
		BIS_WL_sectorIcon = "\A3\ui_f\data\map\markers\nato\o_installation.paa";
		BIS_WL_sectorMarker = "o_installation";
		BIS_WL_baseIcon = "\A3\ui_f\data\map\markers\nato\o_hq.paa";
		BIS_WL_baseMarker = "o_hq";
	} else {
		BIS_WL_sectorIcon = "\A3\ui_f\data\map\markers\nato\b_installation.paa";
		BIS_WL_sectorMarker = "b_installation";
		BIS_WL_baseIcon = "\A3\ui_f\data\map\markers\nato\b_hq.paa";
		BIS_WL_baseMarker = "b_hq";
	};
	uiNamespace setVariable ["BIS_WL_purchaseMenuLastSelection", [0, 0]];
};
if (isNil "BIS_WL_sectorScanActiveSince_EAST") then {BIS_WL_sectorScanActiveSince_EAST = -1};
if (isNil "BIS_WL_sectorScanActiveSince_WEST") then {BIS_WL_sectorScanActiveSince_WEST = -1};
if (isNil "BIS_WL_currentSector_EAST") then {BIS_WL_currentSector_EAST = objNull};
if (isNil "BIS_WL_currentSector_WEST") then {BIS_WL_currentSector_WEST = objNull};
if (isNil "BIS_WL_conqueredSectors_EAST") then {BIS_WL_conqueredSectors_EAST = []};
if (isNil "BIS_WL_conqueredSectors_WEST") then {BIS_WL_conqueredSectors_WEST = []};
if (isNil "BIS_WL_leadingSector_EAST") then {BIS_WL_leadingSector_EAST = objNull};
if (isNil "BIS_WL_leadingSector_WEST") then {BIS_WL_leadingSector_WEST = objNull};
if (isNil "BIS_WL_selectionTime_EAST") then {BIS_WL_selectionTime_EAST = -1};
if (isNil "BIS_WL_selectionTime_WEST") then {BIS_WL_selectionTime_WEST = -1};
BIS_WL_mineRestrictionCode = {
	if (toLower (_this select 1) == "put") then {
		_unit = _this select 0;
		_base = missionNamespace getVariable format ["BIS_WL_base_%1", side group _unit];
		if !(_base in [BIS_WL_currentSector_WEST, BIS_WL_currentSector_EAST]) then {
			_mine = _this select 6;
			if (_mine inArea ((_base getVariable "BIS_WL_sectorMrkrs") select 0)) then {
				_mag = _this select 5;
				deleteVehicle _mine;
				_unit addMagazine _mag;
				playSound "AddItemFailed";
				[toUpper localize "STR_A3_WL_hint_no_mines"] spawn BIS_fnc_WLSmoothText;
			};
		};
	};
};