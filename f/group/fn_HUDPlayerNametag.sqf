// F3 - Nametags
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY

if (!isDedicated && (isNull player)) then
{
    waitUntil {sleep 0.1; !isNull player};
};

// Only run in MP!
// if !isMultiplayer exitWith {};

// ====================================================================================

// SET GLOBAL VARIABLES

// MODIFYABLE

// Default values (can be modified by players in the briefing entry)
// Comment any of these to deactivate the feature entirely
f_showGroup_Nametags = true;	 // Show unit's group next to unit name (except for player's own group)
f_showDistance_Nametags = false; // Show distance to unit under name
f_showVehicle_Nametags = false;  // Show type of vehicle under driver's name
f_showCursorOnly_Nametags = false; // Show only units under cursor target (disable 360° view)

// Other values
f_distCursor_Nametags = 200;	// Distance to display name tag for unit under cursor
f_distAll_Nametags = 50;		// Distance to display name tags for all units around
F_KEY_NAMETAGS =  "TeamSwitch"; // The action key to toggle the name tags. See possible keys here: http://community.bistudio.com/wiki/Category:Key_Actions

// Display values
f_size_Nametags = 0.023; // The size the names are displayed in
f_height_standing_Nametags = 2; // Height above standing infantry unit
f_height_crouch_Nametags = 1.5; // Height above crouching infantry unit
f_height_prone_Nametags = 0.9;  // Height above prone infantry unit
f_vheight_Nametags = 0; // The height of the name tags for units in vehicles (0 = hovering over vehicle)
F_SHADOW_NAMETAGS = 2; // The shadow for the name tags (0 - 2)
f_color_Nametags =  [1,1,1,0.9]; // The color for infantry and units in vehicle cargo (in [red,green, blue, opacity])
f_color2_Nametags = [1,0.1,0.2,0.9]; // The color for units in driver, gunner and other vehicle positions positions
f_groupColor_Nametags = [0,1,0.7,0.9]; // The color for units of the same group
F_FONT_NAMETAGS = "EtelkaMonospaceProBold"; // Font for the names

// SCRIPTSIDE

F_DRAW_NAMETAGS = false;
F_ACTIONKEY_NAMETAGS = (actionKeys F_KEY_NAMETAGS) select 0;
F_KEYNAME_NAMETAGS = actionKeysNames F_KEY_NAMETAGS;
if (isNil "F_ACTIONKEY_NAMETAGS") then {F_ACTIONKEY_NAMETAGS = 20; F_KEYNAME_NAMETAGS = 'U';}; // If the user has not bound 'TeamSwitch' to a key we default to 'U' to toggle the tags

F_KEYUP_NAMETAG = {
	_key = _this select 1;
	_handeld = false;
	if(_key == F_ACTIONKEY_NAMETAGS) then
	{
		//_handeld = true;
	};
	_handeld;
};

F_KEYDOWN_NAMETAG = {
	_key = _this select 1;
	_handeld = false;
	if(_key == F_ACTIONKEY_NAMETAGS) then
	{
		F_DRAW_NAMETAGS = !F_DRAW_NAMETAGS;
		//_handeld = true;
	};
	_handeld;
};

// ====================================================================================

// ADD BRIEFING SECTION
// A section is added to the player's briefing to inform them about name tags being available.

