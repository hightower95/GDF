// All interesting things tfar:

// Tfar has its own event handler system. The bezzle / button is called 'tangent'. 
// When button state changes the following happens: 
// ["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers; 
// This allows doing something after the radio has stopped transmitting.
// Ideas: Timing radios messages, pop ups 
["mYID", "OnTangent",{if(!(_this select 4)) then {player sideChat "survey time";}}, player] call TFAR_fnc_addEventHandler; 