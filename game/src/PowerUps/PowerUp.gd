extends Area2D


var _type: String = "poizon"


var types: Dictionary = {
	"fire": "res://art/PowerUps/16x16_fire.png",
	"ice": "res://art/PowerUps/16x16_ice.png",
	"poizon": "res://art/PowerUps/16x16_poison.png",
	"heal_up": "res://art/PowerUps/heal.png",
	"health_up": "res://art/PowerUps/health_up.png",
}


func _init(type):
	_type = type


func _ready():
	$Sprite.texture = load(types[_type])


