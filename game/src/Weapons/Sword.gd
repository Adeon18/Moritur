extends Weapon



func _ready():
	AnimPlayer = get_node("AnimationPlayer")
	
	var anim = AnimPlayer.get_animation("use")
	anim.track_set_key_value(0, 0, rotation_degrees)
	anim.track_set_key_value(0, 1, rotation_degrees-90)
	anim.track_set_key_value(0, 2, rotation_degrees)
	anim.track_set_key_value(0, 3, rotation_degrees+90)
	anim.track_set_key_value(0, 4, rotation_degrees)
