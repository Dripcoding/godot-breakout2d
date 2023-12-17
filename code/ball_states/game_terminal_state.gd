class_name GameTerminalState


var ball_position_x_init: float
var ball_position_y_init: float


func _init(position_x_init: float, position_y_init: float) -> void:
	ball_position_x_init = position_x_init
	ball_position_y_init = position_y_init


func handle_physics(state: PhysicsDirectBodyState2D, ball: Ball) -> void:
	ball.position.x = get_ball_position_x_init()	
	ball.position.y = get_ball_position_y_init()
	state.linear_velocity = Vector2.ZERO	


func get_ball_position_x_init() -> float:
	return ball_position_x_init


func get_ball_position_y_init() -> float:
	return ball_position_y_init
