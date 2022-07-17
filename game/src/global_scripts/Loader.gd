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
	pass


func load_global():
	"""
	Load all of the data to global script, except the last checkpoint - Check if the first line in a file
	is global related and if it is, perform the loading.
	Also powerup data is not applied to player.
	Used by load_all().
	"""
	pass
