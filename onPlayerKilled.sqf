if (isDedicated) exitWith{};

params ["_killed","_killer"];
if (isNil "f_param_respawn_delay") then {f_param_respawn_delay = 30};

[] spawn {
	sleep 2;
	systemChat format["Respawn in %1 seconds.",f_param_respawn_delay];
};
setPlayerRespawnTime f_param_respawn_delay;

// Commented - 18/11/2017 - I (HT) dont think this has a useful effect
// if (f_param_revivemode == 2) exitWith{}; // Let FAROOQ handle the kill counts (KO + Suicide should not equal 2 Kills)

if(_killer == _killed) then {
	systemChat "Player killed themselves.";
};

[] spawn {
	// Update casualty counter.

	// Random sleep to allow network sync if multiple casualties.
	sleep random 25;
	{
		_x params ["_sideVar","_nameVar","_markerVar"];
		if (playerSide == _sideVar) exitWith {
			_casVar = missionNamespace getVariable [_nameVar,0];
			// Change the respawn marker to reflect # of casualties.
			missionNamespace setVariable [_nameVar,_casVar + 1,true];
			_markerVar setMarkerText format["Casualties: %1",(_casVar + 1)];
		};
	} forEach [
		[west,"f_var_casualtyCount_west","respawn_west"],
		[east,"f_var_casualtyCount_east","respawn_east"],
		[resistance,"f_var_casualtyCount_indp","respawn_guerrila"],
		[civilian,"f_var_casualtyCount_civ","respawn_civilian"]
	];
};