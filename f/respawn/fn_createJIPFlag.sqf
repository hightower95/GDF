
if(!isServer) exitWith {};

_spawnFlag = true;

if _spawnFlag then {
	_flagType = "Flag_AltisColonial_F";
	_flagMarker = "respawn_civilian";

	_player = allPlayers select 0;

	switch (side (group _player)) do {
		case west		: { _flagType = "Flag_Blue_F"; 	_flagMarker = "respawn_west"; };
		case east		: { _flagType = "Flag_Red_F"; 	_flagMarker = "respawn_east"; };
		case resistance	: { _flagType = "Flag_Green_F"; _flagMarker = "respawn_guerrila"; };
	};

// ====================================================================================

	// Create JIP Flag
	if (_flagMarker in allMapMarkers) then {
		if (isNil "f_obj_BaseFlag") then {
				f_obj_BaseFlag = _flagType createVehicleLocal [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5, 0];
				sleep 0.5;
				
				// Don't spawn on seabed.
				if (underwater f_obj_BaseFlag) then {
					f_obj_BaseFlag setPosASL [position f_obj_BaseFlag select 0,position f_obj_BaseFlag select 1,0];
					_flagStone = "Land_W_sharpStone_02" createVehicleLocal [0,0,0];
					_flagStone setPosASL [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5,-1];
				};
			};
				
			f_obj_BaseFlag addAction ["<t color='#FF7F00'>Spawn on Team</t>",f_fnc_teleportPlayer];
		} else {
			["f_teleportOption.sqf",format["No respawn marker found for %1.",side (group player)]] call f_fnc_logIssue;
		};

};