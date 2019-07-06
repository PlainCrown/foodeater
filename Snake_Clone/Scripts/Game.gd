extends Node2D

"""Responsible for adding tail parts and providing them with information"""

onready var snake = $SnakeBody
var tail_scene = preload("res://Scenes/Tail.tscn")

var default_number_of_child_nodes = 5
var tile_size = 40


func _ready():
	# creates two tail nodes at the beginning of the game
	add_tail()
	add_tail()


func add_tail():
	# adds tail
	var tail = tail_scene.instance()
	var last_tail = get_child(get_child_count() - 1)
	# adds any tail after the first one
	# SnakeBody always has to be at the bottom of the node tree
	if last_tail.name != "SnakeBody":
		tail.current_dir = last_tail.last_dir
		tail.next_pos = last_tail.current_pos
		tail.positions.append(last_tail.current_pos)
		tail.directions.append(last_tail.current_dir)
		# adds the positions and directions of the last tail to the current tail
		for tail_part in get_child_count() - default_number_of_child_nodes:
			for pos in last_tail.positions:
				tail.positions.append(pos)
			for dir in last_tail.directions:
				tail.directions.append(dir)
		tail.position = last_tail.last_pos
		tail.current_pos = last_tail.last_pos
		tail.last_part = last_tail
	# adds the first tail
	else:
		tail.position = snake.last_pos
		tail.last_pos = Vector2(40, 320)
		tail.current_pos = snake.last_pos
		tail.next_pos = snake.current_pos
		tail.last_dir = snake.RIGHT
		tail.current_dir = snake.last_dir
		tail.next_dir = snake.current_dir
		tail.positions.append(snake.current_pos)
		tail.directions.append(snake.current_dir)
		tail.last_part = snake
	add_child(tail)
