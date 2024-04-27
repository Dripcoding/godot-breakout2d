extends GutTest

var brick_grid_scene = load("res://scenes/brick_grid.tscn")


func before_each():
	var brick_grid = brick_grid_scene.instantiate()
	add_child(brick_grid)


func after_each():
	var brick_grid = get_node("BrickGrid")
	autoqfree(brick_grid)
	assert_no_new_orphans()


func test_brick_grid_node_exists():
	var brick_grid = get_node("BrickGrid")

	assert_not_null(brick_grid, "The BrickGrid node does not exist")


func test_number_of_bricks():
	var brick_grid = get_node("BrickGrid")
	var expected = 15
	var actual = brick_grid.get_child_count()

	assert_eq(actual, expected, "The number of bricks in the grid is incorrect")


func test_brick_grid_has_correct_children():
	var brick_grid = get_node("BrickGrid")

	for brick in brick_grid.get_children():
		# assert brick properties
		assert_true(brick is StaticBody2D, "Brick is not a StaticBody2D")
		assert_true(brick.is_in_group("brick"), "Brick is not in the brick group")
		assert_true(brick.visible == true, "Brick is not visible")
		assert_true(
			brick.physics_material_override.bounce == 1.0, "Brick does not have a bounce of 1.0"
		)
		assert_true(
			brick.physics_material_override.friction == 0.0, "Brick does not have a friction of 0.0"
		)
		assert_true(
			brick.unique_name_in_owner == true, "Brick does not have a unique name in owner"
		)

		# assert collisionShape2d child properties
		var collision_shape_2d = brick.get_child(0)
		assert_true(
			collision_shape_2d.get_shape() is RectangleShape2D,
			"Brick does not have a rectangle shape"
		)
		assert_true(
			collision_shape_2d is CollisionShape2D, "Brick does not have a CollisionShape2d child"
		)
		assert_true(collision_shape_2d.disabled == false, "CollisionShape2d is disabled")
		assert_true(collision_shape_2d.visible == true, "CollisionShape2d is not visible")

		# assert sprite2d child properties
		var sprite_2d = brick.get_child(1)
		assert_true(sprite_2d is Sprite2D, "Brick is not a Sprite2D child")
		assert_true(sprite_2d.visible == true, "Sprite2D is not visible")
		assert_true(sprite_2d.texture is Texture, "Sprite2D does not have a texture")
