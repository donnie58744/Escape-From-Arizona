@tool
extends Area2D
class_name PickupItem

@export var item:Item
@onready var item_sprite: Sprite2D = $ItemSprite
@export var randomizeVals:bool=false

func _ready() -> void:
	if (item!=null):
		item=item.duplicate(true)
	item_sprite.texture = item.ICON
	setRandVals(item)
	
func setRandVals(item:Item):
	if (randomizeVals):
		if (item is Mag):
			print(item.currentAmmo)
			item.setRandAmmo()

func _on_body_entered(body: Node2D) -> void:
	print(item)
	if (body is Player):
		body.interact_panel_ui.setup(body,item,true)
		body.pickupsInRange.append(self)

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		body.interact_panel_ui.hide()
		body.pickupsInRange.remove_at(body.pickupsInRange.find(self))
