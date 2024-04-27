extends "res://addons/gut/test.gd"

var hud_scene = load("res://scenes/hud.tscn")


func before_each():
	var hud = hud_scene.instantiate()
	add_child(hud)


func after_each():
	var hud = get_node("Hud")
	autofree(hud)
	assert_no_new_orphans()


func test_hud_exists():
	var hud = get_node("Hud")
	assert_not_null(hud, "HUD does not exist")


func test_hud_has_score_label():
	var score_label = get_node("Hud/ScoreLabel")
	assert_not_null(score_label, "Score label does not exist")
	assert_true(score_label is Label, "Score label is not a Label")
	assert_true(score_label.visible, "Score label is not visible")
	assert_eq(score_label.text, "Score: 0", "Score label text is not 'Score: 0'")


func test_hud_has_player_lives_label():
	var player_lives_label = get_node("Hud/PlayerLivesLabel")
	assert_not_null(player_lives_label, "Player lives label does not exist")
	assert_true(player_lives_label is Label, "Player lives label is not a Label")
	assert_true(player_lives_label.visible, "Player lives label is not visible")
	assert_eq(player_lives_label.text, "Lives: 3", "Player lives label text is not 'Lives: 3'")


func test_hud_has_start_game_btn():
	var start_game_btn = get_node("Hud/StartGameBtn")
	assert_not_null(start_game_btn, "Start game button does not exist")
	assert_true(start_game_btn is Button, "Start game button is not a Button")
	assert_true(start_game_btn.visible, "Start game button is not visible")
	assert_eq(start_game_btn.text, "Start Game", "Start game button text is not 'Start Game'")


func test_hud_has_game_over_label():
	var game_over_label = get_node("Hud/GameOverLabel")
	assert_not_null(game_over_label, "Game over label does not exist")
	assert_true(game_over_label is Label, "Game over label is not a Label")
	assert_false(game_over_label.visible, "Game over label is visible")
	assert_eq(game_over_label.text, "Game Over", "Game over label text is not 'Game Over'")


func test_initial_player_lives():
	var hud = get_node("Hud")
	assert_eq(hud.player_lives, 3, "Initial player lives is not 3")


func test_initial_score():
	var hud = get_node("Hud")
	assert_eq(hud.score, 0, "Initial score is not 0")


func test_score_increment():
	var hud = get_node("Hud")
	var score_label = get_node("Hud/ScoreLabel")
	hud._on_ball_score()
	assert_eq(hud.score, 1, "Score did not increment")
	assert_eq(score_label.text, "Score: 1", "Score label text is not 'Score: 1'")


func test_player_lives_decrement():
	var hud = get_node("Hud")
	var player_lives_label = get_node("Hud/PlayerLivesLabel")
	var body = Node2D.new()
	hud._on_ball_out_of_bounds(body)
	assert_eq(hud.player_lives, 2, "Player lives did not decrement")
	assert_eq(player_lives_label.text, "Lives: 2", "Player lives label text is not 'Lives: 2'")
	body.free()


func test_game_over():
	var hud = get_node("Hud")
	var game_over_label = get_node("Hud/GameOverLabel")
	var score_label = get_node("Hud/ScoreLabel")
	var body = Node2D.new()
	watch_signals(hud)
	hud._on_ball_out_of_bounds(body)
	hud._on_ball_out_of_bounds(body)
	hud._on_ball_out_of_bounds(body)
	assert_eq(game_over_label.text, "Game Over", "Game over label text is not 'Game Over'")
	assert_eq(score_label.text, "Score: 0", "Score label text is not 'Score: 0'")
	assert_signal_emitted(hud, "game_over", "Game over signal not emitted")
	assert_signal_emit_count(hud, "game_over", 1, "Game over signal emitted more than once")
	game_over_label.free()
	score_label.free()
	body.free()


func test_game_quit():
	var hud = get_node("Hud")
	watch_signals(hud)
	hud.quit()
	assert_signal_emitted(hud, "game_over", "Game over signal not emitted")
	assert_signal_emit_count(hud, "game_over", 1, "Game over signal emitted more than once")


func test_start_button_visible_after_game_quit():
	var hud = get_node("Hud")
	watch_signals(hud)
	hud.quit()
	assert_signal_emitted(hud, "game_over", "Game over signal not emitted")

	var start_game_btn = get_node("Hud/StartGameBtn")
	assert_not_null(start_game_btn, "Start game button does not exist")
	assert_true(start_game_btn.visible, "Start game button is not visible")


func test_start_button_visible_after_game_over():
	var hud = get_node("Hud")
	watch_signals(hud)
	var body = Node2D.new()
	hud._on_ball_out_of_bounds(body)
	hud._on_ball_out_of_bounds(body)
	hud._on_ball_out_of_bounds(body)
	assert_signal_emitted(hud, "game_over", "Game over signal not emitted")

	var start_game_btn = get_node("Hud/StartGameBtn")
	assert_not_null(start_game_btn, "Start game button does not exist")
	assert_true(start_game_btn.visible, "Start game button is not visible")
	body.free()


func test_start_button_hidden_on_game_start():
	var hud = get_node("Hud")
	var start_game_btn = get_node("Hud/StartGameBtn")

	hud.on_game_start()

	assert_false(start_game_btn.visible, "Start game button is visible")


func test_game_start_btn_pressed():
	var hud = get_node("Hud")
	var start_game_btn = get_node("Hud/StartGameBtn")
	var player_lives_label = get_node("Hud/PlayerLivesLabel")
	var score_label = get_node("Hud/ScoreLabel")
	watch_signals(hud)

	start_game_btn.emit_signal("pressed")

	assert_signal_emitted(hud, "game_start", "Game start signal not emitted")
	assert_signal_emit_count(hud, "game_start", 1, "Game start signal emitted more than once")
	assert_true(player_lives_label.visible, "Player lives label is not visible")
	assert_eq(player_lives_label.text, "Lives: 3", "Player lives label text is not 'Lives: 3'")
	assert_true(score_label.visible, "Score label is not visible")
	assert_eq(score_label.text, "Score: 0", "Score label text is not 'Score: 0'")
