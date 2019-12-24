extends Area2D

"""Informs other nodes when the frog is eaten, spawns it and controls its duration."""

onready var main_node := $".."
onready var UI := $"../UI"
onready var food_area = $"../FoodArea"
onready var frog_timer = $FrogTimer
onready var frog_collision = $FrogCollision


func position_check(next_pos: Vector2) -> void:
	"""Tells the root node to add another snake tail segment and the user interface to add points
	when the frog is located on the cell where the snake head is moving next.
	
	Detecting the location of the frog this way makes the collision shape redundant but it's left in
	the code in case the detection method is changed in the future."""
	if next_pos == position:
		main_node.add_tail(name)
		visible = false
		frog_collision.disabled = true
		UI.add_points(name)


func spawn_attempt() -> void:
	"""Attempts to spawn the frog each time a new tail segment is added, with a 7% chance of success."""
	if not Autoload.just_started:
		var random := rand_range(0, 100)
		if random < 7:
			spawn()


func spawn() -> void:
	"""Spawns the frog on a random empty cell."""
	var random_pos := Vector2(rand_range(40, 640), rand_range(40, 640))
	var new_pos := random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	while new_pos in Autoload.all_current_pos or new_pos in Autoload.all_last_pos \
	or new_pos in Autoload.all_next_pos or new_pos in Autoload.obstacle_positions \
	or new_pos == food_area.position:
		random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
		new_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	position = new_pos
	visible = true
	frog_collision.disabled = false
	
	"""Starts the frog duration countdown."""
	frog_timer.start()


func _on_FrogTimer_timeout() -> void:
	"""Removes the frog 5 seconds after it spawns if it's not eaten by the snake."""
	frog_collision.disabled = true
	visible = false
