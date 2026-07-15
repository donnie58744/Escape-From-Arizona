@tool
extends MagProperties
class_name Mag

@export var currentAmmo:int

func setRandAmmo():
	currentAmmo = randi_range(currentAmmo,AMMO_CAPACITY)

func removeAmmo(amount:int):
	currentAmmo -= amount
