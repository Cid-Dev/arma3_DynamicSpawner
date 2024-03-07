#include "spawn_constants.hpp"

params [
	[ "_trigger", objNull, [ objNull ] ],
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

_trigger call CID_fnc_setTriggerDatas;

private _triggerDatas = _trigger getVariable "CID_triggerDatas";
private _spawnSide = _triggerDatas get "SpawnSide";

_selectedSideSpawnGroups = _groups get _spawnSide;

_trigger call CID_fnc_setTriggerPoints;

private _activationSide = _triggerDatas get "ActivationSide";

_trigger setTriggerActivation [ _activationSide, "PRESENT", true ];

_trigger setTriggerStatements [
	"this",
	
	"thisTrigger spawn CID_fnc_dynamicSpawnerActivated;",

	"thisTrigger spawn CID_fnc_dynamicSpawnerDeactivated;"
];

_trigger setVariable [ "_groups", _selectedSideSpawnGroups ];
_trigger setVariable [ "_customScripts", _customScripts ];
_trigger setVariable [ "_groupsToDespawn", createHashMap ];

_trigger call CID_fnc_createDetectionTrigger;

[ _trigger, "TriggerCreation" ] call CID_fnc_customScript;