class_name ThrowableItem
extends CharacterBody2D

@export var item:Item
var player
var player_inventory

func _init(PLAYER:Player, PLAYER_INVENTORY:PlayerInventory) -> void:
	player = PLAYER
	player_inventory = PLAYER_INVENTORY

func _ready() -> void:
	set_physics_process(false)

func throwingHeldItem(held_item:CharacterBody2D,delta):
	var currentPOS = position
	if (item.isThrowing):
		var itemDistanceX = abs(item.currentPOS.x - held_item.position.x)
		var itemDistanceY = abs(item.currentPOS.y - held_item.position.y)
		
		if ((itemDistanceX < Game.held_item_throw_distance and itemDistanceY < Game.held_item_throw_distance)):
			held_item.move_and_collide(held_item.transform.x * Game.held_item_throw_speed * delta)
		else:
			stopThrow()
	
func startThrow(sceneReparent):
	item.drop(player,player_inventory)
	item.isThrowing = true
	set_physics_process(true)
	
func stopThrow():
	item.isThrowing = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if (item.isThrowing):
		throwingHeldItem(self,delta)
