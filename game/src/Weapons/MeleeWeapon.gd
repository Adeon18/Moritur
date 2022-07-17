extends Weapon


class_name MeleeWeapon


var _damage


var shenanigans: Dictionary = {
	"freeze": false,
	"burn": false,
	"poizon": false,
}


func set_shenanigans(_shenanigans):
	shenanigans = _shenanigans


func use(direction,
		speed,
		damage,
		shenanigans,
		type: String,
		scale_m: int = 1):
	_damage = damage
	set_shenanigans(shenanigans)
	AnimPlayer.play("use")
