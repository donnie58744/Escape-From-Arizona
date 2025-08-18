class_name Player
extends CharacterBody2D

var mouse_pos=null

@export var player_quick_slots_ui: PlayerQuickSlots
@export var inventory_ui: Control
@export var interact_panel_ui: PlayerInteractPanel
@export var gun_info_ui: Panel
@export var character:Character
@export var pickup_timer: Timer
@export var right_hand: CharacterHand
@onready var currentScene:Node2D = get_parent()

func player_movement():
	var directionX = Input.get_axis("left", "right")
	var directionY = Input.get_axis("up", "down")
	var runKey = Input.is_action_pressed("run")
	
	mouse_pos = get_global_mouse_position()
	
	if (directionX):
		velocity.x = directionX * character.currentSpeed
	else:
		velocity.x = 0
		
	if (directionY):
		velocity.y = directionY * character.currentSpeed
	else:
		velocity.y = 0
		
	if (runKey):
		character.currentSpeed = character.RUNNING_SPEED
	else:
		character.currentSpeed = character.WALKING_SPEED
		
	look_at(mouse_pos)
	move_and_slide()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("inventory")):
		interact_panel_ui.hide()
		inventory_ui.showHide()
	if (!inventory_ui.visible):
		if (Input.is_action_just_pressed("throw") and right_hand.held_item):
			character.inventory.drop(right_hand.held_item,get_tree().get_current_scene(),true,right_hand)
		
		if (Input.is_action_just_pressed("interact") and character.pickupsInRange.size() > 0):
			character.inventory.pickup(self,character.pickupsInRange[0],character.inventory.findContainer())
			
		if (Input.is_action_just_pressed("equip") and (character.pickupsInRange.size() > 0)):
			character.inventory.equip(self, character.pickupsInRange[0])

		if (Input.is_action_just_pressed("primary_weapon") and character.inventory.primaryWeapon):
			right_hand.equip(character.inventory.primaryWeapon,"Primary",character)
			gun_info_ui.update(right_hand.held_item)
		if (Input.is_action_just_pressed("secondary_weapon") and character.inventory.secondaryWeapon):
			right_hand.equip(character.inventory.secondaryWeapon,"Secondary",character)
			gun_info_ui.update(right_hand.held_item)
		if (Input.is_action_just_pressed("pistol") and character.inventory.pistol):
			right_hand.equip(character.inventory.pistol,"Pistol",character)
			gun_info_ui.update(right_hand.held_item)
			
		if (right_hand.held_item is Gun):
			if(right_hand.held_item.isAutoFireMode and Input.is_action_pressed("fire")):
				right_hand.shoot(right_hand.held_item,self)
			if (!right_hand.held_item.isAutoFireMode and Input.is_action_just_pressed("fire")):
				right_hand.shoot(right_hand.held_item,self)
			if (Input.is_action_just_pressed("fire mode")):
				right_hand.changeFireMode(right_hand.held_item)
			if (Input.is_action_just_pressed("reload")):
				right_hand.reload(right_hand.held_item,currentScene,character.inventory)
			gun_info_ui.update(right_hand.held_item)
			gun_info_ui.showHide(true)
		else:
			gun_info_ui.showHide(false)
		
		if (character.pickupsInRange.size() == 0):
			interact_panel_ui.hide()

func _physics_process(delta: float) -> void :
	if (!inventory_ui.visible):
		player_movement()
