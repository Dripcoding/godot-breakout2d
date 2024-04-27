extends GutTest

var main_scene = load("res://scenes/main.tscn")


func before_each():
    var main = main_scene.instantiate()
    add_child(main)
    clear_high_score()


func after_each():
    var main = get_node("Main")
    var brick_grid = get_node("Main/BrickGrid")
    assert_not_null(brick_grid, "BrickGrid node does not exist")

    for brick in brick_grid.bricks:
        brick.free()

    add_child_autofree(main)
    assert_no_new_orphans()


func test_utilities_node_exists():
    var utilities = get_node("Main/Utilities")
    assert_not_null(utilities, "Utilities node does not exist")


func test_game_starts_in_ready_state():
    var ball = get_node("Main/Ball")
    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")


func test_player_pausing_game():
    var main = get_node("Main")
    var ball = get_node("Main/Ball")
    var player = get_node("Main/Player")
    var hud = get_node("Main/Hud")
    var player_lives_label = get_node("Main/Hud/PlayerLivesLabel")
    var player_score_label = get_node("Main/Hud/ScoreLabel")

    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

    var player_position_1 = move_left()
    pause_game()
    var player_position_2 = move_left()

    assert_eq(main.get_tree().paused, true, "Game should be paused")
    assert_true(player.pause_game, "Player should be paused")
    assert_eq(player_position_1, player_position_2, "Player should not move while game is paused")
    assert_eq(hud.player_lives, 3, "Player should not lose a life while game is paused")
    assert_eq(player_lives_label.text, "Lives: 3", "Player lives label should be visible")
    assert_eq(player_score_label.text, "Score: 0", "Player score label should be visible")
    assert_true(ball.ball_state is GamePausedState, "Game should be in paused state")


func test_player_quitting_game():
    var ball = get_node("Main/Ball")
    var brick_grid = get_node("Main/BrickGrid")
    var hud = get_node("Main/Hud")
    var player_lives_label = get_node("Main/Hud/PlayerLivesLabel")
    var player_score_label = get_node("Main/Hud/ScoreLabel")
    var brick1 = brick_grid.get_node("Brick")
    var brick2 = brick_grid.get_node("Brick2")
    var brick3 = brick_grid.get_node("Brick3")

    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

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
    assert_eq(hud.player_lives, 3, "Player should not lose a life")
    assert_eq(player_lives_label.text, "Lives: 3", "Player lives label should be visible")
    assert_eq(player_score_label.text, "Score: 0", "Player score label should be visible")
    assert_signal_emitted(hud, "game_over", "Game over signal not emitted")


func test_player_cannot_move_after_quitting_game():
    var ball = get_node("Main/Ball")

    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

    quit_game()
    var player_position_1 = move_left()
    var player_position_2 = move_left()
    assert_eq(player_position_1, player_position_2, "Player should not move while game is paused")


func test_player_resuming_game():
    var main = get_node("Main")
    var player = get_node("Main/Player")
    var ball = get_node("Main/Ball")
    var hud = get_node("Main/Hud")
    var player_lives_label = get_node("Main/Hud/PlayerLivesLabel")
    var player_score_label = get_node("Main/Hud/ScoreLabel")
    var game_start_btn = get_node("Main/Hud/StartGameBtn")

    game_start_btn.emit_signal("pressed")

    pause_game()
    resume_game()

    var player_position_1 = move_left()
    var player_position_2 = move_left()

    assert_true(main.get_tree().paused == false, "Game should not be paused")
    assert_false(player.pause_game, "Player should not be paused")
    assert_ne(player_position_1, player_position_2, "Player should move after game is resumed")
    assert_eq(hud.player_lives, 3, "Player should not lose a life while game is resumed")
    assert_eq(hud.score, 0)
    assert_eq(player_lives_label.text, "Lives: 3", "Player lives label should be visible")
    assert_eq(player_score_label.text, "Score: 0", "Player score label should be visible")
    assert_true(ball.ball_state is GameResumedState, "Game should be in resumed state")


func test_player_losing_game():
    var ball = get_node("Main/Ball")
    var brick_grid = get_node("Main/BrickGrid")
    var hud = get_node("Main/Hud")
    var player_lives_label = get_node("Main/Hud/PlayerLivesLabel")
    var player_score_label = get_node("Main/Hud/ScoreLabel")
    var game_over_label = get_node("Main/Hud/GameOverLabel")
    var brick1 = brick_grid.get_node("Brick")
    var brick2 = brick_grid.get_node("Brick2")
    var brick3 = brick_grid.get_node("Brick3")
    var out_of_bounds_area = get_node("Main/OutOfBoundsArea")

    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

    watch_signals(ball)
    watch_signals(hud)
    watch_signals(out_of_bounds_area)

    collide_with_brick(brick1)
    collide_with_brick(brick2)
    collide_with_brick(brick3)

    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()

    assert_eq(hud.score, 3)
    assert_eq(hud.player_lives, 0, "Player should have no lives left")
    assert_eq(player_lives_label.text, "Lives: 0", "Player lives label should be visible")
    assert_eq(player_score_label.text, "Score: 0", "Player score label should be visible")
    assert_eq(game_over_label.text, "Game Over", "Game Over label should be visible")
    assert_signal_emitted(ball, "score", "Score signal not emitted")
    assert_signal_emit_count(ball, "score", 3, "Score signal not emitted 3 times")
    assert_true(ball.ball_state is GameTerminalState, "Game should be in terminal state")
    assert_signal_emitted(hud, "game_over", "Game over signal not emitted")
    assert_signal_emit_count(hud, "game_over", 1, "Game over signal not emitted once")
    assert_signal_emitted(out_of_bounds_area, "body_entered", "Body entered signal not emitted")
    assert_signal_emit_count(
        out_of_bounds_area, "body_entered", 3, "Body entered signal not emitted 3 times"
    )


