// F3 - SetFog
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// RUN ONLY ON THE SERVER
// This function does never need to run on a client
if !isServer exitWith {};

// DECLARE VARIABLES AND FUNCTIONS
params["_fog"];

if (_fog == 0) exitWith {};

// SELECT FOG VALUES
// [
//	Value for fog at base level, 
//	Decay of fog density with altitude. If set to 0 fog strength is consistent throughout.
// 	Base altitude of fog (in meters). Up until this height fog does *not* loose density.
// ]

// SELECT FOG VALUES
// Using the value of _fog, new fog values are set.

switch (_fog) do 
{
	//None
	case 1:
	{
		[0,0,0] call BIS_fnc_setFog;
	};

	//Light
	case 2:
	{
		[0.2,0,0] call BIS_fnc_setFog;
	};

	//Heavy
	case 3:
	{
		[0.4,0,0] call BIS_fnc_setFog;
	};
	
	//Random
	case 4:
	{	
		_fVal = random (0.25);
		_fDns = random (0.1);
		_fAlt = 0;
		//diag_log text format["[F3] INFO: Fog set to random: %1, %2, %3",_fVal,_fDns,_fAlt];
		[_fVal,_fDns,_fAlt] call BIS_fnc_setFog;
		3600 setFog [0,0,0]; // Dissipate after 1 Hour
	};
};