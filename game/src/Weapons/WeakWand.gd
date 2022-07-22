extends RangedWeapon

class_name WeakWand


func _ready():
	init_data()

func init_data():
	SpriteImg.frame = Constants.WAND_SPRITES[name][_type]
	is_piercing = false
	damage_multiplier = 0.4
	size_multiplier = 0.4
	delay_decrease = 0.5
	speed_multiplier = 3


func disable_pick_up_collision():
	$CollisionShape2D.disabled = true
	$ItemParticle.emitting = false
	AnimPlayer.play("idle")



func change_style(type):
	SpriteImg = get_node("Sprite")
	SpriteImg.frame = Constants.WAND_SPRITES[name][type]
