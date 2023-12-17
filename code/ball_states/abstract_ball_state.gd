class_name AbstractBallState


var context = null


func _init(ball: Ball) -> void:
	print('abstract ball state init')
	context = ball


func get_context() -> Ball:
	return context