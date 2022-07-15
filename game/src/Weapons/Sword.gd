extends Area2D

var is_picked_up: bool = false


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true
