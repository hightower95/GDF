
if(!isServer) exitWith {};

_spawnFlag = true;

if _spawnFlag then {
	_flagType = "Flag_AltisColonial_F";
	_flagMarker = "respawn_civilian";

	// Iterate through all the sides.
	// If a respawn location is specified, and there are players associated with that side add a flag
	{
		_side = _x;
		// Identify the flag type and name from the side
		switch (_side) do {
			case west		: { _flagType = "Flag_Blue_F"; 	_flagMarker = "respawn_west"; };
			case east		: { _flagType = "Flag_Red_F"; 	_flagMarker = "respawn_east"; };
			case resistance	: { _flagType = "Flag_Green_F"; _flagMarker = "respawn_guerrila"; };
			case civilian : {_flagType = "Flag_AltisColonial_F"; _flagMarker = "respawn_civilian";};
			default {_flagType = "Flag_AltisColonial_F"; _flagMarker = "respawn_civilian";};
		};
		
		// Count players on the side under test
		_playersOfSide = {side _x == _side} count allPlayers;
		_respawnFlagHasMapMarker = _flagMarker in allMapMarkers;

		// If the flag is in the map markers - i.e. someone has created a marker called 'respawn_west'
		if (_respawnFlagHasMapMarker) then {
			// Construct the flag name - to save inside a variable on the mission namespace
			_flagName = format["f_obj_BaseFlag_%1", _side];
			// Test to see if a flag exists. (if it doesnt return an empty string - because else it returns a value 'any'. if(any){this code never executes} else {neither does this cause arma})
			_flagObj = missionNamespace getVariable [_flagName, ""];

			if (isNil _flagObj && _playersOfSide > 0) then {
				_newFlagObj = _flagType createVehicle [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5, 0];
				sleep 0.5;
				
				// Don't spawn on seabed.
				if (underwater _newFlagObj) then {
					_newFlagObj setPosASL [position _newFlagObj select 0,position _newFlagObj select 1,0];
					_flagStone = "Land_W_sharpStone_02" createVehicle [0,0,0];
					_flagStone setPosASL [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5,-1];
				};
				missionNamespace setVariable [_flagName, _newFlagObj, true];
				_newFlagObj setVariable ["flagSide", _x, true];
				// The flag only works if your side = the side the flag is supposed to work for. (to prevent a TvT / multiple team scenario being exploited)
				_newFlagObj addAction ["<t color='#FF7F00'>Spawn on Team</t>",f_fnc_teleportPlayer,nil,5,true,true,"side _this == (_target getVariable ['flagSide',side _this])","true"];
				
			};
		} else {
			["f_teleportOption.sqf",format["No map marker found for %1, expected a marker with variable name '%2'",_side,_flagMarker]] call f_fnc_logIssue;
		};
		
	} forEach [west, east, resistance, civilian];

};