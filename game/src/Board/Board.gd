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
onready var BossCell = preload("res://src/Board/Cell/BossCell.tscn")

var cell_instances: Array

var die1_finished = true
var die2_finished = true

var dice_res = 0

var player

var cells_weight: Dictionary =  {
	"combat": {
		"roll_weight": 2
	},
	"random_effect": {
		"roll_weight": 2
	},
#	"shop": {
#		"roll_weight": 1
#	},
	"item": {
		"roll_weight": 2
	},
}

var cell_types: Dictionary = {
			"start": preload("res://src/Board/Cell/StartCell.tscn"),
			"combat": preload("res://src/Board/Cell/CombatCell.tscn"),
			"random_effect": preload("res://src/Board/Cell/RandomEffectCell.tscn"),
	#		"shop": preload("res://src/Board/Cell/ShopCell.tscn"),
			"item": preload("res://src/Board/Cell/ItemCell.tscn"),
			"boss": preload("res://src/Board/Cell/BossCell.tscn")
}

var total_weight
func init_probabilities():
	total_weight = 0.0
	for cell_type in cells_weight.values():
		total_weight += cell_type.roll_weight
		cell_type.acc_weight = total_weight


func random_cell_type():
	var roll: float = rand_range(0.0, total_weight)
	for cell_type in cells_weight.keys():
		if cells_weight[cell_type].acc_weight > roll:
			return cell_type


func _ready():
	
	var starting_pos = Vector2(0, 0)
	
	if !Global.is_board_generated:
		init_probabilities()

		# Setup board
		generate_path(starting_pos)
		Global.is_board_generated = true
	spawn_cells()
	
	# Setup player
	player = BoardPlayer.instance();
	player.starting_pos = starting_pos
	player.CELL_WIDTH = CELL_WIDTH
	player.MARGIN = MARGIN
	player.cell_instances = cell_instances
	player.connect("finished_moving", self, "_on_BoardPlayer_finished_moving")
	player.connect("step_made", self, "_on_BoardPlayer_step_made")
	add_child(player)

	Cam.position = player.position
	
	# Setup camera
	Cam.current = true

func generate_path(starting_pos):
	Global.board_path.append({
		"cell_type": "start",
		"board_position": starting_pos,
		"visited": false
	})
	var last_pos = starting_pos
	
	var taken_positions: Dictionary = {starting_pos: true}
	
	var i = 0
	while i < number_of_cells:
		var shuffled_directions = directions_array.duplicate()
		shuffled_directions.shuffle()
		
		var tried_directions = 0
		for direction in shuffled_directions:
			var new_pos = last_pos + direction
			if taken_positions.has(new_pos):
				tried_directions += 1
				continue
			else:
				Global.board_path.append({
					"cell_type": "boss" if (i == number_of_cells-1) else random_cell_type(),
					"board_position": new_pos,
					"visited": false
				})
				taken_positions[new_pos] = true
				last_pos = new_pos
				i += 1
				break
		
		if tried_directions == shuffled_directions.size():
			var new_free_pos = Global.board_path[i+1]["board_position"]
			taken_positions.erase(new_free_pos)
			last_pos = Global.board_path[i]["board_position"]
			i -= 1


func spawn_cells():
	for i in Global.board_path.size():
		var cell_info = Global.board_path[i]
		var cell_instance = cell_types[cell_info["cell_type"]].instance()
		cell_instance.position = cell_info["board_position"] * (MARGIN + CELL_WIDTH)
		Line.add_point(cell_instance.position)
		cell_instance.cell_info = cell_info
		cell_instance.connect("show_description", self, "_on_Cell_show_description")
		add_child(cell_instance)
		cell_instances.append(cell_instance)


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
	
