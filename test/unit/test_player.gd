extends GutTest

var player_scene = load("res://scenes/player.tscn")


func before_each():
	var player = player_scene.instantiate()
	add_child(player)


func after_each():
	var player = get_node("Player")
	autoqfree(player)
	assert_no_new_orphans()


func test_player_exists():
	var player = get_node("Player")
	assert_not_null(player, "Player does not exist")


func test_player_has_correct_children():
	var player = get_node("Player")

	# character body 2d
	var character_body_2d = player.get_child(0)
	assert_true(character_body_2d is CharacterBody2D, "Player does not have characterBody2d child")
	assert_true(
		character_body_2d.visible, "Player characterBody2d child gravity scale is incorrect"
	)

	# collision shape 2d
	var collision_shape_2d = character_body_2d.get_child(0)
	assert_true(
		collision_shape_2d is CollisionShape2D, "Player does not have collisionShape2d child"
	)
	assert_true(
		collision_shape_2d.shape is RectangleShape2D,
		"Player collisionShape2d child does not have RectangleShape2D shape"
	)
	assert_true(
		collision_shape_2d.disabled == false, "Player collisionShape2d child shape is disabled"
	)
	assert_true(collision_shape_2d.visible == true, "Player collisionShape2d child is not visible")


func test_player_initial_position():
	var player = get_node("Player")
	var expected_position = Vector2(player.position_x_initial, player.position_y_initial)
	assert_eq(player.position, expected_position, "Player initial position is incorrect")


func test_player_speed():
	var player = get_node("Player")
	var expected_speed: float = 300
	assert_eq(player.speed, expected_speed, "Player speed is incorrect")


func test_player_did_not_move():
	var player = get_node("Player")
	var initial_position = player.position
	gut.simulate(player, 1, 1)
	var final_position = player.position
	assert_eq(initial_position, final_position, "Player moved")


func test_player_moved_right():
	var player = get_node("Player")
	player.set_pause_game(false)
	var initial_position = player.position
	Input.action_press("move_right")
	gut.simulate(player, 1, 1)
	Input.action_release("move_right")
	var final_position = player.position
	assert_true(final_position.x > initial_position.x, "Player did not move right")


func test_player_moved_left():
	var player = get_node("Player")
	player.set_pause_game(false)
	var initial_position = player.position
	Input.action_press("move_left")
	gut.simulate(player, 1, 1)
	Input.action_release("move_left")
	var final_position = player.position
	assert_true(final_position.x < initial_position.x, "Player did not move left")


func test_player_pause():
	var player = get_node("Player")
	player.pause()
	assert_true(player.pause_game, "Player did not pause")


func test_player_resume():
	var player = get_node("Player")
	player.resume()
	assert_false(player.pause_game, "Player did not resume")


func test_player_reset_position():
	var player = get_node("Player")
	player.on_game_over()
	var expected_position = Vector2(player.position_x_initial, player.position_y_initial)
	assert_eq(player.position, expected_position, "Player position did not reset")
