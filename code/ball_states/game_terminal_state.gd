class_name GameTerminalState


var ball_position_x_init: float
var ball_position_y_init: float
var ball_context: Ball


func _init(position_x_init: float, position_y_init: float, ball: Ball) -> void:
	ball_position_x_init = position_x_init
	ball_position_y_init = position_y_init
	ball_context = ball


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	var context = get_ball_context()
	context.position.x = get_ball_position_x_init()	
	context.position.y = get_ball_position_y_init()
	state.linear_velocity = Vector2.ZERO	


func get_ball_position_x_init() -> float:
	return ball_position_x_init


func get_ball_position_y_init() -> float:
	return ball_position_y_init


func get_ball_context() -> Ball:
	return ball_context
