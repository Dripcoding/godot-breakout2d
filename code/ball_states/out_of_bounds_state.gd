class_name OutOfBoundsState


var ball_position: Vector2
var ball_position_x_init: float
var ball_position_y_init: float
var ball_linear_velocity: Vector2
var ball_normal_velocity_y: float


func _int(
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


func handle_physics() -> void:
	ball_position.x = ball_position_x_init
	ball_position.y = ball_position_y_init
	ball_linear_velocity.x = Vector2.ZERO.x
	ball_linear_velocity.y = ball_normal_velocity_y