extends Area2D


var _speed: int
var _damage: int
var _direction: Vector2

var _is_piercing: bool = false

var _shenanigans: Dictionary = {
	"freeze": false,
	"burn": false,
	"poizon": false,
}

var _type = "default"


onready var SpriteImg: Sprite = get_node("Sprite")


var sprites: Dictionary = {
	"Bow": {
		"default": 39,
		"freeze": 40,
		"poizon": 48,
		"burn": 46,
	},
	"WeakWand": {
		"default": 13,
		"freeze": 14,
		"poizon": 22,
		"burn": 19,
	},
	"StrongWand": {
		"default": 13,
		"freeze": 14,
		"poizon": 22,
		"burn": 19,
	},
	"MediumWand": {
		"default": 26,
		"freeze": 27,
		"poizon": 35,
		"burn": 32,
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
			shenanigans: Dictionary,
			type: String,
			scale_m: float):
	
	scale *= scale_m
	rotation_degrees = rad2deg(direction.angle()) + 90
	_speed = speed
	_damage = damage
	_direction = direction
	_is_piercing = is_piercing
	_shenanigans = shenanigans
	_type = type
	SpriteImg.frame = sprites[weapon_name][_type]


func hit(body):
	body.take_damage(_damage)
	
	for key in _shenanigans:
		if _shenanigans[key]:
			body.call_deferred(key, _damage)
	
	if !_is_piercing:
		die()


func die():
	$Hit.material.set_shader_param("color", Constants.PROJECTILE_COLOR[_type])
	$Hit.emitting = true
	set_physics_process(false)
	$Sprite.visible = false
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func _on_Cavoon_body_entered(body):
	if !_is_piercing:
		die()
