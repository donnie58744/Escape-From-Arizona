class_name Mag
extends CharacterBody2D

@onready var itemData = Item.new()
@export var MAG_NAME:String
@onready var magData = Game.mags[self.MAG_NAME]
@onready var ITEM_TYPE:String = "Mag"
@onready var HAND_HOLDING_OFFSET:Vector2 = Vector2(0,0)
