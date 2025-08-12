extends Resource
class_name Item

@export var TYPE: Game.ITEM_TYPES
@export var ICON: CompressedTexture2D = preload("res://assets/missing_texture.jpg")
@export var NAME: String
@export var RARITY: Game.RARITIES
@export var HAND_HOLDING_OFFSET:Vector2 = Vector2(0,0)
