extends Sprite2D
class_name CharacterHand

var held_item:Item = null

#TODO RETURN USES MAGJIC NUMBERS!!! NO GOOD!
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
	if (held_item is Gun):
		var checkMag = checkForMag(inventory)
		if (!checkMag.is_empty()):
			var mag:Mag = checkMag[0]
			var magContainer:ItemContainer = checkMag[1]
			if (gun.ITEM_REFRENCE in mag.COMPATABLE_GUNS and mag.ITEM_REFRENCE in gun.COMPATABLE_MAGS):
				if (gun.loadedMag):
					var foundContainer:ItemContainer = inventory.findContainer()
					if (!foundContainer.add(gun.loadedMag,foundContainer.CONTAINER_SIZE,foundContainer.getEmptySlotNum())):
						inventory.drop(gun.loadedMag,currentScene,self)

				gun.loadedMag = mag
				magContainer.remove(mag)

func fire(player:Player, burst:bool=false):
	if not (held_item is Gun):
		return
		
	var gun: Gun = held_item
	# Some Dumb math code to properly spawn bullet at muzzle
	var side_x = sign(cos(player.rotation))
	var side_y = sign(sin(player.rotation))
	var customOffset = Vector2(
		offset.x * abs(side_x),
		offset.y * side_y
	)
	#--------------------------------------------------------
	if (burst): gun.burstFire(self, customOffset)
	else: gun.fire(self, customOffset)

func equipFromItemSlot(item:Item, gunInfoUI:Panel):
	if (item != null): 
		held_item = item
		update(item)
		if (item is Gun):
			offset = -item.ATTACHMENT_POINTS["PistolGrip"]
		gunInfoUI.update(item)
		return true
	return false

func deEquip():
	held_item = null
	update(null)

func update(heldItem:Item):
	if (heldItem):
		texture = heldItem.ICON
	else:
		texture = null
