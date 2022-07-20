extends "res://src/Board/Cell/Cell.gd"

var room

func _ready():
	var files = list_files_in_directory("res://src/Rooms/SmallRooms/")
	room = files[randi() % files.size()]

func on_step(player):
	print("you stepped on combat cell")
	if cell_info["visited"]:
		return
	player.can_roll = false

	after_step()
	SceneChanger.change_scene(room)

func after_step():
	.after_step()

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
