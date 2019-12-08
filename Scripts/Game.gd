extends Node2D

"""Responsible for adding tail parts and providing them with information"""

onready var snake := $SnakeBody
onready var food := $FoodArea
onready var UI := $UI
onready var reset_timer := $ResetTimer
onready var frog := $Frog

var just_reset := false
var tail_scene := preload("res://Scenes/Tail.tscn")


func _ready() -> void:
	# tells the autoload how many nodes there are
	# used in SnakeBody.gd to tell tail nodes apart from default nodes
	Autoload.just_started = true
	Autoload.tail_scale = 0.999
	Autoload.default_node_count = get_child_count()
	# creates the first tail at the beginning of the game
	add_tail("") 


func add_tail(food_name: String) -> void:
	# adds tail and tells food to change positions
	var last_positions := []
	var current_positions := []
	var next_positions := []
	var tail := tail_scene.instance()
	var last_tail := get_child(get_child_count() - 1)
	# adds any tail after the first one
	# SnakeBody always has to be at the bottom of the node tree
	if last_tail.name != "SnakeBody":
		tail.current_pos = last_tail.last_pos
		tail.current_dir = last_tail.last_dir
		tail.next_pos = last_tail.current_pos
		tail.positions.append(last_tail.current_pos)
		tail.directions.append(last_tail.current_dir)
		# adds the positions and directions of the last tail to the current tail
		for pos in last_tail.positions:
			tail.positions.append(pos)
		for dir in last_tail.directions:
			tail.directions.append(dir)
		# gets all of the positions where the next piece of food should not spawn
		for snake_part in get_children():
			if "Tail" in snake_part.name or "SnakeBody" in snake_part.name:
				last_positions.append(snake_part.last_pos)
				current_positions.append(snake_part.current_pos)
				next_positions.append(snake_part.next_pos)
		# places the tail
		tail.position = last_tail.current_pos
	# adds the first tail
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
		on snake speed. This code corrects the distance."""
		if Autoload.snake_speed == Autoload.SLOW:
			tail.position += Vector2(-1, 0)
		elif Autoload.snake_speed == Autoload.NORMAL:
			tail.position += Vector2(-3, 0)
		else:
			tail.position += Vector2(0, 0)
			
	"""Adds the tail as a child node and tells food to move anywhere other than snake positions."""
	add_child(tail)
	Autoload.all_last_pos = last_positions
	Autoload.all_current_pos = current_positions
	Autoload.all_next_pos = next_positions
	if food_name != "Frog":
		food.move()
	if not frog.visible:
		frog.spawn_attempt()


func _unhandled_key_input(event: InputEventKey):
	# resets everything to starting positions if the R key is pressed
	if event.scancode == KEY_R:
		# stops the player from reseting the game for 1 second after it has been reset
		if not just_reset:
			just_reset = true
			reset_timer.start()
			# deletes all tail nodes
			for i in get_children():
				if "Tail" in i.name:
					i.free()
			UI.hide_reset_request()
			snake.reset()
			add_tail("")
	# returns to the main menu
	elif event.scancode == KEY_ESCAPE:
		UI.score_check()
		get_tree().change_scene("res://Scenes/GameSelect.tscn")


func _on_ResetTimer_timeout():
	# allows the player to reset with the R key again when 1 second has passed since the last reset
	just_reset = false
	Autoload.just_started = false
