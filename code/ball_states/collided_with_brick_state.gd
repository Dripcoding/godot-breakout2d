class_name CollidedWithBrickState


var collision_rotation: float


func _init(brick_collision_rotation: float) -> void:
	collision_rotation = brick_collision_rotation


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	var rotation_radian = deg_to_rad(get_brick_collision_rotation())
	state.apply_impulse(state.linear_velocity.rotated(rotation_radian))


func get_brick_collision_rotation() -> float:
	return collision_rotation
