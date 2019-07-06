extends KinematicBody2D

"""Responsible for all tail movement."""

var default_speed = 100
var speed = 100
var tile_size = 40

var last_pos = Vector2()
var current_pos = Vector2()
var next_pos = Vector2()

var last_dir = Vector2()
var current_dir = Vector2()
var next_dir = Vector2()

var positions = []
var directions = []
var last_part = null


func _ready():
	# testing purposes only
	print(position, last_pos, current_pos, next_pos, last_dir, current_dir, next_dir, positions, directions)


func _process(delta):
	# moves the snake 
	move_and_collide(speed * current_dir * delta)
	# snaps the snake to the next position if it moves past it
	if position.distance_to(current_pos) >= tile_size:
		position = next_pos
	# sets the next position and stores previous position and direction
	if position == positions[0]:
		last_dir = current_dir
		current_dir = directions[0]
		last_pos = current_pos
		current_pos = position
		next_pos += directions[0] * tile_size
		clear_array()

	"""For some reason giving all snake parts equal movement speed does not make them move 
	in sync. This code forces the snake parts to maintain a tile_size distance between each other.
	Without this, the first part of the tail eventually exceeds the speed of the snake head and calls 
	the clear_array() function before the snake head can append the next elements, crashing the game."""
	if position.distance_to(last_part.position) > tile_size:
		speed = default_speed + 3
	elif position.distance_to(last_part.position) < tile_size:
		speed = default_speed - 0.1
	else:
		speed = default_speed


func clear_array():
	# removes the first element from both arrays
	positions.pop_front()
	directions.pop_front()
