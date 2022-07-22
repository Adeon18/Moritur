extends MeleeWeapon




func _ready():
	SpriteImg = get_node("Sprite")
	SpriteImg.texture = load(Constants.SWORD_SPRITES[Global.projectile_type])
	AnimPlayer = get_node("AnimationPlayer")

	$HitDetector/CollisionShape2D.disabled = true


func change_style(type):
	SpriteImg = get_node("Sprite")
	SpriteImg.texture = load(Constants.SWORD_SPRITES[type])
	$SwingParticle.material.set_shader_param("color", Constants.PROJECTILE_COLOR[Global.projectile_type])
