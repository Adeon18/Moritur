extends "res://src/Board/Cell/Cell.gd"

func _ready():
	pass # Replace with function body.

func on_step(player):
	print("you stepped on item cell")
	if Global.visited_cells[index]:
		$Sprite.modulate = $Sprite.modulate.darkened(0.5)
	
	player.can_roll = false
	
	if Global.visited_cells[index]:
		player.can_roll = true
		return
	
	was_stepped_on = true
	Global.board_pos = player.current_pos
	after_step()
	
	SceneChanger.change_scene("res://src/Rooms/BossRoom.tscn")


func after_step():
	Global.visited_cells[index] = true
	.after_step()
