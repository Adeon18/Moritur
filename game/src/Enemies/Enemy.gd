extends KinematicBody2D

class_name Enemy

#only for ranged units
var projectile_speed = 100

var health: int = 10
var effective_fighting_distance: int = 40
export var is_hitting: bool = false

var speed: int = 50
var movable: bool = true
var can_hit: bool = true

var distance: float
var velocity: Vector2
var direction_to_player: Vector2

var path = []

onready var player: Player = get_node("../../Player")
onready var Cavoon = preload("res://src/Projectiles/EnemyCavoon.tscn")
onready var Scene = get_node("../../../")
onready var sprite = get_node("./Sprite")
onready var collision = get_node("./Collision")
onready var area2d = get_node("./Area2D")
onready var weapon = get_node("./Sword")
onready var nav = get_node("../../Navigation2D")
onready var raycast = get_node("./RayCast2D")

onready var fire = get_node("./Effects/Fire")
onready var ice = get_node("./Effects/Ice")
onready var poison = get_node("./Effects/Poison")

var Statemachine 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move to player
	distance = position.distance_to(player.position)
	direction_to_player = position.direction_to(player.position)
	velocity = direction_to_player * speed
	
	raycast.set_cast_to(player.global_position - position)
	
	if(raycast.is_colliding()): can_hit = false
	else: can_hit = true

	
	# stop when too close to player or if cant move (useful for freeze?)
	if(movable && ((distance > effective_fighting_distance) || !can_hit)):
		Statemachine.travel("run")
		if(path.size() > 1):
			var d = position.distance_to(path[0])
			if (d > 1): position = position.linear_interpolate(path[0], speed*delta/d)
			else:
				path.remove(0)
	
	
	# handle combat if possible
	if((distance <= effective_fighting_distance) && can_hit):
		handle_fight()


	# mirror enemy if needed
	mirror()


	
		
func update_path():
	path = nav.get_simple_path(position, player.position, false)
	path.remove(0)
	#print(path)
	

func mirror():
	if(movable && (direction_to_player.x < 0 && sprite.scale.x > 0)): 
		sprite.scale.x *= -1
		collision.scale.x *= -1
		area2d.scale.x *= -1
		weapon.scale.x *= -1
	elif(movable && (direction_to_player.x > 0 && sprite.scale.x < 0)): 
		sprite.scale.x *= -1
		collision.scale.x *= -1
		area2d.scale.x *= -1
		weapon.scale.x *= -1

func handle_fight():
	pass

func burn():
	print("Burn")
	fire.visible = true

func freeze():
	print("Freeze")
	ice.visible = true

func poizon():
	print("poison")
	poison.visible = true

func take_damage(damage):
	print("hitt")
	health -= damage

func _on_Area2D_area_entered(area):
	if(area.is_in_group("Projectiles")):
		area.hit(self)
		print("got hit")
