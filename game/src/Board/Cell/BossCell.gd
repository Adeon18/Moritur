extends "res://src/Board/Cell/Cell.gd"

func _ready():
	pass # Replace with function body.

func on_step(player):
	.on_step(player)
	
	print("you stepped on boss cell")

	if cell_info["visited"]:
		return
	
	player.can_roll = false
	
	after_step()
	
	SceneChanger.change_scene("res://src/Rooms/BossRoom.tscn")


func after_step():
	.after_step()
