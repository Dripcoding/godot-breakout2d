extends "res://addons/gut/test.gd"


var main_scene = load("res://scenes/main.tscn")


func before_each():
    var main = main_scene.instantiate()
    add_child(main)


func after_each():
    var main = get_node("Main")
    var brick_grid = get_node("Main/BrickGrid")
    assert_not_null(brick_grid, "BrickGrid node does not exist")
    
    for brick in brick_grid.bricks:
        brick.free()
    
    main.free()


func test_main_exists():
    var main = get_node("Main")
    assert_not_null(main, "Main node does not exist") 


func test_has_player():
    var main = get_node("Main")
    var player = main.get_node("Player")
    assert_not_null(player, "Player node does not exist")


func test_has_ball():
    var main = get_node("Main")
    var ball = main.get_node("Ball")
    assert_not_null(ball, "Ball node does not exist")


func test_has_brick_grid():
    var main = get_node("Main")
    var brick_grid = main.get_node("BrickGrid")
    assert_not_null(brick_grid, "BrickGrid node does not exist")


func test_has_top_boundary():
    var main = get_node("Main")
    var top_boundary = main.get_node("TopBoundary")
    assert_not_null(top_boundary, "TopBoundary node does not exist")
    assert_true(top_boundary is StaticBody2D, "TopBoundary is not a StaticBody2D")

func test_has_left_boundary():
    var main = get_node("Main")
    var left_boundary = main.get_node("LeftBoundary")
    assert_not_null(left_boundary, "LeftBoundary node does not exist")
    assert_true(left_boundary is StaticBody2D, "LeftBoundary is not a StaticBody2D")
    
    # collision shape 2d
    var collision_shape_2d = left_boundary.get_node("CollisionShape2D")
    assert_not_null(collision_shape_2d, "CollisionShape2D node does not exist")
    assert_eq(collision_shape_2d.shape is RectangleShape2D, true, "CollisionShape2D shape is not RectangleShape2D")
    assert_true(collision_shape_2d.visible, "CollisionShape2D is visible")


func test_has_right_boundary():
    var main = get_node("Main")
    var right_boundary = main.get_node("RightBoundary")
    assert_not_null(right_boundary, "RightBoundary node does not exist")
    assert_true(right_boundary is StaticBody2D, "RightBoundary is not a StaticBody2D")

    # collision shape 2d
    var collision_shape_2d = right_boundary.get_node("CollisionShape2D")
    assert_not_null(collision_shape_2d, "CollisionShape2D node does not exist")
    assert_eq(collision_shape_2d.shape is RectangleShape2D, true, "CollisionShape2D shape is not RectangleShape2D")
    assert_true(collision_shape_2d.visible, "CollisionShape2D is visible")


func test_has_out_of_bounds_boundary():
    var main = get_node("Main")
    var out_of_bounds_boundary = main.get_node("OutOfBoundsArea")
    assert_not_null(out_of_bounds_boundary, "OutOfBoundsArea node does not exist")
    assert_true(out_of_bounds_boundary is Area2D, "OutOfBoundsArea is not an Area2D")

    # collision shape 2d
    var collision_shape_2d = out_of_bounds_boundary.get_node("CollisionShape2D")
    assert_not_null(collision_shape_2d, "CollisionShape2D node does not exist")
    assert_eq(collision_shape_2d.shape is RectangleShape2D, true, "CollisionShape2D shape is not RectangleShape2D")
    assert_true(collision_shape_2d.visible, "CollisionShape2D is visible")
