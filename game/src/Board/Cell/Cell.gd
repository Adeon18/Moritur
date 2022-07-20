extends Node2D

signal show_description(description)

var cell_info: Dictionary

var curr_player

onready var WaitOnStepTimer = $WaitOnStepTimer

func _ready():
	print(cell_info)
	if cell_info["visited"]:
		$Sprite.modulate = $Sprite.modulate.darkened(0.5)

func on_step(player):
	curr_player = player
#	curr_player.can_roll = false
	print("you stepped on a cell")
	

func after_step():
	if !cell_info["visited"]:
		$Sprite.modulate = $Sprite.modulate.darkened(0.5)
		cell_info["visited"] = true
