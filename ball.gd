extends Sprite2D

@export var speed = 400

func _process(delta):
	var velocity = Vector2.ZERO

	velocity.x -= 100

	position += velocity * delta
	

	
