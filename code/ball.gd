class_name Ball extends RigidBody2D


signal score


@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60
@export var wall_collision_rotation: float = 60
@export var normal_velocity: float = 350
@export var position_x_initial: float = 499
@export var position_y_initial: float = 500


var previous_velocity: Vector2 = Vector2.ZERO
var ball_state


const collided_with_brick_resource: Resource = preload("res://code/ball_states/collided_with_brick_state.gd")
const collided_with_wall_resource: Resource = preload("res://code/ball_states/collided_with_wall_state.gd")
const out_of_bounds_resource: Resource = preload("res://code/ball_states/out_of_bounds_state.gd")		
const game_resumed_resource: Resource = preload("res://code/ball_states/game_resumed_state.gd")
const game_paused_resource: Resource = preload("res://code/ball_states/game_paused_state.gd")
const game_ready_resource: Resource = preload("res://code/ball_states/game_ready_state.gd")
const game_terminal_resource: Resource = preload("res://code/ball_states/game_terminal_state.gd")


var brick_state = collided_with_brick_resource.new(brick_collision_rotation)
var wall_state = collided_with_wall_resource.new(wall_collision_rotation)
var out_of_bounds_state = out_of_bounds_resource.new(
	position,
	position_x_initial,
	position_y_initial,
	linear_velocity,
	normal_velocity,
	self
)
var game_resumed_state = game_resumed_resource.new(self)
var game_paused_state = game_paused_resource.new(self)
var game_ready_state = game_ready_resource.new(normal_velocity)
var game_terminal_state = game_terminal_resource.new(position_x_initial, position_y_initial, self)


func _integrate_forces(state: PhysicsDirectBodyState2D):
	if !ball_state:
		return
	
	ball_state.handle_physics(state)
	set_state(game_ready_state)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group('brick'):
		body.hide()
		score.emit()
		set_state(brick_state)
	elif body.is_in_group('wall'):
		set_state(wall_state)


func _on_ball_out_of_bounds(body: Node2D) -> void:
	set_state(out_of_bounds_state)


func on_game_over() -> void:
	set_state(game_terminal_state)


func pause() -> void:
	set_state(game_paused_state)


func resume() -> void:
	set_state(game_resumed_state)


func quit() -> void:
	set_state(game_terminal_state)


func set_state(newState) -> void:
	ball_state = newState


func set_previous_velocity(newVelocity: Vector2) -> void:
	previous_velocity = newVelocity


func get_previous_velocity() -> Vector2:
	return previous_velocity