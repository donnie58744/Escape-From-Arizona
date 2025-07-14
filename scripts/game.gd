extends Node
const WALKING_SPEED = 100
const RUNNING_SPEED = 200
const PICKUP_INTERVAL:float = 0.2

const held_item_throw_speed = 300
const held_item_throw_distance = 50

var guns = {
	"Ak47AssaultRifle":{
		"SCENE_PATH":"res://pickups/guns/ak47AssaultRifle.tscn",
		"HAND_HOLDING_OFFSET":Vector2(20, 5),
		"AMMO_TYPE":"7.62x39mm",
		"FIRERATE":0.1,
		"CAN_AUTO_FIRE": true,
		"SPAWN_RATE":90
		},
	"Colt45Revolver":{
		"SCENE_PATH":"res://pickups/guns/colt45Revolver.tscn",
		"HAND_HOLDING_OFFSET":Vector2(25,-10),
		"AMMO_TYPE":".45 ACP",
		"FIRERATE": 0.2,
		"CAN_AUTO_FIRE": false,
		"SPAWN_RATE":80
	}
	}

var mags = {
	"Ak47_30_Round":{
		"SCENE_PATH":"res://pickups/mags/ak47_30_round_mag.tscn",
		"AMMO_CAPACITY":30,
		"SPAWN_RATE":99
	}
}
