extends Area2D


onready var MeleeWeapon: = get_parent()


func hit(body):
	for key in MeleeWeapon.shenanigans:
		if MeleeWeapon.shenanigans[key]:
			body.call_deferred(key, MeleeWeapon._damage)
