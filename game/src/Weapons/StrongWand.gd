extends RangedWeapon

class_name StrongWand


func _ready():
	init_data()

func init_data():
	SpriteImg.frame = Constants.WAND_SPRITES[name][Global.projectile_type]
	is_piercing = false
	damage_multiplier = 2
	size_multiplier = 1.51
	delay_decrease = 3
	speed_multiplier = 0.5


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true
	$ItemParticle.emitting = false
	AnimPlayer.play("idle")
	change_style(_type)


func change_style(type):
	SpriteImg = get_node("Sprite")
	SpriteImg.frame = Constants.WAND_SPRITES[name][type]
