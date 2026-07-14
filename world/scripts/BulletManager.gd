extends Node

func spawn_bullet(bullet: Area2D, pos: Vector2, rot: float):
	bullet.global_position = pos
	bullet.rotation = rot
	add_child(bullet)
