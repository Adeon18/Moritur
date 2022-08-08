extends "res://src/Rooms/BaseRoom.gd"

onready var BossPos = get_node("BossPosition")

onready var powerup = preload("res://src/PowerUps/PowerUp.tscn")

var powerups = [
			"burn",
			"freeze",
			"poizon",
			"heal_up",
			"health_up",
			"projectile_speed",
			"projectile_scale",
			"shot_delay_time",
			"projectile_damage"
]

func _ready():
	if(BossPos):
		var boss = mobs_dict["boss"].instance()
		get_node("Enemies").add_child(boss)
		boss.position = BossPos.position
		boss.is_hitting = false
	
	var item_positions = get_node("ItemPositions")
	for item_pos in item_positions.get_children():
		spawn_item(item_pos)


func spawn_item(item_pos):
	var number = randi() % 9
	var power = powerup.instance()
	add_child(power)
	power.set_type(powerups[number])
	power.position = item_pos.position


func _process(delta):
	if enemies.get_child_count() == 0 and !should_change_scene:
		SceneChanger.change_scene("res://src/UI/MainMenu.tscn")
		should_change_scene = true
