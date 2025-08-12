class_name PlayerQuickSlots
extends Control

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]
@onready var quick_slot_container: HBoxContainer = $"Panel/Quick Slot Container"
var uiQuickSlots = []

func setupQuickSlots():
	for slot:ColorRect in quick_slot_container.get_children():
		uiQuickSlots.append(slot)
		
func clearQuickSlot(quickSlotNum:int):
	var quickSlot = uiQuickSlots[quickSlotNum]
	for node in quickSlot.get_children():
		quickSlot.remove_child(node)
		
func _ready() -> void:
	setupQuickSlots()
