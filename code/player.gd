extends Sprite2D


@export var speed: float = 300

@onready var player: Sprite2D = %Player
@onready var screen_size: Vector2 = get_viewport_rect().end

const X_OFFSET = 70

func _process(delta):
	var velocity: Vector2 = Vector2.ZERO

	if Input.is_action_pressed('move_right'):
		print('move_right')
		velocity.x += 20
	elif Input.is_action_pressed('move_left'):
		print('move_left')
		velocity.x -= 20

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	var min_vector: Vector2 = Vector2(Vector2.ZERO.x + X_OFFSET, 0)
	var max_vector: Vector2 = Vector2(screen_size.x - X_OFFSET, screen_size.y) 
	
	# prevent player from going past left and right boundaries 
	position = position.clamp(min_vector, max_vector)
