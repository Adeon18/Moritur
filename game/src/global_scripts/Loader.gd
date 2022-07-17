extends Node


const SAVE_DIR_NAME: String = "saves"
const GLOBAL_SAVE_FILE: String = "./" + SAVE_DIR_NAME + "/globaldata.save"


func check_for_saves_directory():
	"""
	Create a saves directory.
	"""
	var directory = Directory.new()
	
	directory.open("./.")
	if !directory.dir_exists(SAVE_DIR_NAME):
		push_warning("Loader.gd::create_saves_directory:: No SAVE_DIR, created one.")
		directory.make_dir(SAVE_DIR_NAME)



func save_global():
	"""
	Save all of the global variables to a file using the prewritten save function
	in global.
	Used is save_all().
	"""
	check_for_saves_directory()

	# Initialise an abstract file object and open a save file
	var save_file = File.new()
	save_file.open(GLOBAL_SAVE_FILE, File.WRITE)
	# Store the data in a var
	var global_data = Global.save()
	# Store the json line in a file
	save_file.store_line(to_json(global_data))

	save_file.close()


func load_global():
	"""
	Load all of the data to global script, except the last checkpoint - Check if the first line in a file
	is global related and if it is, perform the loading.
	Also powerup data is not applied to player.
	Used by load_all().
	"""
	check_for_saves_directory()
	var save_file = File.new()
	# Check if file exists - else - skip the load step.
	if not save_file.file_exists(GLOBAL_SAVE_FILE):
		return

	save_file.open(GLOBAL_SAVE_FILE, File.READ)
	while save_file.get_position() < save_file.get_len():
		var global_data = parse_json(save_file.get_line())
		# If the name is not global, we return.

		for attr in global_data.keys():
			Global.set(attr, global_data[attr])
	
	save_file.close()
