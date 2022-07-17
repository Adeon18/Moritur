extends Weapon


class_name MeleeWeapon


var damage


var shenanigans: Dictionary = {
	"freeze": false,
	"burn": false,
	"poizon": false,
}


func set_shenanigans(_shenanigans):
	shenanigans = _shenanigans


func use(direction,
		speed,
		_damage,
		shenanigans,
		type: String,
		scale_m: float = 1.0):
	damage = _damage
	set_shenanigans(shenanigans)
	AnimPlayer.play("use")

