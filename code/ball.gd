extends RigidBody2D


signal score


@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60
@export var wall_collision_rotation: float = 60
@export var normal_velocity: float = 350
@export var position_x_initial: float = 499
@export var position_y_initial: float = 500


var collided_with_brick: bool = false
var collided_with_wall: bool = false
var is_out_of_bounds: bool = false
var game_over: bool = false
var game_paused: bool = false
var game_resumed: bool = false
var previous_velocity: Vector2 = Vector2.ZERO


func _integrate_forces(state: PhysicsDirectBodyState2D):
	if collided_with_brick:
		collided_with_brick = false
		var rotation_radian = deg_to_rad(brick_collision_rotation)
		state.apply_impulse(state.linear_velocity.rotated(rotation_radian))
	elif collided_with_wall:
		collided_with_wall = false
		var rotation_radian = deg_to_rad(wall_collision_rotation)
		state.apply_impulse(state.linear_velocity.rotated(rotation_radian))
	elif is_out_of_bounds:
		is_out_of_bounds = false
		position.x = position_x_initial
		position.y = position_y_initial
		linear_velocity.x = Vector2.ZERO.x
		linear_velocity.y = normal_velocity
	elif game_over:
		position.x = position_x_initial
		position.y = position_y_initial
		linear_velocity = Vector2.ZERO
	elif game_paused and linear_velocity != Vector2.ZERO:
		game_paused = false
		previous_velocity = linear_velocity
		linear_velocity = Vector2.ZERO
	elif game_resumed:
		game_paused = false # todo: debug this
		game_resumed = false
		linear_velocity = previous_velocity	
	else:
		state.linear_velocity = state.linear_velocity.normalized() * normal_velocity


func _on_body_entered(body: Node):
	if body.is_in_group('brick'):
		body.hide()
		collided_with_brick = true
		score.emit()
	elif body.is_in_group('wall'):
		collided_with_wall = true


func _on_ball_out_of_bounds(body: Node2D):
	is_out_of_bounds = true


func on_game_over():
	game_over = true
	position.x = position_x_initial
	position.y = position_y_initial
	linear_velocity = Vector2.ZERO


func pause():
	game_paused = true


func resume():
	# game_paused = false
	game_resumed = true
