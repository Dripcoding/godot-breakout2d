extends GutTest


var main_scene = load("res://scenes/main.tscn")


func before_each():
    var main = main_scene.instantiate()
    add_child(main)
    var player = main.get_node("Player")
    var ball = main.get_node("Ball")
    var brick_grid = main.get_node("BrickGrid")
    var hud = main.get_node("Hud")


func after_each():
    var main = get_node("Main")
    var brick_grid = get_node("Main/BrickGrid")
    assert_not_null(brick_grid, "BrickGrid node does not exist")
    
    for brick in brick_grid.bricks:
        brick.free()
    main.free()
    assert_no_new_orphans()


func test_game_starts_in_ready_state():
    var ball = get_node("Main/Ball")
    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")


func test_player_pausing_game():
    var ball = get_node("Main/Ball")
    var player = get_node("Main/Player")
    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

    var player_position_1 = move_left()    
    pause_game()
    var player_position_2 = move_left()

    assert_true(player.pause_game, "Player should be paused")
    assert_eq(player_position_1, player_position_2, "Player should not move while game is paused")
    assert_true(ball.ball_state is GamePausedState, "Game should be in paused state")


func test_player_quitting_game():
    var ball = get_node("Main/Ball")
    var brick_grid = get_node("Main/BrickGrid")
    var hud = get_node("Main/Hud")
    var brick1 = brick_grid.get_node("Brick")
    var brick2 = brick_grid.get_node("Brick2")
    var brick3 = brick_grid.get_node("Brick3")

    watch_signals(ball)
    watch_signals(hud)

    collide_with_brick(brick1)
    collide_with_brick(brick2)
    collide_with_brick(brick3)

    quit_game()

    assert_eq(hud.score, 3)
    assert_signal_emitted(ball, "score", "Score signal not emitted")
    assert_signal_emit_count(ball, "score", 3, "Score signal not emitted 3 times")
    assert_true(ball.ball_state is GameTerminalState, "Game should be in terminal state")
    assert_signal_emitted(hud, "game_over", "Game over signal not emitted")


func test_player_resuming_game():
    var player = get_node("Main/Player")
    var ball = get_node("Main/Ball")

    pause_game()
    resume_game()

    var player_position_1 = move_left()
    var player_position_2 = move_left()

    assert_false(player.pause_game, "Player should not be paused")
    assert_ne(player_position_1, player_position_2, "Player should move after game is resumed")
    assert_true(ball.ball_state is GameResumedState, "Game should be in resumed state")


# test player losing game


# test player scoring


# test player losing life





# ====== HELPER FUNCTIONS ======
func pause_game():
    var main = get_node("Main")
    Input.action_press("pause")
    gut.simulate(main, 1, 1)
    Input.action_release("pause")


func resume_game():
    var main = get_node("Main")
    Input.action_press("resume")
    gut.simulate(main, 1, 1)
    Input.action_release("resume")


func quit_game():
    var main = get_node("Main")
    Input.action_press("quit")
    gut.simulate(main, 1, 1)
    Input.action_release("quit")


func move_left() -> Vector2:
    var main = get_node("Main")
    var player = get_node("Main/Player")
    Input.action_press("move_left")
    gut.simulate(main, 1, 1)
    Input.action_release("move_left")
    return player.position


func collide_with_brick(brick) -> void:
    var ball = get_node("Main/Ball")
    ball._on_body_entered(brick)
 