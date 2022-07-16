extends KinematicBody2D

signal finished_moving

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

func _ready():
	current_pos = starting_pos

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
		if Input.is_action_just_pressed("ui_up"):
			lerp_speed = 30
		
		if (abs(global_position.x - target_position.x) > 0.01) or (abs(global_position.y - target_position.y) > 0.01):
			global_position = lerp(global_position, target_position, lerp_speed*delta)
		else:
			global_position = target_position
			lerp_speed = 15
			if steps_to_take == 0:
				current_state = STATE.IDLE
				emit_signal("finished_moving")
			else:
				current_state = STATE.TAKING_STEP
	elif current_state == STATE.TAKING_STEP:
		if path[current_pos][1] != null:
			current_pos = path[current_pos][1]
			target_position = current_pos * (CELL_WIDTH + MARGIN)
			current_state = STATE.TRANSITIONING
			steps_to_take -= 1
			current_index += 1
		else:
			steps_to_take = 0
			current_state = STATE.IDLE
			emit_signal("finished_moving")

func move_player(cells: int):
	print("cells to walk: ", cells)
	steps_to_take = cells
	current_state = STATE.TAKING_STEP
