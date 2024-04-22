extends CanvasLayer


signal game_over
signal game_start


@export var player_lives: int = 3


var score: int = 0


func _ready() -> void:
	$GameOverLabel.hide()


func _on_ball_score() -> void:
	score += 1
	$ScoreLabel.text = 'Score: ' + str(score)


func _on_ball_out_of_bounds(body:Node2D) -> void:
	player_lives -= 1
	$PlayerLivesLabel.text = 'Lives: ' + str(player_lives)

	if player_lives == 0:
		game_over.emit()


func on_game_over() -> void:
	$GameOverLabel.show()
	$StartGameBtn.show()
	$ScoreLabel.text = 'Score: 0'

	
func _on_start_game_btn_pressed():
	game_start.emit()


func quit() -> void:
	game_over.emit()


func on_game_start() -> void: 
	score = 0
	player_lives = 3
	$PlayerLivesLabel.text = 'Lives: ' + str(player_lives)
	$ScoreLabel.text = 'Score: ' + str(score)
	$StartGameBtn.hide()
	$GameOverLabel.hide()
