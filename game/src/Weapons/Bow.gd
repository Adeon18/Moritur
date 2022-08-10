extends RangedWeapon

class_name Bow


func get_name():
	return "Bow"



func _ready():
	SpriteImg.frame = Constants.BOW_SPRITES[Global.projectile_type]
	is_piercing = true
	damage_multiplier = 1
	size_multiplier = 1
	delay_decrease = 1
	speed_multiplier = 1

func change_style(type):
	SpriteImg = get_node("Sprite")
	SpriteImg.frame = Constants.BOW_SPRITES[type]
