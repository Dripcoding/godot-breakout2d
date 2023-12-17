class_name CollidedWithBrickState


var collision_rotation: float


func _init(brick_collision_rotation: float) -> void:
	print('collided with brick state init')
	collision_rotation = brick_collision_rotation


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	print('handling brick collision physics')
	var rotation_radian = deg_to_rad(get_brick_collision_rotation())
	state.apply_impulse(state.linear_velocity.rotated(rotation_radian))


func get_brick_collision_rotation() -> float:
	return collision_rotation
