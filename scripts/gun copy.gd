class_name Item
extends CharacterBody2D

const BULLET = preload("res://pickups/bullets/bullet.tscn")

# Gun Data
var isPickuped = false
var isThrowing = false
var isAutoFireMode = false
@onready var currentPOS = position
@export var GUN_NAME:String
@export var AMMO_TYPE:String
@export var FIRERATE:float
@export var CAN_AUTO_FIRE:bool

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]
@onready var handHoldingOffset = Game.handHoldingOffsets[GUN_NAME]

# Scene Items
@onready var muzzle: Marker2D = $Muzzle
@onready var shot: AudioStreamPlayer = $Shot
@onready var fire_rate_timer: Timer = $FireRateTimer
	
func awaitPickup(time):	
	# wait x time so the player cant pickup multiple items at once
	var tween=create_tween().bind_node(self)
	tween.tween_interval(time)
	await tween.finished
	
func createBullet():
	# Create bullet, add it to root scene, play gun sound
	var bullet_instance = BULLET.instantiate()
	bullet_instance.gunName = GUN_NAME
	get_tree().root.add_child(bullet_instance)
	shot.play()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = player.rotation
	
func showGunInfoPlayer():
	player.gunInfo.show()
	player.ammoTypeLabel.text = AMMO_TYPE
	if (isAutoFireMode):
		player.firerateInfoLabel.text = "Auto"
	else:
		player.firerateInfoLabel.text = "Single"
		
func changeFireMode():
	if (CAN_AUTO_FIRE):
		isAutoFireMode = !isAutoFireMode
	showGunInfoPlayer()

func shootBullet():
	if (fire_rate_timer.is_stopped()):
		createBullet()
		fire_rate_timer.start(FIRERATE)
		
func playerPickup():
	# Put gun in player node and position it in his right hand with offsets, also sets the players held item
	if(player.held_item==null):
		reparent(player)
		position = Vector2(player.right_hand.position.x + handHoldingOffset.x ,player.right_hand.position.y+handHoldingOffset.y)
		rotation_degrees = 0
		isPickuped = true
		player.held_item = self
		showGunInfoPlayer()
		await awaitPickup(Game.PICKUP_INTERVAL)

func _process(delta: float) -> void:
	if (isPickuped):
		if(isAutoFireMode and Input.is_action_pressed("fire")):
			shootBullet()
		if (!isAutoFireMode and Input.is_action_just_pressed("fire")):
			shootBullet()
		if (Input.is_action_just_pressed("fire mode")):
			changeFireMode()
	
	if (Input.is_action_just_pressed("interact") and player.pickupsInRange.find(self) == 0):
		await playerPickup()

func _physics_process(delta: float) -> void:
	# Check if thrown item is a specified distance away from the players hand
	if (isThrowing):
		var itemDistanceX = abs(currentPOS.x - position.x)
		var itemDistanceY = abs(currentPOS.y - position.y)
		
		if ((itemDistanceX < Game.held_item_throw_distance and itemDistanceY < Game.held_item_throw_distance)):
			position += transform.x * Game.held_item_throw_speed * delta
			move_and_slide()
		else:
			isThrowing=false
