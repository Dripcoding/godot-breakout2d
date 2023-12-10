extends RigidBody2D


@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60
@export var wall_collision_rotation: float = 60
@export var normal_velocity: float = 350


var collided_with_brick: bool = false
var collided_with_wall: bool = false
var is_out_of_bounds: bool = false

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
		position.x = 499
		position.y = 500
		linear_velocity.x = 0
		linear_velocity.y = 350
		is_out_of_bounds = false
	else:
		state.linear_velocity = state.linear_velocity.normalized() * normal_velocity

func _on_body_entered(body: Node):
	if body.is_in_group('brick'):
		body.queue_free()
		collided_with_brick = true
	elif body.is_in_group('wall'):
		collided_with_wall = true

func _on_ball_out_of_bounds(body: Node2D):
	is_out_of_bounds = true