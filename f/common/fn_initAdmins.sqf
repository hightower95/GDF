// Admin
// ====================================================================================
// This script is to pull the list of admin UIDs from the server into the mission.
// ====================================================================================

// Add list of admins (GD_ADMIN_GetAdminUIDs is a function defined server side)
if (!isNil "GD_ADMIN_GetAdminUIDs") then {
	_adminUIDs = [] call GD_ADMIN_fGetAdminUIDs;

	// Make sure array was returned
	if (_adminUIDs isEqualType []) then {
		missionNamespace setVariable ["adminUIDs",_adminUIDs,true];
	};
};
