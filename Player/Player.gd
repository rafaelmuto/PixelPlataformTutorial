extends KinematicBody2D

export (int) var GRAVITY = 5
export (int) var ADDITIONAL_FALL_GRAVITY = 2
export (int) var JUMP_FORCE = -160
export (int) var JUMP_RELEASE_FORCE = -40
export (int) var MAX_SPEED = 75
export (int) var ACCELERATION = 10
export (int) var FRICTION = 10

var velocity = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Hello World!! from Player Scene...')
	animatedSprite.frames = load("res://Player/PlayerPinkSkin.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	apply_gravity()
	
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = 'idle'
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = 'run'
		if input.x > 0:
			animatedSprite.flip_h = true
		elif input.x < 0:
			animatedSprite.flip_h = false
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		animatedSprite.animation = 'jump'
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
			
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	
	if just_landed:
		animatedSprite.animation = 'run'
		animatedSprite.frame = 1
	
func apply_gravity():
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 300)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount: float):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
