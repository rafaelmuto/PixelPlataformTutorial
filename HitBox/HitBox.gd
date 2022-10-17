extends Area2D

	
func _on_HitBox_body_entered(body):
	print('HitBox_body_entered: ' + body.name)
	if body is PlayerCharacter:
		get_tree().reload_current_scene()
#		body.queue_free()
