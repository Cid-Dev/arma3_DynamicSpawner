

private _configure_all_triggers_script = execVM "scripts\spawn\configure_all_triggers.sqf";
waitUntil
{
	scriptDone _configure_all_triggers_script;
};