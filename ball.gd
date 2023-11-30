extends Sprite2D

@export var speed = 400
@export var initial_x = 100
@export var initial_y = 100

func _ready():
	print('ball ready')
	position.x = initial_x
	position.y = initial_y

func _process(delta):
	print('ball delta')

	var velocity = Vector2.ZERO

	velocity.x -= 100

	position += velocity * delta
	
