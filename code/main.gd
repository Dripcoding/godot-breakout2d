extends Node


func _process(delta):
	if Input.is_action_pressed('pause'):
		pause_game()
	elif Input.is_action_just_pressed('resume'):
		resume_game()


func pause_game():
	propagate_call('pause')


func resume_game():
	print('resume_game')
	propagate_call('resume')


func _on_game_over():
	propagate_call('on_game_over')
