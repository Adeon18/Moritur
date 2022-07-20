extends "res://src/Board/Cell/Cell.gd"

func on_step(player):
	.on_step(player)
	print("you stepped on item cell")
	
	player.can_roll = false
	
	if cell_info["visited"]:
		player.can_roll = true
		return
	
	after_step()
	
	SceneChanger.change_scene("res://src/Rooms/ItemRoom.tscn")

func after_step():
	.after_step()
