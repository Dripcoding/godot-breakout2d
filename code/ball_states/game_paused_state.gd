class_name GamePausedState


var ball_context: Ball


func _init(ball: Ball):
	ball_context = ball


func handle_physics(state: PhysicsDirectBodyState2D):
	var context = get_ball_context()
	if state.linear_velocity != Vector2.ZERO:
		context.set_previous_velocity(context.linear_velocity)

	state.linear_velocity = Vector2.ZERO


func get_ball_context() -> Ball:
	return ball_context