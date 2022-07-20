extends Enemy

onready var shoot_timer = get_node("Timers/ShootTimer")

func _init():
	speed = 80
	effective_fighting_distance = 100
	health = 70

func _ready():
	Statemachine = get_node("AnimationTree").get("parameters/playback")


func handle_fight():
	if(!is_hitting):
		print("I HIT")
		Statemachine.travel("hit")
		movable = false
		is_hitting = true
		shoot_timer.start(1)


func shoot():
	var projectile = Cavoon.instance()
	get_node("../../").add_child(projectile)
	projectile.position = position
	var direction = position.direction_to(player.position)
	projectile.launch(direction, projectile_speed)
		



func _on_ShootTimer_timeout():
	is_hitting = false
