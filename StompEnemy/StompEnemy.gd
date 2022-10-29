extends Node2D

enum {HOVER, FALL, LAND, RISE}

var state = HOVER

onready var start_position = global_position
onready var rayCast2D: = $RayCast2D
onready var timer: = $Timer
onready var animatedSprite: = $AnimatedSprite

func _physics_process(delta):
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)
		
func hover_state():
	state = FALL
	
func fall_state(delta: float):
	animatedSprite.play("falling")
	position.y += 100 * delta
	if rayCast2D.is_colliding():
		var collision_point = rayCast2D.get_collision_point()
		position.y = collision_point.y - 9
		state = LAND
		timer.start(1.0)
		
func land_state():
	if timer.time_left == 0:
		state = RISE
	
func rise_state(delta: float):
	animatedSprite.play("rising")
	position.y = move_toward(position.y, start_position.y, 20 * delta)
	if(position.y == start_position.y):
		state = HOVER
