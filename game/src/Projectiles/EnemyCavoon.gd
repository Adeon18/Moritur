extends Area2D


var _speed: int
var _direction: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position += _direction*_speed*delta

func launch(direction: Vector2, speed: int):
	_direction = direction
	_speed = speed


func _on_Cavoon_area_entered(area):
	if area.is_in_group("Swords"):
		die()


func _on_Cavoon_body_entered(body):
	if !body.is_in_group("Decoration"):
		die()


func die():
	$Hit.material.set_shader_param("color", Constants.ENEMY_PROJ_COLOR["range_enemy"])
	$Hit.emitting = true
	set_physics_process(false)
	$Sprite.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	$CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.9), "timeout")
	queue_free()


