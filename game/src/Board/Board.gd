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
onready var StepsCountLabel = $CanvasLayer/StepsCountLabel
onready var EffectDescriptionLabel = $CanvasLayer/Control/EffectDescriptionLabel
onready var UIAnimPlayer = $CanvasLayer/AnimationPlayer
onready var DiceSoundPlayer = get_node("DiceMusicPlayer")

#var cell_types: Dictionary

var die1_finished = true
var die2_finished = true

var dice_res = 0

var player

var cells_weight: Dictionary =  {
	"combat": {
		"roll_weight": 100
	},
	"random_effect": {
		"roll_weight": 1
	},
#	"shop": {
#		"roll_weight": 1
#	},
	"item": {
		"roll_weight": 1
	},
}

var total_weight
func init_probabilities():
	total_weight = 0.0
	for cell_type in cells_weight.values():
		total_weight += cell_type.roll_weight
		cell_type.acc_weight = total_weight
	

func random_cell_instance():
	var roll: float = rand_range(0.0, total_weight)
	for cell_type in cells_weight.keys():
		if cells_weight[cell_type].acc_weight > roll:
			return Global.cell_types[cell_type].instance()
#	return cell_types.values()[randi() % cell_types.size()].instance()


func _ready():
	seed(Global.random_seed)
	var starting_pos = Vector2(0, 0)
	
	if !Global.if_generated_path:
		Global.cell_types = {
			"start": preload("res://src/Board/Cell/StartCell.tscn"),
			"combat": preload("res://src/Board/Cell/CombatCell.tscn"),
			"random_effect": preload("res://src/Board/Cell/RandomEffectCell.tscn"),
	#		"shop": preload("res://src/Board/Cell/ShopCell.tscn"),
			"item": preload("res://src/Board/Cell/ItemCell.tscn"),
		}
		init_probabilities()

		# Setup board
		Global.path = generate_path(starting_pos)
#		Global.if_generated_path = true
	spawn_cells(Global.path)
	
	# Setup player
	player = BoardPlayer.instance();
	player.path = Global.path
	player.starting_pos = starting_pos
	player.CELL_WIDTH = CELL_WIDTH
	player.MARGIN = MARGIN
	player.position = starting_pos * (MARGIN + CELL_WIDTH)
	player.connect("finished_moving", self, "_on_BoardPlayer_finished_moving")
	player.connect("step_made", self, "_on_BoardPlayer_step_made")
	add_child(player)
	
	Cam.position = player.position
	
	# Setup camera
	Cam.current = true

func generate_path(starting_pos) -> Dictionary:
	var path: Dictionary = {}
	var last_pos: Vector2 = starting_pos
	path[last_pos] = [null, null]
	
	var i = 0
	while i < number_of_cells:
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
	var starting_cell_instance = Global.cell_types["start"].instance()
	if !Global.if_generated_path:
		Global.path[Vector2.ZERO].append(starting_cell_instance)
	Line.add_point(starting_cell_instance.position)
	add_child(starting_cell_instance)
	
	for pos in Global.path.keys().slice(1, path.size()-1):
#		var cell_instance = cell.instance()
		var cell_instance
		if Global.path[pos].size() != 3:
			cell_instance = random_cell_instance()
			cell_instance.position = pos * (CELL_WIDTH + MARGIN)
			
			if cell_instance is RandomEffectCell:
				cell_instance.initialize()
			
			Global.path[pos].append(cell_instance)
		else:
			print(Global.path[pos])
			cell_instance = Global.path[pos][2]
		cell_instance.connect("show_description", self, "_on_Cell_show_description")
		Line.add_point(cell_instance.position)
		add_child(cell_instance)

func _process(delta):
	if !player.can_roll or Input.is_action_just_pressed("focus_on_player"):
		Cam.position = player.position
	DieContainer.position = Cam.position
	
	if Input.is_action_just_pressed("ui_accept") and player.can_roll:
		DiceSoundPlayer.play()
		var die_res = roll_die()
		player.can_roll = false
		dice_res = die_res


func set_die_visible():
	Die1.visible = true
	Die2.visible = true
	
func set_die_not_visible():
	Die1.visible = false
	Die2.visible = false

func roll_die():
	randomize()
	set_die_visible()
	var die1_val = Die1.roll()
	var die2_val = Die2.roll()
	return die1_val + die2_val

func _on_DieWaitTimer_timeout():
	set_die_not_visible()
	player.move_player(dice_res)
	DiceSoundPlayer.stop()

func _on_DieContainer_both_dice_rolled():
	$DieWaitTimer.start()

func _on_BoardPlayer_finished_moving():
#	player.can_roll = true
	StepsCountLabel.visible = false

func _on_BoardPlayer_step_made():
	StepsCountLabel.visible = true
	StepsCountLabel.text = str(player.steps_to_take+1)

func _on_Cell_show_description(description: String):
	set_effect_description(description)

func set_effect_description(description: String):
	EffectDescriptionLabel.text = description
	UIAnimPlayer.play("show")
	yield(UIAnimPlayer, "animation_finished")
	
	yield(get_tree().create_timer(1), "timeout")
	
	UIAnimPlayer.play_backwards("show")
	yield(UIAnimPlayer, "animation_finished")
	
