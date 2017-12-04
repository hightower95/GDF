// Class containing a list of all scripted functions and commands which can be remotely executed by BIS_fnc_MP / remoteExec / remoteExecCall on server or client machines. Can be defined in Config.cpp or in campaign's or mission's Description.ext. The most local variant is used. See also CfgRemoteExecCommands.

class Commands {
	// Can target anyone, don't allow to jip
	class diag_log { allowedTargets=0; }; 					
	class systemChat { allowedTargets=0; };				// Generic
	class execVM { allowedTargets=0; };					// f_setGroupIDs.sqf
	class reveal { allowedTargets=0; }; 				// fn_tfr_aiHearing.sqf
	class setDir { allowedTargets=0; }; 				// FAR Revive.sqf
	class TitleText { allowedTargets=0; }; 				// FAR Revive.sqf
	class playMove { allowedTargets=0; }; 				// FAR Revive.sqf
	class playAction { allowedTargets=0; }; 			// FAR Revive.sqf
	class setUnconscious { allowedTargets=0; }; 		// FAR Revive.sqf
	class action { allowedTargets=0; }; 				// FAR Revive.sqf
	class setPlayerRespawnTime { allowedTargets=0; }	// Wave Respawn
	class animatedoor { allowedTargets=0; }; 			// RHS
	class lockturret { allowedTargets=0; };				// RHS
};
class Functions {
	class BIS_fnc_effectKilledAirDestruction {};				// Prereq for execVM
	class BIS_fnc_effectKilledSecondaries {};					// Prereq for execVM
	class BIS_fnc_objectVar {};									// Prereq for execVM
	class BIS_fnc_spawn { allowedTargets=0; jip=1; }; 			// fn_casualtiesCapCheck.sqf
	class BIS_fnc_execVM { allowedTargets=0; }; 				// f_safeStartLoop.sqf
	class BIS_fnc_showNotification { allowedTargets=0; }; 		// f_breifing_admin.sqf
	class f_fnc_zeusInit { allowedTargets=2; }; 				// f_breifing_admin.sqf
	class f_fnc_zeusTerm { allowedTargets=2; };					// f_breifing_admin.sqf
	class f_fnc_zeusAddAddons { allowedTargets=2; };			// f_breifing_admin.sqf
	class f_fnc_zeusAddObjects { allowedTargets=2; }; 			// f_breifing_admin.sqf
	class f_fnc_safety { allowedTargets=0; jip=1; };			// f_safeStartLoop.sqf
	class f_fnc_assignGear { allowedTargets=0; };				// f_assignGear_AI.sqf
	class f_fnc_mapClickTeleportGroup { allowedTargets=0; };	// fn_mapClickTeleportUnit.sqf
	
};
//remoteexec.txt
// some advice regarding the above : https://community.bistudio.com/wiki/CfgRemoteExec
// http://opendayz.net/threads/a-guide-to-battleye-filters.21066/
// the above may be related to Battle Eye filters?