extends CanvasLayer


var score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print('HUD ready')


func _on_ball_score():
	score += 1
	$ScoreLabel.text = 'Score: ' + str(score)
