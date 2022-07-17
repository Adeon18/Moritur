extends Area2D


var _speed: int
var _direction: Vector2

var spiral: bool = false
var size_scale: int = false
var kill_mode: bool = false
var big_straight: bool = false

var ang
onready var sprite = get_node("./Sprite")


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
	elif(type == "kill"): 
		kill_mode = true
		sprite.frame = 20
	elif(type == "big_straight"):
		big_straight = true
		sprite.frame = 33
		sprite.rotation = direction.angle() + 1.57
	_direction = direction
	_speed = speed


func _on_Cavoon_body_entered(body):
	if(body.get_collision_layer() == 9):
		queue_free()



func _on_Timer_timeout():
	queue_free()
