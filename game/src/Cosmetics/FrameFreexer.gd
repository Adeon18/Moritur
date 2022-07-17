extends Node


export var delay_miliseconds: = 15


func _ready():
	for frame_freezer in get_tree().get_nodes_in_group("FrameFreezers"):
		frame_freezer.connect("frame_freeze_requested", self, "_on_frame_freeze_requested")


func _on_frame_freeze_requested():
	OS.delay_msec(delay_miliseconds)
