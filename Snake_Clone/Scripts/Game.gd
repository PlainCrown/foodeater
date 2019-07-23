extends Node2D

"""Responsible for adding tail parts and providing them with information"""

onready var snake = $SnakeBody
onready var food = $FoodArea
onready var UI = $UI
onready var reset_timer = $ResetTimer

var just_reset = false
var tail_scene = preload("res://Scenes/Tail.tscn")


func _ready():
	# tells the autoload how many nodes there are
	# used in SnakeBody.gd to tell tail nodes apart from default nodes
	Autoload.default_node_count = get_child_count()
	# creates two tail nodes at the beginning of the game
	add_two_tails()


func add_tail():
	# adds tail and tells food to change positions
	var last_positions = []
	var current_positions = []
	var next_positions = []
	var tail = tail_scene.instance()
	var last_tail = get_child(get_child_count() - 1)
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
			if "Tail" in snake_part.name or "SnakeBody" in snake_part:
				last_positions.append(snake_part.last_pos)
				current_positions.append(snake_part.current_pos)
				next_positions.append(snake_part.next_pos)
				
		tail.position = last_tail.last_pos
		tail.last_part = last_tail
	# adds the first tail
	else:
		tail.position = snake.last_pos
		tail.last_pos = Vector2(40, 320)
		tail.current_pos = snake.last_pos
		tail.next_pos = snake.current_pos
		tail.last_dir = snake.RIGHT
		tail.current_dir = snake.last_dir
		tail.positions.append(snake.current_pos)
		tail.directions.append(snake.current_dir)
		tail.last_part = snake
	add_child(tail)
	food.move(last_positions, current_positions, next_positions)


func add_two_tails():
	# adds two tails when the game starts or when it's restarted
	add_tail()
	add_tail()


func _unhandled_key_input(event):
	# resets everything to starting positions if the R key is pressed
	if event.scancode == KEY_R:
		# stops the player from reseting the game for 1.5 seconds after it has been reset
		if not just_reset:
			just_reset = true
			reset_timer.start()
			# deletes all tail nodes
			for i in get_children():
				if "Tail" in i.name:
					i.free()
			UI.hide_reset_request()
			snake.reset()
			add_two_tails()


func _on_ResetTimer_timeout():
	# allows the player to reset with the R key again when 1.5 seconds have passed since the last reset
	just_reset = false
