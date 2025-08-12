extends Node
const WALKING_SPEED = 100
const RUNNING_SPEED = 200
const PICKUP_INTERVAL:float = 0.4

const held_item_throw_speed = 300
const held_item_throw_distance = 50

var playerMaxInventorySize = 10
var playerQuickSlotsSize = 10

# !!!!KEEP ITEM WEIGHTS EQUAL TO 100!!!!
enum RARITIES {Common, Uncommon, Rare, Legendary, Nothing}
enum ITEM_TYPES {Mag,Gun,Backpack,Item}
enum GUN_TYPES {MainWeapon,Pistol,None}
enum SUB_GUN_TYPES {AssaultRifle,Revolver}
var ITEMS:Dictionary = {
	"Guns":[
		"Ak47AssaultRifle","Colt45Revolver"
	],
	"Mags":{
		
	},
	"Backpacks":{
		
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

var guns = {
	"Common":{
		"Ak47AssaultRifle":{
			"RESOURCE_PATH":"res://pickups/guns/ak47AssaultRifle.tscn",
			"SPAWN_WEIGHT":50,
		},
		"Colt45Revolver":{
			"RESOURCE_PATH":"res://pickups/guns/colt45Revolver.tscn",
			"SPAWN_WEIGHT":50,
		}
	},
	}

var mags = {
	"Common":{
		"Ak47_30_Round_Mag":{
			"RESOURCE_PATH":"res://pickups/mags/ak47_30_round_mag.tscn",
			"SPAWN_WEIGHT":100,
		}
	},
}

var backpacks = {
	"Common":{
		"Large_Green_Backpack":{
			
		}
	}
}
