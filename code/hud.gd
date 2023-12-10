extends CanvasLayer


@export var playerLives: int = 3


var score: int = 0


func _on_ball_score():
	score += 1
	$ScoreLabel.text = 'Score: ' + str(score)


func _on_out_of_bounds_area_out_of_bounds():
	playerLives -= 1
	$PlayerLivesLabel.text = 'Lives: ' + str(playerLives)
