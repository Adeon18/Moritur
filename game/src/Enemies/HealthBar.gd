extends Control


onready var health_bar = get_node("./TextureProgress")
onready var tween = get_node("./Tween")

func update_health(health, amount):
	tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.4, Tween.EASE_IN_OUT)
	tween.start()

func update_max_health(max_health):
	health_bar.max_value = max_health
