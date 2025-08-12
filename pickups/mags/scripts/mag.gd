extends MagProperties
class_name Mag

@export var currentAmmo:int

func setRandAmmo():
	currentAmmo = randi_range(currentAmmo,AMMO_CAPACITY)
	print("RAND",currentAmmo)

func removeAmmo(amount:int):
	currentAmmo -= amount
