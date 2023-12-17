class_name Ball extends RigidBody2D


signal score


@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60
@export var wall_collision_rotation: float = 60
@export var normal_velocity: float = 350
@export var position_x_initial: float = 499
@export var position_y_initial: float = 500


var collided_with_brick_resource: Resource = preload("res://code/ball_states/collided_with_brick_state.gd")
var collided_with_wall_resource: Resource = preload("res://code/ball_states/collided_with_wall_state.gd")
var out_of_bounds_resource: Resource = preload("res://code/ball_states/out_of_bounds_state.gd")		


var collided_with_brick: bool = false
var collided_with_wall: bool = false
var is_out_of_bounds: bool = false
var game_over: bool = false
var game_paused: bool = false
var game_resumed: bool = false
var game_quit: bool = false
var previous_velocity: Vector2 = Vector2.ZERO


var ball_state
var brick_state = collided_with_brick_resource.new(brick_collision_rotation)
var wall_state = collided_with_wall_resource.new(wall_collision_rotation)
var out_of_bounds_state = out_of_bounds_resource.new(
	position,
	position_x_initial,
	position_y_initial,
	linear_velocity,
	normal_velocity
)


func _integrate_forces(state: PhysicsDirectBodyState2D):
	# ball_state.handle_physics(state)

	if ball_state != null:
		if collided_with_brick:
			collided_with_brick = false
			ball_state.handle_physics(state)
		elif collided_with_wall:
			collided_with_wall = false
			ball_state.handle_physics(state)
		elif is_out_of_bounds:
			is_out_of_bounds = false
			out_of_bounds_state.handle_physics(self)
		elif game_over || game_quit:
			reset()
		elif game_resumed:
			game_paused = false
			game_resumed = false
			linear_velocity = previous_velocity	
		elif game_paused and linear_velocity != Vector2.ZERO:
			previous_velocity = linear_velocity
			linear_velocity = Vector2.ZERO
		else:
			state.linear_velocity = state.linear_velocity.normalized() * normal_velocity


func _on_body_entered(body: Node) -> void:
	if body.is_in_group('brick'):
		body.hide()
		collided_with_brick = true
		score.emit()
		set_state(brick_state)
	elif body.is_in_group('wall'):
		collided_with_wall = true
		set_state(wall_state)


func _on_ball_out_of_bounds(body: Node2D) -> void:
	is_out_of_bounds = true
	set_state(out_of_bounds_state)


func on_game_over() -> void:
	game_over = true
	position.x = position_x_initial
	position.y = position_y_initial
	linear_velocity = Vector2.ZERO


func pause() -> void:
	game_paused = true


func resume() -> void:
	game_resumed = true


func quit() -> void:
	game_quit = true
	reset()	


func reset() -> void:
	position.x = position_x_initial
	position.y = position_y_initial
	linear_velocity = Vector2.ZERO


func set_state(newState) -> void:
	ball_state = newState
