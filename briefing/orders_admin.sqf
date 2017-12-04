// F3 - Briefing
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// TIPS for briefing notes:
// 1. <font color='#0080FF'><marker name='respawn_west'>XXX</marker></font color>
// 2. format ["This is a number: %1, %2", number1, number2]
// 3. <font color='#0080FF'><marker name='respawn_west'>XXX</marker></font color>
// Green #72E500
// Orange #FF7F00
// Blue #0080FF

// ====================================================================================
// Faction: Admin (Section only displayed to the ADMIN)
//  DO NOT DEPEND UPON THE ADMIN TO DO THINGS FOR THE MISSION!

player createDiarySubject ["Admin","** Admin **"];
// ====================================================================================
// ====================================================================================
// ADD MISSION MAKER NOTES SECTIONS
// All text added below will only be visible to the current admin

_customText = "";

// ADMIN BRIEFING
// This is a generic section displayed only to the ADMIN

_briefing ="
<br/><font size='18' color='#FF7F00'>ADMIN SECTION</font><br/>
This briefing section can only be seen by the current admin.
<br/><br/>
";

// MISSION-MAKER NOTES
// This section displays notes made by the mission-maker for the ADMIN

if (_customText != "") then {
	_briefing = _briefing + "<br/><font size='18' color='#FF7F00'>MISSION-MAKER NOTES</font><br/>";
	_briefing = _briefing + _customText + "<br/><br/>";
};

_briefing = _briefing + "
<font size='18' color='#FF7F00'>DEBUG OPTIONS</font><br/>
<font color='#66B2FF'><execute expression=""[['',true],'f_fnc_debug',false] call BIS_fnc_MP; hintSilent 'Running - Check Server Log';"">
Debug Check</execute></font><br/>";

// SAFE START SECTION
_briefing = _briefing + "
<br/><font size='18' color='#FF7F00'>SAFE START CONTROL</font><br/>
<font color='#66B2FF'><execute expression=""f_param_safe_start = -1; publicVariable 'f_param_safe_start';
['SafeStartMissionStarting',['Safe Start Ended!']] remoteExec ['bis_fnc_showNotification',0];
[false] remoteExec ['f_fnc_safety',0];
hintSilent 'Safe Start ended!';"">
End Safe Start timer</execute></font><br/><br/>";

// ADD ZEUS SUPPORT SECTION
_briefing = _briefing + "
<font size='18' color='#FF7F00'>ZEUS SUPPORT</font><br/>
<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {
	[player,true] remoteExec ['f_fnc_zeusInit',2];
	hintSilent 'Curator assigned.';
};"">Assign ZEUS to admin</execute></font><br/>

<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,(playableUnits + switchableUnits)] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added playable units.'
};"">Add players and playable units to ZEUS object list</execute></font><br/>

<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,true,true] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Assigned control over all group leaders and empty vehicles.'
};"">
Add all group leaders and empty vehicles</execute></font><br/>

<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,true] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Add all units.'
};"">Add all mission objects</execute></font> <font color='#FF0000'>(MAY CAUSE DESYNC)</font><br/>

<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	(getAssignedCuratorLogic player) removeCuratorEditableObjects [allDead,true];
	hintSilent 'Removed dead units.'
};"">Remove all dead units from ZEUS</execute></font><br/>

<font color='#66B2FF'><execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,false] remoteExec ['f_fnc_zeusAddObjects',2];
	[player,false] remoteExec ['f_fnc_zeusAddAddons',2];
	hintSilent 'Removed powers and units.'
};"">Remove all powers and objects from ZEUS</execute></font><br/>
<br/>
";

// CREATE DIARY ENTRY
player createDiaryRecord ["Admin", ["*** ADMIN MENU ***",_briefing]];

