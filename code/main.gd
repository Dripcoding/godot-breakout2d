extends Node


func _process(delta) -> void:
	if Input.is_action_pressed('pause'):
		pause_game()
	elif Input.is_action_just_pressed('resume'):
		resume_game()
	elif Input.is_action_just_pressed('quit'):
		quit_game()


func pause_game() -> void:
	propagate_call('pause')


func resume_game() -> void:
	propagate_call('resume')


func quit_game() -> void:
	propagate_call('quit')


func _on_game_over():
	propagate_call('on_game_over')
