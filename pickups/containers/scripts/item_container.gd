extends ItemContainerProperties
class_name ItemContainer

@export var items:Array[Item]

func canAdd(containerSize:int)->bool:
	if (items.size() < containerSize):
		return true
	else:
		return false

func add(item:Item, containerSize:int):
	if (canAdd(containerSize)):
		items.append(item)

func remove(item:Item):
	items.remove_at(items.find(item))
