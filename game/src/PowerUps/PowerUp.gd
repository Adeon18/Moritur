extends Area2D


export var _type: String = "poizon"


var types: Dictionary = {
	"burn": "res://art/PowerUps/16x16_fire.png",
	"freeze": "res://art/PowerUps/16x16_ice.png",
	"poizon": "res://art/PowerUps/16x16_poison.png",
	"heal_up": "res://art/PowerUps/heal.png",
	"health_up": "res://art/PowerUps/health_up.png",
	"pspeed_increase": null,
	"size_multiplier": null,
	"delay_multilier": null,
	"damage_increase": null
}



func _ready():
	$Sprite.texture = load(types[_type])


func set_type(type):
	_type = type
	_ready()


func get_type():
	return _type

func die():
	queue_free()
