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
		else:
			return true
	return false
	
# TODO MAKE THIS FUNCTION BETTER? REMOVE DO VAR
func canEquip(item:Item, do:bool=false) -> bool:
	match item.TYPE:
		Game.ITEM_TYPES.Gun:
			if ((item as Gun).GUN_TYPE == Game.GUN_TYPES.MainWeapon):
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
		player.pickupsInRange.remove_at(player.pickupsInRange.find(pickupItem))
		pickupItem.queue_free()
		return true
	return false
		
func pickup(player:Player, pickupItem:PickupItem, itemContainer:ItemContainer)->bool:
	var item:Item = pickupItem.item
	if (canPickup(item,itemContainer)):
		if(itemContainer.add(item,itemContainer.CONTAINER_SIZE,itemContainer.getEmptySlotNum())):
			player.pickupsInRange.remove_at(player.pickupsInRange.find(pickupItem))
			pickupItem.queue_free()
			return true
	return false

# TODO MAKE THIS BETTER DONT BE CHECKING STRINGS USE ENUM
func drop(item:Item, player:Player, level:Node2D, held:bool):
	var pickupItemScene = preload("res://pickups/PickupItem.tscn")
	var pickupItem = pickupItemScene.instantiate()
	if (held):
		if (player.currentEquipSlot == "Primary"):
			primaryWeapon = null
		elif (player.currentEquipSlot == "Secondary"):
			secondaryWeapon = null
		elif (player.currentEquipSlot == "Pistol"):
			pistol = null
		player.held_item = null
		player.right_hand.texture = null
	pickupItem.item = item
	pickupItem.transform = player.right_hand.global_transform
	level.add_child(pickupItem)

#TODO MAKE BETTER DONT BE USING STRINGS USE ENUM
func add(item:Item, slot:ItemSlot,itemContainer:ItemContainer)->bool:
	print(item,itemContainer)
	if (slot.name == "PrimaryWeaponSlot"):
		primaryWeapon = item
		return true
	elif (slot.name == "SecondaryWeaponSlot"):
		secondaryWeapon = item
		return true
	elif (slot.name == "PistolSlot"):
		pistol = item
		return true
	if (itemContainer != null and item != itemContainer):
		print(item,itemContainer)
		print("ASDASD")
		if(itemContainer.add(item,itemContainer.CONTAINER_SIZE,slot.SLOT_NUM)):
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
	if (itemContainer):
		itemContainer.remove(item)
	slot.clear()
