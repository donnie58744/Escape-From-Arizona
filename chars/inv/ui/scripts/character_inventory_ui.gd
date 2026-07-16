extends Control

@onready var slot_grid_container: GridContainer = $GridContainer
@export var right_hand:CharacterHand
@export var character_inventory:CharacterInventory
@export var pockets: HBoxContainer
@export var backpack_item_container: ItemContainerUI
@export var slots: Array[ItemSlot]

var showInventory:bool = false
var slotMoveInto:ItemSlot

class DragState:
	var dragging_item: DragableItem = null
	var item: Item = null
	var offset: Vector2 = Vector2.ZERO
	var target_slot: ItemSlot = null

	func is_active() -> bool:
		return item != null

	func clear() -> void:
		if item != null:
			dragging_item.queue_free()
		dragging_item = null
		item = null
		target_slot = null
var drag := DragState.new()

func _ready() -> void:
	visible = false
	update_slots()

func connectDragSig(slot:ItemSlot):
	if (!slot.is_connected("gui_input",Callable(self, "slot_gui_input").bind(slot))):
		slot.connect("gui_input", Callable(self, "slot_gui_input").bind(slot))

func slot_gui_input(event: InputEvent, itemSlot:ItemSlot):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (event.pressed):
			drag.dragging_item = itemSlot.dragableItem
			drag.item = drag.dragging_item.item
			
			if(drag.is_active()):
				drag.offset = get_global_mouse_position() - drag.dragging_item.global_position
		else: # draggingItem Let Go
			if (drag.is_active()):
				# Move into slot
				if(character_inventory.moveItem(drag.item, slotMoveInto, itemSlot)):
						if (right_hand.held_item == drag.item):
							right_hand.deEquip()
						
						slotMoveInto.update(drag.item)
				else:
					# Move Item back to slot from where it was dragged from
					itemSlot.update(drag.item)
				drag.clear()

	if (event is InputEventMouseMotion and drag.dragging_item!=null):
		drag.dragging_item.global_position = get_global_mouse_position() - drag.offset
		
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
