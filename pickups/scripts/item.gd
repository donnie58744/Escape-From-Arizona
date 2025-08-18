@tool
extends Resource
class_name Item

@export var TYPE: Game.ITEM_TYPES = Game.ITEM_TYPES.Item:
	set(value):
		TYPE = value
		notify_property_list_changed()
@export var ITEM_REFRENCE:int
@export var ICON: CompressedTexture2D = preload("res://assets/missing_texture.jpg")
@export var NAME: String
@export var RARITY: Game.RARITIES
@export var HAND_HOLDING_OFFSET:Vector2 = Vector2(0,0)

func _validate_property(property: Dictionary) -> void:
	if property.name == "ITEM_REFRENCE":
		match TYPE:
			Game.ITEM_TYPES.Gun: property.hint = PROPERTY_HINT_ENUM; property.hint_string = ",".join(Game.GUNS.keys())
			Game.ITEM_TYPES.Mag: property.hint = PROPERTY_HINT_ENUM; property.hint_string = ",".join(Game.MAGS.keys())
			Game.ITEM_TYPES.Backpack: property.hint = PROPERTY_HINT_ENUM; property.hint_string = ",".join(Game.BACKPACKS.keys())
			Game.ITEM_TYPES.Item: property.usage |= PROPERTY_USAGE_READ_ONLY
