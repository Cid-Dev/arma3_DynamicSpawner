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
private _length = count _all_spawn_triggers;

for "_i" from 0 to _length - 1 do
{
	private _trigger = _all_spawn_triggers select _i;
	diag_log format [ "Setting up trigger %1 if needed.", triggerText _trigger ];

	[
		_trigger,
		_groups,
		_customScripts
	] call CID_fnc_configureTrigger;
};