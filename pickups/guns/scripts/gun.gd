@tool
extends GunProperties
class_name Gun

enum FIRE_MODES { SEMI, AUTO, BURST }

@export var AMMO_TYPE:String
@export var FIRERATE:float

const BULLET = preload("res://pickups/bullets/bullet.tscn")

@export var available_fire_modes: Array[FIRE_MODES] = [FIRE_MODES.SEMI, FIRE_MODES.AUTO]
@export var fire_mode: FIRE_MODES = FIRE_MODES.SEMI
@export var loadedMag:Mag
@export var ATTACHMENT_POINTS:Dictionary = {"Muzzle":Vector2(), "PistolGrip":Vector2()}

var last_fire_time: float = 0.0
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

func cycleFireMode() -> void:
	var idx := available_fire_modes.find(fire_mode)
	idx = (idx + 1) % available_fire_modes.size()
	fire_mode = available_fire_modes[idx]

func fire(hand: CharacterHand, offset: Vector2) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	if canFire() and (now - last_fire_time) >= FIRERATE:
		var bullet = createBullet()
		var bulletPOS: Vector2 = hand.global_position + offset.rotated(hand.global_rotation) + ATTACHMENT_POINTS["Muzzle"].rotated(hand.global_rotation)
		loadedMag.removeAmmo(1)
		BulletManager.spawn_bullet(bullet, bulletPOS, hand.global_rotation)
		last_fire_time = now
