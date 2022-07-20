extends Camera2D


onready var ShakeTimer: Timer = get_node("ShakeTimer")

export var amplitude: = 6.0
export var _duration: = 0.4
export(float, EASE) var damp_easing
export var _shake: = false setget set_shake

var enabled: bool = true

func _ready():
	randomize()
	set_process(false)
	set_duration(_duration)
	yield(get_tree().create_timer(0.1),"timeout")
	connect_to_shakers()


func _process(delta):
	var damping: = ease(ShakeTimer.time_left / ShakeTimer.wait_time, damp_easing)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping
	) 


func set_duration(duration: float):
	_duration = duration
	ShakeTimer.wait_time = duration


func set_amplitude(amp):
	amplitude = amp


func set_shake(shake):
	_shake = shake
	set_process(shake)
	offset = Vector2()
	if shake:
		ShakeTimer.start()


func connect_to_shakers():
	for shaker in get_tree().get_nodes_in_group("Shakers"):
		shaker.connect("camera_shake_requested", self, "_on_camera_shake_requested")


func _on_camera_shake_requested(amp, dur):
	if is_processing():
		return
	if !enabled:
		return
	set_amplitude(amp)
	set_duration(dur)
	set_shake(true)


func _on_ShakeTimer_timeout():
	set_shake(false)
