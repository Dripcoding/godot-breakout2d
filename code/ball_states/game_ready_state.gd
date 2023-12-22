class_name GameReadyState


var speed: float


func _init(normal_speed: float) -> void:
	speed = normal_speed


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = state.linear_velocity.normalized() * get_speed()


func get_speed() -> float:
	return speed
