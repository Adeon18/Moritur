extends RangedWeapon

class_name Bow


func _ready():
	is_piercing = true
	damage_multiplier = 1
	size_multiplier = 1
	delay_decrease = 1
	speed_multiplier = 1


func create_projectile(direction, speed, damage, is_piercing, shenanigans: Dictionary, type, scale_m):
	var cavoon = Cavoon.instance()
	get_node("../../.").add_child(cavoon)
	
	cavoon.global_position = global_position + 16 * direction
	cavoon.launch(name, direction, speed, damage, is_piercing, shenanigans, type, scale_m)
