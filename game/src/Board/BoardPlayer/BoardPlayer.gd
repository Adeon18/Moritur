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
var current_index = 0

var going_backwards = false
var can_roll = true

onready var WhooshSound = get_node("Whoosh")

func _ready():
	current_pos = Global.board_pos
	position = current_pos * (CELL_WIDTH + MARGIN)

func _physics_process(delta):
	if current_state == STATE.IDLE:
		pass
#		if Input.is_action_just_pressed("ui_up"):
#			steps_to_take = randi() % 12 + 1
#			print("Throwing dice: ", steps_to_take)
#			if steps_to_take > 0:
#				current_state = STATE.TAKING_STEP
#		if Input.is_action_just_pressed("ui_up"):
#			if path[current_pos][1] != null:
#				current_pos = path[current_pos][1]
#				target_position = current_pos * (CELL_WIDTH + MARGIN)
#				current_state = STATE.TRANSITIONING
#
#		if Input.is_action_just_pressed("ui_down"):
#			if path[current_pos][0] != null:
#				current_pos = path[current_pos][0]
#				target_position = current_pos * (CELL_WIDTH + MARGIN)
#				current_state = STATE.TRANSITIONING
				
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
				path[current_pos][2].on_step(self)
			else:
				current_state = STATE.TAKING_STEP
	elif current_state == STATE.TAKING_STEP:
		if (path[current_pos][1] != null and !going_backwards) or (path[current_pos][0] != null and going_backwards):
			if !going_backwards:
				current_pos = path[current_pos][1]
				current_index += 1
				Global.current_index = current_index
			else:
				current_pos = path[current_pos][0]
				current_index -= 1
				Global.current_index = current_index
			target_position = current_pos * (CELL_WIDTH + MARGIN)
			current_state = STATE.TRANSITIONING
			steps_to_take -= 1
			emit_signal("step_made")
			WhooshSound.play()
		else:
#			path[current_pos][2].on_step(self)
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
