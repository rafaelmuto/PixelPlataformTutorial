tool
extends Path2D

enum ANIMATION_TYPE { LOOP, BOUNCE }

export (ANIMATION_TYPE) var animation_type setget set_animation_type

onready var animationPlayer = $AnimationPlayer

func _ready():
	play_updated_animation()

func set_animation_type(value):
	animation_type = value
	play_updated_animation()

func play_updated_animation():
	match animation_type:
		ANIMATION_TYPE.LOOP: animationPlayer.play("MoveAlongPathLoop")
		ANIMATION_TYPE.BOUNCE: animationPlayer.play("MoveAlongPathBounce")
