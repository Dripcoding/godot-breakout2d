extends Node

@onready var is_game_over = false;
@onready var has_game_started = false;

func _ready() -> void:
	get_tree().paused = true


func _process(delta) -> void:
	if Input.is_action_pressed('pause'):
		pause_game()
	elif Input.is_action_just_pressed('resume'):
		resume_game()
	elif Input.is_action_just_pressed('quit'):
		quit_game()


func pause_game() -> void:
	get_tree().paused = true
	propagate_call('pause')


func resume_game() -> void:
	if has_game_started and not is_game_over:
		get_tree().paused = false
	propagate_call('resume')


func quit_game() -> void:
	has_game_started = false
	is_game_over = true
	get_tree().paused = true
	propagate_call('quit')


func _on_game_over() -> void:
	is_game_over = true
	get_tree().paused = true
	propagate_call('on_game_over')


func _on_game_start():
	has_game_started = true
	is_game_over = false
	get_tree().paused = false
	propagate_call('on_game_start')
