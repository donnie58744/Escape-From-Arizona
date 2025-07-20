class_name Player
extends CharacterBody2D

var currentSpeed = Game.WALKING_SPEED
var mouse_pos=null
var held_item = null

@onready var player_ui: Control = $UI/PlayerUI
@onready var gunInfoContainer: ColorRect = player_ui.get_node("GunInfo")
@onready var ammoTypeLabel: Label = player_ui.get_node("GunInfo/List/AmmoTypeLabel")
@onready var firerateInfoLabel: Label = player_ui.get_node("GunInfo/List/FirerateLabel")
@onready var currentAmmoLabel: Label = player_ui.get_node("GunInfo/List/CurrentAmmoLabel")
@onready var pickup_label: Label = player_ui.get_node("PickupLabel")
@onready var right_hand: Marker2D = $RightHand
var pickupsInRange:Array = []
@onready var maxInventorySize:int = Game.playerMaxInventorySize
@onready var inventory:Array = []
@onready var currentScene:Node2D = get_parent()

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
	
func canAddToInventory() -> bool:
	if (inventory.size() < maxInventorySize):
		return true
	return false
	
func addToInventory(item:CharacterBody2D) -> bool:
	if (canAddToInventory()):
		inventory.append(item)
		return true
	return false
	
func removeFromInventory(item:CharacterBody2D):
	inventory.remove_at(inventory.find(item))
	
func dropItem(item:CharacterBody2D):
	removeFromInventory(item)
	currentScene.add_child(item)
	item.position = position

func awaitPickup(time):	
	# wait x time so the player cant pickup multiple items at once
	var tween=create_tween().bind_node(self)
	tween.tween_interval(time)
	await tween.finished

func playerPickup():
	var itemToPickup:CharacterBody2D = pickupsInRange[0]
	var itemToPickupParent = itemToPickup.get_parent()
	# Put gun in player node and position it in his right hand with offsets, also sets the players held item
	if(canAddToInventory()):
		# Equip pickuped item
		if (held_item == null):
			held_item = itemToPickup
			
			held_item.reparent(self)
			held_item.item.isPickuped = true
			held_item.position = Vector2(right_hand.position.x + held_item.HAND_HOLDING_OFFSET.x ,right_hand.position.y+held_item.HAND_HOLDING_OFFSET.y)
			held_item.rotation_degrees = 0
		# Put pickuped item in inventory
		else:
			itemToPickupParent.remove_child(itemToPickup)
		
		addToInventory(itemToPickup)
		print(inventory)
		await awaitPickup(Game.PICKUP_INTERVAL)
		
func showGunInfo():
	if (held_item != null and held_item.ITEM_TYPE == "Gun"):
			held_item.setupGunInfoPlayer()
			gunInfoContainer.show()
	else:
		gunInfoContainer.hide()

func _process(delta: float) -> void:
	showGunInfo()
			
	if (Input.is_action_just_pressed("throw")):
		if (held_item is ThrowableItem and held_item.itemData != null):
			var itemThrown:ThrowableItem=held_item
			if (itemThrown.itemData.IS_THROWABLE):
				var throwPOS = right_hand.global_position
				
				itemThrown.startThrow(throwPOS,currentScene)
				removeFromInventory(itemThrown)
				held_item = null
	
	if (Input.is_action_just_pressed("interact") and pickupsInRange.size() > 0):
		await playerPickup()

func _physics_process(delta: float) -> void :
	player_movement()
