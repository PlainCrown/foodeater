extends Node2D

"""Responsible for adding tail parts and providing them with information"""

onready var snake = $SnakeBody
onready var food = $FoodArea

var tail_scene = preload("res://Scenes/Tail.tscn")
var default_number_of_child_nodes = 5


func _ready():
	# creates two tail nodes at the beginning of the game
	add_tail()
	add_tail()


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