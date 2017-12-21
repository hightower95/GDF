// F3 - SetTime
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// Player is JIP so time will be synced automatically.
if !isServer exitWith {};
params ["_timeOfDay"];

// Fix for single-player.
if (!isNil "f_var_timeOfDay") exitWith {};

// DECLARE VARIABLES AND FUNCTIONS
private ["_year","_month","_day","_transition","_hour","_minute","_time"];

// f_var_timeOfDay is also used to set clear weather at night for SERVER.
if (_timeOfDay == 0) exitWith {
	missionNamespace setVariable ["f_var_timeOfDay", daytime, true];
};

// SET DEFAULT VALUES
// The default values that together form the in-game date are set.
_year = 2030;
_month = 6;
_day = 16;

// CALCULATE SUNSET/SUNRISE
// Ensure dawn and dusk don't happen in the dark during different seasons and at different latitudes
_sunsetSunrise = [_year,_month,_day,0,0] call BIS_fnc_sunriseSunsetTime;
_sunriseSunsetExists = !(_sunsetSunrise in [[-1,0],[0,-1]]); // can happen if you're far north or far south
_sunrise = [floor (_sunsetSunrise select 0), floor (((_sunsetSunrise select 0) % 1) * 60)];
_sunset = [floor (_sunsetSunrise select 1), floor (((_sunsetSunrise select 1) % 1) * 60)];

// function for correcting adding hours and minutes to hours and minutes
_addTime = {
    params ["_timeStart","_minutes"];
    _result = [_timeStart,[0,_minutes]] call BIS_fnc_vectorAdd;
	
	// Balance additional minutes
    while { _result select 1 > 60 } do {
        _result set [1,(_result select 1) - 60];
        _result set [0,(_result select 0) + 1];
    };
	
	// Balance negative minutes.
	while { _result select 1 < 0 } do {
        _result set [1,(_result select 1) + 60];
        _result set [0,(_result select 0) - 1];
    };
		
    // make sure hour is in range [0,23]
    _result set [0,(_result select 0) % 24];
    if (_result select 0 < 0) then {
        _result set [0,(_result select 0) + 24];
    };
    _result
};

// SELECT MISSION TIME OF DAY
// Using the value of _timeOfDay, we define new values for _hour and _minute.
switch (_timeOfDay) do {
	// 60m to Sunrise
	case 1: { if (_sunriseSunsetExists) then { _time = [_sunrise,-60] call _addTime; } else { _time = [3,20]; }; };	
	// 30m to Sunrise
	case 2: { if (_sunriseSunsetExists) then { _time = [_sunrise,-30] call _addTime; } else { _time = [4,20]; }; };	
	// Sunrise
	case 3: { if (_sunriseSunsetExists) then { _time = _sunrise; } else { _time = [4,40]; }; };	
	// Early Morning 30m after Sunrise
	case 4: { if (_sunriseSunsetExists) then { _time = [_sunrise,30] call _addTime; } else { _time = [5,20]; }; };	
	// Morning 90m after Sunrise
	case 5: { if (_sunriseSunsetExists) then { _time = [_sunrise,60] call _addTime; } else { _time = [6,20]; }; };	
	// Late Morning
	case 6: { _time = [9,0]; }; 
	// Noon
	case 7:{ _time = [12,0]; }; 
	// Afternoon
	case 8:{ _time = [15,0]; }; 
	// Late Afternoon (60m To Last Light)
	case 9: { if (_sunriseSunsetExists) then { _time = [_sunset,-60] call _addTime; } else { _time = [18,10]; }; };	
	// Evening (30m To Last Light)
	case 10: { if (_sunriseSunsetExists) then { _time = [_sunset,-30] call _addTime; } else { _time = [18,40]; }; };	
	// Sunset
	case 11: { if (_sunriseSunsetExists) then { _time = _sunset; } else { _time = [19,10]; }; };	
	// Night
	case 12:{ _time = [22,15]; }; 
	// Midnight
	case 13: { _time = [0,0]; };
	// Random
	case 14:{ _time = [floor random 23.9,floor random 60]; };
};

_time params ["_hour","_minute"];

// CHECK IF TRANSITION IS NEEDED
// If we're changing the date in-mission, set the BIS function to display a smooth transition
// We check the various dates to make sure we stick with a smart value

_transition = false;
if (time > 0) then {
	_transition = true;
	_day = date select 2;
	_month = date select 1;
	_year = date select 0;

	if (date select 3 > _hour) then {_day = _day + 1};
	if (_day > 31) then {_day = 1; _month = _month + 1};
	if (_month > 12) then {_month = 1; _year = _year + 1};
};

// SET DATE VARIABLE
// Using the single variables, we construct a new variable _date
_date = [_year,_month,_day,_hour,_minute];

f_var_timeOfDay = _hour;
publicVariable "f_var_timeOfDay";

//diag_log text format["[F3] INFO: Time set to: %1",_hour];

// SET DATE FOR ALL CLIENTS
// Using a BIS function we share the new date across the network
[_date,true,_transition] call BIS_fnc_setDate;