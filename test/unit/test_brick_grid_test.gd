extends GutTest

# extends "res://addons/gut/test.gd"

var brick_grid_scene = load("res://scenes/brick_grid.tscn")

func test_number_of_bricks():
    var brick_grid = brick_grid_scene.instantiate()
    add_child(brick_grid)
    
    var expected = 15
    var actual = brick_grid.get_child_count()
    
    assert_eq(actual, expected, "The number of bricks in the grid is incorrect")
    
    remove_child(brick_grid)