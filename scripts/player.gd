class_name Player
extends CharacterBody2D

var currentSpeed = Game.WALKING_SPEED
var mouse_pos=null
var held_item:Item = null
var currentEquipSlot = null

@onready var player_ui: CanvasLayer = $UI
@onready var player_quick_slots_ui: PlayerQuickSlots = $UI/PlayerQuickSlots
@export var inventory: CharacterInventory
@onready var inventory_ui: Control = $UI/PlayerInventory
@onready var interact_panel_ui: PanelContainer = $UI/InteractPanel
@onready var pickup_timer: Timer = $PickupTimer
@onready var right_hand: Sprite2D = $RightHand
var pickupsInRange:Array[PickupItem]
@onready var maxInventorySize:int = Game.playerMaxInventorySize
@onready var currentScene:Node2D = get_parent()
@onready var quickSlots:Array = [0,1,2,3,4,5,6,7,8,9]
@onready var gun_info: Panel = $UI/GunInfo

func player_movement():
	if (!inventory_ui.visible):
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

func deEquipHeld():
	right_hand.texture = null
	held_item = null
	
func shoot(gun:Gun):
	if (gun.loadedMag and gun.loadedMag.currentAmmo > 0):
		# Some Dumb math code to properly spawn bullet at muzzle
		var side_x = sign(cos(rotation))
		var side_y = sign(sin(rotation))
		var offset = Vector2(
			right_hand.offset.x * abs(side_x),
			right_hand.offset.y * side_y
		)
		#--------------------------------------------------------
		
		var bullet = gun.createBullet()
		bullet.position = right_hand.global_position + offset.rotated(rotation) + gun.ATTACHMENT_POINTS["Muzzle"].rotated(rotation)
		bullet.rotation = rotation
		gun.loadedMag.removeAmmo(1)
		get_tree().get_current_scene().add_child(bullet)
		gun_info.update(gun)
#TODO RETURN USES MAGJIC NUMBERS!!! NO GOOD
func checkForMag()->Array:
	var hasTactialRig = inventory.tactialRig
	var hasBackpack = inventory.backpack

	if (hasTactialRig != null):
		for item in hasTactialRig:
			if (item is Mag):
				return [item]
	elif (hasBackpack != null):
		var backpack:Backpack = hasBackpack
		for item in backpack.items:
			if (item is Mag):
				return [item,backpack]
	return []
	
func reload(gun:Gun):
	var checkMag = checkForMag()
	if (!checkMag.is_empty()):
		var mag:Mag = checkMag[0]
		var container:ItemContainer = checkMag[1]
		var itemRarity=Game.RARITIES.keys()[mag.RARITY]
		var compatableMags = gun.COMPATABLE_MAGS
		for compatableMag in compatableMags:
			if (compatableMag.NAME == mag.NAME):
				if (gun.loadedMag):
					if (!inventory.canPickup(gun.loadedMag,true)):
						inventory.drop(gun.loadedMag,self,currentScene,false)

				gun.loadedMag = mag
				container.remove(mag)
				print(mag,gun.loadedMag.currentAmmo,mag.currentAmmo)
				gun_info.update(gun)

func changeFireMode(gun:Gun):
	if (gun.CAN_AUTO_FIRE):
		gun.isAutoFireMode = !gun.isAutoFireMode

func equipToHeld(item:Item,equipSlotName:String):
	currentEquipSlot = equipSlotName
	held_item = item
	right_hand.texture = held_item.ICON
	if (item is Gun):
		right_hand.offset = -item.ATTACHMENT_POINTS["PistolGrip"]
		gun_info.update(held_item)

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("throw") and held_item):
		inventory.drop(held_item,self,get_tree().get_current_scene(),true)
	
	if (Input.is_action_just_pressed("interact") and pickupsInRange.size() > 0):
		inventory.pickup(pickupsInRange[0])
		
	if (Input.is_action_just_pressed("equip") and (pickupsInRange.size() > 0)):
		inventory.equip(pickupsInRange[0])
		
	if (Input.is_action_just_pressed("inventory")):
		inventory_ui.showHide()

	if (Input.is_action_just_pressed("primary_weapon") and inventory.primaryWeapon):
		equipToHeld(inventory.primaryWeapon,"Primary")
	if (Input.is_action_just_pressed("secondary_weapon") and inventory.secondaryWeapon):
		equipToHeld(inventory.secondaryWeapon,"Secondary")
	if (Input.is_action_just_pressed("pistol") and inventory.pistol):
		equipToHeld(inventory.pistol,"Pistol")
		
	if (held_item is Gun):
		if(held_item.isAutoFireMode and Input.is_action_pressed("fire")):
			shoot(held_item)
			gun_info.update(held_item)
		if (!held_item.isAutoFireMode and Input.is_action_just_pressed("fire")):
			shoot(held_item)
		if (Input.is_action_just_pressed("fire mode")):
			changeFireMode(held_item)
			gun_info.update(held_item)
		if (Input.is_action_just_pressed("reload")):
			reload(held_item)
			
		gun_info.showHide(true)
	else:
		gun_info.showHide(false)

func _physics_process(delta: float) -> void :
	player_movement()
