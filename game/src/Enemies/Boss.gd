extends Enemy

var attack_num: int = 0

onready var HealthBar = get_node("./CanvasLayer/Control")
onready var BossCavoon = preload("res://src/Projectiles/BossCavoon.tscn")
onready var cavoon_ceration = get_node("CavoonCreationPoint")

var CAVOON_MARGIN = Vector2(15, 0)
var CAVOON_SPAWN_RADIUS = 15

func _init():
	speed = 30
	effective_fighting_distance = 60
	health = 300

func _ready():
	Statemachine = get_node("AnimationTree").get("parameters/playback")
	attack_timer = get_node("./Timers/AttackTimer")
	HealthBar.update_max_health(health)
	HealthBar.update_health(health, health)

func handle_fight():
	pass


func _on_AttackTimer_timeout():
	var ang = rand_range(0, 1)
	for i in range(15):
		ang += 30
		cavoon_ceration.position = Vector2(cos(ang), sin(ang)) * CAVOON_SPAWN_RADIUS + direction * CAVOON_MARGIN
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
	get_node("../../").add_child(projectile)
	projectile.position = cavoon_ceration.global_position
	var direction = Vector2(cos(ang), sin(ang))
	projectile.launch(direction, projectile_speed, type, size_mult)


func take_damage(damage):
	.take_damage(damage)
	HealthBar.update_health(health, damage)
	
