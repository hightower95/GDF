// F3 - SetWeather
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
params [["_wind",0]];

if (!isServer || isNil "_wind") exitWith {};

// SELECT MISSION WIND

// ACE SETTINGS
// ACE_WIND_PARAMS = [currentDirection, directionChange, currentSpeed, speedChange, transitionTime];

0 setWaves (_wind / 10);
setWind [_wind,random _wind];
missionNamespace setVariable ["ACE_WIND_PARAMS", [random 360, random 10, _wind, random (_wind / 2), 240], true];

f_param_wind = _wind;
publicVariable "f_param_wind";

diag_log text format["[F3] INFO: Wind %1",_wind];