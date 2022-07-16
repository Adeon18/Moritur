extends Weapon




func _ready():
	AnimPlayer = get_node("AnimationPlayer")


func create_projectile(direction, speed):
	var cavoon = Cavoon.instance()
	get_node("../../.").add_child(cavoon)
	
	cavoon.global_position = global_position
	print(cavoon.global_position)
	cavoon.launch(direction, speed)
