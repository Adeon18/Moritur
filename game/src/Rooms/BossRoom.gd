extends "res://src/Rooms/BaseRoom.gd"

onready var BossPos = get_node("BossPosition")

func _ready():
	if(BossPos):
		var boss = mobs_dict["boss"].instance()
		get_node("Enemies").add_child(boss)
		boss.position = BossPos.position
		boss.is_hitting = false
