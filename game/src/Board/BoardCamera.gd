extends Camera2D


var mouse_start_pos
var screen_start_position

var dragging = false


const MIN_ZOOM = 1
const MAX_ZOOM = 8


func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	if event.is_action("wheel_up"):
		zoom -= Vector2.ONE
		var clamped_zoom = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
		zoom = Vector2(clamped_zoom, clamped_zoom)
	elif event.is_action("wheel_down"):
		zoom += Vector2.ONE
		var clamped_zoom = clamp(zoom.x, MIN_ZOOM, MAX_ZOOM)
		zoom = Vector2(clamped_zoom, clamped_zoom)
	
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
