extends KinematicBody2D


export (int) var SPEED = 25

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var ledgeCheckRight = $LedgeCheckRight
onready var ledgeCheckLeft = $LedgeCheckLeft


func _physics_process(_delta):
	
	if is_on_wall() or not ledgeCheckRight.is_colliding() or not ledgeCheckLeft.is_colliding():
		direction *= -1
	
	$AnimatedSprite.flip_h = direction.x > 0
	
	velocity = direction * SPEED
	move_and_slide(velocity, Vector2.UP)
