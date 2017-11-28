// F3 - Safe Start, Safety Toggle
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
//=====================================================================================

//Exit if server
if(isDedicated) exitWith {};

switch (_this select 0) do
{
	//Turn safety on
	case true:
	{
		// Delete bullets from fired weapons
		if (isNil "f_eh_safetyMan") then {
			f_eh_safetyMan = player addEventHandler["Fired", {systemChat "Safe Start is Enabled!"; deleteVehicle (_this select 6);}];
		};

		// Disable guns and damage for vehicles if player is crewing a vehicle
		if (vehicle player != player && {player in [gunner vehicle player,driver vehicle player,commander vehicle player]}) then {
			player setVariable ["f_var_safetyVeh",vehicle player];
			(player getVariable "f_var_safetyVeh") allowDamage false;

			if (isNil "f_eh_safetyVeh") then {
				f_eh_safetyVeh = (player getVariable "f_var_safetyVeh") addEventHandler["Fired", {deleteVehicle (_this select 6);}];
			};
		};
		
		[] spawn {
			waitUntil { time > 1 };
			
			if (vehicle player == player) then {
				player switchMove "AmovPercMstpSlowWrflDnon";
			};
		};

		// Make player invincible
		{ _x allowDamage false; } forEach playableUnits;
	};

	//Turn safety off
	case false;
	default {
		//Allow player to fire weapons
		if !(isNil "f_eh_safetyMan") then {
			player removeEventhandler ["Fired", f_eh_safetyMan];
			f_eh_safetyMan = nil;
		};
		
		// Re-enable guns and damage for vehicles if they were disabled
		if !(isNull(player getVariable ["f_var_safetyVeh",objNull])) then {
			(player getVariable "f_var_safetyVeh") allowDamage true;

			if !(isNil "f_eh_safetyVeh") then {
				(player getVariable "f_var_safetyVeh") removeEventhandler ["Fired", f_eh_safetyVeh];
				f_eh_safetyVeh = nil;
			};
			player setVariable ["f_var_safetyVeh",nil];
		};

		// Make player vulnerable
		{ _x allowDamage true; } forEach playableUnits;
	};
};