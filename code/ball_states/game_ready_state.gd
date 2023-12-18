class_name GameReadyState


var ready_speed: float


func _init(speed: float):
	ready_speed = speed


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.normalized() * get_ready_speed()


func get_ready_speed() -> float:
	return ready_speed
