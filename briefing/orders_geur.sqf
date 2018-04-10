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
// Faction: GEUR (Indepdent / Chernaraus) - the 'green' guys

// ====================================================================================
// ADMINISTRATION
// #include "mInfo.hpp";
_author = "Generally Dangerous";

// The code below creates the execution sub-section of notes.
// ====================================================================================
// SITUATION
_situation_friendly_forces = format["
<br/><font size='18' color='#FF7F00'>FRIENDLY FORCES</font>
<br/> Infantry / Vehicles / Fire support details here
<br/>
"];

_situation_enemy_forces = format["
<br/><font size='18' color='#FF7F00'>ENEMY FORCES</font>
<br/> Enemy known Infantry / Vehicles / Fire support details here
<br/> Enemy distribution / likely reaction?
"];

_situation = format["
<br/><font size='18' color='#FF7F00'>SITUATION</font>
%1
<br/>
%2
<br/>",_situation_friendly_forces, _situation_enemy_forces];

player createDiaryRecord ["diary", ["Situation", format["
<br/>GD Mission by %1
%2
<br/>", _author, _situation]]];

//====================================================================================
// MISSION

_objectives = format["
<br/><font size='18' color='#FF7F00'>OBJECTIVES</font>
<br/> 1. Fill out objectives
<br/> 2. Check they work
<br/>
"];

_commanders_intent = format ["
<br/><font size='18' color='#FF7F00'>COMMANDER'S INTENT</font>
<br/> What is the commander trying to achieve through this mission?
"];

_limits = format ["
<br/><font size='18' color='#FF7F00'>FAILURE CONDITIONS</font>
<br/> Everyone disconnects
"];

_notes = format ["
<br/><font size='18' color='#FF7F00'>ADDITIONAL INFO</font>
<br/> Watch out for the nuke.
"];

_exe = player createDiaryRecord ["diary", ["Mission",format["
<br/><font size='18' color='#FF7F00'>MISSION</font>
<br/>
<br/>
%1
<br/>
%2
<br/>
%3
<br/>
%4
<br/><font size='18' color='#FF7F00'>CREDITS</font>
<br/>Created by <font color='#72E500'>%5</font color> using 2600K's template (edited by Hightower)
<br/>
<br/>A custom-made mission for ArmA 3 and Generally Dangerous
<br/>https://units.arma3.com/unit/generallydangerous
<br/>
",_objectives, _commanders_intent, _limits, _notes, _author]]];