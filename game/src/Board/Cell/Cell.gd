extends Node2D

var was_stepped_on = false
var curr_player

func on_step(player):
	curr_player = player
	curr_player.can_roll = false
	print("you stepped on a cell")

func after_step():
	if !was_stepped_on:
		$Sprite.modulate = $Sprite.modulate.darkened(0.5)
		was_stepped_on = true


func _on_WaitOnStepTimer_timeout():
	after_step()
