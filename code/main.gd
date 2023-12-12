extends Node


func _on_hud_game_over():
	propagate_call('on_game_over')
