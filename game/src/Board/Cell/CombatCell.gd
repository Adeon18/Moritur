extends "res://src/Board/Cell/Cell.gd"


func on_step(player):
	print("you stepped on combat cell")
	player.can_roll = false
	
	if was_stepped_on:
		player.can_roll = true
		return
	
	was_stepped_on = true
	SceneChanger.change_scene("res://src/Rooms/RoomBig.tscn")