[] spawn {
	waitUntil {scriptDone f_sqf_brief};

	_bstr = format ["<font size='18' color='#FF7F00'>NAME TAGS</font><br/>Toggle name tags for friendly units below.<br/><br/>
Name tags are displayed when aiming at individual units up to %4m away, and constantly for all units within %3m.
        ",F_KEYNAME_NAMETAGS, F_KEY_NAMETAGS,F_DISTALL_NAMETAGS,F_DISTCursor_NAMETAGS];

        _bstr = _bstr + "<br/><br/><font color='#66B2FF'><execute expression=""
                if (F_DRAW_NAMETAGS) then [{hintSilent 'Tags deactivated!';F_DRAW_NAMETAGS= false},{F_DRAW_NAMETAGS = true;hintSilent 'Tags activated!'}];""
                >ENABLE NAMETAGS</execute></font><br/>Toggle tags for nearby units.";

        if !(isNil "F_SHOWGROUP_NAMETAGS") then {
                _bstr = _bstr + "<br/><br/><font color='#66B244'><execute expression=""
                if (F_SHOWGROUP_NAMETAGS) then [{hintSilent 'Group display deactivated!';F_SHOWGROUP_NAMETAGS= false},{F_SHOWGROUP_NAMETAGS = true;hintSilent 'Group display activated!'}];""
                >TOGGLE GROUP NAME</execute></font><br/>Toggle group name next to a unit.";
        };

        if !(isNil "F_SHOWDISTANCE_NAMETAGS") then {
                _bstr = _bstr + "<br/><br/><font color='#66B244'><execute expression=""
                if (F_SHOWDISTANCE_NAMETAGS) then [{hintSilent 'Distance display deactivated!';F_SHOWDISTANCE_NAMETAGS= false},{F_SHOWDISTANCE_NAMETAGS = true;hintSilent 'Distance display activated!'}];""
                >TOGGLE DISTANCE</execute></font><br/>Toggle distance from units.";
        };

        if !(isNil "f_showVehicle_Nametags") then {
                _bstr = _bstr + "<br/><br/><font color='#66B244'><execute expression=""
                if (f_showVehicle_Nametags) then [{hintSilent 'Vehicle type display deactivated!';F_SHOWVEHICLE_NAMETAGS= false},{F_SHOWVEHICLE_NAMETAGS = true;hintSilent 'Vehicle type display activated!'}];""
				>TOGGLE VEHICLE TYPE</execute></font><br/>Toggle vehicle type under driver.";
        };

    _bstr = _bstr + "<br/><br/><font size='18' color='#FF7F00'>COLORS</font><br/>
    <font color='#FFFFFF'>Friendly</font><br/>
    <font color='#7FFFD4'>Fireteam</font><br/>
    <font color='#FF143C'>Vehicle Crew</font>";

	player createDiaryRecord ["Diary", ["NameTags (Options)",_bstr]];

	// NOTIFY NEW PLAYERS ABOUT NAMETAGS VIA HINT
	if ((((squadParams player) select 0) select 0) != "Zeus" && isMultiplayer) then {
		[] spawn {
			sleep 5;
			F_DRAW_NAMETAGS = true;
			player groupChat format["Name tags are enabled - Press %1 to disable.",F_KEYNAME_NAMETAGS];
		};
	};
};

// ====================================================================================

// ADD EVENTHANDLERS
// After the mission has initialized eventhandlers are added to the register keypresses.

sleep 0.1;

waitUntil {!isNull (findDisplay 46)}; // Make sure the display we need is initialized

F_DRAW_NAMETAGS = false; // Enable nametags from the start

// Remove due to group switch additon.
(findDisplay 46) displayAddEventHandler   ["keyup", "_this call F_KEYUP_NAMETAG"];
(findDisplay 46) displayAddEventHandler   ["keydown", "_this call F_KEYDOWN_NAMETAG"];

// ====================================================================================
// the real code.

addMissionEventHandler ["Draw3D", {

	if(F_DRAW_NAMETAGS) then
	{

	private ["_ents","_veh","_color","_inc","_suffix","_pos","_angle"];

	_ents = [];

	// Unless disabled, collect all entities in the relevant distance
	if !(f_showCursorOnly_Nametags) then {
		_ents = (position player) nearEntities [["CAManBase","LandVehicle","Helicopter","Plane","Ship_F"], f_distAll_Nametags];
	};

	if (!(cursorTarget in _ents) && {((player distance cursorTarget) <= f_distCursor_Nametags) && player knowsAbout cursorTarget >= 1.5}) then {_ents append [cursorTarget]};

		// Start looping through all entities
		{
			// Filter entities
			if (
				// Only for the player's side
				(side _x == side player || {group _x == group player}) &&
				// Only other players & no virtual units
				{_x != player && !(player isKindOf "VirtualMan_F")}
				)
			then
			{

				// If the entity is Infantry
				if((typeOf _x) isKindOf "Man") then
				{
					_pos = visiblePosition _x;
					[_x,_pos] call f_fnc_group_drawNameTag;
				}

				// Else (if it's a vehicle)
				else
				{

					_veh = _x;
					_inc = 1;
					_alternate = 0;

					{
						// Get the various crew slots
						_suffix = switch (true) do {
							case (driver _veh == _x && !((_veh isKindOf "helicopter") || (_veh isKindOf "plane"))):{" - D"};
							case (driver _veh == _x && ((_veh isKindOf "helicopter") || (_veh isKindOf "plane"))):{" - P"};
							case (commander _veh == _x);
							case (effectiveCommander _veh == _x):{" - CO"};
							case (gunner _veh == _x):{" - G"};
							case (assignedVehicleRole _x select 0 == "Turret" && commander _veh != _x && gunner _veh != _x && driver _veh != _x):{" - C"};
							default {""};
						};

						_pos = visiblePosition _x;

						// Only display tags for non-driver crew and cargo if player is up close
						if (effectiveCommander _veh == _x || group _x == group player || _pos distance player <= f_distAll_Nametags) then {

							// If the unit is the driver, calculate the available and taken seats
							if (effectiveCommander _veh == _x) then {
								// Workaround for http://feedback.arma3.com/view.php?id=21602
								_maxSlots = getNumber(configFile >> "CfgVehicles" >> typeOf _veh >> "transportSoldier") + (count allTurrets [_veh, true] - count allTurrets _veh);
								_freeSlots = _veh emptyPositions "cargo";

								if (_maxSlots > 0) then {
									_suffix = _suffix + format [" (%1/%2)",(_maxSlots-_freeSlots),_maxSlots];
								};
							};

							// If the unit is in a turret, a passenger or the driver
							if (_pos distance (getPosVisual (driver _veh)) > 0.1 || driver _veh == _x) then
							{
								[_x,_pos,_suffix] call f_fnc_drawNameTag;
							}
							else // Gunners and all other slots
							{
								if(_x == gunner _veh) then
								{
									_pos = [_veh modelToWorld (_veh selectionPosition "gunnerview") select 0,_veh modelToWorld (_veh selectionPosition "gunnerview") select 1,(visiblePosition _x) select 2];
								}
								else
								{
									_angle = (getDir _veh)+180;
									_pos = [((_pos select 0) + sin(_angle)*(0.6*_inc)) , (_pos select 1) + cos(_angle)*(0.6*_inc),_pos select 2 + F_VHEIGHT_NAMETAGS];
									_inc = _inc + 1;
								};

								[_x,_pos,_suffix] call f_fnc_drawNameTag;
							};

						};

					} forEach crew _veh;
				};
			};
		} forEach _ents;

	}; // Outmost if scope

}]; // End of the Eventhandler Scope