extends KinematicBody2D

var default_speed: int = 400
var friction: float = 0.25
var acceleration: float = 0.35
var direction: Vector2 = Vector2()

var is_dashing: bool = false
var dash_speed: int = 1200

var _velocity = Vector2()
var _speed = default_speed

var DashGhost = preload("res://src/Actors/DashGhost.tscn")

onready var SpriteNode: Sprite = get_node("Sprite")
onready var DashDurationTimer: Timer = get_node("DashDuration")
onready var DashCooldownTimer: Timer = get_node("DashCooldown")
onready var GhostSpawnCooldownTimer: Timer = get_node("GhostSpawnCooldown")
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
	GhostSpawnCooldownTimer.start()
	HitboxCollisionShape.disabled = true
	is_dashing = true
	
	instance_dash_ghost()


func instance_dash_ghost():
	var dghost = DashGhost.instance()
	get_parent().add_child(dghost)
	
	dghost.global_position = global_position
	dghost.texture = SpriteNode.texture
	dghost.vframes = SpriteNode.vframes
	dghost.hframes = SpriteNode.hframes
	dghost.frame = SpriteNode.frame
	dghost.flip_h = SpriteNode.flip_h


func _on_DashDuration_timeout():
	DashCooldownTimer.start()
	GhostSpawnCooldownTimer.stop()
	HitboxCollisionShape.disabled = false
	is_dashing = false


func _on_GhostSpawnCooldown_timeout():
	instance_dash_ghost()
