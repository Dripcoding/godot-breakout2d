class_name OutOfBoundsState


var ball_position: Vector2
var ball_position_x_init: float
var ball_position_y_init: float
var ball_linear_velocity: Vector2
var ball_normal_velocity_y: float


func _init(
	position: Vector2,
	position_x_init: float,
	position_y_init: float,
	linear_velocity: Vector2,
	normal_velocity: float
) -> void:
	ball_position = position
	ball_position_x_init = position_x_init
	ball_position_y_init = position_y_init
	ball_linear_velocity = linear_velocity
	ball_normal_velocity_y = normal_velocity


func handle_physics(state: PhysicsDirectBodyState2D, ball: Ball) -> void:
	ball.position.x = get_ball_position_x_init()
	ball.position.y = get_ball_position_y_init()
	state.linear_velocity.x = Vector2.ZERO.x
	state.linear_velocity.y = get_ball_normal_velocity_y()


func get_ball_position() -> Vector2:
	return ball_position


func get_ball_position_x_init() -> float:
	return ball_position_x_init


func get_ball_position_y_init() -> float:
	return ball_position_y_init


func get_ball_linear_velocity() -> Vector2:
	return ball_linear_velocity


func get_ball_normal_velocity_y() -> float:	
	return ball_normal_velocity_y