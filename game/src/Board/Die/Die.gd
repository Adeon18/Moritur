extends Node2D

signal finish_roll

onready var AnimPlayer = $AnimationPlayer
onready var RollTimer = $RollTimer

var current_die: int = 1

func play_roll_animation():
	AnimPlayer.play("roll1")
	RollTimer.wait_time = rand_range(0.5, 1.0)
	RollTimer.start()

func roll():
	play_roll_animation()
	current_die = random_die()
	return current_die

func random_die():
	return randi() % 6 + 1

func _on_RollTimer_timeout():
	AnimPlayer.stop()
	$Sprite.frame = current_die - 1
	emit_signal("finish_roll")
