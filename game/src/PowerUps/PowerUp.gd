extends Area2D


export var _type: String = "poizon"


var types: Dictionary = {
	"burn": {
		"image": "res://art/PowerUps/16x16_fire.png",
		"color": Color.orangered
	},
	"freeze": {
		"image": "res://art/PowerUps/16x16_ice.png",
		"color": Color.skyblue
	},
	"poizon": {
		"image":"res://art/PowerUps/16x16_poison.png" ,
		"color": Color.green
	},
	"heal_up": {
		"image": "res://art/PowerUps/heal.png",
		"color": Color.red
	},
	"health_up": {
		"image": "res://art/PowerUps/health_up.png",
		"color": Color.red
	},
	"pspeed_increase": {
		"image": null,
		"color": Color.orangered
	},
	"size_multiplier": {
		"image": null,
		"color": Color.orangered
	},
	"delay_multilier": {
		"image": null,
		"color": Color.orangered
	},
	"damage_increase": {
		"image": null,
		"color": Color.orangered
	},
}


func _ready():
	$Sprite.texture = load(types[_type].image)


func set_type(type):
	_type = type
	_ready()


func get_type():
	return _type

func die():
	$CUM.emitting = true
	$ItemParticle.emitting = false
	$AnimationPlayer.play("die")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
