extends Area2D

	
func _on_HitBox_body_entered(body):
	#print('HitBox: ' + body.name)
	if body is PlayerCharacter:
		body.player_die()
