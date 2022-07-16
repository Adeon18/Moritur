extends Enemy

func _init():
	speed = 20
	effective_fighting_distance = 100

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



func _on_Timer_timeout():
	update_path()




