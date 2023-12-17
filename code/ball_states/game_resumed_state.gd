class_name GameResumedState


func handle_physics(state: PhysicsDirectBodyState2D, previous: Vector2) -> void:
	state.linear_velocity = previous
