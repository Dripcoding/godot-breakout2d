class_name CollidedWithWallState 


var collision_rotation: float


func _init(wall_collision_rotation: float) -> void:
	collision_rotation = wall_collision_rotation


func handle_physics(state: PhysicsDirectBodyState2D) -> void:
	var rotation_radian = deg_to_rad(get_wall_collision_rotation())
	state.apply_impulse(state.linear_velocity.rotated(rotation_radian))


func get_wall_collision_rotation() -> float:
	return collision_rotation