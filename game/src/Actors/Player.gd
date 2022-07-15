extends KinematicBody2D

var default_speed: int = 400
var friction: float = 0.25
var acceleration: float = 0.35
var direction: Vector2 = Vector2()

var is_dashing: bool = false
var dash_speed: int = 1000

var _velocity = Vector2()
var _speed = default_speed

onready var DashDurationTimer: Timer = get_node("DashDuration")
onready var DashCooldownTimer: Timer = get_node("DashCooldown")
onready var Hitbox: Area2D = get_node("Hitbox")
onready var HitboxCollisionShape: CollisionShape2D = get_node("Hitbox/CollisionShape2D")


func _physics_process(delta):

	# Basic movement
	if is_dashing:
		_speed = dash_speed
	else:
		_speed = default_speed
		direction = get_direction_vector()
		
	if direction.length() > 0:
		_velocity = lerp(_velocity, direction * _speed, acceleration)
	else:
		_velocity = lerp(_velocity, Vector2.ZERO, friction)
	
	_velocity = move_and_slide(_velocity)


func get_direction_vector():
	"""
	Return the normalized direction vector of the player movement
	"""
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


func _input(event):
	if Input.is_action_just_pressed("slide"):
		if DashCooldownTimer.is_stopped() and !is_dashing:
			start_dash()


func start_dash():
	DashDurationTimer.start()
	HitboxCollisionShape.disabled = true
	is_dashing = true


func _on_DashDuration_timeout():
	DashCooldownTimer.start()
	HitboxCollisionShape.disabled = false
	is_dashing = false
