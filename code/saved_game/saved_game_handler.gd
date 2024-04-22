class_name SavedGameHandler extends Node


signal loaded_game_data


@onready var hud = $"../Hud"


func save_game():
	var saved_game: SavedGame = SavedGame.new()

	saved_game.player_score = hud.score

	ResourceSaver.save(saved_game, "user://saved_game.tres")


func load_game():
	var saved_game: SavedGame = load("user://saved_game.tres") as SavedGame

	if saved_game.player_score:
		hud.highScore = saved_game.player_score
		print('high score is ', hud.highScore)
	loaded_game_data.emit()


func quit():
	save_game()


func on_game_over():
	save_game()


func on_game_start():
	load_game()
