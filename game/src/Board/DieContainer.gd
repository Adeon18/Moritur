extends Node2D

signal both_dice_rolled

var die1_finish = false
var die2_finish = false

func _on_Die1_finish_roll():
	die1_finish = true
	if die2_finish:
		emit_signal("both_dice_rolled")
		die1_finish = false
		die2_finish = false


func _on_Die2_finish_roll():
	die2_finish = true
	if die1_finish:
		emit_signal("both_dice_rolled")
		die1_finish = false
		die2_finish = false
