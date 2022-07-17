extends "res://src/Board/Cell/Cell.gd"

class_name RandomEffectCell

enum EFFECTS {
	GO_BACKWARDS
}

var effect_name = EFFECTS.GO_BACKWARDS

var backwards_step = 0

const effects_functions: Dictionary = {
	EFFECTS.GO_BACKWARDS: "go_backwards"
}

func initialize():
	if effect_name == EFFECTS.GO_BACKWARDS:
		backwards_step = randi() % 12 + 1

func on_step(player):
	print("you stepped on mysterious cell")
	if was_stepped_on:
		print("you already stepped on this cell")
		return

	was_stepped_on = true
	after_step()
	call_deferred(effects_functions[effect_name], player)



func go_backwards(player):
	player.go_backwards(backwards_step)

