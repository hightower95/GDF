// Script to detect if the given player is an admin
// ====================================================================================
params ["_player"];
private ["_admin_uids", "_player_is_admin"];
_admin_uids = missionNamespace getVariable ["adminUIDs", []];

_player_is_admin = false;

if((getPlayerUID _player) in _admin_uids) then {
	_player_is_admin = true;
};

if(player == _player) then {
	if(serverCommandAvailable "#kick" || !isMultiplayer) then {
		_player_is_admin = true;
	};
};


_player_is_admin;
