extends "res://src/Board/Cell/Cell.gd"

var room

func _ready():
	var files = list_files_in_directory("res://src/Rooms/SmallRooms/")
	room = files[randi() % files.size()]

func on_step(player):
	print("you stepped on combat cell")
	player.can_roll = false
	
	if was_stepped_on:
		player.can_roll = true
		return
	
	was_stepped_on = true
	Global.board_pos = player.current_pos
	SceneChanger.change_scene(room)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(path + file)

	dir.list_dir_end()

	return files
