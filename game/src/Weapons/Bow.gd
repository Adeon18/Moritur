extends Weapon

class_name Bow

func _ready():
	SpriteImg = get_node("Sprite")
	is_piercing = true
	AnimPlayer = get_node("AnimationPlayer")


func create_projectile(direction, speed, damage, is_piercing, is_freezing, is_fire, is_poizon, type, scale_m):
	var cavoon = Cavoon.instance()
	get_node("../../.").add_child(cavoon)
	
	cavoon.global_position = global_position + 16 * direction
	cavoon.launch(name, direction, speed, damage, is_piercing, is_freezing, is_fire, is_poizon, type, scale_m)
