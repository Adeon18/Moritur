extends KinematicBody2D

class_name Player

signal camera_shake_requested(amp, dur)
signal frame_freeze_requested(delay)

signal health_changed
signal max_health_changed

signal pickable_encountered(title, desc)
signal no_pickable

var weapon_rotation_radius: int = 16

var is_invinsible: bool = false

var default_speed: int = 100
var friction: float = 0.25
var acceleration: float = 0.35
var direction: Vector2 = Vector2()

var is_dashing: bool = false
var dash_speed: int = 600

var mouse_position: Vector2 = Vector2()

# Effects
var camera_shake_duration: float = 0.4
var camera_shake_amplitude: float = 3.0

var frame_freeze_delay: int = 15

var _velocity = Vector2()
var _speed = default_speed

var DashGhost = preload("res://src/Actors/DashGhost.tscn")
var DefaultWeapon = load("res://src/Weapons/{name}.tscn".format({"name": Global.weapon_name}))
var WeaponObject

var weapon_to_be_picked_up
var is_colliding_with_weapon: bool = false

var dead: = false

var shenanigans: Dictionary = {
	"freeze": false,
	"burn": false,
	"poizon": false
}


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
onready var CollisionShapeWall: CollisionShape2D = get_node("CollisionShape2D")
onready var HitboxCollisionShape: CollisionShape2D = get_node("Hitbox/CollisionShape2D")

func _ready():
	StateMashine = $AnimationTree.get("parameters/playback")
	
	shenanigans = {"freeze": Global.freeze, "burn": Global.burn, "poizon": Global.poizon}
	
	ShootCooldownTimer.wait_time = Global.shot_delay_time
	
	###
	var weapon = DefaultWeapon.instance()
	WeaponContainer.call_deferred("add_child", weapon)
	
	weapon.call_deferred("disable_pick_up_collision")
	weapon.set_deferred("position", Vector2(0, 0))
	# print(Global.projectile_type)
	weapon.change_style(Global.projectile_type)
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
		Hitbox.scale.x = 1
		if (CollisionShapeWall.position.x < 0):
			CollisionShapeWall.position.x = abs(CollisionShapeWall.position.x)
	elif (mouse_position.x < global_position.x):
		SpriteNode.flip_h = false
		WeaponContainer.scale.y = -1
		Hitbox.scale.x = -1
		if (CollisionShapeWall.position.x > 0):
			CollisionShapeWall.position.x = -CollisionShapeWall.position.x

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
						Global.projectile_speed,
						Global.projectile_damage,
						shenanigans,
						Global.projectile_type,
						Global.projectile_scale)
		$ShootPlayer.play()
		ShootCooldownTimer.start()


func _input(event):
	if Input.is_action_just_pressed("slide") && _velocity.length() > 1:
		if DashCooldownTimer.is_stopped() and !is_dashing:
			$DashSound.play()
			start_dash()
	
	if Input.is_action_pressed("pick_up") and WeaponPickUpCooldownTimer.time_left == 0 and is_colliding_with_weapon:
		$PickUpSound.play()
		emit_pick_up_object_signal()
		if weapon_to_be_picked_up.is_in_group("Weapons"):
			Global.weapon_name = weapon_to_be_picked_up.name
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
	Global.shot_delay_time = object.delay_decrease
	ShootCooldownTimer.wait_time = Global.shot_delay_time


func power_up(object):
	var key = object.get_type()
	if key in Constants.EFFECTS:
		shenanigans[key] = true
		if key == "burn": Global.burn = true
		if key == "freeze": Global.freeze = true
		if key == "poizon": Global.poizon = true
		Global.projectile_type = key
		WeaponObject.change_style(Global.projectile_type)
	elif key in ["heal_up", "health_up"]:
		if key == "heal_up":
			Global.health = Global.max_health
			emit_signal("health_changed")
		elif key == "health_up":
			Global.max_health += 1
			if (Global.max_health == Global.health+1):
				Global.health = Global.max_health
			emit_signal("max_health_changed")
	else:
		Global.set_deferred(key, Global.get(key) * Constants.MULTIPLIERS[key])
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
	clone.call_deferred("change_style", Global.projectile_type)
	clone.set_deferred("position", Vector2(0, 0))

	WeaponObject = clone
	is_colliding_with_weapon = false
	weapon_to_be_picked_up = null



func take_damage(amount):
	if !is_invinsible:
		Global.health -= amount
		# animatons
		emit_signal("camera_shake_requested", camera_shake_amplitude, camera_shake_duration)
		emit_signal("frame_freeze_requested", frame_freeze_delay)
		emit_signal("health_changed")
		$HitPlayer.play()
		if Global.health == 0:
			die()
			DamageTween.interpolate_property(WeaponObject, "modulate:a", 1.0, 0.0, 0.8)
			DamageTween.start()
		else:
			DamageTween.interpolate_property(SpriteNode.material, "shader_param/flash_modifier", 0.0, 1.0, 0.1)
			DamageTween.start()
		is_invinsible = true
		InvisibilityCooldownTimer.start()


func emit_pick_up_object_signal():
	emit_signal("camera_shake_requested", camera_shake_amplitude - 2, camera_shake_duration - 0.1)
	emit_signal("frame_freeze_requested", frame_freeze_delay + 15)


func die():
	HitboxCollisionShape.set_deferred("disabled", true)
	set_physics_process(false)
	StateMashine.travel("death")
	dead = true


func reload_scene():
	if dead:
		SceneChanger.restart()
		dead = false


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
		emit_signal("pickable_encountered", Constants.WEAPON_DESCRIPTIONS[area.name].title, Constants.WEAPON_DESCRIPTIONS[area.name].desc)
	
	if area.is_in_group("Powerups"):
		weapon_to_be_picked_up = area
		is_colliding_with_weapon = true
		emit_signal("pickable_encountered", Constants.POWERUP_DESCRIPTIONS[area.get_type()].title, Constants.POWERUP_DESCRIPTIONS[area.get_type()].desc)
	
	if area.is_in_group("EnemyProjectile"):
		take_damage(1)


func _on_Hitbox_area_exited(area):
	if area.is_in_group("Weapons"):
		weapon_to_be_picked_up = null
		is_colliding_with_weapon = false
		emit_signal("no_pickable")
	elif area.is_in_group("Powerups"):
		weapon_to_be_picked_up = null
		is_colliding_with_weapon = false
		emit_signal("no_pickable")


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
