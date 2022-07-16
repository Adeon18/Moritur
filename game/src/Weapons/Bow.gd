extends Weapon



func _ready():
	SpriteImg = get_node("Sprite")
	is_piercing = true
	AnimPlayer = get_node("AnimationPlayer")


func create_projectile(direction, speed, damage, is_piercing, is_freezing, is_poizon, scale_m):
	var cavoon = Cavoon.instance()
	get_node("../../.").add_child(cavoon)
	
	cavoon.global_position = global_position
	cavoon.launch(direction, speed, damage, is_piercing, is_freezing, is_poizon, scale_m)
