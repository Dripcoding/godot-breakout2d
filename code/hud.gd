extends CanvasLayer


signal game_over


@export var playerLives: int = 3


var score: int = 0


func _ready() -> void:
	$GameOverLabel.hide()


func _on_ball_score() -> void:
	score += 1
	$ScoreLabel.text = 'Score: ' + str(score)


func _on_ball_out_of_bounds(body:Node2D) -> void:
	playerLives -= 1
	$PlayerLivesLabel.text = 'Lives: ' + str(playerLives)

	if playerLives == 0:
		game_over.emit()


func _on_game_over() -> void:
	$GameOverLabel.show()
	$ScoreLabel.text = 'Score: 0'

# todo: impl quit