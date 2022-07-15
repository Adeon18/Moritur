extends KinematicBody2D

export var speed: int = 350
export var friction: float = 0.1
export var acceleration: float = 0.35

var _velocity = Vector2()

func get_direction_vector():
	var dir = Vector2()

	if Input.is_action_pressed('right'):
		dir.x += 1
	if Input.is_action_pressed('left'):
		dir.x -= 1
	if Input.is_action_pressed('down'):
		dir.y += 1
	if Input.is_action_pressed('up'):
		dir.y -= 1
		
	return dir.normalized()

func _physics_process(delta):
	var direction = get_direction_vector()
	if direction.length() > 0:
		_velocity = lerp(_velocity, direction * speed, acceleration)
	else:
		_velocity = lerp(_velocity, Vector2.ZERO, friction)
	_velocity = move_and_slide(_velocity)
