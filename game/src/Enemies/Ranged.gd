extends Enemy

func _init():
	speed = 80
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


func shoot():
	var projectile = Cavoon.instance()
	Scene.add_child(projectile)
	projectile.position = position
	var direction = position.direction_to(player.position)
	projectile.launch(direction, projectile_speed)
		

