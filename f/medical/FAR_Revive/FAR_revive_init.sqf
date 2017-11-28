//
// Farooq's Revive 1.5
//

//------------------------------------------//
// Parameters - Feel free to edit these
//------------------------------------------//

if (isNil "f_param_bleedout") then {
	f_param_bleedout = 600;
	diag_log text "[F3] WARNING (FAR_revive_init.sqf): f_param_bleedout was not defined! Defaulting to 600";
};

// Seconds until unconscious unit bleeds out and dies. Set to 0 to disable.
FAR_BleedOut = f_param_bleedout;	

// Is GameType Coop? If so don't use spectator intermission and extended death messages.
FAR_IsCoop = ((getText(missionconfigfile >> "Header" >> "gameType")) == "Coop");

// Enable teamkill notifications
FAR_EnableDeathMessages = true;


/*
	0 = Only medics can revive
	1 = All units can revive
	2 = Same as 1 but a medikit is required to revive
*/
if(isNil "f_param_revivemode") then {
	FAR_ReviveMode = 1;
} else {
	FAR_ReviveMode = f_param_revivemode;
};


//------------------------------------------//

call compile preprocessFile "f\medical\FAR_revive\FAR_revive_funcs.sqf";

#define SCRIPT_VERSION "1.526"

FAR_isDragging = false;
FAR_isDragging_EH = [];
FAR_deathMessage = [];
FAR_Debugging = true;

if (isDedicated) exitWith {};

////////////////////////////////////////////////
// Player Initialization
////////////////////////////////////////////////
[] spawn
{
    waitUntil { !isNull player };

	// Public event handlers
	"FAR_isDragging_EH" addPublicVariableEventHandler FAR_public_EH;
	"FAR_deathMessage" addPublicVariableEventHandler FAR_public_EH;
	
	[] spawn FAR_Player_Init;

	// Event Handlers
	player addEventHandler 
	[
		"Respawn", 
		{ 
			player setVariable ["FAR_isUnconscious", 0, true];
			player setVariable ["FAR_isStabilized", 0, true];
			player setVariable ["FAR_isDragged", 0, true];
			[] spawn FAR_Player_Init;
		}
	];
};

FAR_Player_Init =
{
	// Clear event handler before adding it
	player removeAllEventHandlers "HandleDamage";

	player addEventHandler ["HandleDamage", FAR_HandleDamage_EH];
	player addEventHandler 
	[
		"Killed",
		{
			// Remove dead body of player (for missions with respawn enabled)
			_body = _this select 0;
			
			[_body] spawn 
			{
				waitUntil { alive player };
				params ["_body"];
				deleteVehicle _body;
			}
		}
	];
	
	player setVariable ["FAR_isUnconscious", 0, true];
	player setVariable ["FAR_isStabilized", 0, true];
	player setVariable ["FAR_isDragged", 0, true];
	player setCaptive false;

	FAR_isDragging = false;
	
	[] spawn FAR_Player_Actions;
};

// Drag & Carry animation fix
[] spawn
{
	while {true} do
	{
		if (animationState player == "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon" || animationState player == "helper_switchtocarryrfl" || animationState player == "AcinPknlMstpSrasWrflDnon") then
		{
			if (FAR_isDragging) then
			{
				player switchMove "AcinPknlMstpSrasWrflDnon";
			}
			else
			{
				player switchMove "amovpknlmstpsraswrfldnon";
			};
		};
			
		sleep 3;
	}
};

////////////////////////////////////////////////
// [Debugging] Add revive to playable AI units
////////////////////////////////////////////////
if (!FAR_Debugging || isMultiplayer) exitWith {};

{
	if (!isPlayer _x) then 
	{
		_x addEventHandler ["HandleDamage", FAR_HandleDamage_EH];
		_x setVariable ["FAR_isUnconscious", 0, true];
		_x setVariable ["FAR_isStabilized", 0, true];
		_x setVariable ["FAR_isDragged", 0, true];
		[_x] spawn FAR_AI_Actions;
	};
} forEach switchableUnits;