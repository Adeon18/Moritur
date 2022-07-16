extends Area2D


var _speed: int
var _damage: int
var _direction: Vector2

var _is_piercing: bool = false
var _type = "default"


onready var SpriteImg: Sprite = get_node("Sprite")


var sprites: Dictionary = {
	"Bow": {
		"default": 39,
		"freeze": 40,
		"poizon": 48
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += _direction*_speed*delta


func launch(weapon_name: String,
			direction: Vector2,
			speed: int,
			damage: int,
			is_piercing: bool,
			type: String,
			scale_m: int):
	
	scale *= scale_m
	rotation_degrees = rad2deg(direction.angle()) + 90
	_speed = speed
	_damage = damage
	_direction = direction
	_is_piercing = is_piercing
	_type = type
	SpriteImg.frame = sprites[weapon_name][_type]
