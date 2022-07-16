extends Area2D

class_name Weapon

var shot_delay_time: float = 0.5

var AnimPlayer


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true


func use():
	AnimPlayer.play("use")
	create_projectile()

func create_projectile():
	pass
