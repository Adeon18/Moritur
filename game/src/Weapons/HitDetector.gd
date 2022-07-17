extends Area2D


onready var MeleeWeaponObj: = get_parent()


func hit(body):
	body.take_damage(MeleeWeaponObj.damage)
	for key in MeleeWeaponObj.shenanigans:
		if MeleeWeaponObj.shenanigans[key]:
			body.call_deferred(key, MeleeWeaponObj.damage)
