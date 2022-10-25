extends Node2D

onready var camera: = $Camera2D
onready var player: = $Player

func _ready():
	VisualServer.set_default_clear_color(Color.deepskyblue)
	player.connect_camera(camera)
