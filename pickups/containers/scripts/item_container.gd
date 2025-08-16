extends ItemContainerProperties
class_name ItemContainer

@export var items:Array[Item]
var itemSlotPosistions:Dictionary = {} # Resource:slotnum

# This is for if the container was given items in the editor it will update the container dict
func setupItemSlotPosistions():
	for item in items:
		if (!itemSlotPosistions.has(item)):
			itemSlotPosistions[item]=getEmptySlotNum()

func getEmptySlotNum()->int:
	var takenSlotNums = []
	for slotNum in itemSlotPosistions.values():
		takenSlotNums.append(slotNum)
	for number in range(0,CONTAINER_SIZE):
		if (number not in takenSlotNums):
			return number
	return -1

func canAdd(containerSize:int)->bool:
	if (items.size() < containerSize):
		return true
	return false

func add(item:Item, containerSize:int,slotNum:int)->bool:
	if (canAdd(containerSize) and item != self):
		items.append(item)
		itemSlotPosistions[item]=slotNum
		print(itemSlotPosistions)
		return true
	return false

func remove(item:Item):
	items.remove_at(items.find(item))
	itemSlotPosistions.erase(item)
