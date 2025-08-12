extends Panel
class_name ItemSlot

@export var SLOT_TYPE: Game.ITEM_TYPES = Game.ITEM_TYPES.Item
@export var WEAPON_SLOT_TYPE: Game.GUN_TYPES = Game.GUN_TYPES.None
@export var CONTAINER_ITEM:Item
var dragableItem:DragableItem

func clear():
	dragableItem = null
	for n in get_children():
		remove_child(n)

func update(item: Item):
	var dragableItemScene = preload("res://chars/inv/dragable_item.tscn")
	if (!item):
		clear()
	else:
		clear()
		dragableItem = dragableItemScene.instantiate()
		dragableItem.item = item
		dragableItem.slot = self
		add_child(dragableItem)
		print("CREATE DRAG ITEM",dragableItem.item.NAME)
