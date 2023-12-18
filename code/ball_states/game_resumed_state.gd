class_name GameResumedState


var ball_context: Ball


func _init(ball: Ball) -> void:
	ball_context = ball


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = get_previous_velocity()


func get_previous_velocity() -> Vector2:
	return ball_context.get_previous_velocity()
