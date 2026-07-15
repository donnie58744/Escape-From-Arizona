class_name Player
extends Character

var mouse_pos=null

@export var player_quick_slots_ui: PlayerQuickSlots
@export var inventory_ui: Control
@export var interact_panel_ui: PlayerInteractPanel
@export var gun_info_ui: Panel
@onready var currentScene:Node2D = get_parent()

func update_pickup_hover_ui():
	var hovered_pickup: PickupItem = null
	for pickup in character_data.pickupsInRange:
		if pickup.isMouseOver():
			hovered_pickup = pickup
			break

	characterPickupItem = hovered_pickup

	if hovered_pickup:
		interact_panel_ui.setup(self, hovered_pickup.item)
	else:
		interact_panel_ui.hide()

func player_movement():
	var directionX = Input.get_axis("left", "right")
	var directionY = Input.get_axis("up", "down")
	var runKey = Input.is_action_pressed("run")
	
	mouse_pos = get_global_mouse_position()
	
	if (directionX):
		velocity.x = directionX * character_data.currentSpeed
	else:
		velocity.x = 0
		
	if (directionY):
		velocity.y = directionY * character_data.currentSpeed
	else:
		velocity.y = 0
		
	if (runKey):
		character_data.currentSpeed = character_data.RUNNING_SPEED
	else:
		character_data.currentSpeed = character_data.WALKING_SPEED
		
	look_at(mouse_pos)
	move_and_slide()

func _process(delta: float) -> void:
	print(characterPickupItem)
	print(character_data.pickupsInRange)
	
	update_pickup_hover_ui()
	
	if (Input.is_action_just_pressed("inventory")):
		interact_panel_ui.hide()
		inventory_ui.showHide()
	if (!inventory_ui.visible):
		if (Input.is_action_just_pressed("throw")): character_data.inventory.drop(right_hand.held_item,get_tree().get_current_scene(),right_hand)
		
		if (Input.is_action_just_pressed("interact")): character_data.inventory.pickup(self,character_data.inventory.findContainer())
			
		if (Input.is_action_just_pressed("equip")): character_data.inventory.equip(self)

		if (Input.is_action_just_pressed("primary_weapon")): right_hand.equip(character_data.inventory.primaryWeapon, gun_info_ui)
		
		if (Input.is_action_just_pressed("secondary_weapon")): right_hand.equip(character_data.inventory.secondaryWeapon, gun_info_ui)
		
		if (Input.is_action_just_pressed("pistol")): right_hand.equip(character_data.inventory.pistol,gun_info_ui)
		
		if (Input.is_action_pressed("fire")): right_hand.fire(right_hand.held_item,self)

		if (Input.is_action_just_pressed("fire mode")): right_hand.changeFireMode(right_hand.held_item)

		if (Input.is_action_just_pressed("reload")): right_hand.reload(right_hand.held_item,currentScene,character_data.inventory)

		if (right_hand.held_item is Gun):
			gun_info_ui.update(right_hand.held_item)
			gun_info_ui.showHide(true)
		else:
			gun_info_ui.showHide(false)
		
		if (character_data.pickupsInRange.size() == 0):
			interact_panel_ui.hide()

func _physics_process(delta: float) -> void :
	if (!inventory_ui.visible):
		player_movement()
