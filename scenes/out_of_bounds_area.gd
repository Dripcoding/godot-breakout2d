extends Area2D

signal out_of_bounds


func _on_body_entered(body:Node2D):
	if body.is_in_group('ball'):
		body.queue_free()
		out_of_bounds.emit()
