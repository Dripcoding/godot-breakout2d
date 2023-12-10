extends CanvasLayer


@export var playerLives: int = 3


var score: int = 0


func _ready():
	$GameOverLabel.hide()


func _on_ball_score():
	score += 1
	$ScoreLabel.text = 'Score: ' + str(score)


func _on_ball_out_of_bounds(body:Node2D):
	playerLives -= 1
	$PlayerLivesLabel.text = 'Lives: ' + str(playerLives)

	if playerLives == 0:
		$GameOverLabel.show()	
