	/*
	In order to add an ending:
	Ensure you following the naming convention "End_<insert your mission ending>"
	Make sure that the title is either Mission Complete or Mission Failed.
	e.g.
	 class End_customSuccessEnding 
	 {
		title = MISSION_SUCCESS;
		subtitle = "Summerise the ending";
		description = "A little message";
	 };


	*/
	// These names are used by briefing/orders_admin  and f/common/fn_mpEndReceiver - do not change!
	#define MISSION_SUCCESS "Mission Complete"
	#define MISSION_FAILED "Mission Failed"
	
	class End_success
	{
		title = MISSION_SUCCESS;
		subtitle = "Objectives Succeeded";		
		description = "You did a better job than Bravo squad!";
	};
	
	class End_time
	{
		title = MISSION_FAILED;
		subtitle = "Times Up!";
		description = "You failed to complete the objectives in time";
	};
	
	class End_casualties
	{
		title = MISSION_FAILED;
		subtitle = "Too many casualties!";
		description = "You failed to complete the objectives without taking excessive casualties";
	};
	
	class End_asset
	{
		title = MISSION_FAILED;
		subtitle = "Asset Lost!";
		description = "You lost too many friendly assets";
	};
	
	// DO NOT REMOVE default - to remove look at f/common/fn_mpEndReceiver.sqf
	class End_default 
	{
		title = MISSION_SUCCESS;
		subtitle = "End";
		description = "You finished the mission - but maybe the creator should specify an ending type";
	};




	