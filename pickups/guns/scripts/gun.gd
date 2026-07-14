@tool
extends GunProperties
class_name Gun

@export var AMMO_TYPE:String
@export var FIRERATE:float
@export var CAN_AUTO_FIRE:bool

const BULLET = preload("res://pickups/bullets/bullet.tscn")

@export var isAutoFireMode = false
@export var loadedMag:Mag
@export var ATTACHMENT_POINTS:Dictionary = {"Muzzle":Vector2(), "PistolGrip":Vector2()}

# ------------------

func canFire() -> bool:
	if (!loadedMag): return false
	if (loadedMag.currentAmmo <= 0): return false
	return true

func createBullet() -> Area2D:
	# Create bullet, add it to root scene, play gun sound
	var bullet_instance = BULLET.instantiate()
	bullet_instance.gunName = NAME
	return bullet_instance

func shoot(player:Player, offset:Vector2):
	if (canFire()):
		var bullet = createBullet()
		var bulletPOS:Vector2 = player.global_position + offset.rotated(player.rotation) + ATTACHMENT_POINTS["Muzzle"].rotated(player.rotation)
		loadedMag.removeAmmo(1)
		BulletManager.spawn_bullet(bullet, bulletPOS, player.rotation)
