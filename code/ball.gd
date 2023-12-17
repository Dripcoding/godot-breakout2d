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
var game_resumed_resource: Resource = preload("res://code/ball_states/game_resumed_state.gd")
var game_paused_resource: Resource = preload("res://code/ball_states/game_paused_state.gd")
var game_ready_resource: Resource = preload("res://code/ball_states/game_ready_state.gd")


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
var game_resumed_state = game_resumed_resource.new()
var game_paused_state = game_paused_resource.new()
var game_ready_state = game_ready_resource.new()


func _integrate_forces(state: PhysicsDirectBodyState2D):
	# ball_state.handle_physics(state)

	if ball_state != null:
		if collided_with_brick && ball_state is CollidedWithBrickState:
			collided_with_brick = false
			ball_state.handle_physics(state)
		elif collided_with_wall && ball_state is CollidedWithWallState:
			collided_with_wall = false
			ball_state.handle_physics(state)
		elif is_out_of_bounds && ball_state is OutOfBoundsState:
			is_out_of_bounds = false
			ball_state.handle_physics(self)
		elif game_over || game_quit:
			reset()
		elif game_resumed && ball_state is GameResumedState:
			game_paused = false
			game_resumed = false
			ball_state.handle_physics(self, previous_velocity)
		elif game_paused and linear_velocity != Vector2.ZERO && ball_state is GamePausedState:
			ball_state.handle_physics(self)
		else:	
			ball_state.handle_physics(state, normal_velocity)
		set_state(game_ready_state)

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
	set_state(game_paused_state)


func resume() -> void:
	game_resumed = true
	set_state(game_resumed_state)


func quit() -> void:
	game_quit = true
	reset()	


func reset() -> void:
	position.x = position_x_initial
	position.y = position_y_initial
	linear_velocity = Vector2.ZERO


func set_state(newState) -> void:
	ball_state = newState


func set_previous_velocity(newVelocity: Vector2) -> void:
	previous_velocity = newVelocity