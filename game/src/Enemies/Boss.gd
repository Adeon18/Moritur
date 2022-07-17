extends Enemy

var attack_num: int = 0


onready var BossCavoon = preload("res://src/Projectiles/BossCavoon.tscn")
func _init():
	speed = 30
	effective_fighting_distance = 60
	health = 500

func _ready():
	Statemachine = get_node("AnimationTree").get("parameters/playback")
	attack_timer = get_node("./Timers/AttackTimer")

func handle_fight():
	pass


func _on_AttackTimer_timeout():
	var ang = rand_range(0, 1)
	for i in range(15):
		ang += 30
		if(attack_num == 0):
			launch_missile(ang, "spiral", 1)
		elif(attack_num == 2):
			launch_missile(ang, "kill", 1)
		elif(attack_num == 3):
			launch_missile(ang, "big_straight", 2)
		elif(attack_num == 1):
			launch_missile(ang, "chasing", 1)
	attack_num += 1
	if(attack_num>3): attack_num = 0

func launch_missile(ang, type, size_mult):
	var projectile = BossCavoon.instance()
	Scene.add_child(projectile)
	projectile.position = position
	var direction = Vector2(cos(ang), sin(ang))
	projectile.launch(direction, projectile_speed, type, size_mult)
