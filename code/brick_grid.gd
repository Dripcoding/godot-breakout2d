extends Node2D


func reset_bricks():
	for child in get_children():
		child.show()


func on_game_over():
	reset_bricks()	


func quit():
	reset_bricks()