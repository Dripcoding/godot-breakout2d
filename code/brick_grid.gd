extends Node2D


const bricks_scene: Resource = preload("res://scenes/brick.tscn")
var bricks: Array[Node] = []


func _ready() -> void:
	for child in get_children():
		bricks.append(child.duplicate())
		
		
func reset_brick_grid() -> void:			
	self.call_deferred('reset_bricks')


func on_game_over() -> void:
	reset_brick_grid()	


func quit() -> void:
	reset_brick_grid()


func get_bricks() -> Array[Node]:
	return bricks


func reset_bricks() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	for brick in bricks:
		var new_brick: Node = bricks_scene.instantiate()
		new_brick.add_to_group('bricks')
		new_brick.add_to_group('brick')
		new_brick.position = brick.position
		self.add_child(new_brick)
		new_brick.show()

