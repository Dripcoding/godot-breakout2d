extends RigidBody2D

@export var ball_rotation_degrees: float = 60

@onready var ball: RigidBody2D = %Ball

var collided_with_brick: bool = false

func _integrate_forces(state):
	if collided_with_brick:
		collided_with_brick = false
		state.apply_impulse(state.linear_velocity.rotated(deg_to_rad(60)))

func _on_body_entered(body:Node):
	if body.is_in_group('brick'):
		body.queue_free()
		collided_with_brick = true
