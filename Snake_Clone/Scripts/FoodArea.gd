extends Area2D

"""Calls for add_tail() in Game.gd, re-positions food after it's consumed."""

onready var main_node = $".."

func position_check(next_pos):
	# calls the add_tail function if the next_pos of SnakeBody is the same as the food position
	if next_pos == position:
		main_node.add_tail()


func move(all_last_pos, all_current_pos, all_next_pos):
	# places the food on any random cell that the snake isn't on
	# due to inconsistent snake speed, sometimes places food on a cell that the snake is on
	randomize()
	var random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
	var snapped_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	while snapped_pos in all_current_pos or snapped_pos in all_last_pos or snapped_pos in all_next_pos:
		random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
		snapped_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	position = snapped_pos
