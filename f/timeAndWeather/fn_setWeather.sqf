// F3 - SetWeather
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// RUN ONLY ON THE SERVER
// This function does never need to run on a client
if !isServer exitWith {};

params ["_weather"];

if (_weather == 0) exitWith {};

// SELECT MISSION WEATHER
// Using the value of _weather, new weather conditions are set.
switch (_weather) do {
// Clear (Calm)
	case 1:
	{
		[0] call BIS_fnc_setOvercast;
		0 setWindStr  0.01;
		0 setWindForce 0.01;
		0 setWaves 0;
	};
// Light Cloud
	case 2:
	{
		[0.25] call BIS_fnc_setOvercast;
		0 setWindStr  0.01;
		0 setWindForce 0.01;
		0 setWaves 0;
	};
// Overcast
	case 3:
	{
		[0.5] call BIS_fnc_setOvercast;
		0 setWindStr  0.25;
		0 setWindForce 0.5;
		0 setWaves 0.25;
	};
// Rain
	case 4:
	{
		[0.75] call BIS_fnc_setOvercast;
		0 setWindStr  0.25;
		0 setWindForce 0.5;
		0 setWaves 0.25;
	};
// Storm
	case 5:
	{
		[1] call BIS_fnc_setOvercast;
		0 setWindStr  0.75;
		0 setWindForce 1;
		0 setWaves 0.25;
	};
// Random
	case 6:
	{
		_weather = random 1;
		_windStr = random 0.15;
		_windForce = random 0.1;
		_windWaves = random 0.15;
		
		0 setWindStr _windStr;
		0 setWindForce _windForce;
		0 setWaves _windWaves;
		
		[_weather] spawn {
			waitUntil{!isNil "f_var_timeOfDay"};
			if (f_var_timeOfDay < 4 || f_var_timeOfDay > 19) then { 
				[0] call BIS_fnc_setOvercast;
			} else {
				_this call BIS_fnc_setOvercast;
			};
		};
	};
};

diag_log text format["[F3] INFO: Weather: %1",_weather];