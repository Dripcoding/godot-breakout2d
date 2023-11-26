extends Sprite2D

@export var speed:float = 400
var screen_size

func _ready():
	print('player ready')
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO

	if (Input.is_action_pressed('move_right')):
		print('move right')
		velocity.x += 1
	elif (Input.is_action_pressed('move_left')):
		print('move left')
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	velocity = velocity.normalized() * speed
	position += velocity * delta
	# todo: use paddle width to clamp player movement
	position = position.clamp(Vector2.ZERO, screen_size)
