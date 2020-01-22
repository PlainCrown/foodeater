extends Node2D

"""Responsible for activating obstacle mode, adding new tail segments, and restarting the game."""

onready var snake := $SnakeBody
onready var food := $FoodArea
onready var UI := $UI
onready var reset_timer := $ResetTimer
onready var frog := $Frog
onready var obstacles := $Obstacles
onready var audio_player := $AudioStreamPlayer

const EAT_SOUND = preload("res://Assets/Sound/eat.wav")

var tail_scene := preload("res://Scenes/Tail.tscn")


func _ready() -> void:
	"""Sets the game as just started and begins the reset timer."""
	Autoload.just_started = true
	reset_timer.start()
	
	"""Activtates the obstacles."""
	if Autoload.obstacles:
		obstacles.visible = true
		for obstacle in obstacles.get_children():
			Autoload.obstacle_positions.append(obstacle.position)
			obstacle.get_node("ObstacleShape").disabled = false
	
	"""Helps distinguish between default nodes and tail nodes added later, to prevent the default 
	nodes from being accidentally removed when the game is reset and deletes tail segments."""
	Autoload.default_node_count = get_child_count()
	
	"""Sets default game settings and tells to add the first tail segment."""
	audio_player.volume_db = Autoload.sfx_volume
	Autoload.tail_scale = 0.998
	add_tail("")


func add_tail(food_name: String) -> void:
	"""Creates and adds new tail segments.
	
	This code is written in a way that requires the SnakeBody to always be the at the bottom 
	of the node tree. This is bad, but it works and I'm too lazy to change it."""
	var last_positions := []
	var current_positions := []
	var next_positions := []
	var tail := tail_scene.instance()
	var last_tail := get_child(get_child_count() - 1)
	
	"""Adds any tail segment after the first one."""
	if last_tail.name != "SnakeBody":
		audio_player.stream = EAT_SOUND
		audio_player.pitch_scale = rand_range(0.9, 1)
		audio_player.play()
		tail.current_pos = last_tail.last_pos
		tail.current_dir = last_tail.last_dir
		tail.next_pos = last_tail.current_pos
		tail.positions.append(last_tail.current_pos)
		tail.directions.append(last_tail.current_dir)
		
		"""Adds the positions and directions of the last tail to the current tail."""
		for pos in last_tail.positions:
			tail.positions.append(pos)
		for dir in last_tail.directions:
			tail.directions.append(dir)
		
		"""Gets all of the snake positions where the food and the frog can't spawn.
		
		Only using the one of the next_positions and one of the last_positions should be enough, but 
		the food still somehow spawns under the snake sometimes if all positions aren't included."""
		for snake_part in get_children():
			if "Tail" in snake_part.name or "SnakeBody" in snake_part.name:
				last_positions.append(snake_part.last_pos)
				current_positions.append(snake_part.current_pos)
				next_positions.append(snake_part.next_pos)
		tail.position = last_tail.current_pos
		
		"""Adds the first tail segment at the start of the game."""
	else:
		tail.last_pos = Vector2(40, 320)
		tail.current_pos = snake.last_pos
		tail.next_pos = snake.current_pos
		tail.last_dir = snake.RIGHT
		tail.current_dir = snake.last_dir
		
		tail.positions.append(snake.current_pos)
		tail.directions.append(snake.current_dir)
		tail.position = snake.last_pos
		
		"""The distance between the snake head and first snake tail segment changes depending
		on snake speed. This corrects the distance."""
		if Autoload.snake_speed == Autoload.SLOW:
			tail.position += Vector2(-1, 0)
		elif Autoload.snake_speed == Autoload.NORMAL:
			tail.position += Vector2(-3, 0)
	
	"""Adds the tail segment as a child node."""
	add_child(tail)
	Autoload.all_last_pos = last_positions
	Autoload.all_current_pos = current_positions
	Autoload.all_next_pos = next_positions
	
	"""Tells the food to move and attempts to spawn the frog."""
	if food_name != "Frog":
		food.move()
	if not frog.visible:
		frog.spawn_attempt()


func _unhandled_key_input(event: InputEventKey):
	"""Resets everything when the R key is pressed."""
	if event.scancode == KEY_R:
		if not Autoload.just_started:
			Autoload.just_started = true
			reset_timer.start()
			
			"""Removes the frog if it's currently visible and resets tail node scaling."""
			if frog.visible:
				$Frog/FrogCollision.disabled = true
				frog.visible = false
			Autoload.tail_scale = 0.998
			
			"""Removes all tail segments."""
			for i in get_children():
				if "Tail" in i.name:
					i.free()
			
			"""Resets things to default and tells to add a new first tail segment."""
			UI.hide_reset_request()
			snake.reset()
			add_tail("")
		
		"""Returns to the game select menu if the escape key is pressed."""
	elif event.scancode == KEY_ESCAPE:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/GameSelect.tscn")


func _on_ResetTimer_timeout():
	"""Allows the player to restart the game with the R key again, 1 second after the last restart."""
	Autoload.just_started = false
