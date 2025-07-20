class_name Item
extends Node

var isPickuped = false
var isThrowing = false
var currentPOS:Vector2
var OBJECT:CharacterBody2D
@export var ITEM_NAME: String
@export var RARITY: Game.RARITIES
@export var IS_THROWABLE:bool = true
var ITEM_TYPE: String
