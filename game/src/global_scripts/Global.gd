extends Node

var health: int = 3
var max_health: int = 3

var burn: bool = false
var freeze: bool = false
var poizon: bool = false

var weapon_name = "Sword"
var projectile_speed: int = 300
var projectile_damage: float = 20
var projectile_scale: float = 2.0
var shot_delay_time: float = 1
var projectile_type: String = "default"

var is_board_generated = false
var board_path: Array
var board_player_current_index = 0

func _ready():
	Loader.load_global()
	randomize()


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


func fucking_reset_oh_my_fucking_god():
	health = 3
	max_health = 3

	burn = false
	freeze = false
	poizon = false

	weapon_name = "Sword"
	projectile_speed = 300
	projectile_damage = 20
	projectile_scale = 2.0
	shot_delay_time = 1
	projectile_type = "default"

	is_board_generated = false
	board_path = []
	board_player_current_index = 0
