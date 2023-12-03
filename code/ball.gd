extends RigidBody2D

@onready var ball: RigidBody2D = %Ball

var collided_with_brick: bool = false

func _integrate_forces(state):
	if collided_with_brick:
		print('collided with brick')

func _on_body_entered(body:Node):
	if body.is_in_group('brick'):
		body.queue_free()
		collided_with_brick = true
