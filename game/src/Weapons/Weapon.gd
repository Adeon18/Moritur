extends Area2D

class_name Weapon


var ShotCooldownTimer
var delay_decrease: = 1.0

onready var SpriteImg: Sprite = get_node("Sprite")
onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")
onready var Cavoon = preload("res://src/Projectiles/Cavoon.tscn")


func _ready():
	$ItemParticle.material.set_shader_param("color", Constants.PROJECTILE_COLOR[Global.projectile_type])


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true
	$ItemParticle.emitting = false
	AnimPlayer.play("idle")
	AnimPlayer.playback_speed = delay_decrease


func enable_pick_up_collision():
	$CollisionShape2D.disabled = false
	$ItemParticle.emitting = true
	AnimPlayer.play("float")



func use(direction,
		speed,
		damage,
		shenanigans,
		type: String,
		scale_m: float = 1.0):
	pass



func create_projectile(direction, speed, damage, is_piercing, shenanigans, type, scale_m):
	pass

func change_style(type):
	pass



