extends Weapon

class_name RangedWeapon


var is_piercing: bool = false


func use(direction,
		speed,
		damage,
		shenanigans,
		type: String,
		scale_m: int = 1):
	AnimPlayer.play("use")
	create_projectile(direction, speed, damage, is_piercing, shenanigans, type, scale_m)
