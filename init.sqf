private _spawn_trigger_init_script = execVM "scripts\spawn\init.sqf";
waitUntil
{
	scriptDone _spawn_trigger_init_script;
};