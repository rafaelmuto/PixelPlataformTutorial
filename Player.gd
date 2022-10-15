extends KinematicBody2D


var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	print('hello world!')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = 50
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -50
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -120
	
	velocity.y += 4
	velocity = move_and_slide(velocity)
