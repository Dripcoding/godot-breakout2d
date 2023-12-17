class_name GamePausedState


func handle_physics(ball: Ball, state: PhysicsDirectBodyState2D):
	if state.linear_velocity != Vector2.ZERO:
		ball.set_previous_velocity(ball.linear_velocity)

	state.linear_velocity = Vector2.ZERO

