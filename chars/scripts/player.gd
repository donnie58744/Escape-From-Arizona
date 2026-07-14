class_name Player
extends Combatant

var mouse_pos=null

@export var player_quick_slots_ui: PlayerQuickSlots
@export var inventory_ui: Control
@export var interact_panel_ui: PlayerInteractPanel
@export var gun_info_ui: Panel
@onready var currentScene:Node2D = get_parent()

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
	if (Input.is_action_just_pressed("inventory")):
		interact_panel_ui.hide()
		inventory_ui.showHide()
	if (!inventory_ui.visible):
		if (Input.is_action_just_pressed("throw") and right_hand.held_item):
			character_data.inventory.drop(right_hand.held_item,get_tree().get_current_scene(),true,right_hand)
		
		if (Input.is_action_just_pressed("interact") and character_data.pickupsInRange.size() > 0):
			character_data.inventory.pickup(self,character_data.pickupsInRange[0],character_data.inventory.findContainer())
			
		if (Input.is_action_just_pressed("equip") and (character_data.pickupsInRange.size() > 0)):
			character_data.inventory.equip(self, character_data.pickupsInRange[0])

		if (Input.is_action_just_pressed("primary_weapon") and character_data.inventory.primaryWeapon):
			right_hand.equip(character_data.inventory.primaryWeapon,"Primary",character_data)
			gun_info_ui.update(right_hand.held_item)
		
		if (Input.is_action_just_pressed("secondary_weapon") and character_data.inventory.secondaryWeapon):
			right_hand.equip(character_data.inventory.secondaryWeapon,"Secondary",character_data)
			gun_info_ui.update(right_hand.held_item)
		
		if (Input.is_action_just_pressed("pistol") and character_data.inventory.pistol):
			right_hand.equip(character_data.inventory.pistol,"Pistol",character_data)
			gun_info_ui.update(right_hand.held_item)
		
		if (Input.is_action_pressed("fire")):
			right_hand.fire(right_hand.held_item,self)

		if (Input.is_action_just_pressed("fire mode")):
			right_hand.changeFireMode(right_hand.held_item)

		if (Input.is_action_just_pressed("reload")):
			right_hand.reload(right_hand.held_item,currentScene,character_data.inventory)

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
