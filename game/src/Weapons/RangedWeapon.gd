extends Weapon

class_name RangedWeapon

var _type: = "default"

var is_piercing: bool = false
var damage_multiplier: float = 1
var size_multiplier: float = 1.0

var speed_multiplier: float = 1.0


func use(direction,
		speed:float,
		damage,
		shenanigans,
		type: String,
		scale_m: float = 1.0):
	AnimPlayer.play("use")
	_type = type
	create_projectile(direction,
		speed*speed_multiplier,
		damage*damage_multiplier,
		is_piercing,
		shenanigans,
		type,
		scale_m*size_multiplier)



func create_projectile(direction, speed, damage, is_piercing, shenanigans: Dictionary, type, scale_m):
	var cavoon = Cavoon.instance()
	get_node("../../../.").add_child(cavoon)
	
	cavoon.global_position = global_position + 16 * direction
	cavoon.launch(name, direction, speed, damage, is_piercing, shenanigans, type, scale_m)

