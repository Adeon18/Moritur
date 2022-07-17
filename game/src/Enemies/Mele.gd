extends Enemy

func _init():
	speed = 50
	effective_fighting_distance = 20

func _ready():
	Statemachine = get_node("AnimationTree").get("parameters/playback")


func handle_fight():
	if(!is_hitting):
		Statemachine.travel("hit")
		movable = false
		is_hitting = true
	else:
		Statemachine.travel("run")
		movable = true


