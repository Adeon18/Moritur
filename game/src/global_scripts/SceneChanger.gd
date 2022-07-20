extends CanvasLayer

signal scene_changed()

onready var AnimPlayer = $AnimationPlayer
onready var Black = $Control/Black

func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	AnimPlayer.play("fade")
	yield(AnimPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	AnimPlayer.play_backwards("fade")
	yield(AnimPlayer, "animation_finished")
	emit_signal("scene_changed")
	

func restart():
	Global.fucking_reset_oh_my_fucking_god()
	change_scene(Constants.BOARD_SCENE_PATH)
