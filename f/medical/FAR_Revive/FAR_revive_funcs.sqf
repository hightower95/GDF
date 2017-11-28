////////////////////////////////////////////////
// Player Actions
////////////////////////////////////////////////
FAR_Player_Actions =
{
	if (alive player && player isKindOf "Man") then 
	{
		// addAction args: title, filename, (arguments, priority, showWindow, hideOnUse, shortcut, condition, positionInModel, radius, radiusView, showIn3D, available, textDefault, textToolTip)
		player addAction ["<t color=""#C90000"">" + "Revive" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_revive"], 11, true, true, "", "call FAR_Check_Revive"];
		player addAction ["<t color=""#C90000"">" + "Stabilize" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_stabilize"], 10, true, true, "", "call FAR_Check_Stabilize"];
		player addAction ["<t color=""#C90000"">" + "Drag" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_drag"], 9, false, true, "", "call FAR_Check_Dragging"];
		if (!isNil "f_param_respawn") then {
			if (f_param_respawn == 0) then {
				player addAction ["<t color=""#C90000"">" + "Spectate" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];	
			} else {
				player addAction ["<t color=""#C90000"">" + "Suicide" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];
			};
		} else {
			player addAction ["<t color=""#C90000"">" + "Suicide" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];
		};
	};
};

FAR_AI_Actions =
{
	_unit = _this select 0;		
	if (alive _unit && _unit isKindOf "Man") then 
	{
		// addAction args: title, filename, (arguments, priority, showWindow, hideOnUse, shortcut, condition, positionInModel, radius, radiusView, showIn3D, available, textDefault, textToolTip)
		_unit addAction ["<t color=""#B70000"">" + "Revive" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_revive"], 11, true, true, "", "call FAR_Check_Revive"];
		_unit addAction ["<t color=""#B70000"">" + "Stabilize" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_stabilize"], 10, true, true, "", "call FAR_Check_Stabilize"];
		_unit addAction ["<t color=""#B70000"">" + "Drag" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_drag"], 9, false, true, "", "call FAR_Check_Dragging"];
		if (!isNil "f_param_respawn") then {
			if (f_param_respawn == 0) then {
				_unit addAction ["<t color=""#B70000"">" + "Spectate" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];	
			} else {
				_unit addAction ["<t color=""#B70000"">" + "Suicide" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];
			};
		} else {
			_unit addAction ["<t color=""#B70000"">" + "Suicide" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_suicide"], 9, false, true, "", "call FAR_Check_Suicide"];
		};
	};
};

////////////////////////////////////////////////
// Handle Death
////////////////////////////////////////////////
FAR_HandleDamage_EH =
{
	private ["_isUnconscious","_damageReduction","_damageToAdd"];
	params ["_unit","_bodyPart","_amountOfDamage","_killer"];
	_isUnconscious = _unit getVariable "FAR_isUnconscious";
	if(isNil "f_param_farooq_modifier") then {
		f_param_farooq_modifier = 0;
	};
	_damageReduction = 1 - (f_param_farooq_modifier/100);
	if(_damageReduction <= 0) then {
		_damageReduction = 1;
	};
	// f_param_farooq_modifier: 
	// 0: Off
	// 1: 35% less damage
	// 3: 67% less damage
	// 6: 84% less damage
	if(_bodyPart == "head" && _bodyPart != "" && headgear _unit != "" && _damageToAdd > 0.6) then {
		removeHeadgear _unit;
		_damageToAdd = 0.15;
	};
	
	if(f_param_farooq_modifier > 0 && _amountOfDamage < 0.99 && _isUnconscious == 0 && alive _unit) then {
		// executes if amount of damage = 0. NEVER add a base modifier
		_currentDamage = damage _unit;
		_damageToAdd = _amountOfDamage - _currentDamage;
		if(_damageToAdd != 0) then {
			player sideChat format ["Current: %1, Damage to add: %2, after reduction: %3", _currentDamage, _damageToAdd, (_damageToAdd * _damageReduction)];
		};
		_amountOfDamage = _currentDamage + (_damageToAdd * _damageReduction);
	};
	
	if (alive _unit && 
		_amountOfDamage >= 0.9 && 
		_isUnconscious == 0 && 
		_bodyPart in ["","head","face_hub","neck","spine1","spine2","spine3","pelvis","body"]
		) then { // 1.54 Changes
			_unit setDamage 0;
			_unit allowDamage false;
			_amountOfDamage = 0;
			[_unit, _killer] spawn FAR_Player_Unconscious;
		};
	_amountOfDamage;
};

////////////////////////////////////////////////
// Make Player Unconscious
////////////////////////////////////////////////
FAR_Player_Unconscious =
{
	private["_tickLeft"];
	params ["_unit", "_killer"];
	_tickLeft = 0;
	
	// Death message
	if (FAR_EnableDeathMessages && !isNil "_killer" && isPlayer _killer && _killer != _unit) then
	{
		FAR_deathMessage = [_unit, _killer];
		publicVariable "FAR_deathMessage";
		["FAR_deathMessage", [_unit, _killer]] call FAR_public_EH;
	};
	
	[player] remoteExec ["f_fnc_casualtyReceiver", 2]; // send message to server - it handles the rest
	// 26K- Casualty Count & OSD	
	// switch (side (group player)) do {
	// 	case west: {
	// 		f_var_casualtyCount_west = f_var_casualtyCount_west + 1; 
	// 		publicVariable "f_var_casualtyCount_west"; 
	// 		"respawn_west" setMarkerText format["Casualties: %1",f_var_casualtyCount_west];
	// 	};
		
	// 	case east: {
	// 		f_var_casualtyCount_east = f_var_casualtyCount_east + 1; 
	// 		publicVariable "f_var_casualtyCount_east"; 
	// 		"respawn_east" setMarkerText format["Casualties: %1",f_var_casualtyCount_east];
	// 	};
		
	// 	case resistance: {
	// 		f_var_casualtyCount_indp = f_var_casualtyCount_indp + 1; 
	// 		publicVariable "f_var_casualtyCount_indp"; 
	// 		"respawn_guerrila" setMarkerText format["Casualties: %1",f_var_casualtyCount_indp];
	// 	};
		
	// 	default {
	// 		f_var_casualtyCount_civ = f_var_casualtyCount_civ + 1; 
	// 		publicVariable "f_var_casualtyCount_civ"; 
	// 		"respawn_civilian" setMarkerText format["Casualties: %1",f_var_casualtyCount_civ];
	// 	};
	// };
	
	if (isPlayer _unit) then
	{
		disableUserInput true;
		titleText ["", "BLACK FADED"];
		disableUserInput false;
		disableUserInput true;
		disableUserInput false;
	};
	
	// Eject unit if inside vehicle
	if (vehicle _unit != _unit) then 
	{
		unAssignVehicle _unit;
		_unit action ["getOut", vehicle _unit];
		
		sleep 2;
	};
	
	_unit setDamage 0;
    _unit setVelocity [0,0,0];
    _unit allowDamage false;
	_unit setCaptive true;
    _unit playMove "AinjPpneMstpSnonWrflDnon_rolltoback";
	
	sleep 4;
    
	if (isPlayer _unit) then {
		titleText ["", "BLACK IN", 1];
		disableUserInput false;
	};
	
	_unit switchMove "AinjPpneMstpSnonWrflDnon";
	_unit enableSimulation false;
	_unit setVariable ["FAR_isUnconscious", 1, true];
	
	// Call this code only on players
	if (isPlayer _unit) then  {
		_bleedOut = time + FAR_BleedOut;
		
		// 26K - Spectator Intermission START (CSSA3)
		if (!FAR_IsCoop || FAR_BleedOut == 9999) then {
			["Initialize", [_unit, [(side _unit)], false, false]] call BIS_fnc_EGSpectator;
		};
		
		while { !isNull _unit && alive _unit && _unit getVariable "FAR_isUnconscious" == 1 && _unit getVariable "FAR_isStabilized" == 0 && (FAR_BleedOut <= 0 || time < _bleedOut) } do {
			if (FAR_BleedOut > 900) then {
				hintSilent format["Waiting for a medic\n\n%1", call FAR_CheckFriendlies];
			} else { 
				hintSilent format["Bleedout in %1 seconds\n\n%2", round (_bleedOut - time), call FAR_CheckFriendlies];
			};
			sleep 0.5;
		};
		
		if (_unit getVariable "FAR_isStabilized" == 1) then {
			//Unit has been stabilized. Disregard bleedout timer.
			
			while { !isNull _unit && alive _unit && _unit getVariable "FAR_isUnconscious" == 1 } do {
				hintSilent format["You have been stabilized\n\n%1", call FAR_CheckFriendlies];	
				sleep 0.5;
			};
		};
		
		// Player bled out
		if (FAR_BleedOut > 0 && {time > _bleedOut} && {_unit getVariable ["FAR_isStabilized",0] == 0}) then {
			// Player will be coming back alive, stop the camera.
			["Terminate"] call BIS_fnc_EGSpectator;
			_unit setDamage 1;
		} else {
			["Terminate"] call BIS_fnc_EGSpectator;
			// Player got revived
			_unit setVariable ["FAR_isStabilized", 0, true];
			sleep 6;
			
			// Clear the "medic nearby" hint
			hintSilent "";
			
			_unit enableSimulation true;
			_unit allowDamage true;
			_unit setDamage 0;
			_unit setCaptive false;
			
			_unit playMove "amovppnemstpsraswrfldnon";
			_unit playMove "";
		};
	} else {
		// [Debugging] Bleedout for AI
		_bleedOut = time + FAR_BleedOut;
		
		while {!isNull _unit && alive _unit && _unit getVariable "FAR_isUnconscious" == 1 && _unit getVariable "FAR_isStabilized" == 0 && (FAR_BleedOut < 0 || time < _bleedOut) } do
		{
			sleep 0.5;
		};
		
		if (_unit getVariable "FAR_isStabilized" == 1) then {			
			while { !isNull _unit && alive _unit && _unit getVariable "FAR_isUnconscious" == 1 } do
			{
				sleep 0.5;
			};
		};
		
		// AI bled out
		if (FAR_BleedOut > 0 && {time > _bleedOut} && {_unit getVariable ["FAR_isStabilized",0] == 0}) then
		{
			_unit setDamage 1;
			_unit setVariable ["FAR_isUnconscious", 0, true];
			_unit setVariable ["FAR_isDragged", 0, true];
		}
	};
};

////////////////////////////////////////////////
// Revive Player
////////////////////////////////////////////////
FAR_HandleRevive =
{
	params ["_target"];

	if (alive _target) then
	{
		player playMove "AinvPknlMstpSlayWrflDnon_medic";

		_target setVariable ["FAR_isUnconscious", 0, true];
		_target setVariable ["FAR_isDragged", 0, true];
		
		sleep 6;
		
		// [Debugging] Code below is only relevant if revive script is enabled for AI
		if (!isPlayer _target) then
		{
			_target enableSimulation true;
			_target allowDamage true;
			_target setDamage 0;
			_target setCaptive false;
			
			_target playMove "amovppnemstpsraswrfldnon";
		};
	
	};
};

////////////////////////////////////////////////
// Stabilize Player
////////////////////////////////////////////////
FAR_HandleStabilize =
{
	params ["_target"];

	if (alive _target) then
	{
		player playMove "AinvPknlMstpSlayWrflDnon_medic";
		
		if (!("Medikit" in (items player)) ) then {
			player removeItem "FirstAidKit";
		};

		_target setVariable ["FAR_isStabilized", 1, true];
		
		sleep 6;
	};
};

////////////////////////////////////////////////
// Drag Injured Player
////////////////////////////////////////////////
FAR_Drag =
{
	private ["_id"];
	params ["_target"];
	
	FAR_isDragging = true;

	_target attachTo [player, [0, 1.1, 0.092]];
	_target setDir 180;
	_target setVariable ["FAR_isDragged", 1, true];
	
	player playMoveNow "AcinPknlMstpSrasWrflDnon";
	
	// Rotation fix
	FAR_isDragging_EH = _target;
	publicVariable "FAR_isDragging_EH";
	
	// Add release action and save its id so it can be removed
	_id = player addAction ["<t color=""#C90000"">" + "Release" + "</t>", "f\medical\FAR_revive\FAR_handleAction.sqf", ["action_release"], 10, true, true, "", "true"];
	
	hint "Press 'C' if you can't move.";
	
	// Wait until release action is used
	waitUntil 
	{ 
		!alive player || player getVariable "FAR_isUnconscious" == 1 || !alive _target || _target getVariable "FAR_isUnconscious" == 0 || !FAR_isDragging || _target getVariable "FAR_isDragged" == 0 
	};

	// Handle release action
	FAR_isDragging = false;
	
	if (!isNull _target && alive _target) then
	{
		_target switchMove "AinjPpneMstpSnonWrflDnon";
		_target setVariable ["FAR_isDragged", 0, true];
		detach _target;
	};
	
	player removeAction _id;
};

FAR_Release =
{
	// Switch back to default animation
	player playMove "amovpknlmstpsraswrfldnon";

	FAR_isDragging = false;
};

////////////////////////////////////////////////
// Event handler for public variables
////////////////////////////////////////////////
FAR_public_EH =
{
	if(count _this < 2) exitWith {};
	
	params ["_EH", "_target"];

	// FAR_isDragging
	if (_EH == "FAR_isDragging_EH") then
	{
		_target setDir 180;
	};
	
	// FAR_deathMessage
	if (_EH == "FAR_deathMessage") then
	{
		_killed = _target select 0;
		_killer = _target select 1;

		if (isPlayer _killed && isPlayer _killer) then {
			if (FAR_IsCoop) then {
				systemChat format["%1 was killed by %2", name _killed, name _killer];
			} else {
				systemChat format["%1 (%3) was killed by %2 (%4)", name _killed, name _killer, side (group _killed), side (group _killer)];
			};
		};
	};
};

////////////////////////////////////////////////
// Revive Action Check
////////////////////////////////////////////////
FAR_Check_Revive = 
{
	private ["_target", "_isTargetUnconscious", "_isDragged"];

	_return = false;
	
	// Unit that will excute the action
	_isPlayerUnconscious = player getVariable "FAR_isUnconscious";
	_isMedic = getNumber (configfile >> "CfgVehicles" >> typeOf player >> "attendant");
	_target = cursorTarget;

	// Make sure player is alive and target is an injured unit
	if( !alive player || _isPlayerUnconscious == 1 || FAR_isDragging || isNil "_target" || !alive _target || (!isPlayer _target && !FAR_Debugging) || (_target distance player) > 2 || side (group player) != side (group _target)) exitWith
	{
		_return
	};
	
	_isTargetUnconscious = _target getVariable "FAR_isUnconscious";
	_isDragged = _target getVariable "FAR_isDragged"; 
	
	// Make sure target is unconscious and player is a medic 
	if (_isTargetUnconscious == 1 && _isDragged == 0 && (_isMedic == 1 || FAR_ReviveMode > 0) ) then
	{
		_return = true;

		// [ReviveMode] Check if player has a Medikit
		if ( FAR_ReviveMode == 2 && !("Medikit" in (items player)) ) then
		{
			_return = false;
		};
	};
	
	_return
};

////////////////////////////////////////////////
// Stabilize Action Check
////////////////////////////////////////////////
FAR_Check_Stabilize = 
{
	private ["_target", "_isTargetUnconscious", "_isDragged"];

	_return = false;
	
	// Unit that will excute the action
	_isPlayerUnconscious = player getVariable "FAR_isUnconscious";
	_target = cursorTarget;
	

	// Make sure player is alive and target is an injured unit
	if( !alive player || _isPlayerUnconscious == 1 || FAR_isDragging || isNil "_target" || !alive _target || (!isPlayer _target && !FAR_Debugging) || (_target distance player) > 2) exitWith
	{
		_return
	};
	
	_isTargetUnconscious = _target getVariable "FAR_isUnconscious";
	_isTargetStabilized = _target getVariable "FAR_isStabilized";
	_isDragged = _target getVariable "FAR_isDragged"; 
	
	// Make sure target is unconscious and hasn't been stabilized yet, and player has a FAK/Medikit 
	if (_isTargetUnconscious == 1 && _isTargetStabilized == 0 && _isDragged == 0 && ( ("FirstAidKit" in (items player)) || ("Medikit" in (items player)) ) ) then
	{
		_return = true;
	};
	
	_return
};

////////////////////////////////////////////////
// Suicide Action Check
////////////////////////////////////////////////
FAR_Check_Suicide =
{
	_return = false;
	_isPlayerUnconscious = player getVariable ["FAR_isUnconscious",0];
	
	// Below checks player is stablized before allowing respawn.
	// _isTargetStabilized = player getVariable ["FAR_isStabilized",0];
	// if (alive player && _isPlayerUnconscious == 1) then 
	
	if (alive player && _isPlayerUnconscious == 1) then 
	{
		_return = true;
	};
	
	_return
};

////////////////////////////////////////////////
// Dragging Action Check
////////////////////////////////////////////////
FAR_Check_Dragging =
{
	private ["_target", "_isPlayerUnconscious", "_isDragged"];
	
	_return = false;
	_target = cursorTarget;
	_isPlayerUnconscious = player getVariable "FAR_isUnconscious";

	if( !alive player || _isPlayerUnconscious == 1 || FAR_isDragging || isNil "_target" || !alive _target || (!isPlayer _target && !FAR_Debugging) || (_target distance player) > 2 ) exitWith
	{
		_return;
	};
	
	// Target of the action
	_isTargetUnconscious = _target getVariable "FAR_isUnconscious";
	_isDragged = _target getVariable "FAR_isDragged"; 
	
	if(_isTargetUnconscious == 1 && _isDragged == 0) then
	{
		_return = true;
	};
		
	_return
};

////////////////////////////////////////////////
// Show Nearby Friendly Medics
////////////////////////////////////////////////
FAR_IsFriendlyMedic =
{
	private ["_unit"];
	
	_return = false;
	_unit = _this;
	_isMedic = getNumber (configfile >> "CfgVehicles" >> typeOf _unit >> "attendant");
				
	if ( alive _unit && (isPlayer _unit || FAR_Debugging) && side (group _unit) == side (group player) && _unit getVariable "FAR_isUnconscious" == 0 && _isMedic == 1) then
	{
		_return = true;
	};
	
	_return
};

FAR_CheckFriendlies =
{
	private ["_unit", "_units", "_medics", "_hintMsg"];
	
	_units = nearestObjects [getpos player, ["Man", "Car", "Air", "Ship"], 800];
	_medics = [];
	_dist = 800;
	_hintMsg = "";
	
	// Find nearby friendly medics
	if (count _units > 1) then
	{
		{
			if (_x isKindOf "Car" || _x isKindOf "Air" || _x isKindOf "Ship") then
			{
				if (alive _x && count (crew _x) > 0) then
				{
					{
						if (_x call FAR_IsFriendlyMedic) then
						{
							_medics = _medics + [_x];
							
							if (true) exitWith {};
						};
					} forEach crew _x;
				};
			} 
			else 
			{
				if (_x call FAR_IsFriendlyMedic) then
				{
					_medics = _medics + [_x];
				};
			};
			
		} forEach _units;
	};
	
	// Sort medics by distance
	if (count _medics > 0) then
	{
		{
			if (player distance _x < _dist) then
			{
				_unit = _x;
				_dist = player distance _x;
			};
		
		} forEach _medics;
		
		if (!isNull _unit) then
		{
			_unitName	= name _unit;
			_distance	= floor (player distance _unit);
			
			_hintMsg = format["Nearby Medic:\n%1 is %2m away.", _unitName, _distance];
		};
	} 
	else 
	{
		_hintMsg = "No medic nearby.";
	};
	
	_hintMsg
};



