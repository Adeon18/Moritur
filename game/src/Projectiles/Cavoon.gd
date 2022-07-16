extends Area2D


var _speed: int
var _damage: int
var _direction: Vector2

var _is_piercing: bool = false
var _is_freezing: bool = false
var _is_poizon: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += _direction*_speed*delta


func launch(direction: Vector2,
			speed: int,
			damage: int,
			is_piercing: bool,
			is_freezing: bool,
			is_poizon: bool,
			scale_m: int):
	scale *= scale_m
	_speed = speed
	_damage = damage
	_direction = direction
	_is_piercing = is_piercing
	_is_freezing = is_freezing
	_is_poizon = is_poizon
