class_name Gun
extends ThrowableItem

const BULLET = preload("res://pickups/bullets/bullet.tscn")

var isAutoFireMode = false
var loadedMag:Mag = null

# USE itema for these vars
@onready var ITEM_TYPE:String = "Gun"
@onready var item: Item = $Item
# ------------------

@onready var gunData = Game.guns[Game.RARITIES.keys()[self.item.RARITY]][self.item.ITEM_NAME]

@onready var AMMO_TYPE:String = self.gunData["AMMO_TYPE"]
@onready var FIRERATE:float = self.gunData["FIRERATE"]
@onready var CAN_AUTO_FIRE:bool = self.gunData["CAN_AUTO_FIRE"]
@onready var HAND_HOLDING_OFFSET = self.gunData["HAND_HOLDING_OFFSET"]

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]

# Scene Items
@onready var muzzle: Marker2D = $Muzzle
@onready var shotSound: AudioStreamPlayer = $Shot
@onready var fire_rate_timer: Timer = $FireRateTimer

func createBullet():
	# Create bullet, add it to root scene, play gun sound
	var bullet_instance = BULLET.instantiate()
	bullet_instance.gunName = self.item.ITEM_NAME
	get_tree().root.add_child(bullet_instance)
	shotSound.play()
	bullet_instance.global_position = muzzle.global_position
	bullet_instance.rotation = player.rotation
	
func setupGunInfoPlayer():
	player.ammoTypeLabel.text = AMMO_TYPE
	if (loadedMag):
		player.currentAmmoLabel.text = str(loadedMag.currentAmmo) + "/" + str(loadedMag.magData["AMMO_CAPACITY"])
	else:
		player.currentAmmoLabel.text = "0/0"
	if (isAutoFireMode):
		player.firerateInfoLabel.text = "Auto"
	else:
		player.firerateInfoLabel.text = "Single"
		
func changeFireMode():
	if (CAN_AUTO_FIRE):
		isAutoFireMode = !isAutoFireMode

func shootBullet():
	if (fire_rate_timer.is_stopped() and loadedMag):
		if (loadedMag.currentAmmo > 0):
			createBullet()
			loadedMag.currentAmmo -= 1
			fire_rate_timer.start(FIRERATE)
		
func reload():
	for item:Node2D in player.inventory:
		if (item is Mag):
			var mag:Mag = item
			var itemRarity=Game.RARITIES.keys()[mag.item.RARITY]
			var itemName = mag.item.ITEM_NAME
			var compatableWeapons = Game.mags[itemRarity][itemName]["COMPATABLE_WEAPONS"]
			for compatableWeapon in compatableWeapons:
				if (compatableWeapon == self.item.ITEM_NAME):
					print("LOAD!")
					
					if (loadedMag):
						if (!player.addToInventory(loadedMag)):
							player.dropItem(loadedMag)

					loadedMag = mag
					# Move Mag into gun so remove it from the inventory
					
					player.removeFromInventory(loadedMag)
					
					setupGunInfoPlayer()
			break

func _process(delta: float) -> void:
	if (self.item.isPickuped):
		if(isAutoFireMode and Input.is_action_pressed("fire")):
			shootBullet()
		if (!isAutoFireMode and Input.is_action_just_pressed("fire")):
			shootBullet()
		if (Input.is_action_just_pressed("fire mode")):
			changeFireMode()
		if (Input.is_action_just_pressed("reload")):
			reload()
