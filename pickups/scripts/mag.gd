class_name Mag
extends ThrowableItem

@onready var ITEM_TYPE:String = "Mag"
@onready var item: Item = $Item

@onready var magData = Game.mags[Game.RARITIES.keys()[self.item.RARITY]][self.item.ITEM_NAME]

@onready var HAND_HOLDING_OFFSET:Vector2 = Vector2(0,0)
@onready var currentAmmo = magData["AMMO_CAPACITY"]
