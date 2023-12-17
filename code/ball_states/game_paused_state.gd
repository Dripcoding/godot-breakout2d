class_name GamePausedState


func handle_physics(ball: Ball):
	ball.set_previous_velocity((ball.linear_velocity))
	ball.linear_velocity = Vector2.ZERO
