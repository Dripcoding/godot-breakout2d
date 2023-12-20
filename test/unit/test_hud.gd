extends "res://addons/gut/test.gd"


var hud_scene = load("res://scenes/hud.tscn")


func before_each():
    var hud = hud_scene.instantiate()
    add_child(hud)


func after_each():
    var hud = get_node("Hud")
    remove_child(hud)


func test_hud_exists():
    var hud = get_node("Hud")
    assert_not_null(hud, "HUD does not exist")


func test_initial_player_lives():
    var hud = get_node("Hud")
    assert_eq(hud.playerLives, 3, "Initial player lives is not 3")


func test_initial_score():
    var hud = get_node("Hud")
    assert_eq(hud.score, 0, "Initial score is not 0")


func test_score_increment():
    var hud = get_node("Hud")
    var score_label = get_node("Hud/ScoreLabel")
    hud._on_ball_score()
    assert_eq(hud.score, 1, "Score did not increment")
    assert_eq(score_label.text, 'Score: 1', "Score label text is not 'Score: 1'")


func test_player_lives_decrement():
    var hud = get_node("Hud")
    var player_lives_label = get_node("Hud/PlayerLivesLabel")
    hud._on_ball_out_of_bounds(Node2D.new())
    assert_eq(hud.playerLives, 2, "Player lives did not decrement")
    assert_eq(player_lives_label.text, 'Lives: 2', "Player lives label text is not 'Lives: 2'")


func test_game_over():
    var hud = get_node("Hud")
    var game_over_label = get_node("Hud/GameOverLabel")
    var score_label = get_node("Hud/ScoreLabel")
    watch_signals(hud)
    hud._on_ball_out_of_bounds(Node2D.new())
    hud._on_ball_out_of_bounds(Node2D.new())
    hud._on_ball_out_of_bounds(Node2D.new())
    assert_eq(game_over_label.text, 'Game Over', "Game over label text is not 'Game Over'")
    assert_eq(score_label.text, 'Score: 0', "Score label text is not 'Score: 0'")
    assert_signal_emitted(hud, "game_over", "Game over signal not emitted")