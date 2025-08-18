extends Node

# !!!!KEEP ITEM WEIGHTS EQUAL TO 100!!!!
enum RARITIES {Common, Uncommon, Rare, Legendary, Nothing}
enum ITEM_TYPES {Mag,Gun,Backpack,Item}
enum GUN_TYPES {None,MainWeapon,Pistol}
enum SUB_GUN_TYPES {None,AssaultRifle,Revolver}
enum GUNS {None,Ak47AssaultRifle,Colt45Revolver}
enum MAGS {None,Ak47_30_Round_Mag}
enum BACKPACKS {None,Large_Green_Backpack}

var ITEM_SPAWN_DATA:Dictionary = {
	ITEM_TYPES.Gun:{
		RARITIES.Common:{
			GUNS.Ak47AssaultRifle:{
				"RESOURCE_PATH":"res://pickups/guns/ak47AssaultRifle.tscn",
				"SPAWN_WEIGHT":50,
			},
			GUNS.Colt45Revolver:{
				"RESOURCE_PATH":"res://pickups/guns/colt45Revolver.tscn",
				"SPAWN_WEIGHT":50,
			}
		}
	},
	ITEM_TYPES.Mag:{
		RARITIES.Common:{
			MAGS.Ak47_30_Round_Mag:{
				"RESOURCE_PATH":"res://pickups/mags/ak47_30_round_mag.tscn",
				"SPAWN_WEIGHT":100,
			}
		},
	},
	ITEM_TYPES.Backpack:{
		RARITIES.Common:{
			BACKPACKS.Large_Green_Backpack:{
				
			}
		}
	}
}

const rarities = {
	"Common":{
		"SPAWN_WEIGHT":50
		},
	"Uncommon":{
		"SPAWN_WEIGHT":28
	},
	"Rare":{
		"SPAWN_WEIGHT":15
	},
	"Legendary":{
		"SPAWN_WEIGHT":5
	},
	"Nothing":{
		"SPAWN_WEIGHT":2
	}
	}
