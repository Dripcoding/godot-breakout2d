class_name GameReadyState


func handle_physics(state: PhysicsDirectBodyState2D, speed: float) -> void:
	state.linear_velocity = state.linear_velocity.normalized() * speed
