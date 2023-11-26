extends Sprite2D

@export var speed:float = 400

const OFFSET_X:float = 8
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	elif Input.is_action_pressed('move_left'):
		velocity.x -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	velocity = velocity.normalized() * speed
	position += velocity * delta

	var playerWidth:Vector2 = $CharacterBody2D.get_node('CollisionShape2D').get('shape').get_rect().size
	var vector_min:Vector2 = Vector2(OFFSET_X + playerWidth.x, 0)
	var vector_max:Vector2 = Vector2(screen_size.x - playerWidth.x - OFFSET_X, screen_size.y)

	position = position.clamp(vector_min, vector_max)
