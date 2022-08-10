extends Control



signal camera_shake_requested(amp, dur)


var start_game_pressed: bool = false


onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")


func _ready():
	AnimPlayer.play("idl")
	yield(AnimPlayer, "animation_finished")
	AnimPlayer.play("intro")
	yield(AnimPlayer, "animation_finished")
	SceneChanger.change_scene("res://src/UI/MainMenu.tscn")


func request_shake_big():
	emit_signal("camera_shake_requested", 6, 0.4)
