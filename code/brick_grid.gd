extends Node2D


func on_game_over():
	for child in get_children():
		child.show()	
