// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_refUnit","_refUnitArray","_movePoint"];

// ====================================================================================

if (count (playableUnits + switchableUnits) < 2) exitWith {};

_aceDetected = [] call f_fnc_detectACE;

if(_aceDetected) then {
	_isUnconscious = ace_medical_fnc_getUnconsciousCondition;
	// If player is not leader, and leader is alive and not unconscious
	if (leader player != player && alive (leader player) && !([leader player] call _isUnconscious)) then {
		_refUnit = leader player;
	} else {
		_refUnitArray = [];
		// Find other alive/conscious units in the group.
		{ if (alive _x && (![_x] call _isUnconscious)) then { _refUnitArray pushBack _x; }; 
		} forEach (units group player) - [player];
		
		/*If there are no units alive and conscious we'll look for the next best thing
		It would be better if in here it would find say the CO / Alpha 
		as better alternatives to teleport to.
		There are also edge cases caused by having two friendly
		sides working together. 
		Basically - this works for like 95% of missions, we'll use zeus for 4%, and 1% of the time some unlucky sod is going to have to run for 20 minutes :P.
		*/
		if (count _refUnitArray == 0) then {
			// If there are no units in the group. Find an alternate group:
			{ if ((side _x) == side (group player) && _x != player && !([_x] call _isUnconscious)) then {_refUnitArray pushBack _x;}; } forEach allUnits;
			_refUnit = _refUnitArray select 0;
		} else {
			_refUnit = _refUnitArray select 0;
		};
	};
} else {
	if (leader player != player && alive (leader player)) then {
		_refUnit = leader player;
	} else {
		_refUnitArray = [];
		
		{ if (alive _x) then { _refUnitArray pushBack _x; }; 
		} forEach (units group player) - [player];
		
		if (count _refUnitArray == 0) then {
			{ if ((side _x) == side (group player) && _x != player) then {_refUnitArray pushBack _x;}; } forEach allUnits;
			_refUnit = _refUnitArray select 0;
		} else {
			_refUnit = _refUnitArray select 0;
		};
	};
}

// ====================================================================================

// If the JIP unit's team member is in a vehicle, put him in too
// The code has fail-safe logic in case the vehicle is full
if (vehicle _refUnit != _refUnit) then {	// Member is in vehicle	
	if (!(player moveInAny (vehicle _refUnit))) then {	// Can't move JIP to vehicle!
		if ((getPos _refUnit select 2) > 10 || (speed _refUnit) > 35) then { // Member is in-flight or going too fast.
			systemChat format["Cannot Join on %1 - Target vehicle is full and in motion! Try later.",_refUnit];
		} else {
			player setPos [getPos _refUnit select 0, (getPos _refUnit select 1) - 5, 0.1];	
		};
	};
} else {
	_movePoint = position _refUnit findEmptyPosition [2,50,typeOf player];
	
	if (count _movePoint > 0) then {
		player setPos _movePoint;
	} else {
		player setPos [getPos _refUnit select 0, (getPos _refUnit select 1) - 5, 0.1];
	};
};