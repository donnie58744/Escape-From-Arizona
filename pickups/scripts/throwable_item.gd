class_name ThrowableItem
extends CharacterBody2D

@export var itemData: Item

func _ready() -> void:
	set_physics_process(false)

func throwingHeldItem(held_item:CharacterBody2D,delta):
	if (itemData.isThrowing):
		var itemDistanceX = abs(itemData.currentPOS.x - held_item.position.x)
		var itemDistanceY = abs(itemData.currentPOS.y - held_item.position.y)
		
		if ((itemDistanceX < Game.held_item_throw_distance and itemDistanceY < Game.held_item_throw_distance)):
			held_item.move_and_collide(held_item.transform.x * Game.held_item_throw_speed * delta)
		else:
			stopThrow()
	
func startThrow(throwPOS,sceneReparent):
	self.reparent(sceneReparent)
	print(throwPOS)
	self.itemData.currentPOS = throwPOS
	self.itemData.isPickuped = false
	self.itemData.isThrowing = true
	set_physics_process(true)
	
func stopThrow():
	itemData.isThrowing = false
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if (itemData.isThrowing):
		throwingHeldItem(self,delta)
