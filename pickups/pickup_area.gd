extends Area2D
class_name PickupArea

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]

var getInteractKey = OS.get_keycode_string(InputMap.action_get_events("interact")[0].physical_keycode)

func uiElements():
	if (player.held_item == null):
		if (player.pickupsInRange.size() > 0):
			player.pickup_label.text = "Press " + "'" + str(getInteractKey) + "'" + " to Pickup"
			player.pickup_label.show()
		else:
			player.pickup_label.hide()
	else:
		player.pickup_label.hide()

func _process(delta: float) -> void:
	uiElements()

func playerInRange(area, pickupItem):
	if (area.get_parent().name == "Player" and !pickupItem.itemData.isPickuped):
		player.pickupsInRange.append(pickupItem)

func playerOutRange(area, pickupItem):
	if (area.get_parent().name == "Player"):
		player.pickupsInRange.remove_at(player.pickupsInRange.find(pickupItem))
		
func stopThrowing(body, pickupItem):
	if (body.name != "Player" and !pickupItem.itemData.isPickuped):
		pickupItem.itemData.isThrowing = false
		player.held_item = null

func _on_area_entered(area: Area2D) -> void:
	var pickupItem = get_parent()
	print(pickupItem)
	playerInRange(area, pickupItem)

func _on_area_exited(area: Area2D) -> void:
	var pickupItem = get_parent()
	playerOutRange(area, pickupItem)

func _on_body_entered(body: Node2D) -> void:
	var pickupItem = get_parent()
	stopThrowing(body, pickupItem)
