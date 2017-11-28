// Zeus - Client Intro
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS
private ["_nearLoc","_lineOne","_lineTwo"];

_lineOne  = briefingName;
_lineTwo  = "Undisclosed Location";

// Two parameters were passed otherwise default to the location.
if(count _this > 1) then
{
	if ((_this select 1) != "") then { _lineTwo = _this select 1};
} else {
	_nearLoc = (nearestLocations [getPosATL player, ["NameCityCapital","NameCity","NameVillage","NameLocal"], 1000]); 
	if (count _nearLoc > 0) then { 
		_lineTwo = format["%1, %2 %3",worldName,(["Nearby","Close to","Outside","Near"] call BIS_fnc_selectRandom),text(_nearLoc select 0)]; 
	};
};

// One parameters was passed, so just check that.
if(count _this > 0) then
{
	if ((_this select 0) != "") then { _lineOne = _this select 0};
};

sleep 15;

[
	[
		[_lineOne,"align = 'right' valign = 'bottom' size = '0.8' font='PuristaSemibold'"],
		["","<br/>"],
		[_lineTwo,"align = 'right' valign = 'bottom' size = '0.8' font = 'PuristaSemibold'"]
	], -.75, 1.15
	, true, "%1"
] spawn BIS_fnc_typeText2;