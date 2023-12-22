extends Sprite2D


@export var speed: float = 300
@export var position_x_initial: float = 500
@export var position_y_initial: float = 629

@onready var player: Sprite2D = %Player
@onready var screen_size: Vector2 = get_viewport_rect().end

const X_OFFSET: float = 70


var pause_game: bool = false


func _ready() -> void:
	position.x = position_x_initial
	position.y = position_y_initial


func _process(delta) -> void:
	var velocity: Vector2 = Vector2.ZERO

	if pause_game:
		return
	elif Input.is_action_pressed('move_right'):
		velocity.x += 20
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 20

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	var min_vector: Vector2 = Vector2(Vector2.ZERO.x + X_OFFSET, 0)
	var max_vector: Vector2 = Vector2(screen_size.x - X_OFFSET, screen_size.y) 
	
	# prevent player from going past left and right boundaries 
	position = position.clamp(min_vector, max_vector)


func on_game_over() -> void:
	position.x = position_x_initial
	position.y = position_y_initial


func pause() -> void:
	pause_game = true 


func resume() -> void:
	pause_game = false
