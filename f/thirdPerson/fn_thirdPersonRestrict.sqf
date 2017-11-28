// ----------------------------------------------------------------------------
// 				NO 3RD PERSON - {Hightower} @ Generally Dangerous (edited from god-father @ 1-PARA)
// ----------------------------------------------------------------------------
// To use this script add an 'init.sqf' file to your mission 
// and include the line '[] execVM f_thirdPerson.sqf;'  
// if it doesnt work check you mission folder structure. I used this within the 'f' framwork.
// F3 - EarPlugs
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// 
// If you want 3rd person disabled on a specific vehicle add to its init.sqf:
// this setVariable["3rdPersonDisabled", true];


if(isDedicated) exitWith {};

// Wait for parameter to be initialised
waitUntil{!isNil "f_param_thirdPerson"};

waitUntil{!isNull (findDisplay 46)};

if (f_param_thirdPerson == 0) exitWith {}; // No restriction

if (f_param_thirdPerson == 1) exitWith {
	[] spawn {
		f_thirdPerson_locked = false;
		while {true} do {
					waitUntil {cameraView == "EXTERNAL" || cameraView == "GROUP"};
					
					// if vehicle player = player, the player is not in a vehicle -
					// so do not allow first person. 
					if((vehicle player) == player) then {
						// If the player is leader of the group they are in they are allowed third
						// person for a limited amount of time. 
						if(leader group player == player) then {
							if(f_thirdPerson_locked) then {
								hint "3rd Person on cool down";
							} else {
								_allowed_time = 5;
								// show a count down
								for "_i" from 0 to (_allowed_time - 1) do {
									[_allowed_time - _i] call {
										hint format ["3rd Person Time Remaining: %1", _this select 0];
										sleep 1;
									};
								};
								hint "";
								f_thirdPerson_locked = true;
								// Wait a random amount of seconds then re-enable.
								[] spawn {
									sleep random [20, 40, 100];
									f_thirdPerson_locked = false;								
								};
							
							};
							
						};
						player switchCamera "INTERNAL";				
					} else {
						// Player is in a vehicle
						
						// Mission author can disable 3rd person in specific vehicles 
						_3rdIsDisabled = vehicle player getVariable ["3rdPersonDisabled", false];
						if (_3rdIsDisabled) then {
							player switchCamera "INTERNAL";									
						};
					};
		};
	};
};

// 3rd Disabled Everywhere
if (f_param_thirdPerson == 2) exitWith { 
	[] spawn {
		while {(true)} do {
			waitUntil {cameraView == "EXTERNAL" || cameraView == "GROUP"};
			player switchCamera "internal";
			// This removed script disables something called TacticalView.
			// if (player == leader group player) then {
				// dokeyCheck = { if ((_this select 1) in (actionKeys "TacticalView")) exitWith { true }; false };
				// (FindDisplay 46) displayAddEventHandler ["keydown","_this call dokeyCheck"];
			// };
			// sleep 0.1;
		};
	};
};
