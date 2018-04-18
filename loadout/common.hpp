
#define 


_army AddBaseRole("Autorifleman",
    helmet="helmet_classname",
    ChestRig="blah",

role.helmet = 
role.helmet_alternate = 
role.weapon.primary =
role.weapon.primary.magazines = 
role.weapon.primary.magazines_alternate =
role.weapon_alternates

#define options []
#define loadout_item ["", options]

#define helmet loadout_item('helmet')
#define empty_loadout [helmet, chest_rig, weapon ]
//https://github.com/acemod/ACE3/blob/master/tools/cba/addons/main/script_macros_common.hpp

#define HELMET 1
#define CHEST 2


#define STD_LDOUT NAME + HELMET + RIG + BACKPACK + UNIFORM + WEAPON_PRIM + WEAPON_SEC + WEAPON_PISTOL + ITEMS
#define CREATE_LOADOUT(name) [name];


#define SET_ITEM(loadout, index, classname) loadout set [index, classname]
#define SET_ITEM_OPTIONS(loadout, index, options) loadout set[(index + 1), options]

#define GET_ITEM(loadout, index) loadout select index
#define GET_ITEM(loadout, index) loadout select (index+1)

#define SET_HELMET(loadout, classname) SET_ITEM(loadout,HELMET,classname) 
#define GET_HELMET(loadout) GET_ITEM(loadout,HELMET)
#define ASSIGN_HELMET(loadout, unit) (unit removeHeadgear; unit assignHeadgear (GET_HELMET(loadout))) 

// 
Default_Loadout

set_default_rifle
-> loadouts
  -- functions
  -- cfgs 
  -> blufor
    -- base
    -> faction
      "register_faction"
      "get_loadout_callback" 
    -> faction
  -> opfor
  -> ind

class loadout_roles {
    class base {
        name = "rifleman";
        modifiers[] = [];
        skills[] = [];
    };
    class autorifleman : base {
        name = "autorifle";
        modifiers[] = [];
        skills = ["unsteady", "strong"];
        weapon = automatic_light;
        optics = optics_close;
        
    };
};

["rifleman", "us", ["light", "sl"]] call f_fnc_assignGear

case "rifleman":
    player addWeapon WEAPON_RIFLEMAN
    player addMagazines [PRIMARY_MAGS, 10]

if count (modifiers select {_x == "SL"}) > 0 then {
    player addItem "item_gps";
    player addItem "binoculars";
}

python:
{
"rifleman":{
    "uniform": {
        "class": "cls_name_uni",
        "contents" : ["this", "that"]
    },
    "chest": {
        "default": "cls_name_uni",
        "options": ""
        "contents" : ["this", "that"]
    }
}
}

roles = {
    "rifleman": {
        article : article type, default, options
        "weapon_primary" : {
            "weapon_default" : {
                "class": "clsname",
                "magazines": [("tracer", 5), ("std", 7)],
                "optic": {
                    "default": "blah",
                    "alternates": [
                        {
                        "cls": "clsname",
                        "test": "isNight"
                        }
                    ]
                }
            },
            "alternates": [
                 {
                    "class": "clsname",
                    "magazines": [("tracer", 5), ("std", 7)]
                },
                 {
                    "class": "clsname",
                    "magazines": [("tracer", 5), ("std", 7)]
                },
            ],
            "optics": 
        }
    }

}

roles.hpp
case rifleman:
[{magazines},{grenades},{smokes},{gps},{medic_supplies}]
{magazines} = {{primary_mags}{secondary_mags}{tetiary_mags}}
{primary_mags} = {{normal}{tracer}}

nato.sqf:
{normal_mags} : "556stdx5v_clsname"

["{magazines}"]

"{magazines}" : ["{primary_mags}",




//[["Autorifleman", ["Helmet","Helmet_ClassName"],["ChestRig",["Blah","Blah2"]],["Rifleman", []]

_unit = player;

role = getRole (_unit)
           -> guessByVariable (_unit getVariable "role")
           -> guessByClassName (className _unit)
           -> guessByItems (if medikit, if toolkit, if explosives)
           -> guessByWeapon (if magazine bullets > 10 > 30, has GL, has AT)
           -> otherTest
faction = getFaction (_unit)
faction_roles = getGear (faction)

loadout = lookup_loadout(role)

faction = ["NewArmy"] call addFaction;
faction setDefault 
faction addRole (rolename, role class names, items, weapon, test)
faction setEquipment

faction = [roles, role_tests, faction_name]
roles = STD_ROLES
roles removeRole ("rifleman")

there has to be elements: [palette of roles, palette of gear]
the role maps gear to a faction
the gear palette maps faction classname to items