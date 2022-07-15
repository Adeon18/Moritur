extends Enemy

func _init():
	speed = 40

func _ready():
	Statemachine = get_node("AnimationTree").get("parameters/playback")


func handle_fight():
	print("AAA")
