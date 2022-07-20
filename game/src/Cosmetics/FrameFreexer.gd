extends Node


export var delay_miliseconds: = 15


func _ready():
	yield(get_tree().create_timer(0.1),"timeout")
	for frame_freezer in get_tree().get_nodes_in_group("FrameFreezers"):
		frame_freezer.connect("frame_freeze_requested", self, "_on_frame_freeze_requested")


func _on_frame_freeze_requested(delay):
	OS.delay_msec(delay)
