@tool
extends Area2D
class_name PickupItem

@export var item:Item
@onready var item_sprite: Sprite2D = $ItemSprite
@export var randomizeVals:bool=false
@onready var player:Player = get_tree().get_nodes_in_group("player")[0]
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var playerInRange = false

func _ready() -> void:
	# Prevent editor for executing
	if (!Engine.is_editor_hint()):
		if (item!=null):
			item=item.duplicate(true)
		setRandVals(item)
	item_sprite.texture = item.ICON
	
func setRandVals(item:Item):
	if (randomizeVals):
		if (item is Mag):
			item.setRandAmmo()

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		playerInRange = true

func _on_body_exited(body: Node2D) -> void:
	if (body is Player):
		playerInRange = false

func mouseArea(isShow:bool):
	if (isShow and !player.inventory_ui.visible):
		if (playerInRange):
			player.interact_panel_ui.setup(player,item)
			if (self not in player.pickupsInRange):
				player.pickupsInRange.append(self)
		else:
			if(self in player.pickupsInRange):
				player.pickupsInRange.remove_at(player.pickupsInRange.find(self))
	else:
		if(self in player.pickupsInRange):
			player.pickupsInRange.remove_at(player.pickupsInRange.find(self))

func _process(delta):
	if (!is_queued_for_deletion() and !Engine.is_editor_hint()):
		var mouse_pos_local = to_local(get_global_mouse_position())
		var shape = collision_shape_2d.shape
		if shape is RectangleShape2D:
			if abs(mouse_pos_local.x) <= shape.extents.x and abs(mouse_pos_local.y) <= shape.extents.y:
				mouseArea(true)
			else:
				mouseArea(false)
		elif shape is CircleShape2D:
			if mouse_pos_local.length() <= shape.radius:
				mouseArea(true)
			else:
				mouseArea(false)
