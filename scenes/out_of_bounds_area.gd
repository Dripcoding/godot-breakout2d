extends Area2D




func _on_body_entered(body:Node2D):
	print('entered out of bounds')
	if body.is_in_group('ball'):
		body.queue_free()
