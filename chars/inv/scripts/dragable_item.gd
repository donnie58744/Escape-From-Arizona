extends Node2D
class_name DragableItem
@onready var item_sprite: TextureRect = $ItemSprite

var item:Item
var iconSize:Vector2

func _ready() -> void:
	update()

func update():
	item_sprite.texture = item.ICON
	item_sprite.size = iconSize
