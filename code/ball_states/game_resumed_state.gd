class_name GameResumedState


func handle_physics(ball: Ball, previous: Vector2) -> void:
	ball.linear_velocity = previous
