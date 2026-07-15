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
var is_bursting: bool = false
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
	
func burstFire(hand: CharacterHand, offset: Vector2) -> void:
	var BURST_SIZE = 3
	if is_bursting:
		return
	if not canFire() or (Time.get_ticks_msec()/1000.0 - last_fire_time) < FIRERATE:
		return

	is_bursting = true
	var burstLeft = BURST_SIZE
	if loadedMag.currentAmmo - BURST_SIZE < 0:
		burstLeft = loadedMag.currentAmmo

	for i in range(burstLeft):
		_shoot(hand, offset)
		if i < burstLeft - 1:
			await hand.get_tree().create_timer(FIRERATE).timeout

	last_fire_time = Time.get_ticks_msec() / 1000.0
	is_bursting = false

func fire(hand: CharacterHand, offset: Vector2) -> void:
	var now := Time.get_ticks_msec() / 1000.0
	if canFire() and (now - last_fire_time) >= FIRERATE:
		_shoot(hand, offset)
		last_fire_time = now
		
func _shoot(hand: CharacterHand, offset: Vector2):
	var bullet = createBullet()
	var bulletPOS: Vector2 = hand.global_position + offset.rotated(hand.global_rotation) + ATTACHMENT_POINTS["Muzzle"].rotated(hand.global_rotation)
	loadedMag.removeAmmo(1)
	BulletManager.spawn_bullet(bullet, bulletPOS, hand.global_rotation)
	
