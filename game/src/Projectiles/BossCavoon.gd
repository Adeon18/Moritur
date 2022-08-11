extends Area2D


var _speed: int
var _direction: Vector2

var spiral: bool = false
var size_scale: int = false
var kill_mode: bool = false
var big_straight: bool = false
var chasing: bool = false
var chaseee: bool = false

var _type

var ang
onready var sprite = get_node("./Sprite")
onready var player = get_node("../Player")

func _ready():
	spiral = false
	kill_mode = false


func _physics_process(delta):
	position += _direction*_speed*delta
	if(kill_mode):
		change_dir(delta, 3)
	elif(spiral): 
		change_dir(delta, 0.8)
	elif(big_straight):
		change_dir(delta, 0)
	elif(chasing && chaseee):
		_direction = position.direction_to(player.position)
	rotation = position.angle_to(player.position) + 1.57


func change_dir(delta, rad):
	ang = _direction.angle()
	ang += rad*delta
	_direction.x = cos(ang)
	_direction.y = sin(ang)

func launch(direction: Vector2, speed: int, type, size_mul):
	scale.x *= size_mul * 2
	scale.y *= size_mul * 2
	if(type == "spiral"): 
		spiral = true
		sprite.frame = 19
		_type = "boss_spiral"
	elif(type == "kill"): 
		kill_mode = true
		sprite.frame = 20
		_type = "boss_kill"
	elif(type == "big_straight"):
		big_straight = true
		sprite.frame = 33
		sprite.rotation = direction.angle() + 1.57
		_type = "boss_big"
	elif(type == "chasing"):
		chasing = true
		sprite.frame = 31
		_type = "boss_chasing"
	_direction = direction
	_speed = speed


func _on_Cavoon_body_entered(body):
	if !body.is_in_group("Decoration"):
		die()



func _on_Timer_timeout():
	die()


func _on_ChasingTimer_timeout():
	chaseee = true


func _on_ChasingLifetime_timeout():
	if(chasing):
		die()


func _on_Cavoon_area_entered(area):
	if area.is_in_group("Swords"):
		die()


func die():
	$Hit.material.set_shader_param("color", Constants.ENEMY_PROJ_COLOR[_type])
	$Hit.emitting = true
	set_physics_process(false)
	$Sprite.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.9), "timeout")
	queue_free()

