extends KinematicBody2D

class_name Player

signal camera_shake_requested
signal frame_freeze_requested

var weapon_rotation_radius: int = 16

var health: int = 3
var is_invinsible: bool = false

var default_speed: int = 100
var friction: float = 0.25
var acceleration: float = 0.35
var direction: Vector2 = Vector2()

var is_dashing: bool = false
var dash_speed: int = 600

var mouse_position: Vector2 = Vector2()

var _velocity = Vector2()
var _speed = default_speed

var DashGhost = preload("res://src/Actors/DashGhost.tscn")
var DefaultWeapon = preload("res://src/Weapons/Sword.tscn")
var WeaponObject

var weapon_to_be_picked_up
var is_colliding_with_weapon: bool = false

var projectile_speed: int = 300
var projectile_damage: int = 1
var projectile_scale: float = 2.0
var shot_delay_time: float = 1

var shenanigans: Dictionary = {
	"freeze": false,
	"burn": false,
	"poizon": false
}

var projectile_type: String = "default"



var StateMashine

onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")
onready var DamageTween: Tween = get_node("DamageTween")
onready var SpriteNode: Sprite = get_node("Sprite")
onready var WeaponPosition: Position2D = get_node("WeaponPosition")
onready var DashDurationTimer: Timer = get_node("DashDuration")
onready var DashCooldownTimer: Timer = get_node("DashCooldown")
onready var GhostSpawnCooldownTimer: Timer = get_node("GhostSpawnCooldown")
onready var ShootCooldownTimer: Timer = get_node("ShootCooldownTimer")
onready var WeaponPickUpCooldownTimer: Timer = get_node("WeaponPickUpCooldown")
onready var InvisibilityCooldownTimer: Timer = get_node("InvisibilityCooldown")
onready var Hitbox: Area2D = get_node("Hitbox")
onready var WeaponContainer: Node2D = get_node("WeaponPosition")
onready var HitboxCollisionShape: CollisionShape2D = get_node("Hitbox/CollisionShape2D")

func _ready():
	StateMashine = $AnimationTree.get("parameters/playback")
	ShootCooldownTimer.wait_time = shot_delay_time
	
	###
	var weapon = DefaultWeapon.instance()
	WeaponContainer.call_deferred("add_child", weapon)
	
	weapon.call_deferred("disable_pick_up_collision")
	weapon.set_deferred("position", Vector2(0, 0))

	WeaponObject = weapon
	###
	DamageTween.interpolate_property(SpriteNode.material, "shader_param/flash_modifier", 0.0, 1.0, 0.1)


func _physics_process(delta):
	mouse_position = get_global_mouse_position()

	# Basic movement
	if is_dashing:
		_speed = dash_speed
	else:
		_speed = default_speed
		direction = get_direction_vector()
	
	if mouse_position.x > global_position.x:
		SpriteNode.flip_h = true
		WeaponContainer.scale.y = 1
	elif (mouse_position.x < global_position.x):
		SpriteNode.flip_h = false
		WeaponContainer.scale.y = -1

	handle_weapon_rotation()
	handle_attack()
	
	if direction.length() > 0:
		if !is_invinsible:
			StateMashine.travel("run")
		_velocity = lerp(_velocity, direction * _speed, acceleration)
	else:
		if !is_invinsible:
			StateMashine.travel("idle")
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
	var mouse_pos = mouse_position
	var player_pos = global_transform.origin 
	var distance = player_pos.distance_to(mouse_pos) 
	var mouse_dir = (mouse_pos-player_pos).normalized()
	
	if distance > weapon_rotation_radius:
		mouse_pos = player_pos + (mouse_dir * weapon_rotation_radius)
		WeaponContainer.look_at(mouse_position)
	
	WeaponContainer.global_transform.origin = mouse_pos


func handle_attack():
	if Input.is_action_pressed("attack") && ShootCooldownTimer.time_left == 0:
		WeaponObject.use(global_position.direction_to(mouse_position),
						projectile_speed,
						projectile_damage,
						shenanigans,
						projectile_type,
						projectile_scale)
		ShootCooldownTimer.start()


func _input(event):
	if Input.is_action_just_pressed("slide"):
		if DashCooldownTimer.is_stopped() and !is_dashing:
			start_dash()
	
	if Input.is_action_pressed("pick_up") and WeaponPickUpCooldownTimer.time_left == 0 and is_colliding_with_weapon:
		if weapon_to_be_picked_up.is_in_group("Weapons"):
			pick_up(weapon_to_be_picked_up)
		elif weapon_to_be_picked_up.is_in_group("Powerups"):
			power_up(weapon_to_be_picked_up)
		WeaponPickUpCooldownTimer.start()


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


func pick_up(object):
	unparent()
	reparent(object)
	ShootCooldownTimer.wait_time = shot_delay_time * object.delay_decrease


func power_up(object):
	var key = object.get_type()
	if key in Constants.EFFECTS:
		shenanigans[key] = true
		projectile_type = key
		WeaponObject.change_style(projectile_type)
	elif key in ["heal_up", "health_up"]:
		# heal up code
		pass
	else:
		set_deferred(key, get(key) * Constants.MULTIPLIERS[key])
	weapon_to_be_picked_up = null
	object.die()


func unparent():
	var clone = WeaponObject.duplicate()
	WeaponObject.queue_free()

	get_parent().call_deferred("add_child", clone)

	clone.call_deferred("enable_pick_up_collision")
	clone.set_deferred("global_position", WeaponPosition.global_position)



func reparent(area):
	var clone = area.duplicate()
	area.queue_free()

	WeaponContainer.call_deferred("add_child", clone)

	clone.call_deferred("disable_pick_up_collision")
	clone.set_deferred("position", Vector2(0, 0))

	WeaponObject = clone
	is_colliding_with_weapon = false
	weapon_to_be_picked_up = null


func take_damage(amount):
	if !is_invinsible:
		health -= amount
		# animatons
		emit_signal("camera_shake_requested")
		emit_signal("frame_freeze_requested")
		if health == 0:
			die()
			DamageTween.interpolate_property(WeaponObject, "modulate:a", 1.0, 0.0, 0.8)
			DamageTween.start()
		else:
			DamageTween.interpolate_property(SpriteNode.material, "shader_param/flash_modifier", 0.0, 1.0, 0.1)
			DamageTween.start()
		is_invinsible = true
		InvisibilityCooldownTimer.start()


func die():
	HitboxCollisionShape.set_deferred("disabled", true)
	set_physics_process(false)
	StateMashine.travel("death")


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
	
	if area.is_in_group("Powerups"):
		weapon_to_be_picked_up = area
		is_colliding_with_weapon = true
	
	if area.is_in_group("EnemyProjectile"):
		take_damage(1)


func _on_Hitbox_area_exited(area):
	if area.is_in_group("Weapons"):
		weapon_to_be_picked_up = null
		is_colliding_with_weapon = false


func _on_InvisibilityCooldown_timeout():
	is_invinsible = false


func _on_DamageTween_tween_completed(_object, _key):
	if (SpriteNode.material.get_shader_param("flash_modifier") == 0.0):
		if !is_invinsible:
			DamageTween.stop(SpriteNode.material)
			return
		DamageTween.interpolate_property(SpriteNode.material, "shader_param/flash_modifier", 0.0, 1.0, 0.1)
	else:
		DamageTween.interpolate_property(SpriteNode.material, "shader_param/flash_modifier", 1.0, 0.0, 0.1)
	DamageTween.start()
