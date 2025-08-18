extends Sprite2D
class_name CharacterHand

var held_item:Item = null
var currentEquipSlot = null

#TODO RETURN USES MAGJIC NUMBERS!!! NO GOOD
func checkForMag(inventory:CharacterInventory)->Array:
	var hasTactialRig = inventory.tactialRig
	var hasBackpack = inventory.backpack

	if (hasTactialRig != null):
		for item in hasTactialRig:
			if (item is Mag):
				return [item]
	elif (hasBackpack != null):
		var backpack:Backpack = hasBackpack
		for item in backpack.items:
			if (item is Mag):
				return [item,backpack]
	return []
	
func reload(gun:Gun,currentScene,inventory:CharacterInventory):
	var checkMag = checkForMag(inventory)
	if (!checkMag.is_empty()):
		var mag:Mag = checkMag[0]
		var magContainer:ItemContainer = checkMag[1]
		if (gun.ITEM_REFRENCE in mag.COMPATABLE_GUNS and mag.ITEM_REFRENCE in gun.COMPATABLE_MAGS):
			print("Load")
			if (gun.loadedMag):
				var foundContainer:ItemContainer = inventory.findContainer()
				if (!foundContainer.add(gun.loadedMag,foundContainer.CONTAINER_SIZE,foundContainer.getEmptySlotNum())):
					inventory.drop(gun.loadedMag,currentScene,false,self)

			gun.loadedMag = mag
			magContainer.remove(mag)

func changeFireMode(gun:Gun):
	if (gun.CAN_AUTO_FIRE):
		gun.isAutoFireMode = !gun.isAutoFireMode

func shoot(gun:Gun, characterBody:CharacterBody2D):
	if (gun.loadedMag and gun.loadedMag.currentAmmo > 0):
		# Some Dumb math code to properly spawn bullet at muzzle
		var side_x = sign(cos(characterBody.rotation))
		var side_y = sign(sin(characterBody.rotation))
		var customOffset = Vector2(
			offset.x * abs(side_x),
			offset.y * side_y
		)
		#--------------------------------------------------------
		
		var bullet = gun.createBullet()
		bullet.position = global_position + customOffset.rotated(characterBody.rotation) + gun.ATTACHMENT_POINTS["Muzzle"].rotated(characterBody.rotation)
		bullet.rotation = characterBody.rotation
		gun.loadedMag.removeAmmo(1)
		get_tree().get_current_scene().add_child(bullet)

func equip(item:Item,equipSlotName:String,character:Character):
	currentEquipSlot = equipSlotName
	held_item = item
	update(item)
	if (item is Gun):
		offset = -item.ATTACHMENT_POINTS["PistolGrip"]

func deEquip():
	held_item = null
	update(null)

func update(heldItem:Item):
	if (heldItem):
		texture = heldItem.ICON
	else:
		texture = null
