extends Node

var health: int = 3
var max_health: int = 3

var burn: bool = false
var freeze: bool = false
var poizon: bool = false

var weapon_name = "Sword"
var projectile_speed: int = 300
var projectile_damage: int = 1
var projectile_scale: float = 2.0
var shot_delay_time: float = 1
var projectile_type: String = "default"


var board_pos = Vector2(0, 0)
var current_index = 0
var visited_cells: Array = []

var path: Dictionary = {}
var if_generated_path: bool = false
var cell_types: Dictionary = {
			"start": preload("res://src/Board/Cell/StartCell.tscn"),
			"combat": preload("res://src/Board/Cell/CombatCell.tscn"),
			"random_effect": preload("res://src/Board/Cell/RandomEffectCell.tscn"),
	#		"shop": preload("res://src/Board/Cell/ShopCell.tscn"),
			"item": preload("res://src/Board/Cell/ItemCell.tscn"),
}

var random_seed

func _ready():
	Loader.load_global()
	randomize()
	random_seed = randi()
	seed(random_seed)



func save():
	return {
		"health": health,
		"max_health": max_health,
		"projectile_speed": projectile_speed,
		"projectile_damage": projectile_damage,
		"projectile_scale": projectile_scale,
		"shot_delay_time": shot_delay_time,
		"projectile_type": projectile_type,
		"burn": burn,
		"freeze": freeze,
		"poizon": poizon
	}
