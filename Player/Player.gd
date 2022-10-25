extends KinematicBody2D
class_name PlayerCharacter

export (Resource) var moveData

var velocity = Vector2.ZERO
enum { MOVE, CLIMB }
var state = MOVE

onready var animatedSprite = $AnimatedSprite
onready var ladderCheck = $LadderCheck
onready var jumpBufferTimer = $JumpBufferTimer
onready var coyoteJumpTimer = $CoyoteJumpTimer
onready var remoteTransform2d = $RemoteTransform2D


var double_jump
var buffered_jump = false
var coyote_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.frames = load("res://Player/Skin/PlayerGreenSkin.tres")
	moveData = moveData as MovementData
	double_jump = moveData.DOUBLE_JUMP_COUNT

func _physics_process(_delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)


func connect_camera(camera: Camera2D) -> void:
	var camera_path = camera.get_path()
	remoteTransform2d.remote_path = camera_path
	

func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"): state = CLIMB
		
	apply_gravity()
	
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = 'idle'
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = 'run'
		animatedSprite.flip_h = input.x > 0
		
	if is_on_floor():
		double_jump = moveData.DOUBLE_JUMP_COUNT
	else:
		animatedSprite.animation = 'jump'

	if can_jump():
		input_jump()
	else:
		# jump release
		if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
			velocity.y = moveData.JUMP_RELEASE_FORCE
			
		# double jump
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.JUMP_FORCE
			double_jump -= 1
			# this animation is waaay too fast...
			# animatedSprite.animation = 'idle'
			# animatedSprite.frame = 0
		
		# buffer jump
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jumpBufferTimer.start()
		
		# fast fall
		if velocity.y > 0:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
	
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	# move_and_slide() actualy moves the Player
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = 'run'
		animatedSprite.frame = 1
		
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()


func climb_state(input):
	if not is_on_ladder(): state = MOVE
	
	if input.length() != 0:
		animatedSprite.animation = 'run'
	else: 
		animatedSprite.animation = 'idle'
		
	velocity = input * moveData.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)


func player_die():
	SoundPlayer.play_sound(SoundPlayer.HIT)
	queue_free()
	Events.emit_signal("player_died")


func can_jump():
	return is_on_floor() or coyote_jump


func input_jump():
	if Input.is_action_just_pressed("ui_up") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		buffered_jump = false
		coyote_jump = false


func is_on_ladder():
	return ladderCheck.is_colliding()


func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)


func apply_acceleration(amount: float):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)


func _on_JumpBufferTimer_timeout():
	buffered_jump = false


func _on_CoyoteJumpTimer_timeout():
	pass # Replace with function body.
