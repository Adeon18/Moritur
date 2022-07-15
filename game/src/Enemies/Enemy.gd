extends KinematicBody2D


var hp: int = 10
var velocity: Vector2
var speed: int = 50

onready var Player: Player = get_node("../../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = position.direction_to(Player.position) * speed
	move_and_slide(velocity)


func burn():
	pass

func freeze():
	pass
