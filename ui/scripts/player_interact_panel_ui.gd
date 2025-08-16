extends PanelContainer
class_name PlayerInteractPanel
@onready var equip_label: Label = $VBoxContainer/EquipLabel
@onready var pickup_label: Label = $VBoxContainer/PickupLabel

func _ready() -> void:
	hide()
	equip_label.hide()
	pickup_label.hide()

func setup(player:Player,item:Item):
	if (player.inventory.canEquip(item)):
		var getKey = OS.get_keycode_string(InputMap.action_get_events("equip")[0].physical_keycode)
		equip_label.text = "Press " + "`" + getKey + "`" + " To Equip"
		equip_label.show()
		show()
	else:
		equip_label.hide()
	if (player.inventory.canPickup(item,player.inventory.findContainer())):
		var getKey = OS.get_keycode_string(InputMap.action_get_events("interact")[0].physical_keycode)
		pickup_label.text = "Press " + "`" + getKey+ "`" + " To Pickup"
		pickup_label.show()
		show()
	else:
		pickup_label.hide()
