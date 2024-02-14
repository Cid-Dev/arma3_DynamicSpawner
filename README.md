# Arma 3 Cid's Dynamic Spawner

This script is made to help people having triggers that spawn units at random locations and add waypoints to them



https://github.com/Cid-Dev/arma3_DynamicSpawner/assets/26785799/c176c626-18b7-4a5a-acc1-d120713d2015



## Usage

Copy the `scripts` folder at the root of your mission

Edit/create a mission

Edit/create the file `init.sqf` (or [whichever file](https://community.bistudio.com/wiki/Initialisation_Order) you think is best suited for your mission) and add this code :

```sqf
private _spawn_trigger_init_script = execVM "scripts\spawn\init.sqf";
waitUntil
{
  scriptDone _spawn_trigger_init_script;
};
```

### Trigger creation

Place a trigger somewhere on the map and give it a shape and a size

![20240214143051_1](https://github.com/Cid-Dev/arma3_DynamicSpawner/assets/26785799/ca4f1967-ed45-456d-b7d0-96da2c7a90aa)

Edit the trigger attributes and gives it a text it respecting the following format :

`DynamicSpawn_<Activating side>_<Side to spawn>_<Amount of infantry squads>_<Amount of waypoints for infantry>_<Amount of vehicle squads>_<Amount of waypoints for vehicles>_<Amount of air units>_<Amount of air units waypoints (actually unused)>_<ID of the trigger>`

Where :

\<Activating side\> is the side that will activate the trigger when entering in  
\<Side to spawn\> is the side of the units that will spawn when the trigger is activated

Both sides can have the values : `"WEST"`, `"EAST"`, `"GUER"`, `"CIV"`

\<Amount of infantry squads\>, \<Amount of vehicle squads\> and \<Amount of air units\> are the amount of squads that will be spawn (except for air, that's just the amount of units).  
They can have any value above zero (including zero if you don't want such type of units)

\<Amount of waypoints for infantry\>, \<Amount of waypoints for vehicles\> and \<Amount of air units waypoints\> are the amount of waypoints for each kind of squads (actually unused for air units).  
They can have any value above zero (including zero if you don't want the units to move)  or a range of values using a comma `,` as separator, such ass `4,8` if you want between 4 and 8 waypoints.

\<ID of the trigger\> is a numeric value used to identify each triggers. Keep them unique or you may expect bugs (such as units spawning/moving at the wrong place)

For example : `DynamicSpawn_WEST_EAST_5_6,8_2_4_1_1_1` will trigger when an unit from WEST enters the trigger and will spawn units from EAST such as :  
- 5 infantry squads having each between 6 and 8 waypoints
- 2 vehicle squads having 4 waypoints
- 1 air unit
- The Id of the trigger is 1

![20240214152200_1](https://github.com/Cid-Dev/arma3_DynamicSpawner/assets/26785799/e46f0095-72c8-4992-a067-dfd70e908cc3)

And that's all for the trigger !

### Spawnpoints

For spawnpoints, place `Game Logic` entities on the map and give them as text the value : `<Type of group to spawn>_SPAWN_POINT_<id of the trigger>_<id of the spawn point>`

Where :

\<Type of group to spawn\> can have as value any of those : `INFANTRY`, `VEHICLE` or `AIR`

\<id of the trigger\> must match the id of the trigger previously created, so that way, when trigger `1` will be activated, the script will know it must use the `*_SPAWN_POINT_1_*` as spawn points. That way, **spawn points can be placed outside of the trigger** (allowing, for example, air units coming from far away)

\<id of the spawn point\> is used to have different unique names for spawn points (and that value is automatically incremented when copying/pasting the spawnpoints)

For example :

    INFANTRY_SPAWN_POINT_1_1
    INFANTRY_SPAWN_POINT_1_2
    INFANTRY_SPAWN_POINT_1_3
    ...
    
    VEHICLE_SPAWN_POINT_1_1
    VEHICLE_SPAWN_POINT_1_2
    VEHICLE_SPAWN_POINT_1_3
    VEHICLE_SPAWN_POINT_1_4
    ...
    
    AIR_SPAWN_POINT_1_1
    AIR_SPAWN_POINT_1_2
    ...

The example below shows many spawn points placed in Stratis.  
You can notice the air spawn points are placed all around the map, far away from the trigger

![20240214153846_1](https://github.com/Cid-Dev/arma3_DynamicSpawner/assets/26785799/f96c8c7d-05bd-46cf-90ea-5fbfd511693e)

### Waypoints

The waypoints work the same way than the spawn points : Their format is : `<Type of group>_WAYPOINT_<id of the trigger>_<id of the waypoint>` : 

    INFANTRY_WAYPOINT_1_1
    INFANTRY_WAYPOINT_1_2
    INFANTRY_WAYPOINT_1_3
    INFANTRY_WAYPOINT_1_4
    ...
    
    VEHICLE_WAYPOINT_1_1
    VEHICLE_WAYPOINT_1_2
    VEHICLE_WAYPOINT_1_3
    ...

#### Side note for air vehicle

There is no air waypoints, the behavior of air vehicles is different :

Once spawned (1000 meters altitude), they will fly and [`loiter`](https://community.bohemia.net/wiki/Waypoints#Loiter) around the center of the trigger (Altitude 250, radius 500)  
When a unit from the activating side is detected by the spawning side, the aircrafts will go [`Seek and Destroy`](https://community.bohemia.net/wiki/Waypoints#Seek_.26_Destroy) on that unit location.  
When the search is over, they will go back to `loiter`

---

The screenshot bellow shows the trigger, spawn points and waypoints placed in Stratis :

![20240214155605_1](https://github.com/Cid-Dev/arma3_DynamicSpawner/assets/26785799/70e80eee-d746-483b-9889-14d4622c1d76)

## Configuration and customization

This script is highly configurable and customizable

To do so, open the file located in `scripts\spawn\configure_all_triggers.sqf` and locate the part starting with the comment `// --------------- Customizations ---------------` and ending with `// ----------------------------------------------`

### Units and groups to spawn

You can define which units and groups will be spawned. This way, you can use any mods, as long as you tell the script the classnames of the units/groups you want to use

The groups can be :

- predefined groups as found in the configFile (for example a CSAT infantry squad is located under : `configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad"`)
- an array containing the classname of the units (For example : `[ "B_G_Soldier_A_F", "B_G_Soldier_F", "B_G_Soldier_AR_F", "B_G_Soldier_LAT_F" ]`)

To do so, edit the variable named `_groups`

This variable is a nested [`HashMap`](https://community.bistudio.com/wiki/HashMap) under the form :

(for more readability, I'm using the JSON-like format)

    {
      "<Side name>": {
        "INFANTRY": [
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Infantry" >> "Pre-configured_group_1",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Infantry" >> "Pre-configured_group_2",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Infantry" >> "Pre-configured_group_3",
          [ "unit_type_1", "unit_type_2", "unit_type_3", "unit_type_4", "unit_type_5" ]
        ],
        "VEHICLE": [
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Mechanized" >> "Pre-configured_group_1",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Mechanized" >> "Pre-configured_group_2",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Armored" >> "Pre-configured_group_1",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Armored" >> "Pre-configured_group_2",
          configFile >> "CfgGroups" >> "<Side name>" >> "Faction" >> "Armored" >> "Pre-configured_group_3",
          [ "unit_type_1", "unit_type_2", "unit_type_3", "unit_type_4", "unit_type_5" ]
        ],
        "AIR": [
          "Air_vehicle_type_1",
          "Air_vehicle_type_2",
          "Air_vehicle_type_3",
          "Air_vehicle_type_4"
        ]
      },
      "<Side name 2>": {
        // same as above, but using units of another side
      }
    }

For example, using vanilla CSAT units :

```sqf
private _configGroups = configFile >> "CfgGroups";
private _eastGroups = _configGroups >>  "East";
private _eastGroupOPF_F = _eastGroups >> "OPF_F";
private _eastGroupOPF_FInfantry = _eastGroupOPF_F >> "Infantry";
private _eastGroupOPF_FMechanized = _eastGroupOPF_F >> "Mechanized";
private _eastGroupOPF_FArmored = _eastGroupOPF_F >> "Armored";

private _groups = createHashMapFromArray [
	[
		"EAST", createHashMapFromArray [
			[
				"INFANTRY", [
					_eastGroupOPF_FInfantry >> "OIA_InfSquad",
					_eastGroupOPF_FInfantry >> "OIA_InfSquad_Weapons",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam_AT",
					_eastGroupOPF_FInfantry >> "OIA_InfTeam_AA",
					_eastGroupOPF_FInfantry >> "OIA_InfSentry",
					_eastGroupOPF_FInfantry >> "OI_reconTeam",
					_eastGroupOPF_FInfantry >> "OI_reconPatrol",
					_eastGroupOPF_FInfantry >> "OI_reconSentry",
					_eastGroupOPF_FInfantry >> "OI_SniperTeam",
					_eastGroupOPF_FInfantry >> "OIA_InfAssault",
					_eastGroupOPF_FInfantry >> "OIA_ReconSquad",
					_eastGroupOPF_FInfantry >> "O_InfTeam_AT_Heavy"
				]
			],
			[
				"VEHICLE", [
					_eastGroupOPF_FMechanized >> "OIA_MechInfSquad",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_AT",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_AA",
					_eastGroupOPF_FMechanized >> "OIA_MechInf_Support",
					_eastGroupOPF_FArmored >> "OIA_TankPlatoon",
					_eastGroupOPF_FArmored >> "OIA_TankPlatoon_AA",
					_eastGroupOPF_FArmored >> "OIA_TankSection",
					_eastGroupOPF_FArmored >> "OIA_SPGPlatoon_Scorcher",
					_eastGroupOPF_FArmored >> "OIA_SPGSection_Scorcher",
					_eastGroupOPF_FArmored >> "O_TankSection_Heavy",
					_eastGroupOPF_FArmored >> "O_TankPlatoon_Heavy"
				]
			],
			[
				"AIR", [
					"O_Heli_Light_02_F",
					"O_Heli_Light_02_v2_F",
					"O_Heli_Attack_02_F",
					"O_Heli_Attack_02_black_F",
					"O_Plane_CAS_02_F",
					"O_T_VTOL_02_infantry_F",
					"O_T_VTOL_02_vehicle_F",
					"O_T_VTOL_02_infantry_hex_F",
					"O_T_VTOL_02_infantry_ghex_F",
					"O_T_VTOL_02_infantry_grey_F",
					"O_T_VTOL_02_vehicle_hex_F",
					"O_T_VTOL_02_vehicle_grey_F",
					"O_Plane_Fighter_02_F",
					"O_Plane_Fighter_02_Stealth_F",
					"O_Plane_CAS_02_Cluster_F",
					"O_Plane_Fighter_02_Cluster_F"
				]
			]
		]
	]
];
```

### Should the trigger be deleted when the zone is cleared?

If so, set the variable `_deleteEverythingOnceCleared` to `true`. The main script will then remove everything : the trigger, its spawn points, its waypoints, and so on...

### Further customizations

If you need more customizations, you can inject custom scripts that can be executed at :

- Trigger creation
- Trigger activation
- Trigger deactivation
- Trigger cleared (when all spawned units are dead)

To do so, you can set the variable `_extraScript` with compiled code for trigger creation, `_extraScriptActivated` for trigger activation, `_extraScriptDeactivated` for trigger deactivation and `_extraScriptClearedTrigger` for trigger cleared

If you need to add parameters for each scripts, you can set the array `_extraScriptParams` for the code located in `_extraScript`, `_extraScriptParamsActivated` for the code located in `_extraScriptActivated`, `_extraScriptParamsDeactivated` for the code located in `_extraScriptDeactivated` and the array `_extraScriptClearedTriggerParams` for `_extraScriptClearedTrigger`

The main script, when calling the custom ones, will add paramters to them, so **your custom scripts must look like** :

    params [
    	[ "_trigger", objNull, [ objNull ] ],
    	"_functions",
    	"your_custom_parameter_1",
    	"your_custom_parameter_2",
    	"your_custom_parameter_3",
      // more parameters if needed
    ];

    // your code goes there

The pre-defined parameters are :

- `_trigger` This parameter contains the trigger itself which will execute the script
- `_functions` This is an HashMap containing utilities functions, defined in `scripts\spawn\configure_all_triggers.sqf` line 2 : `_functions`

The code currently contains an example of custom scripts for trigger creation and trigger cleared.  
The script `scripts\spawn\customizations\custom_script_create_trigger.sqf` contains code that will add a CSAT flag on the map at the location of the trigger and will "paint" the trigger zone in red  
The script `scripts\spawn\customizations\zone_cleared.sqf` contains code that will replace the previously created CSAT flag by a NATO one, will remove the "red paint" and will add an hint message telling the zone is cleared
