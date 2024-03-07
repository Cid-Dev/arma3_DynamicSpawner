#include "spawn_constants.hpp"

params [
	[
		"_groups",
		createHashMapFromArray
		[
			[
				"EAST", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"WEST", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"CIV", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			],
			[
				"GUER", createHashMapFromArray
				[
					[ "INFANTRY", [] ],
					[ "VEHICLE", [] ],
					[ "AIR", [] ]
				]
			]
		],
		[ createHashMap ]
	],
	[
		"_customScripts",
		createHashMapFromArray
		[
			[
				"TriggerCreation", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			],
			[
				"TriggerActivated", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			],
			[
				"TriggerDeactivated", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			],
			[
				"TriggerDetected", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			],
			[
				"TriggerUndetected", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			],
			[
				"TriggerCleared", createHashMapFromArray
				[
					[ "Script", {} ],
					[ "Params", [] ]
				]
			]
		],
		[ createHashMap ]
	]
];

private _all_spawn_triggers = (allMissionObjects "EmptyDetector") select { triggerText _x regexMatch TRIGGER_NAME_PATTERN };

{
	private _trigger = _x;
	
	[
		_trigger,
		_groups,
		_customScripts
	] call CID_fnc_configureTrigger;
} forEach _all_spawn_triggers;