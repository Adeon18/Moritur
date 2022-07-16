extends Weapon



func _ready():
	SpriteImg = get_node("Sprite")
	AnimPlayer = get_node("AnimationPlayer")
	$HitDetector/CollisionShape2D.disabled = true

