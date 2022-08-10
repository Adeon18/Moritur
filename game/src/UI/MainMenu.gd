extends Control


signal camera_shake_requested(amp, dur)


var start_game_pressed: bool = false


onready var PlayButton: TextureButton = get_node("PlayButton")
onready var ExitButton: TextureButton = get_node("ExitButton")
onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")


func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	AnimPlayer.play("appear")
	yield(AnimPlayer, "animation_finished")
	AnimPlayer.play("float")
	$AudioStreamPlayer.play()


func request_shake_big():
	emit_signal("camera_shake_requested", 6, 0.4)

func request_shake_small():
	emit_signal("camera_shake_requested", 5, 0.3)


func _on_PlayButton_pressed():
	if !start_game_pressed:
		SceneChanger.change_scene("res://src/Board/Board.tscn")
		start_game_pressed = true
	PlayButton.modulate.a = 1


func _on_PlayButton_mouse_entered():
	PlayButton.modulate.a = 0.8


func _on_PlayButton_mouse_exited():
	PlayButton.modulate.a = 1


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_ExitButton_mouse_entered():
	ExitButton.modulate.a = 0.8


func _on_ExitButton_mouse_exited():
	ExitButton.modulate.a = 1

