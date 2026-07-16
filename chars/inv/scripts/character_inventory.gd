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

func canPutInSlotType(slot:ItemSlot, item:Item) -> bool:
	if not (slot and item):
		return false
	
	# Generic slots (backpack grid cells) accept anything
	if slot.SLOT_TYPE == Game.ITEM_TYPES.Item:
		return true

	# The item's own declared type must match what the slot expects
	if item.TYPE != slot.SLOT_TYPE:
		return false

	# Guns need one more check: Primary/Secondary vs Pistol slot
	if item is Gun:
		return slot.WEAPON_SLOT_TYPE == (item as Gun).GUN_TYPE

	return true
	
func getEquipSlotFor(item:Item) -> Game.EQUIP_SLOTS:
	match item.TYPE:
		Game.ITEM_TYPES.Gun:
			if (item as Gun).GUN_TYPE == Game.GUN_TYPES.MainWeapon:
				if primaryWeapon == null: return Game.EQUIP_SLOTS.Primary
				elif secondaryWeapon == null: return Game.EQUIP_SLOTS.Secondary
			elif (item as Gun).GUN_TYPE == Game.GUN_TYPES.Pistol:
				if pistol == null: return Game.EQUIP_SLOTS.Pistol
		Game.ITEM_TYPES.Backpack:
			if backpack == null: return Game.EQUIP_SLOTS.Backpack
	return Game.EQUIP_SLOTS.None	

func canEquip(item:Item) -> bool:
	return getEquipSlotFor(item) != Game.EQUIP_SLOTS.None
	
func canPickup(item:Item,itemContainer:ItemContainer)->bool:
	if (itemContainer):
		if (itemContainer.canAdd(itemContainer.CONTAINER_SIZE)):
			return true
	return false

func setItemSlotItem(item:Item) -> bool:
	var target := getEquipSlotFor(item)
	match target:
		Game.EQUIP_SLOTS.Primary: primaryWeapon = item
		Game.EQUIP_SLOTS.Secondary: secondaryWeapon = item
		Game.EQUIP_SLOTS.Pistol: pistol = item
		Game.EQUIP_SLOTS.Backpack: backpack = item
		Game.EQUIP_SLOTS.None: return false
	return true

func equipToItemSlot(player:Player)->bool:
	var pickupItem:PickupItem = player.characterPickupItem
	if (pickupItem != null):
		var item:Item = pickupItem.item
		if (setItemSlotItem(item)):
			player.character_data.pickupsInRange.remove_at(player.character_data.pickupsInRange.find(pickupItem))
			pickupItem.queue_free()
			return true
	return false
		
func pickup(player:Player, itemContainer:ItemContainer)->bool:
	var pickupItem:PickupItem = player.characterPickupItem
	if (pickupItem != null):
		var item:Item = pickupItem.item
		if (canPickup(item,itemContainer)):
			if(itemContainer.add(item,itemContainer.CONTAINER_SIZE,itemContainer.getEmptySlotNum())):
				player.character_data.pickupsInRange.remove_at(player.character_data.pickupsInRange.find(pickupItem))
				pickupItem.queue_free()
				return true
	return false

func drop(item:Item, level:Node2D, rightHand:CharacterHand):
	if (item):
		var pickupItemScene = preload("res://pickups/PickupItem.tscn")
		var pickupItem = pickupItemScene.instantiate()
		if (primaryWeapon == item): primaryWeapon = null
		elif (secondaryWeapon == item): secondaryWeapon = null
		elif (pistol == item): pistol = null
		rightHand.deEquip()
		pickupItem.item = item
		pickupItem.transform = rightHand.global_transform
		level.add_child(pickupItem)

func canAddToSlot(item:Item, slot:ItemSlot,itemContainer:ItemContainer)->bool:
	match slot.EQUIP_SLOT_TYPE:
		Game.EQUIP_SLOTS.Primary: return primaryWeapon == null
		Game.EQUIP_SLOTS.Secondary: return secondaryWeapon == null
		Game.EQUIP_SLOTS.Pistol: return pistol == null
		Game.EQUIP_SLOTS.TacticalRig: return tactialRig == null
		Game.EQUIP_SLOTS.Backpack: return backpack == null

	if (itemContainer != null and item != itemContainer):
		var couldAdd = itemContainer.canAdd(itemContainer.CONTAINER_SIZE)
		return couldAdd
	return false
	
func addToSlot(item:Item, slot:ItemSlot, itemContainer:ItemContainer):
	if not canAddToSlot(item, slot, itemContainer):
		return false
	match slot.EQUIP_SLOT_TYPE:
		Game.EQUIP_SLOTS.Primary: primaryWeapon = item
		Game.EQUIP_SLOTS.Secondary: secondaryWeapon = item
		Game.EQUIP_SLOTS.Pistol: pistol = item
		Game.EQUIP_SLOTS.TacticalRig: tactialRig = item
		Game.EQUIP_SLOTS.Backpack: backpack = item
		_:
			if itemContainer:
				itemContainer.add(item, itemContainer.CONTAINER_SIZE, slot.SLOT_NUM)
	return true

func remove(item:Item ,slot:ItemSlot, itemContainer:ItemContainer):
	match slot.EQUIP_SLOT_TYPE:
		Game.EQUIP_SLOTS.Primary: primaryWeapon = null
		Game.EQUIP_SLOTS.Secondary: secondaryWeapon = null
		Game.EQUIP_SLOTS.Pistol: pistol = null
		Game.EQUIP_SLOTS.TacticalRig: tactialRig = null
		Game.EQUIP_SLOTS.Backpack: backpack = null

	if (itemContainer):
		itemContainer.remove(item)
	slot.clear()
	
func canMoveItemToSlot(item: Item, targetSlot: ItemSlot) -> bool:
	if not canPutInSlotType(targetSlot, item):
		return false
	return canAddToSlot(item, targetSlot, targetSlot.CONTAINER_ITEM)

func moveItem(item:Item,toSlot:ItemSlot,fromSlot:ItemSlot):
	if not canMoveItemToSlot(item,toSlot):
		return false
	remove(item,fromSlot,fromSlot.CONTAINER_ITEM)
	addToSlot(item, toSlot, toSlot.CONTAINER_ITEM)
	return true
