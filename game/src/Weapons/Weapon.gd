extends Area2D

class_name Weapon


var AnimPlayer
var ShotCooldownTimer

onready var Cavoon = preload("res://src/Projectiles/Cavoon.tscn")


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true



func use(direction, speed):
	AnimPlayer.play("use")
	create_projectile(direction, speed)


func create_projectile(direction, speed):
	pass



