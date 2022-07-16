extends Node2D

const CELL_WIDTH = 64
const MARGIN = 32

var directions: Dictionary = {
	"TOP": Vector2(0, -1),
	"TOP_LEFT": Vector2(-1, -1),
	"TOP_RIGHT": Vector2(1, -1),
	"LEFT": Vector2(-1, 0),
	"RIGHT": Vector2(1, 0),
	"BOTTOM": Vector2(0, 1),
	"BOTTOM_LEFT": Vector2(-1, 1),
	"BOTTOM_RIGHT": Vector2(1, 1),
}

var directions_array: Array = directions.values()

export var number_of_cells: int = 4

onready var cell = preload("res://src/Board/Cell/Cell.tscn")
onready var Line = $Line2D
onready var BoardPlayer = preload("res://src/Board/BoardPlayer/BoardPlayer.tscn")

func _ready():
#	randomize()
	var starting_pos = Vector2(4, 2)
	var path = generate_path(starting_pos)
	spawn_cells(path)
	var player = BoardPlayer.instance();
	player.path = path
	player.starting_pos = starting_pos
	player.CELL_WIDTH = CELL_WIDTH
	player.MARGIN = MARGIN
	player.position = starting_pos * (MARGIN + CELL_WIDTH)
	add_child(player)

func generate_path(starting_pos) -> Dictionary:
	var path: Dictionary = {}
	var last_pos: Vector2 = starting_pos
	path[last_pos] = [null, null]
	Line.add_point(last_pos * (CELL_WIDTH + MARGIN))
	
	for i in range(number_of_cells):
		var new_pos
		while true:
			new_pos = last_pos + directions_array[randi() % directions_array.size()]
#			new_pos = last_pos + directions["BOTTOM"]
			if path.has(new_pos):
				continue
			else:
				break
		path[new_pos] = [last_pos, null]
		path[last_pos][1] = new_pos
		last_pos = new_pos
		Line.add_point(last_pos * (CELL_WIDTH + MARGIN))
	
	return path


func spawn_cells(path):
	for pos in path.keys():
		var cell_instance = cell.instance()
		cell_instance.position = pos * (CELL_WIDTH + MARGIN)
		add_child(cell_instance)

