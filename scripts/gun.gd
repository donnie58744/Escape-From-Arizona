class_name Gun
extends CharacterBody2D

const BULLET = preload("res://pickups/bullets/bullet.tscn")

# Gun Data
@onready var itemData = Item.new()
var isAutoFireMode = false
var hasMag = false
@export var GUN_NAME:String
@onready var gunData = Game.guns[GUN_NAME]
@onready var ITEM_TYPE:String = "Gun"
@onready var AMMO_TYPE:String = self.gunData["AMMO_TYPE"]
@onready var FIRERATE:float = self.gunData["FIRERATE"]
@onready var CAN_AUTO_FIRE:bool = self.gunData["CAN_AUTO_FIRE"] 
@onready var HAND_HOLDING_OFFSET = self.gunData["HAND_HOLDING_OFFSET"]

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]

# Scene Items
@onready var muzzle: Marker2D = $Muzzle
@onready var shotSound: AudioStreamPlayer = $Shot
@onready var fire_rate_timer: Timer = $FireRateTimer

func createBullet():
	# Create bullet, add it to root scene, play gun sound
	var bullet_instance = BULLET.instantiate()
	bullet_instance.gunName = GUN_NAME
	get_tree().root.add_child(bullet_instance)
	shotSound.play()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = player.rotation
	
func setupGunInfoPlayer():
	player.ammoTypeLabel.text = AMMO_TYPE
	if (isAutoFireMode):
		player.firerateInfoLabel.text = "Auto"
	else:
		player.firerateInfoLabel.text = "Single"
		
func changeFireMode():
	if (CAN_AUTO_FIRE):
		isAutoFireMode = !isAutoFireMode

func shootBullet():
	if (fire_rate_timer.is_stopped()):
		createBullet()
		fire_rate_timer.start(FIRERATE)

func _process(delta: float) -> void:
	if (itemData.isPickuped):
		if(isAutoFireMode and Input.is_action_pressed("fire")):
			shootBullet()
		if (!isAutoFireMode and Input.is_action_just_pressed("fire")):
			shootBullet()
		if (Input.is_action_just_pressed("fire mode")):
			changeFireMode()

func _physics_process(delta: float) -> void:
	pass
