	class f_ParamSpacer_title
  	{
		title = "---- ADMIN Options - System -----";
		values[] = {-100};
		texts[] = {" "};
		default = -100;
		code = "";
  	};
	class f_param_revivemode
    {
            title = "Who can revive others? (farooq)";
            values[] = {1,2,0};
            texts[] = {"Anyone","Anyone with medikit","Only medics"};
            default = 2;
    };
	class f_param_farooq_modifier
	{
			title = "Damage Taken Modifier (farooq)";
			values[] = {0,35,67,84}; // Percentages (negatives are supported)
			texts[] = {"Off","Light (35%)","Heavy(67%)","Massive(84%)"};
			default = 0;
	};
	class f_ParamSpacer_title1
  	{
		title = "---- GAME Options - Environment ----";
		values[] = {-100};
		texts[] = {" "};
		default = -100;
		code = "";
  	};
	class f_param_AISkill		// F3 - AI Skill Selector
	{
		title = "AI Skill Level";
		values[] = {0,1,2,3,4};
		texts[] = {"Disabled","Freight Train O' Death (120%)","I'm in my Element: Lead (100%)","Walk in the park (80%)","I'm too young to die (60%)"};
		default = 2;
	};
    class f_param_weather
	{
		title = "Weather";
		values[] = {0,1,2,3,4,5,6};
		texts[] = {"Mission Default","Calm","Light Cloud","Overcast","Rain","Storm","Random"};
		default = 2;
		function = "f_fnc_SetWeather";			// This function is called to apply the values
 		isGlobal = 0;						// Execute this only on the server
	};
	class f_param_fog
	{
		title = "Fog";
		values[] = {0,1,2,3,4};
		texts[] = {"Mission Default","None","Light","Heavy","Random"};
		default = 2;
		function = "f_fnc_SetFog";			// This function is called to apply the values
		isGlobal = 0;						// Execute this only on the server
	};
    class f_param_timeOfDay
	{
		title = "Time of Day";
		values[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14};
		texts[] = {"Mission Default","1hr to First Light","30m to First Light","First Light","30m after First Light","Morning","Late Morning","Noon","Afternoon","1hr to Last Light","30m to Last Light","Last Light","Night","Midnight","Random"};
		default = 14;
		function = "f_fnc_setTime";
		isGlobal = 0;
	};
	class f_ParamSpacer_title2
  	{
		title = "---- GAME Options - Immersion ----";
		values[] = {-100};
		texts[] = {" "};
		default = -100;
		code = "";
  	};
    class f_param_shiftClick		// Zeus - Shift Clicking
    {
            title = "Equipment - Map Shift-Click";
			values[] = {0,1};
			texts[] = {"Disabled","Enabled"};
			default = 0;
			code = "if (%1 == 0) then {{onMapSingleClick ""_shift"";} remoteExec [""bis_fnc_call"", 0, true];};";
    };
    class f_param_thirdPerson		// Zeus - 3rd Person Options
    {
		title = "System - Third Person";
		values[] = {0,1,2};
		texts[] = {"By Server Difficulty","3P - In Vehicles Only","3P - Disabled Everywhere"};
		default = 1;
    };
