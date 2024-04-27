class_name GameReadyState

var ball_context: Ball
var speed: float


func _init(ball: Ball, normal_speed: float) -> void:
	ball_context = ball
	speed = normal_speed


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity == Vector2.ZERO:
		ball_context.set_global_position(
			Vector2(get_ball_context().get_position().x, get_ball_context().get_position().y)
		)
		state.linear_velocity = Vector2(0, 350)
	state.linear_velocity = state.linear_velocity.normalized() * get_speed()


func get_speed() -> float:
	return speed


func get_ball_context() -> Ball:
	return ball_context
