// Full Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
waitUntil { isServer || !isNull player };
// ======================================
// README:
// Before you think you can change everything from 'execVM' to 'call' or 'spawn'
// https://forums.bistudio.com/forums/topic/115016-call-execvm-and-spawn-which-and-when/
// ====================================================================================
// MISSION SPECIFIC SCRIPTS AND VARIABLES
if(!isDedicated) then {
	f_param_debugMode = 1;
};
// ====================================================================================
// SHARED SCRIPTS - Both client and server
gd_param_safeStart = true; //todo :move to config file
[gd_param_safeStart] spawn f_fnc_enableSafeStart; 	// F3 - Safe Start
//====================================================================================
// SERVER ONLY SCRIPTS!
if isServer then {
	// DO NOT disable this - (disabled HT 2017). This actually creates multiple arrays of units - these may be used to set AI skill levels I guess. Disabled and no effect. 
	// f_script_setLocalVars = [] execVM "f\common\f_setLocalVars.sqf"; 	// F3 - Common Local Variables
	// [] execVM "f\misc\f_stayInVehicle.sqf"; 			// Zeus - Stubborn Crew
	// Set the AI skill (all 7 of the AI skills)
	// [] execVM "f\setAISKill\f_setAISkill.sqf"; 		// F3 - AI Skill Selector
	// Define the groups that are in game. This is important for the HUD showing groups. 
	// If you are having issues check mission/groups.hpp 
	// [] execVM "f\setGroupID\f_setGroupIDs.sqf";		// F3 - Group IDs
	
	// Will write a debug line to the server log file every 30 seconds. Can be handed for troubleshooting
	// [] execVM "f\misc\f_stayInVehicle.sqf"; 			// Zeus - Stubborn Crew
	// [] spawn {
	// 	sleep 0.1;
	// 	{if (_x isKindOf "Man" && !(_x getVariable["BIS_hvt_keepSimulationEnabled",false])) then {deleteVehicle _x}} forEach allDead;
	// };
	[] spawn {
		sleep 1;
		waitUntil {
			sleep 30;
			diag_log text format ["[F3] PERFORMANCE --- Elapsed time: %1 --- Server FPS: %2 --- Server Min FPS: %3",[(round time)] call BIS_fnc_secondsToString,round (diag_fps),round (diag_fpsmin)];
			!isNil "f_var_stopLogging";
		};
	};
	[] execVM "f\respawn\fn_createJIPflag.sqf";							// Zeus - JIP Flagpole
	// LEAVE! This lets other scripts know that the server has completed its initialization
	missionNamespace setVariable ["f_var_missionLoaded", true, true];
};
// ====================================================================================
// CLIENT ONLY SCRIPTS - Typically controlled via MISSION PARAMETERS.
if hasInterface then { 
	if isMultiplayer then { 
			enableSaving [false, false];			// Disable Saving
			enableSentences false;					// Disable Unit Calls
			player setSpeaker "NoVoice";
	};
	
	if (!([] call f_fnc_detectACE)) then {
		// [] spawn f_fnc_earplugs;
		// [] call f_fnc_showPlayerNametag;
		// Group map markers
		// [] execVM "f\groupMarkers\f_setLocGroupMkr.sqf";				// F3 - Group Markers
		// earplugs, player name tag hud, group hud tag.
	};

	if(([] call f_fnc_detectTFAR)) then {
		[] call f_fnc_initTFAR; // Edit config\modConfig\tfar.hpp
	};

	/*
		TODO: (for briefing)
			Add loadout notes
			Add loadout options
			Add orbat
	*/
	// Todo - I know ace does this, but saves time. 
	// [] call f_group_assignFTColours;
	// Todo - show where FT is on the map (little triangles)
	// [] 
	[] execVM "f\map\fn_drawAO.sqf";
	[] execVM "f\briefing\fn_initBriefing.sqf";
	// TODO: but better- can this be done on the server?
	// [] call f_fnc_createJIPFlag; // requires a marker called 'respawn_' + side (e.g. respawn_west, respawn_east, respawn_guer)
	// [] spawn f_fnc_thirdPersonRestrict;
	// [] spawn f_fnc_initCasualtyWatcher;

	// ====================================================================================
	// CLIENT INTRO
	titleCut ["", "BLACK IN", 5];
	[] spawn {
		sleep 0.1;
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [6];
		"dynamicBlur" ppEffectCommit 0;
		"dynamicBlur" ppEffectAdjust [0.0];
		"dynamicBlur" ppEffectCommit 7;
		[] call f_fnc_playMissionIntro;
	};
};

if(isServer) then {
	// todo: detect mission issues. Though may be best to put this in a script called immediately at the top of this file and which runs in a separate thread.
// Leave in for debug. Its sort of useful - will tell you if you've forgotten to give gear to units or other tips. 
	// [] execVM "f\common\f_debug.sqf"; 				// Zeus - Debug
};
// ====================================================================================