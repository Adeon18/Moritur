extends Node2D

onready var player_spawn_pos = $PlayerSpawnPos
onready var spawnpoints = get_node("EnemySpawnPoints")
onready var player = preload("res://src/Actors/Player.tscn")
onready var enemies = $Enemies

var total_weight
func _ready():
	mobs_dict = {
		"mele": preload("res://src/Enemies/Mele.tscn"),
		"ranged": preload("res://src/Enemies/Ranged.tscn"),
		"boss": preload("res://src/Enemies/Boss.tscn")
	}
	var player_instance = player.instance()
	add_child(player_instance)
	player_instance.position = player_spawn_pos.position
	
	init_probabilities()
	for point in spawnpoints.get_children():
		var mob = random_cell_instance()
		get_node("Enemies").add_child(mob)
		mob.position = point.position
		mob.is_hitting = false
		


var mobs_dict: Dictionary = {
	
}

var mobs_weights: Dictionary =  {
  "mele": {
	"roll_weight": 7
	},
	"ranged":{
		"roll_weight": 3
	}
}


func init_probabilities():
	total_weight = 0.0
	for mob_type in mobs_weights.values():
		total_weight += mob_type.roll_weight
		mob_type.acc_weight = total_weight
  

func random_cell_instance():
	var roll: float = rand_range(0.0, total_weight)
	for mob_type in mobs_weights.keys():
		if mobs_weights[mob_type].acc_weight > roll:
			return mobs_dict[mob_type].instance()


func _process(delta):
	if enemies.get_child_count() == 0:
		SceneChanger.change_scene("res://src/Board/Board.tscn")
