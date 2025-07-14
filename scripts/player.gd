class_name Player
extends CharacterBody2D

var currentSpeed = Game.WALKING_SPEED
var mouse_pos=null
var held_item = null

const coltRevolver = preload("res://pickups/guns/colt45Revolver.tscn")
const ak47AssaultRifle = preload("res://assets/Guns/01 - Individual sprites/Guns/AK 47 [96x48].png")
@onready var player_ui: Control = $UI/PlayerUI
@onready var gunInfo: ColorRect = player_ui.get_node("GunInfo")
@onready var ammoTypeLabel: Label = player_ui.get_node("GunInfo/List/AmmoTypeLabel")
@onready var firerateInfoLabel: Label = player_ui.get_node("GunInfo/List/FirerateLabel")
@onready var pickup_label: Label = player_ui.get_node("PickupLabel")
@onready var right_hand: Marker2D = $RightHand
var pickupsInRange:Array = []

func player_movement():
	var directionX = Input.get_axis("left", "right")
	var directionY = Input.get_axis("up", "down")
	var runKey = Input.is_action_pressed("run")
	
	mouse_pos = get_global_mouse_position()
	
	if (directionX):
		velocity.x = directionX * currentSpeed
	else:
		velocity.x = 0
		
	if (directionY):
		velocity.y = directionY * currentSpeed
	else:
		velocity.y = 0
		
	if (runKey):
		currentSpeed = Game.RUNNING_SPEED
	else:
		currentSpeed = Game.WALKING_SPEED
		
	look_at(mouse_pos)
	move_and_slide()
	
func throwingHeldItem(delta):
	if (held_item and held_item.itemData.isThrowing):
		var itemDistanceX = abs(held_item.itemData.currentPOS.x - held_item.position.x)
		var itemDistanceY = abs(held_item.itemData.currentPOS.y - held_item.position.y)
		
		if ((itemDistanceX < Game.held_item_throw_distance and itemDistanceY < Game.held_item_throw_distance)):
			held_item.position += held_item.transform.x * Game.held_item_throw_speed * delta
			held_item.move_and_slide()
		else:
			held_item.itemData.isThrowing=false
			held_item = null

func throwHeldItem():
	var level = get_parent()
	
	held_item.reparent(level)
	held_item.itemData.currentPOS = right_hand.global_position
	held_item.itemData.isPickuped = false
	held_item.itemData.isThrowing = true

func awaitPickup(time):	
	# wait x time so the player cant pickup multiple items at once
	var tween=create_tween().bind_node(self)
	tween.tween_interval(time)
	await tween.finished

func playerPickup():
	# Put gun in player node and position it in his right hand with offsets, also sets the players held item
	if(held_item==null):		
		held_item = pickupsInRange[0]
		
		held_item.reparent(self)
		held_item.itemData.isPickuped = true
		held_item.position = Vector2(right_hand.position.x + held_item.HAND_HOLDING_OFFSET.x ,right_hand.position.y+held_item.HAND_HOLDING_OFFSET.y)
		held_item.rotation_degrees = 0
		await awaitPickup(Game.PICKUP_INTERVAL)
		
func showGunInfo():
	if (held_item != null and held_item.ITEM_TYPE == "Gun"):
			held_item.setupGunInfoPlayer()
			gunInfo.show()
	else:
		gunInfo.hide()

func _process(delta: float) -> void:
	showGunInfo()
			
	if (Input.is_action_just_pressed("throw") and held_item):
		throwHeldItem()
	
	if (Input.is_action_just_pressed("interact") and pickupsInRange.size() > 0):
		await playerPickup()

func _physics_process(delta: float) -> void :
	player_movement()
	
	throwingHeldItem(delta)
