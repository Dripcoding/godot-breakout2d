extends RigidBody2D

@export var brick_collision_rotation: float = 60
@export var player_collision_rotation: float = 60

@onready var ball: RigidBody2D = %Ball

var collided_with_brick: bool = false

func _integrate_forces(state: PhysicsDirectBodyState2D):
	if collided_with_brick:
		collided_with_brick = false
		var rotation_radian = deg_to_rad(brick_collision_rotation)
		state.apply_impulse(state.linear_velocity.rotated(rotation_radian))

func _on_body_entered(body: Node):
	if body.is_in_group('brick'):
		body.queue_free()
		collided_with_brick = true