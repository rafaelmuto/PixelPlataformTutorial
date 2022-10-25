extends Area2D

onready var animatedSprite = $AnimatedSprite

var active = true

func _on_CheckPoint_body_entered(body):
	if not body is PlayerCharacter: return
	if not active: return
	animatedSprite.play("checked")
	active = false
	Events.emit_signal("hit_checkpoint", position)
