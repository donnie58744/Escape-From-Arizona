extends CharacterBaseStats
class_name Character

@export var inventory: CharacterInventory
var quickSlots:Array = [0,1,2,3,4,5,6,7,8,9]
var currentSpeed = WALKING_SPEED
var pickupsInRange:Array[PickupItem]
