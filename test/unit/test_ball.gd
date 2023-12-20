extends GutTest


var ball_scene = load("res://scenes/ball.tscn")


func before_each():
    var ball = ball_scene.instantiate()
    add_child(ball)


func after_each():
    var ball = get_node("Ball")
    remove_child(ball)


func test_ball_exists():
    var ball = get_node("Ball")
    assert_not_null(ball, "Ball does not exist")


func test_ball_has_correct_children():
    var ball = get_node("Ball")    

    # sprite 2d
    var sprite_2d = ball.get_child(0)
    assert_not_null(sprite_2d is Sprite2D, "Ball is not a Sprite2D child")
    assert_true(sprite_2d.visible, "Sprite2D is not visible")
    assert_true(sprite_2d.texture is Texture, "Sprite2D is not a Texture")
    
    # collision shape 2d
    var collision_shape_2d = ball.get_child(1)
    assert_not_null(collision_shape_2d is CollisionShape2D, "Ball is not a CollisionShape2D child")
    assert_true(collision_shape_2d.disabled == false, "CollisionShape2D is not disabled")
    assert_true(collision_shape_2d.visible, "CollisionShape2D is not visible")
    assert_true(collision_shape_2d.shape is CircleShape2D, "CollisionShape2D is not a CircleShape2D")


func test_ball_initial_position():
    var ball = get_node("Ball")
    var expected_position = Vector2(ball.position_x_initial, ball.position_y_initial)
    assert_eq(ball.position, expected_position, "Ball initial position is incorrect")


func test_ball_velocity():
    var ball = get_node("Ball")
    var expected_velocity = Vector2(0, 350)
    assert_eq(ball.linear_velocity, expected_velocity, "Ball initial velocity is incorrect")


func test_ball_state():
    var ball = get_node("Ball")
    assert_null(ball.ball_state, "Ball state is not null")


func test_ball_collides_with_brick():
    var ball = get_node("Ball")
    var brick = Node2D.new()
    brick.add_to_group("brick")
    ball._on_body_entered(brick)
    assert_eq(ball.ball_state, ball.brick_state, "Ball state is not brick_state after colliding with a brick")


func test_ball_collides_with_wall():
    var ball = get_node("Ball")
    var wall = Node2D.new()
    wall.add_to_group("wall")
    ball._on_body_entered(wall)
    assert_eq(ball.ball_state, ball.wall_state, "Ball state is not wall_state after colliding with a wall")


func test_ball_out_of_bounds():
    var ball = get_node("Ball")
    ball._on_ball_out_of_bounds(Node2D.new())
    assert_eq(ball.ball_state, ball.out_of_bounds_state, "Ball state is not out_of_bounds_state after going out of bounds")


func test_ball_pause():
    var ball = get_node("Ball")
    ball.pause()
    assert_eq(ball.ball_state, ball.game_paused_state, "Ball state is not game_paused_state after pausing")


func test_ball_resume():
    var ball = get_node("Ball")
    ball.resume()
    assert_eq(ball.ball_state, ball.game_resumed_state, "Ball state is not game_resumed_state after resuming")


func test_ball_quit():
    var ball = get_node("Ball")
    ball.quit()
    assert_eq(ball.ball_state, ball.game_terminal_state, "Ball state is not game_terminal_state after quitting")