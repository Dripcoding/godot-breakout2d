class_name GameResumedState


var ball_context: Ball


func _init(ball: Ball) -> void:
	ball_context = ball


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity == Vector2.ZERO:
		state.linear_velocity = get_ball_context().get_previous_velocity()


func get_ball_context() -> Ball:
	return ball_context
