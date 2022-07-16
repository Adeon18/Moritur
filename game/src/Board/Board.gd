extends Node2D

const CELL_WIDTH = 64
const MARGIN = 32

var directions: Dictionary = {
	"TOP": Vector2(0, -1),
#	"TOP_LEFT": Vector2(-1, -1),
#	"TOP_RIGHT": Vector2(1, -1),
	"LEFT": Vector2(-1, 0),
	"RIGHT": Vector2(1, 0),
#	"BOTTOM": Vector2(0, 1),
#	"BOTTOM_LEFT": Vector2(-1, 1),
#	"BOTTOM_RIGHT": Vector2(1, 1),
}

var directions_array: Array = directions.values()

export var number_of_cells: int = 4

onready var cell = preload("res://src/Board/Cell/Cell.tscn")
onready var Line = $Line2D
onready var BoardPlayer = preload("res://src/Board/BoardPlayer/BoardPlayer.tscn")
onready var Cam = $Camera2D
onready var Die1 = $DieContainer/Die1
onready var Die2 = $DieContainer/Die2
onready var DieContainer = $DieContainer

var cell_types: Dictionary


var die1_finished = true
var die2_finished = true

var can_roll = true
var dice_res = 0

var Player

func _ready():
#	randomize()

	cell_types = {
		"combat": preload("res://src/Board/Cell/CombatCell.tscn"),
		"extra_step": preload("res://src/Board/Cell/ExtraStepCell.tscn"),
	}

	# Setup board
	var starting_pos = Vector2(0, 0)
	var path = generate_path(starting_pos)
	spawn_cells(path)
	
	# Setup player
	Player = BoardPlayer.instance();
	Player.path = path
	Player.starting_pos = starting_pos
	Player.CELL_WIDTH = CELL_WIDTH
	Player.MARGIN = MARGIN
	Player.position = starting_pos * (MARGIN + CELL_WIDTH)
	Player.connect("finished_moving", self, "_on_BoardPlayer_finished_moving")
	add_child(Player)
	
	# Setup camera
	Cam.current = true

func generate_path(starting_pos) -> Dictionary:
	var path: Dictionary = {}
	var last_pos: Vector2 = starting_pos
	path[last_pos] = [null, null]
#	Line.add_point(last_pos * (CELL_WIDTH + MARGIN))
#
#	for i in range(number_of_cells):
#		var new_pos
#		while true:
#			new_pos = last_pos + directions_array[randi() % directions_array.size()]
##			new_pos = last_pos + directions["BOTTOM"]
#			if path.has(new_pos):
#				continue
#			else:
#				break
#		path[new_pos] = [last_pos, null]
#		path[last_pos][1] = new_pos
#		last_pos = new_pos
#		Line.add_point(last_pos * (CELL_WIDTH + MARGIN))
	
	var i = 0
	while i < number_of_cells-1:
		var shuffled_directions = directions_array.duplicate()
		shuffled_directions.shuffle()
		
		var tried_directions = 0
		for direction in shuffled_directions:
			var new_pos = last_pos + direction
			if path.has(new_pos):
				tried_directions += 1
				continue
			else:
				path[new_pos] = [last_pos, null]
				path[last_pos][1] = new_pos
				last_pos = new_pos
				i += 1
				break
		
		if tried_directions == shuffled_directions.size():
			var new_last_pos = path[last_pos][0]
			path[last_pos][0] = null
			if new_last_pos != null:
				path[new_last_pos][1] = null
			i -= 1
	
	return path


func spawn_cells(path):
	for pos in path.keys():
		var cell_instance = cell.instance()
#		var cell_instance = random_cell_instance()
		cell_instance.position = pos * (CELL_WIDTH + MARGIN)
		Line.add_point(cell_instance.position)
		add_child(cell_instance)

func random_cell_instance():
	return cell_types.values()[randi() % cell_types.size()].instance()

func _process(delta):
	Cam.position = Player.position
	DieContainer.position = Cam.position
	
	if Input.is_action_just_pressed("ui_accept") and can_roll:
		var die_res = roll_die()
		print(die_res)
		can_roll = false
		dice_res = die_res
#		Player.move_player(die_res)


func set_die_visible():
	Die1.visible = true
	Die2.visible = true
	
func set_die_not_visible():
	Die1.visible = false
	Die2.visible = false

func roll_die():
	set_die_visible()
	var die1_val = Die1.roll()
	var die2_val = Die2.roll()
	return die1_val + die2_val


func _on_DieWaitTimer_timeout():
	set_die_not_visible()
	Player.move_player(dice_res)

func _on_DieContainer_both_dice_rolled():
	$DieWaitTimer.start()

func _on_BoardPlayer_finished_moving():
	can_roll = true
