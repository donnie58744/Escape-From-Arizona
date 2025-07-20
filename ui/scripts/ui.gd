extends Node2D
@onready var pickup_label: Label = $PickupLabel
@onready var gun_info_label: Label = $GunInfoLabel

func _ready() -> void:
	pickup_label.hide()
	gun_info_label.hide()
	
func _process(delta: float) -> void:
	global_rotation = 0