func test_player_cannot_move_after_game_over():
    var brick_grid = get_node("Main/BrickGrid")
    var ball = get_node("Main/Ball")
    var brick1 = brick_grid.get_node("Brick")
    var brick2 = brick_grid.get_node("Brick2")
    var brick3 = brick_grid.get_node("Brick3")

    assert_true(ball.ball_state is GameReadyState, "Game should start in ready state")

    collide_with_brick(brick1)
    collide_with_brick(brick2)
    collide_with_brick(brick3)

    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()

    var player_position_1 = move_player_left()
    var player_position_2 = move_player_left()
    assert_eq(player_position_1, player_position_2, "Player should not move after game is over")


func test_player_starting_game():
    var main = get_node("Main")
    var hud = get_node("Main/Hud")
    var start_game_btn = get_node("Main/Hud/StartGameBtn")
    var player_lives_label = get_node("Main/Hud/PlayerLivesLabel")
    var score_label = get_node("Main/Hud/ScoreLabel")
    watch_signals(hud)

    assert_true(main.get_tree().paused, "Game should be paused")
    assert_true(start_game_btn.visible, "Start game button should be visible")
    assert_eq(player_lives_label.text, "Lives: 3", "Player lives label should be visible")
    assert_eq(score_label.text, "Score: 0", "Score label should be visible")
    assert_signal_not_emitted(hud, "game_start", "Game start signal should not be emitted")

    start_game_btn.emit_signal("pressed")

    assert_false(main.get_tree().paused, "Game should not be paused")
    assert_false(start_game_btn.visible, "Start game button should not be visible")
    assert_signal_emitted(hud, "game_start", "Game start signal not emitted")
    assert_signal_emit_count(hud, "game_start", 1, "Game start signal not emitted once")


func test_high_score_shown_after_game_quit():
    var high_score_label = get_node("Main/Hud/HighScoreLabel")
    var start_game_btn = get_node("Main/Hud/StartGameBtn")
    var utilities = get_node("Main/Utilities")
    var brick_grid = get_node("Main/BrickGrid")
    var brick1 = brick_grid.get_node("Brick")

    watch_signals(utilities)

    collide_with_brick(brick1)
    quit_game()
    start_game_btn.emit_signal("pressed")
    
    assert_signal_emitted(utilities, "loaded_game_data", "High score signal not emitted")
    assert_true(high_score_label.visible, "High score label should be visible")
    assert_eq(high_score_label.text, "High Score: 1","High score should be greater than 0")

func test_high_score_shown_after_game_over():
    var high_score_label = get_node("Main/Hud/HighScoreLabel")
    var start_game_btn = get_node("Main/Hud/StartGameBtn")
    var utilities = get_node("Main/Utilities")
    var brick_grid = get_node("Main/BrickGrid")
    var brick1 = brick_grid.get_node("Brick")
    var brick2 = brick_grid.get_node("Brick2")
    var brick3 = brick_grid.get_node("Brick3")

    watch_signals(utilities)

    collide_with_brick(brick1)
    collide_with_brick(brick2)
    collide_with_brick(brick3)

    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()
    collide_with_out_of_bounds_area()

    start_game_btn.emit_signal("pressed")

    assert_signal_emitted(utilities, "loaded_game_data", "High score signal not emitted")
    assert_true(high_score_label.visible, "High score label should be visible")
    assert_eq(high_score_label.text, "High Score: 3","High score should be greater than 0")

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


func move_player_left() -> Vector2:
    var player = get_node("Main/Player")
    Input.action_press("move_left")
    Input.action_release("move_left")
    return player.position


func collide_with_brick(brick) -> void:
    var ball = get_node("Main/Ball")
    ball.emit_signal("body_entered", brick)


func collide_with_out_of_bounds_area() -> void:
    var out_of_bounds_area = get_node("Main/OutOfBoundsArea")
    var ball = get_node("Main/Ball")
    out_of_bounds_area.emit_signal("body_entered", ball)


func clear_high_score() -> void:
    var empty_resource = SavedGame.new()
    ResourceSaver.save(empty_resource, "user://saved_game.tres")

