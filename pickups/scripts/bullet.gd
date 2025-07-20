extends Node2D
class_name Bullet

const SPEED:int = 860

var gunName:String = ""

@onready var player:Player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()
