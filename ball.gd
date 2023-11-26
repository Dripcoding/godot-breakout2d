extends Sprite2D

@export var speed = 400

func _ready():
	print('ball ready')

func _process(delta):
	print('ball delta')

	var velocity = Vector2.ZERO

	velocity.x -= 100

	position += velocity * delta
	

	
