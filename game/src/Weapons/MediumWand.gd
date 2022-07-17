extends RangedWeapon

class_name MediumWand


func _ready():
	init_data()

func init_data():
	SpriteImg.frame = Constants.WAND_SPRITES[name][_type]
	is_piercing = false
	damage_multiplier = 1
	size_multiplier = 0.8
	delay_decrease = 0.8
	speed_multiplier = 1.5


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true
	$ItemParticle.emitting = false
	AnimPlayer.play("idle")
	change_style(_type)


func change_style(type):
	SpriteImg.frame = Constants.WAND_SPRITES[name][type]
