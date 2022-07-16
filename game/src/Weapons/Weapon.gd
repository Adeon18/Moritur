extends Area2D

class_name Weapon


var is_piercing: bool = false


var SpriteImg
var AnimPlayer
var ShotCooldownTimer

onready var Cavoon = preload("res://src/Projectiles/Cavoon.tscn")


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true


func enable_pick_up_collision():
	$CollisionShape2D.disabled = false



func use(direction,
		speed,
		damage,
		type: String,
		scale_m: int = 1):
	AnimPlayer.play("use")
	create_projectile(direction, speed, damage, is_piercing, type, scale_m)


func create_projectile(direction, speed, damage, is_piercing, type, scale_m):
	pass



