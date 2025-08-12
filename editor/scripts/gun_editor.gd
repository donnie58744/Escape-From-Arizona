@tool
extends Node2D
@export var gun:Gun
@onready var item_sprite: Sprite2D = $ItemSprite
@export_tool_button("Save To Resource")
var save_resource_action: Callable
@export_tool_button("Update Gun Resource")
var update_action: Callable

func _ready():
	save_resource_action = Callable(self, "save_mount_points")
	update_action = Callable(self, "setup")
	setup()
	
func setup():
	item_sprite.texture = gun.ICON
	for child in get_children():
		if child is Marker2D:
			child.position = gun.ATTACHMENT_POINTS[child.name]
	
func save_mount_points():
	if not gun:
		push_error("No Gun resource assigned!")
		return

	for child in get_children():
		if child is Marker2D:
			gun.ATTACHMENT_POINTS[child.name] = child.position

	if gun.resource_path != "":
		ResourceSaver.save(gun, gun.resource_path)
		print("✅ Saved mount points:", gun.ATTACHMENT_POINTS)
	else:
		push_error("Gun resource has no saved path. Save it as a .tres first!")
