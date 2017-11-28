
if (!hasInterface) exitWith {};
// if (!isDedicated && (isNull player)) then {waitUntil {!isNull player};};

// Wait until server has set parameters.
// waitUntil{!(isNil "f_var_setParams")};

// ====================================================================================
// DECLARE VARIABLES AND FUNCTIONS
// private ["_player_side"];

// ====================================================================================
// DECLARE VARIABLES AND FUNCTIONS
_player_side = side player;

// Briefing for admin - put in a different thread so that if an admin logs in
// during the mission, they will have the brief added.
_x = [] spawn {
	waitUntil {[player] call f_fnc_isPlayerAdmin};
	if (isNil "f_admin_brief_added") then {
		#include "..\..\briefing\orders_admin.sqf";
		systemChat "Admin Briefing Added";
	};
	f_admin_brief_added = true;
};

switch (_player_side) do {	
	case west : {
		#include "..\..\briefing\orders_west.sqf";
	};
	case east : {
		#include "..\..\briefing\orders_east.sqf";
	};
	case resistance : {
		#include "..\..\briefing\orders_geur.sqf";
	};
	case civilian : {
		#include "..\..\briefing\orders_civ.sqf";
	};
	case sideLogic : {
		#include "..\..\briefing\orders_zeus.sqf";
	};
	default { diag_log text format ["[F3] DEBUG (briefing.sqf): Side %1 is not defined.",_player_side];	};
};

player createDiaryRecord ["diary", ["",""]];