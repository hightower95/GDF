params ["_newUnit","_oldUnit","_respawn","_respawnDelay"];
if (isNull _oldUnit || time < 1) exitWith {};

// [(_newUnit getVariable ["f_var_assignGear",""]),player] call f_fnc_assignGear;