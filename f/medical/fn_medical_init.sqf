// F3 - Medical Systems Support initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
if !hasInterface exitWith {};
// RUN RELEVANT SCRIPTS, DEPENDING ON SYSTEM IN USE
// Each medical modification requires a different set of scripts to be used, and so we
// split into a separate script file for initialisation of each mod.

if (f_param_debugMode == 1) then { diag_log text format["[F3] DEBUG (fn_medical_init.sqf): Running for %1",([player,"Server"] select isServer)]; };

// Check which system to use
call
{
	// Farooq
		// If script is being run on a client
		if hasInterface then {
			call compileFinal preprocessFileLineNumbers "f\medical\FAR_revive\FAR_revive_init.sqf";
		};
};