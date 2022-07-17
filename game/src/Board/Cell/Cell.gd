extends Node2D

var was_stepped_on = false

func on_step(player):
	print("you stepped on a cell")

func after_step():
	$Sprite.modulate = $Sprite.modulate.darkened(0.5)
