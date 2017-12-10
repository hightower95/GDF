// Functions such as medical and radios are called directly since postInit didn't seem to be completing on Altis map?
class F
{
	class missionConditions
	{
		file = "f\timeAndWeather";
		class setWeather{};
		class setTime{};
		class setFog{};
		class setWind{};
	};
	class casualtyCap
	{
		file = "f\casualtyCap";
		class casualtyReceiver{};
		class initCasualtyWatcher{};
	};
	class common
	{
		file = "f\common";
		class playMissionIntro{};
		class processParamsArray{preInit = 1;postInit = 1;};
		class initAdmins{};
		class isPlayerAdmin{};
		class mpEnd{};
		class mpEndReceiver{};
	};
	class group
	{
		file = "f\group";
		class HUDPlayerNametag{};
		class drawNametag{};
		class setGroupID{};
		class setFireTeamColours{};
	};
	class safeStart
	{
		file = "f\safeStart";
		class safety{};
		class enableSafeStart{};
	};
	class map
	{
		file = "f\map";
		class drawAO{};
	};
	class earplugs
	{
		file = "f\earplug";
		class earplugs{};
	};
	class thirdperson 
	{
		file = "f\thirdPerson";
		class thirdPersonRestrict{};
	};
	class respawn 
	{
		file = "f\respawn";
		class teleportPlayer{};
	};
	class tfar 
	{
		file = "f\tfar";
		class detectTFAR{requiredAddons[]={"task_force_radio"};};
		class initTFAR{requiredAddons[]={"task_force_radio"};};
	};
	class ace
	{
		file = "f\ace";
		class detectACE{};	
	};
    class zeus
	{
		file = "f\zeus";
		class zeusInit{};
		class zeusAddAddons{};
		class zeusAddObjects{};
	};
};