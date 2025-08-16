extends GridContainer
class_name ItemContainerUI
var slots:Array[ItemSlot]

func clearSlots():
	for n:ItemSlot in get_children():
		n.queue_free()
	slots.clear()

func setup(itemContainer:ItemContainer):
	# Runs when player inventory is open
	clearSlots()
	if (itemContainer):
		itemContainer.setupItemSlotPosistions()
		addSlots(itemContainer)
		updateSlots(itemContainer)

func updateSlots(itemContainer:ItemContainer):
	var containerContents:Array = itemContainer.items
	for i in range(min(containerContents.size(),slots.size())):
		var item:Item = containerContents[i]
		var slot:ItemSlot
		var slotNum:int = itemContainer.itemSlotPosistions[item]
		
		slot = slots[slotNum]
		slot.update(item)

func addSlots(itemContainer:ItemContainer):
	var CONTAINER_SIZE:int = itemContainer.CONTAINER_SIZE
	if (slots.size() != CONTAINER_SIZE):
		for i in CONTAINER_SIZE:
			var slotScene = preload("res://ui/ItemSlot.tscn")
			var slot = slotScene.instantiate()
			slot.CONTAINER_ITEM = itemContainer
			slot.SLOT_NUM = i
			slots.append(slot)
			add_child(slot)
