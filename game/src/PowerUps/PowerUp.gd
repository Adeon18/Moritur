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
	"projectile_speed": {
		"image": "res://art/PowerUps/encrease_speed.png",
		"color": Color.darkred
	},
	"projectile_scale": {
		"image":"res://art/PowerUps/projectile_size.png" ,
		"color": Color.darkred
	},
	"shot_delay_time": {
		"image": "res://art/PowerUps/cd_reduction.png",
		"color": Color.lightcoral
	},
	"projectile_damage": {
		"image": "res://art/PowerUps/encrease_dmg.png",
		"color": Color.darkred
	},
}


func _ready():
	$Sprite.texture = load(types[_type].image)
	$ItemParticle.material.set_shader_param("color", types[_type].color)
	print($ItemParticle.material.get_shader_param("color"))
	$CUM.material.set_shader_param("color", types[_type].color)


func set_type(type):
	_type = type
	_ready()


func get_type():
	return _type

func die():
	Loader.save_global()
	$CUM.emitting = true
	$ItemParticle.emitting = false
	$AnimationPlayer.play("die")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
