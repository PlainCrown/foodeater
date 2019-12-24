extends Area2D

"""Informs other nodes when the food is eaten and moves the food to a new empty cell."""

onready var main_node := $".."
onready var UI := $"../UI"
onready var frog := $"../Frog"


func position_check(next_pos: Vector2) -> void:
	"""Tells the root node to add another snake tail segment and the user interface to add points
	when the food is located on the cell where the snake head is moving next.
	
	Detecting the location of food this way makes the collision shape redundant but it's left in 
	the code in case the detection method is changed in the future."""
	if next_pos == position:
		main_node.add_tail(name)
		UI.add_points(name)


func move() -> void:
	"""Moves the food to a random empty cell."""
	randomize()
	var random_pos := Vector2(rand_range(40, 640), rand_range(40, 640))
	var new_pos := random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	while new_pos in Autoload.all_current_pos or new_pos in Autoload.all_last_pos \
	or new_pos in Autoload.all_next_pos or new_pos in Autoload.obstacle_positions \
	or new_pos in Autoload.no_spawn_zone and Autoload.just_started \
	or new_pos == frog.position and frog.visible == true:
		random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
		new_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	position = new_pos
