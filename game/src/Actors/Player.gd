extends KinematicBody2D

class_name Player

var default_speed: int = 400
var friction: float = 0.25
var acceleration: float = 0.35
var direction: Vector2 = Vector2()

var is_dashing: bool = false
var dash_speed: int = 1200

var mouse_position: Vector2 = Vector2()

var _velocity = Vector2()
var _speed = default_speed

var DashGhost = preload("res://src/Actors/DashGhost.tscn")
var Weapon

var weapon_to_be_picked_up
var is_colliding_with_weapon: bool = false

var projectile_speed: int = 200

onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")
onready var SpriteNode: Sprite = get_node("Sprite")
onready var WeaponPosition: Position2D = get_node("WeaponPosition")
onready var DashDurationTimer: Timer = get_node("DashDuration")
onready var DashCooldownTimer: Timer = get_node("DashCooldown")
onready var GhostSpawnCooldownTimer: Timer = get_node("GhostSpawnCooldown")
onready var Hitbox: Area2D = get_node("Hitbox")
onready var HitboxCollisionShape: CollisionShape2D = get_node("Hitbox/CollisionShape2D")

func _ready():
	AnimPlayer.play("run")

func _physics_process(delta):
	mouse_position = get_global_mouse_position()

	# Basic movement
	if is_dashing:
		_speed = dash_speed
	else:
		_speed = default_speed
		direction = get_direction_vector()
	
	if mouse_position.x > global_position.x:
		SpriteNode.flip_h = false
		if (Weapon): Weapon.scale = Vector2(1, 1)
		if (Weapon): Weapon.position.x = WeaponPosition.position.x
	elif (mouse_position.x < global_position.x):
		SpriteNode.flip_h = true
		if (Weapon): Weapon.scale = Vector2(-1, -1)
		if (Weapon): Weapon.position.x = -WeaponPosition.position.x

	handle_weapon_rotation()
	
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


func handle_weapon_rotation():
	if Weapon:
		Weapon.look_at(mouse_position)
		Weapon.rotate(sign(Weapon.position.x) * 1.5708)


func _input(event):
	if Input.is_action_just_pressed("slide"):
		if DashCooldownTimer.is_stopped() and !is_dashing:
			start_dash()
	
	if Input.is_action_pressed("pick_up") and is_colliding_with_weapon:
		reparent(weapon_to_be_picked_up)
	
	if Input.is_action_pressed("attack"):
		Weapon.use(global_position.direction_to(mouse_position), projectile_speed)

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
	dghost.flip_h = false if scale.x == 1 else true


func reparent(area):
	var clone = area.duplicate()
	area.queue_free()

	call_deferred("add_child", clone)

	clone.call_deferred("disable_pick_up_collision")
	clone.set_deferred("position", WeaponPosition.position)

	Weapon = clone
	is_colliding_with_weapon = false
	weapon_to_be_picked_up = null


func _on_DashDuration_timeout():
	DashCooldownTimer.start()
	GhostSpawnCooldownTimer.stop()
	HitboxCollisionShape.disabled = false
	is_dashing = false


func _on_GhostSpawnCooldown_timeout():
	instance_dash_ghost()


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Weapons"):
		weapon_to_be_picked_up = area
		is_colliding_with_weapon = true

