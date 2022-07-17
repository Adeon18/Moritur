extends Node


var MULTIPLIERS: Dictionary = {
	"projectile_speed": 1.25,
	"projectile_scale": 1.1,
	"shot_delay_time": 0.8,
	"projectile_damage": 1.5
}

var EFFECTS = ["burn", "freeze", "poizon"]


var PROJECTILE_COLOR: Dictionary = {
	"burn": Color.orangered,
	"freeze": Color.skyblue,
	"poizon": Color.green,
	"default": Color.whitesmoke
}


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
	"StrongWand": {
		"default": 3,
		"poizon": 2,
		"freeze": 1,
		"burn": 0,
	}, 
	
}

var WEAPON_DESCRIPTIONS: Dictionary = {
	"Bow": {
		"title": "A Bow",
		"desc": "Pierces enemies",
	},
	"Sword": {
		"title": "A Sword",
		"desc": "Bonk",
	},
	"WeakWand": {
		"title": "A Small Wand",
		"desc": "Quite fast",
	},
	"MediumWand": {
		"title": "Average Wand",
		"desc": "Pretty average",
	},
	"StrongWand": {
		"title": "A Strong Wand",
		"desc": "Big Boy",
	},
}

var POWERUP_DESCRIPTIONS: Dictionary = {
	"burn": {
		"title": "Fier",
		"desc": "Meke 'em burn!",
	},
	"freeze": {
		"title": "Freeze",
		"desc": "Freeze enemies",
	},
	"poizon": {
		"title": "Poizon",
		"desc": "Just don't drink it..",
	},
	"heal_up": {
		"title": "Heal up!",
		"desc": "Heal yourself",
	},
	"health_up": {
		"title": "+ max health",
		"desc": "Increase max health",
	},
	"projectile_speed": {
		"title": "Projectle Speed",
		"desc": "Wand go brr",
	},
	"projectile_scale": {
		"title": "Bigger spells",
		"desc": "Bigger projectiles",
	},
	"shot_delay_time": {
		"title": "Decrease Delay",
		"desc": "Shoot faster",
	},
	"projectile_damage": {
		"title": "Damage",
		"desc": "Hit harder",
	},
}
