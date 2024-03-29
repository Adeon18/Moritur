extends CanvasLayer


const SIZE = 20


onready var PlayerRef: = get_parent()


onready var DashDelay: = get_node("Control/DashDelay")
onready var ReloadTime: = get_node("Control/ReloadTime")
onready var HeartsFull: TextureRect = get_node("Control/HeartsFull")
onready var HeartsEmpty: TextureRect = get_node("Control/HeartsEmpty")


func _ready():
	DashDelay.max_value = 100
	HeartsFull.rect_size.x = SIZE * Global.health
	HeartsEmpty.rect_size.x = SIZE * Global.max_health
	for player in get_tree().get_nodes_in_group("Player"):
		player.connect("health_changed", self, "_on_Player_health_changed")
		player.connect("max_health_changed", self, "_on_Player_max_health_changed")
		player.connect("pickable_encountered", self, "_on_Player_pickable_encountered")
		player.connect("no_pickable", self, "_on_Player_no_pickable")


func _on_Player_health_changed():
	HeartsFull.rect_size.x = SIZE * Global.health


func _on_Player_max_health_changed():
	HeartsFull.rect_size.x = SIZE * Global.health
	HeartsEmpty.rect_size.x = SIZE * Global.max_health


func _on_Player_pickable_encountered(title, desc):
	$AnimationPlayer.play("show_window")
	$Control/TextureRect/Title.text = title
	$Control/TextureRect/Desc.text = desc


func _on_Player_no_pickable():
	$AnimationPlayer.play("hide_window")


func _process(delta):
	if(PlayerRef):
		DashDelay.value = (DashDelay.max_value - PlayerRef.DashCooldownTimer.time_left * DashDelay.max_value)
		ReloadTime.max_value = Global.shot_delay_time * 100
		ReloadTime.value = ReloadTime.max_value - PlayerRef.ShootCooldownTimer.time_left * 100


