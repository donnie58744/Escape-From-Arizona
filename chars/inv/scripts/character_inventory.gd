extends Resource
class_name CharacterInventory

@export var helmet: Item
@export var facecover: Item
@export var earpiece: Item
@export var tactialRig: ItemContainer
@export var armband: Item
@export var bodyArmour: Item
@export var eyewear: Item
@export var primaryWeapon: Gun
@export var pistol: Gun
@export var secondaryWeapon: Gun
@export var backpack: Backpack

func findContainer()->ItemContainer:
	if (backpack):
		return backpack
	return

func canPutInSlotType(slot:ItemSlot,draggableItem:DragableItem)->bool:
	if (slot and draggableItem):
		# TODO ADD EQUIPABLE TO ITEM DATA AND FIX IF STATMENT
		# Check if equippable item
		if (slot.SLOT_TYPE != Game.ITEM_TYPES.Item):
			if (draggableItem.item is Gun):
				if (slot.SLOT_TYPE == Game.ITEM_TYPES.Gun):
					if (slot.WEAPON_SLOT_TYPE == (draggableItem.item as Gun).GUN_TYPE):
						return true
			elif (draggableItem.item is Backpack):
				if (slot.SLOT_TYPE == Game.ITEM_TYPES.Backpack):
					return true
		else:
			return true
	return false
	
# TODO MAKE THIS FUNCTION BETTER? REMOVE DO VAR
func canEquip(item:Item, do:bool=false) -> bool:
	match item.TYPE:
		Game.ITEM_TYPES.Gun:
			if ((item as Gun).GUN_TYPE == Game.GUN_TYPES.MainWeapon):
				print("EQUIPPPP")
				if(primaryWeapon==null):
					if (do): primaryWeapon = item
					return true
				elif(secondaryWeapon==null):
					if (do): secondaryWeapon = item
					return true
			elif ((item as Gun).GUN_TYPE == Game.GUN_TYPES.Pistol):
				if (pistol==null):
					if (do): pistol = item
					return true
		Game.ITEM_TYPES.Backpack:
			if(backpack==null):
				if (do): backpack=item
				return true
	return false
	
func canPickup(item:Item,itemContainer:ItemContainer)->bool:
	if (itemContainer):
		if (itemContainer.canAdd(itemContainer.CONTAINER_SIZE)):
			return true
	return false

func equip(player:Player, pickupItem:PickupItem)->bool:
	var item:Item = pickupItem.item
	if (canEquip(item,true)):
		player.character_data.pickupsInRange.remove_at(player.character_data.pickupsInRange.find(pickupItem))
		pickupItem.queue_free()
		return true
	return false
		
func pickup(player:Player, pickupItem:PickupItem, itemContainer:ItemContainer)->bool:
	var item:Item = pickupItem.item
	if (canPickup(item,itemContainer)):
		if(itemContainer.add(item,itemContainer.CONTAINER_SIZE,itemContainer.getEmptySlotNum())):
			player.character_data.pickupsInRange.remove_at(player.character_data.pickupsInRange.find(pickupItem))
			pickupItem.queue_free()
			return true
	return false

# TODO MAKE THIS BETTER DONT BE CHECKING STRINGS USE ENUM
func drop(item:Item, level:Node2D, held:bool, rightHand:CharacterHand):
	var pickupItemScene = preload("res://pickups/PickupItem.tscn")
	var pickupItem = pickupItemScene.instantiate()
	if (held):
		if (rightHand.currentEquipSlot == "Primary"):
			primaryWeapon = null
		elif (rightHand.currentEquipSlot == "Secondary"):
			secondaryWeapon = null
		elif (rightHand.currentEquipSlot == "Pistol"):
			pistol = null
	rightHand.deEquip()
	pickupItem.item = item
	pickupItem.transform = rightHand.global_transform
	level.add_child(pickupItem)

# TODO MAKE THIS FUNCTION BETTER? REMOVE DO VAR AND DONT BE CHECKING STRINGS USE ENUM
func canAdd(item:Item, slot:ItemSlot,itemContainer:ItemContainer, do:bool=false)->bool:
	if (slot.name == "PrimaryWeaponSlot"):
		if (do): primaryWeapon = item
		return true
	elif (slot.name == "SecondaryWeaponSlot"):
		if (do): secondaryWeapon = item
		return true
	elif (slot.name == "PistolSlot"):
		if (do): pistol = item
		return true
	elif (slot.name == "TactialRigSlot"):
		if (do):tactialRig = item
		return true
	elif (slot.name == "BackpackSlot"):
		if (do):backpack = item
		return true
	if (itemContainer != null and item != itemContainer):
		if (do):itemContainer.add(item,itemContainer.CONTAINER_SIZE,slot.SLOT_NUM)
		if(itemContainer.canAdd(itemContainer.CONTAINER_SIZE)):
			return true
	return false

#TODO MAKE BETTER DONT BE USING STRINGS USE ENUM
func remove(item:Item ,slot:ItemSlot, itemContainer:ItemContainer):
	if (slot.name == "PrimaryWeaponSlot"):
		primaryWeapon = null
	elif (slot.name == "SecondaryWeaponSlot"):
		secondaryWeapon = null
	elif (slot.name == "PistolSlot"):
		pistol = null
	elif (slot.name == "TactialRigSlot"):
		tactialRig = null
	elif (slot.name == "BackpackSlot"):
		backpack = null
	if (itemContainer):
		itemContainer.remove(item)
	slot.clear()
