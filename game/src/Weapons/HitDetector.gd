extends Area2D


onready var MeleeWeaponObj: = get_parent()


func hit(body):
	for key in MeleeWeaponObj.shenanigans:
		if MeleeWeaponObj.shenanigans[key]:
			body.call_deferred(key, MeleeWeaponObj._damage)
