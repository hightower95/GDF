if (!hasInterface) exitWith {};

[] spawn {
    // MAKE SURE THE PLAYER INITIALIZES PROPERLY
    if (player != player) then {waitUntil {player == player};};
    if (!alive player) then {waitUntil {alive player};};
	if (player != leader player) exitWith {};
	if (count units (group player) < 4) exitWith {};
	
    // DECLARE PRIVATE VARIABLES
    private ["_red","_blue","_yellow","_green"];
	
    sleep 1;
    	
	// Set suffixes for each colour
	_red = "1_";
	_blue = "2_";
	_yellow = "_M";
	_green = "3_";

    // SET TEAM COLOURS
    {
        private ["_unit"];
        _unit = _x;

        {
			if (((str _unit) find _x) != -1) then {
				private ["_tcolor"];
				_tcolor = ["red","blue","yellow","green"] select _forEachIndex;
				
				_unit assignTeam _tcolor;
				
				if (isClass (configFile >> "CfgPatches" >> "cba_main")) then {
					["CBA_teamColorChanged", [_unit, _tcolor]] call CBA_fnc_globalEvent;
				};
            };
        } forEach [_red,_blue,_yellow,_green];
    } forEach units (group player);
};