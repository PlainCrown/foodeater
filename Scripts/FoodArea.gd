extends Area2D

"""Calls for add_tail() in Game.gd, re-positions food after it's consumed."""

onready var main_node := $".."
onready var UI := $"../UI"
onready var frog := $"../Frog"

var last_pos = null


func position_check(next_pos: Vector2) -> void:
	# calls the add_tail function if the next_pos of SnakeBody is the same as the food position
	if next_pos == position:
		main_node.add_tail(name)
		UI.add_points(name)


func move() -> void:
	# places the food on any random cell that the snake isn't on
	# sometimes the food still gets placed under the snake for some reason
	randomize()
	var random_pos := Vector2(rand_range(40, 640), rand_range(40, 640))
	var new_pos := random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	while new_pos in Autoload.all_current_pos or new_pos in Autoload.all_last_pos \
	or new_pos in Autoload.all_next_pos or new_pos == Vector2(80, 320) and Autoload.just_started \
	or new_pos == frog.position and frog.visible == true:
		random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
		new_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	position = new_pos
