extends KinematicBody2D

signal finished_moving
signal step_made

var path: Dictionary;
var starting_pos;
var current_pos;

var CELL_WIDTH;
var MARGIN;

enum STATE {IDLE, TRANSITIONING, TAKING_STEP}
var current_state = STATE.IDLE

var target_position = Vector2.ZERO
var lerp_speed = 15

var steps_to_take = 0

var going_backwards = false
var can_roll = true

var cell_instances

onready var WhooshSound = get_node("Whoosh")

func _ready():
	current_pos = Global.board_path[Global.board_player_current_index]["board_position"]
	position = current_pos * (CELL_WIDTH + MARGIN)

func _physics_process(delta):
	if current_state == STATE.IDLE:
		pass
	elif current_state == STATE.TRANSITIONING:
		if Input.is_action_pressed("ui_accept"):
			lerp_speed = 30
		
		if (abs(global_position.x - target_position.x) > 0.01) or (abs(global_position.y - target_position.y) > 0.01):
			global_position = lerp(global_position, target_position, lerp_speed*delta)
		else:
			global_position = target_position
			lerp_speed = 15
			if steps_to_take == 0:
				emit_signal("finished_moving")
				on_finish_moving()
				current_state = STATE.IDLE
				cell_instances[Global.board_player_current_index].on_step(self)
			else:
				current_state = STATE.TAKING_STEP
	elif current_state == STATE.TAKING_STEP:
		if (Global.board_player_current_index+1 != cell_instances.size() and !going_backwards) or (Global.board_player_current_index-1 != -1 and going_backwards):
			if !going_backwards:
				current_pos = Global.board_path[Global.board_player_current_index+1]["board_position"]
				Global.board_player_current_index += 1
			else:
				current_pos = Global.board_path[Global.board_player_current_index-1]["board_position"]
				Global.board_player_current_index -= 1
			target_position = current_pos * (CELL_WIDTH + MARGIN)
			current_state = STATE.TRANSITIONING
			steps_to_take -= 1
			emit_signal("step_made")
			WhooshSound.play()
		elif Global.board_player_current_index+1 == cell_instances.size():
			cell_instances[Global.board_player_current_index].on_step(self)
			emit_signal("finished_moving")
			on_finish_moving()
		else:
			steps_to_take = 0
			current_state = STATE.IDLE
			emit_signal("finished_moving")
			on_finish_moving()

func on_finish_moving():
	going_backwards = false
	can_roll = true

func move_player(cells: int):
	can_roll = false
	steps_to_take = cells
	current_state = STATE.TAKING_STEP

func go_backwards(cells_num: int):
	going_backwards = true
	can_roll = false
	steps_to_take = cells_num
	current_state = STATE.TAKING_STEP
