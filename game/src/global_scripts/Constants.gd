extends Node


var MULTIPLIERS: Dictionary = {
	"projectile_speed": 1.25,
	"projectile_scale": 1.05,
	"shot_delay_time": 0.5,
	"projectile_damage": 1.5
}

var EFFECTS = ["burn", "freeze", "poizon"]


var WAND_SPRITES: Dictionary = {
	"WeakWand": {
		"default": 9,
		"poizon": 8,
		"freeze": 7,
		"burn": 6,
	},
	"MediumWand": {
		"default": 15,
		"poizon": 14,
		"freeze": 13,
		"burn": 12,
	},
	"StronfWand": {
		"default": 3,
		"poizon": 2,
		"freeze": 1,
		"burn": 0,
	}, 
	
}

