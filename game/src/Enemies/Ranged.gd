extends Enemy

onready var shoot_timer = get_node("Timers/ShootTimer")
onready var cavoon_ceration = get_node("CavoonCreationPoint")
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

func mirror():
	if(movable && (direction_to_player.x < 0 && sprite.scale.x > 0)):
		cavoon_ceration.position.x *=-1
	elif(movable && (direction_to_player.x > 0 && sprite.scale.x < 0)):
		cavoon_ceration.position.x *=-1
	.mirror()

func shoot():
	var projectile = Cavoon.instance()
	get_node("../../").add_child(projectile)
	projectile.position = cavoon_ceration.global_position
	var direction = position.direction_to(player.position)
	projectile.launch(direction, projectile_speed)
		



func _on_ShootTimer_timeout():
	is_hitting = false
