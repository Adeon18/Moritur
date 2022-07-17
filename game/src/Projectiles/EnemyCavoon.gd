extends Area2D


var _speed: int
var _direction: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += _direction*_speed*delta

func launch(direction: Vector2, speed: int):
	_direction = direction
	_speed = speed


func _on_Cavoon_area_entered(area):
	pass