// ====================================================================================
// WEATHER CONTROL
f_var_trans = 300; // Transiton time in seconds
_missionWeather = "<font size='18' color='#FF7F00'>TIME / WEATHER</font><br/>
<br/><font color='#FF7F00'>TIME</font>
<br/>Instantly skip time forward a given number of hours/minutes:
<br/>
<font color='#66B2FF'><execute expression=""0.5 remoteExec ['skipTime', 2]; hintSilent 'Time: +30 Minutes';"">+30 Minutes</execute></font> | 
<font color='#66B2FF'><execute expression=""1 remoteExec ['skipTime', 2]; hintSilent 'Time: +1 hour';"">+1 Hour</execute></font> | 
<font color='#66B2FF'><execute expression=""6 remoteExec ['skipTime', 2]; hintSilent 'Time: +6 hours';"">+6 Hours</execute></font> | 
<font color='#66B2FF'><execute expression=""12 remoteExec ['skipTime', 2]; hintSilent 'Time: +12 hours';"">+12 Hours</execute></font> | 
<font color='#66B2FF'><execute expression=""24 remoteExec ['skipTime', 2]; hintSilent 'Time: +24 hours';"">+24 Hours</execute></font>
<br/>
<br/><font color='#FF7F00'>DELAY</font>
<br/>The following applies to both WIND and CLOUD/RAIN settings. Use the below to adjust the delay to allow for gradual weather changes (e.g thick fog forms in 10 minutes):
<br/>
<font color='#66B2FF'><execute expression=""f_var_trans = 0; hintSilent format['Delay set to: %1',f_var_trans];"">Reset to Zero</execute></font> | 
<font color='#66B2FF'><execute expression=""f_var_trans = 300; hintSilent format['Delay set to: %1',f_var_trans];"">Reset to 5 Minutes</execute></font> | 
<font color='#66B2FF'><execute expression=""f_var_trans = f_var_trans + 60; hintSilent format['Delay increased to %1',f_var_trans];"">+60 Secs</execute></font> | 
<font color='#66B2FF'><execute expression=""if (f_var_trans <= 60) then { f_var_trans = 0; } else { f_var_trans = f_var_trans - 60; }; hintSilent format['Delay decreased to %1',f_var_trans];"">-60 Secs</execute></font>
<br/>
<br/><font color='#FF7F00'>FOG</font>
<br/>Fog is applied across the server according to the DELAY chosen above (default: 5 minutes). A zero delay means the change will be instant.
<br/>
<br/>Any value greater than a delay of 0 will gradually adjust the conditions and appear more natural:<br/>
<font color='#66B2FF'><execute expression=""[-1, 0, [0,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Removing Fog', f_var_trans];"">Disable Fog (Instant)</execute></font>
<br/>
<br/>
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: None (%1 secs)', f_var_trans];"">None</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.1,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Very Light (%1 secs)', f_var_trans];"">Very Light</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.2,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Light (%1 secs)', f_var_trans];"">Light</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.4,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Medium (%1 secs)', f_var_trans];"">Medium</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.6,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Thick (%1 secs)', f_var_trans];"">Thick</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.8,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Very Thick (%1 secs)', f_var_trans];"">Very Thick</execute></font>
<br/>
<br/><font color='#66B2FF'><execute expression=""hintSilent format['Fog is: %1',fog];"">Check Fog Setting</execute></font>
<br/>
<br/><font color='#FF7F00'>CLOUDS/RAIN</font>
<br/>Weather is applied across the server according to the DELAY chosen above (default: 5 minutes). If a delay is selected, the engine will take UP TO ONE HOUR to fully change conditions. 
<br/>
<br/>If the delay is set to zero, weather settings will INSTANTLY be applied:
<br/>
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [1, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Clear (%1 secs)', f_var_trans];"">Clear</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [2, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Light Cloud (%1 secs)', f_var_trans];"">Light</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [3, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Overcast (%1 secs)', f_var_trans];"">Overcast</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [4, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Light Rain (%1 secs)', f_var_trans];"">Rain</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [5, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Rainy (%1 secs)', f_var_trans];"">Heavy Rain</execute></font> | 
<font color='#66B2FF'><execute expression=""publicVariable 'f_var_trans'; [6, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Stormy (%1 secs)', f_var_trans];"">Storm</execute></font>
<br/>
<br/><font color='#66B2FF'><execute expression=""hintSilent format['Clouds are: %1',overcast];"">Check Cloud Setting</execute></font><br/>
<br/>
<font color='#FF7F00'>WIND</font>
<br/>The wind settings below will override those determined by the Cloud/Rain settings. Altering any cloud settings will reset all wind values:
<br/>
<font color='#66B2FF'><execute expression=""[0] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: None';"">None</execute></font> | 
<font color='#66B2FF'><execute expression=""[2] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Very Low';"">Very Low</execute></font> | 
<font color='#66B2FF'><execute expression=""[4] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Low';"">Low</execute></font> | 
<font color='#66B2FF'><execute expression=""[6] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Medium';"">Medium</execute></font> | 
<font color='#66B2FF'><execute expression=""[8] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: High';"">Strong</execute></font> | 
<font color='#66B2FF'><execute expression=""[10] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Very High';"">Very Strong</execute></font> | 
<font color='#66B2FF'><execute expression=""[20] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Hurricane';"">Hurricane</execute></font>
<br/>
<br/><font color='#66B2FF'><execute expression=""hintSilent format['Wind Speed is: %1',wind];"">Check Wind Speed</execute></font>
<br/>
";

player createDiaryRecord ["Admin", ["Time & Weather",_missionWeather]];

// ====================================================================================
// Mission Endings
// ENDINGS
// This block of code collects all valid endings and formats them properly

_title = [];
_ending = [];
_endings = [];
_briefing = "";

_all_endings = missionConfigFile >> "CfgDebriefing";
_briefing = _briefing + "
<font size='18' color='#FF7F00'>ENDINGS</font><br/>
These endings are available. To trigger an ending click on its link - It will take a few seconds to synchronise across all clients.<br/><br/>
";

for "_i" from 0 to (count _all_endings - 1) do {
	_ending = _all_endings select _i;
	_configName_tokens = (configName (_ending)) splitString "_";
	_title = getText(_ending >> "title");
	
	_is_success_ending = ((_title) find "Complete") > -1;
	_ending_font_colour = '#DC0000'; // red
	if(_is_success_ending) then {
		_ending_font_colour = '#2DC201';
	};
	_ending_type = "";
	if(count _configName_tokens != 2) then {
		diag_log format ["Improperly formatted ending: %1", configName(_ending)];
		_ending_type = "unknown"; 
	} else {
		_ending_type = _configName_tokens select 1;
	};
	_description = getText(_ending >> "description");

	_briefing = _briefing + format [
	"<font color='%4'>%1</font>:<font color='#66B2FF'><execute expression=""[['%2'],'f_fnc_mpEnd',false] spawn BIS_fnc_MP;"">'%2'</execute></font>:<br/>
	%3<br/><br/>"
	,_title,text _ending_type,_description,_ending_font_colour];

};

player createDiaryRecord ["Admin", ["Endings",_briefing]];