params [["_issueScript","Unknown",[""]],["_issueText","---",[""]]];

missionNamespace setVariable ["f_var_missionIssues",(missionNamespace getVariable ["f_var_missionIssues",""]) + format["<font color='#72E500'>%1</font>: %2<br/>",_issueScript,_issueText]];
	
true