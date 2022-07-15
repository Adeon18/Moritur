extends KinematicBody2D


var hp: int = 10
var effective_fighting_distance: int = 20


var speed: int = 50
var movable: bool = true

var curr_direction: bool = true

var distance: float
var velocity: Vector2
var direction_to_player: Vector2

onready var Player: Player = get_node("../../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# move to player
	distance = position.distance_to(Player.position)
	direction_to_player = position.direction_to(Player.position)
	velocity = direction_to_player * speed
	# stop when too close to player or if cant move (useful for freeze?)
	if(movable && (distance > effective_fighting_distance)):
		move_and_slide(velocity)
	# mirror enemy
	if(direction_to_player.x < 0 && scale.y > 0): 
		scale.x *= -1
	elif(direction_to_player.x > 0 && scale.y < 0): 
		scale.x *= -1




func burn():
	pass


func freeze():
	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("projectile"):
		body.hit(self)
