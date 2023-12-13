extends Node


func _process(delta):
	if Input.is_action_pressed('pause'):
		pause_game()


func pause_game():
	propagate_call('pause')


func _on_game_over():
	propagate_call('on_game_over')
