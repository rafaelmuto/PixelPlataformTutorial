extends KinematicBody2D
class_name PlayerCharacter

export (Resource) var moveData

var velocity = Vector2.ZERO

onready var animatedSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	print('Hello World!! from Player Scene...')
	animatedSprite.frames = load("res://Player/Skin/PlayerGreenSkin.tres")

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
		animatedSprite.flip_h = input.x > 0

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = moveData.JUMP_FORCE
	else:
		animatedSprite.animation = 'jump'
		if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
			velocity.y = moveData.JUMP_RELEASE_FORCE
			
		if velocity.y > 0:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
	
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	
	if just_landed:
		animatedSprite.animation = 'run'
		animatedSprite.frame = 1
	
func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	
func apply_acceleration(amount: float):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)
