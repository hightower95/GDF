
// getUnitLoadout = 
[
    [
        "arifle_MX_SW_pointer_F", // rifle
        "", // silencer
        "acc_pointer_IR", // laser
        "", // optic
        [
            "100Rnd_65x39_caseless_mag", // loaded magazine
            0 // rounds left 
        ],
        [], // secondary magazine?
        "bipod_01_F_snd" // bipod
    ], // primary
    [], // launcher
    [
        "hgun_P07_F",
        "",
        "",
        "",
        ["16Rnd_9x21_Mag",17],
        [],
        ""
    ],
    [
        "U_B_CombatUniform_mcam_tshirt",
        [
            ["ACE_EarPlugs",1],
            ["ACE_fieldDressing",2],
            ["ACE_morphine",1],
            ["SmokeShell",1,1],
            ["HandGrenade",1,1],
            ["SmokeShellGreen",1,1],
            ["Chemlight_green",1,1]
        ]
    ],
    [
        "V_PlateCarrier2_rgr",
        [
            ["100Rnd_65x39_caseless_mag",5,100],
            ["16Rnd_9x21_Mag",2,17],
            ["Chemlight_green",1,1]
        ]
    ],
    [], // backpack
    "H_HelmetB_grass", //helmet
    "", //glasse?
    [], //binoculars
    ["ItemMap","","tf_anprc152_1","ItemCompass","tf_microdagr","NVGoggles"] //map, gps, radio, compass, watch, nvgs
];

// an option step before:
[
    [
		[
        "arifle_MX_SW_pointer_F", // rifle
        "", // silencer
        ["default", ["acc_pointer_IR","something"]], // laser options
        ["default", ["blah", "whatever"]], // optic
        [
            "100Rnd_65x39_caseless_mag", // loaded magazine
            0 // rounds left 
        ],
        [], // secondary magazine?
        "bipod_01_F_snd", // bipod
		"magazine_main" // main mag
		"magazine_tracer" // tracer
		// I think GLs dont need alternates - because its standard loadouts.
    	]
	], // primary
    [], // launcher
    [
        "hgun_P07_F",
        "",
        "",
        "",
        ["16Rnd_9x21_Mag",17],
        [],
        ""
    ],
    [
        "U_B_CombatUniform_mcam_tshirt",
        [
            ["ACE_EarPlugs",1],
            ["ACE_fieldDressing",2],
            ["ACE_morphine",1],
            ["SmokeShell",1,1],
            ["HandGrenade",1,1],
            ["SmokeShellGreen",1,1],
            ["Chemlight_green",1,1]
        ]
    ],
    [
        
		[
			"V_PlateCarrier2_rgr",
			[
				["100Rnd_65x39_caseless_mag",5,100],
				["16Rnd_9x21_Mag",2,17],
				["Chemlight_green",1,1]
			]
		],
		[
			["rig_lite", "night"], ["rig_lite_other", "day"]
		]
		
    ],
    [], // backpack
    "H_HelmetB_grass", //helmet
    "", //glasse?
    [], //binoculars
    ["ItemMap","","tf_anprc152_1","ItemCompass","tf_microdagr","NVGoggles"] //map, gps, radio, compass, watch, nvgs
];



