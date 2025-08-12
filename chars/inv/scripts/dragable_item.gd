extends Node2D
class_name DragableItem
@onready var item_sprite: TextureRect = $ItemSprite

var item:Item
var slot:ItemSlot

func _ready() -> void:
	item_sprite.texture = item.ICON
	item_sprite.size = slot.custom_minimum_size
