extends Control

@onready var slot_grid_container: GridContainer = $GridContainer
@export var right_hand:CharacterHand
@export var character_inventory:CharacterInventory
@export var pockets: HBoxContainer
@export var backpack_item_container: ItemContainerUI
@export var slots: Array[ItemSlot]

var showInventory:bool = false
var draggingItem:DragableItem
var drag_offset
var slotMoveInto:ItemSlot

func _ready() -> void:
	visible = false
	update_slots()

func resetDrag(draggingItem:DragableItem):
	draggingItem.queue_free()
	draggingItem = null
	slotMoveInto = null

func connectDragSig(slot:ItemSlot):
	if (!slot.is_connected("gui_input",Callable(self, "slot_gui_input").bind(slot))):
		slot.connect("gui_input", Callable(self, "slot_gui_input").bind(slot))

func slot_gui_input(event: InputEvent, slot:ItemSlot):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.pressed):
			draggingItem = slot.dragableItem
			# Check if there is a dragableItem in slot
			if(draggingItem != null):
				drag_offset = get_global_mouse_position() - draggingItem.global_position
		# draggingItem Let Go
		else:
			if (draggingItem != null):
				# Move Item back to slot from where it was dragged from
				slot.update(draggingItem.item)
				# If the player has hovered over an empty item slot then move the draggingItem into that slot and change inventory pos
				if (slotMoveInto!=null):
					# Move into slot if the ITEM_TYPES match up
					if (character_inventory.canPutInSlotType(slotMoveInto,draggingItem)):
						if(character_inventory.canAdd(draggingItem.item,slotMoveInto,slotMoveInto.CONTAINER_ITEM)):
							character_inventory.remove(draggingItem.item,slot,slot.CONTAINER_ITEM)
							if (right_hand.held_item == draggingItem.item):
								right_hand.deEquip()
							draggingItem.slot.dragableItem = null
							slotMoveInto.update(draggingItem.item)
							character_inventory.canAdd(draggingItem.item,slotMoveInto,slotMoveInto.CONTAINER_ITEM,true)
						else:
							slot.update(draggingItem.item)
					else:
						print("WRONG SLOT TYPE")
				resetDrag(draggingItem)

	if (event is InputEventMouseMotion and draggingItem!=null):
		draggingItem.global_position = get_global_mouse_position() - drag_offset
		
		var hovered := get_viewport().gui_get_hovered_control()
		
		if hovered and hovered != self:
			# Check if hovered is a ItemSlot
			if hovered is ItemSlot:
				# Check if Hovered slot is empty
				if (hovered.dragableItem==null):
					slotMoveInto=hovered
			# If not an item slot then the player must be hovering over something it cant be put into
			else:
				slotMoveInto = null

func showHide():
	showInventory = !showInventory
	update_slots()
	self.visible = showInventory
	
func update_slots():
	var inventory:Dictionary = {
		"helmet":character_inventory.helmet,
		"facecover":character_inventory.facecover,
		"earpiece":character_inventory.earpiece,
		"tactialRig":character_inventory.tactialRig,
		"armband":character_inventory.armband,
		"bodyArmour":character_inventory.bodyArmour,
		"eyewear":character_inventory.eyewear,
		"primaryWeapon":character_inventory.primaryWeapon,
		"pistol":character_inventory.pistol,
		"secondaryWeapon":character_inventory.secondaryWeapon,
		"backpack":character_inventory.backpack
	}
	for i in range(min(inventory.keys().size(),slots.size())):
		var key = inventory.keys()[i]
		var item = inventory[key]
		slots[i].update(item)
	backpack_item_container.setup(inventory.backpack)
	if (character_inventory.backpack):
		print(character_inventory.backpack.items)
	
	# TODO MAKE A FUNCTION THAT CONNECTS ALL SLOTS
	for slot in slots:
		connectDragSig(slot)
	for slot in backpack_item_container.slots:
		connectDragSig(slot)
