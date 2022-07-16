extends Area2D

class_name Weapon


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
		shenanigans,
		type: String,
		scale_m: int = 1):
	pass



func create_projectile(direction, speed, damage, is_piercing, shenanigans, type, scale_m):
	pass



