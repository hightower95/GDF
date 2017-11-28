// F3 - EarPlugs
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY

if (!isDedicated && (isNull player)) then
{
    waitUntil {sleep 0.1; !isNull player};
};

// ====================================================================================

// SET GLOBAL VARIABLES

// Default values
F_KEY_EARPLUGS =  207; // The action key to toggle the earplugs.
F_ACTIONKEY_EARPLUGS = "END"; // The action key name to toggle the earplugs.

// SCRIPTSIDE

F_EARPLUGS = false;

F_KEYDOWN_EARPLUG = {
	_key = _this select 1;
	// hint format ["Pressed key: %1", _key];
	_handeld = false;
	if(_key == F_KEY_EARPLUGS) then
	{
		if (F_EARPLUGS) then { 1 fadeSound 1; F_EARPLUGS = false; titleText ["You've removed your earplugs.", "PLAIN DOWN", 2]; }
		else { 1 fadeSound 0.10; F_EARPLUGS = true; titleText ["You've inserted your earplugs.", "PLAIN DOWN", 2]; };
		//_handeld = true;  // Remove to stop this interfering with other commands.
	};
	_handeld;
};

// ====================================================================================

// ADD BRIEFING SECTION
// A section is added to the player's briefing to inform them about name tags being available.
/*
[] spawn {
	waitUntil {scriptDone f_script_briefing};

	_bstr = format ["<font size='18'>F3 EAR PLUGS</font><br/>Toggle ear plugs in the mission by pressing %1.<br/><br/>
Ear plugs will isolate ambient combat and vehicles sounds while leaving voice communications clear.
        ",F_ACTIONKEY_EARPLUGS];

	// NOTIFY PLAYER ABOUT NAMETAGS VIA HINT
	//sleep 5;
	//hintsilent format ["Press %1 to toggle ear plugs.",F_ACTIONKEY_EARPLUGS];
};*/

// ====================================================================================

// ADD EVENTHANDLERS
// After the mission has initialized eventhandler is added to the register keypresses.

sleep 0.1;

waitUntil {!isNull (findDisplay 46)}; // Make sure the display we need is initialized
(findDisplay 46) displayAddEventHandler   ["KeyDown", "_this call F_KEYDOWN_EARPLUG"];