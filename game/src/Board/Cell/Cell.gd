extends Node2D

signal show_description(description)

var cell_info: Dictionary

var was_stepped_on = false
var curr_player
var index

#func _ready():
#	if Global.visited_cells[index]:
#		$Sprite.modulate = $Sprite.modulate.darkened(0.5)

func on_step(player):
	curr_player = player
#	curr_player.can_roll = false
	print("you stepped on a cell")
	

func after_step():
	if !Global.visited_cells[index]:
		$Sprite.modulate = $Sprite.modulate.darkened(0.5)
		Global.visited_cells[Global.current_index] = true


func _on_WaitOnStepTimer_timeout():
	after_step()
