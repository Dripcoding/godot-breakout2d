class_name Ball extends RigidBody2D


signal score


@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60
@export var wall_collision_rotation: float = 60
@export var normal_velocity: float = 350
@export var position_x_initial: float = 499
@export var position_y_initial: float = 500


var previous_velocity: Vector2 = Vector2.ZERO


const collided_with_wall_resource: Resource = preload("res://code/ball_states/collided_with_wall_state.gd")
const out_of_bounds_resource: Resource = preload("res://code/ball_states/out_of_bounds_state.gd")		
const game_resumed_resource: Resource = preload("res://code/ball_states/game_resumed_state.gd")
const game_paused_resource: Resource = preload("res://code/ball_states/game_paused_state.gd")
const game_ready_resource: Resource = preload("res://code/ball_states/game_ready_state.gd")
const game_terminal_resource: Resource = preload("res://code/ball_states/game_terminal_state.gd")


var wall_state: CollidedWithWallState = collided_with_wall_resource.new(wall_collision_rotation)
var out_of_bounds_state: OutOfBoundsState = out_of_bounds_resource.new(
	position,
	position_x_initial,
	position_y_initial,
	linear_velocity,
	normal_velocity,
	self
)
var game_resumed_state: GameResumedState = game_resumed_resource.new(self)
var game_paused_state: GamePausedState = game_paused_resource.new(self)
var game_ready_state: GameReadyState = game_ready_resource.new(self, normal_velocity)
var game_terminal_state: GameTerminalState = game_terminal_resource.new(position_x_initial, position_y_initial, self)


var ball_state = game_ready_state
var collided_with_brick = false
var game_started = false
var game_was_over = false


func _ready() -> void:
	position.x = position_x_initial
	position.y = position_y_initial


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if game_was_over:
		reset_position(state)
		game_was_over = false

	if collided_with_brick:
		var impulse = state.linear_velocity.normalized().rotated(deg_to_rad(brick_collision_rotation)) * 350
		state.apply_impulse(impulse)
		collided_with_brick = false
		
	ball_state.handle_physics(state)
	set_state(game_ready_state)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group('brick') or body.is_in_group('bricks'):
		body.queue_free()
		score.emit()
		set_collided_with_brick(true)
	elif body.is_in_group('wall'):
		set_state(wall_state)


func _on_ball_out_of_bounds(body: Node2D) -> void:
	set_state(out_of_bounds_state)


func on_game_over() -> void:
	set_state(game_terminal_state)
	self.set_global_position(Vector2(position_x_initial, position_y_initial))
	self.set_linear_velocity(Vector2.ZERO)
	game_was_over = true
	# previous_velocity = Vector2.ZERO

func on_game_start() -> void:
	set_state(game_ready_state)


func pause() -> void:
	set_state(game_paused_state)


func resume() -> void:
	set_state(game_resumed_state)


func quit() -> void:
	set_state(game_terminal_state)
	self.set_global_position(Vector2(position_x_initial, position_y_initial))
	self.set_linear_velocity(Vector2.ZERO)
	game_was_over = true


func reset_position(state: PhysicsDirectBodyState2D) -> void:
	self.position.x = position_x_initial
	self.position.y = position_y_initial
	state.linear_velocity.x = Vector2.ZERO.x
	state.linear_velocity.y = normal_velocity


func set_state(newState) -> void:
	ball_state = newState


func set_previous_velocity(newVelocity: Vector2) -> void:
	previous_velocity = newVelocity


func get_previous_velocity() -> Vector2:
	return previous_velocity


func set_collided_with_brick(val: bool) -> void:
	collided_with_brick = val
