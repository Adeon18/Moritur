extends Node2D

onready var player_spawn_pos = $PlayerSpawnPos
onready var spawnpoints = get_node("EnemySpawnPoints")
onready var player = preload("res://src/Actors/Player.tscn")

onready var powerup = preload("res://src/PowerUps/PowerUp.tscn")

onready var wand_weak = preload("res://src/Weapons/WeakWand.tscn")
onready var wand_med = preload("res://src/Weapons/MediumWand.tscn")
onready var wand_large = preload("res://src/Weapons/StrongWand.tscn")

onready var sword = preload("res://src/Weapons/Sword.tscn")
onready var bow = preload("res://src/Weapons/Bow.tscn")

onready var item_pos = get_node("ItemPos")
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
var weapons

var total_weight
func _ready():
	weapons = [[wand_weak, "WeakWand"], [wand_large, "StrongWand"], [wand_med, "MediumWand"], [sword, "Sword"], [bow, "Bow"]]
	
	spawn_item()

	var player_instance = player.instance()
	add_child(player_instance)
	player_instance.position = player_spawn_pos.position

func spawn_item():
	var number = randi() % 14
	if(number < 9):
		if number == 0 && Global.burn: spawn_item()
		elif number == 1 && Global.freeze: spawn_item()
		elif number == 2 && Global.poizon: spawn_item()
		else:
			var power = powerup.instance()
			add_child(power)
			power.set_type(powerups[number])
			power.position = item_pos.position
	else:
		if(weapons[number-9][1] != Global.weapon_name):
			var weap = weapons[number-9][0].instance()
			add_child(weap)
			weap.position = item_pos.position
		else:
			spawn_item()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		SceneChanger.change_scene("res://src/Board/Board.tscn")


