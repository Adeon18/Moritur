extends "res://src/Board/Cell/Cell.gd"

class_name RandomEffectCell

enum EFFECTS {
	GO_BACKWARDS,
	GO_FORWARDS
}

var effect_weight: Dictionary =  {
	EFFECTS.GO_BACKWARDS: {
		"roll_weight": 1
	},
	EFFECTS.GO_FORWARDS: {
		"roll_weight": 1
	},
}

const effects_functions: Dictionary = {
	EFFECTS.GO_BACKWARDS: "go_backwards",
	EFFECTS.GO_FORWARDS: "go_forwards",
}

onready var WaitOnStepTimer = $WaitOnStepTimer

var effect_name = EFFECTS.GO_BACKWARDS


var backwards_step = 0
var forwards_step = 0

func initialize():
	init_probabilities()
	random_effect()
#	print(effects_functions[effect_name])
	match effect_name:
		EFFECTS.GO_BACKWARDS:
			backwards_step = randi() % 3 + 1
		EFFECTS.GO_FORWARDS:
			forwards_step = randi() % 3 + 1

var total_weight
func init_probabilities():
	total_weight = 0.0
	for effect_type in effect_weight.values():
		total_weight += effect_type.roll_weight
		effect_type.acc_weight = total_weight
		
func random_effect():
	var roll: float = rand_range(0.0, total_weight)
	for effect_type in effect_weight.keys():
		if effect_weight[effect_type].acc_weight > roll:
			effect_name = effect_type
			return

func on_step(player):
	curr_player = player
	player.can_roll = false
	print("you stepped on mysterious cell")
	if was_stepped_on:
		player.can_roll = true
		print("you already stepped on this cell")
		return

	WaitOnStepTimer.start()

func after_step():
	.after_step()
	print("Bruh")

func go_backwards(player):
	print("player going backwards for ", backwards_step, " cells")
	player.go_backwards(backwards_step)

func go_forwards(player):
	print("player going forwards for ", forwards_step, " cells")
	player.move_player(forwards_step)

func _on_WaitOnStepTimer_timeout():
	after_step()
	call_deferred(effects_functions[effect_name], curr_player)
