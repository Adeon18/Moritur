extends Weapon


class_name MeleeWeapon


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
	set_shenanigans(shenanigans)
	AnimPlayer.play("use")
