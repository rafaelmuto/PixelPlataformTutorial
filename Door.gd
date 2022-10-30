extends Area2D

export (String, FILE, "*.tscn") var target_level_path = ""

var player = false

# warning-ignore:unused_argument
func _process(delta):
	if not player: return
	if not player.is_on_floor(): return
	if Input.is_action_just_pressed("ui_accept"):
		if target_level_path.empty(): return
		got_to_next_level()

func got_to_next_level():
	Transitions.play_exit_transition()
	get_tree().paused = true
	yield(Transitions, "transition_completed")
	Transitions.play_enter_transition()
	yield(Transitions, "transition_completed")
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene(target_level_path)
	
func _on_Door_body_entered(body):
	if not body is PlayerCharacter: return
	player = body

func _on_Door_body_exited(body):
	if not body is PlayerCharacter: return
	player = null
