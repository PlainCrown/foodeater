extends KinematicBody2D

"""Responsible for all tail movement."""

var speed = Autoload.default_speed
var last_pos = Vector2()
var current_pos = Vector2()
var next_pos = Vector2()
var last_dir = Vector2()
var current_dir = Vector2()
var positions = []
var directions = []


func _process(delta):
	if Autoload.moving:
		# moves the tail
		move_and_collide(Autoload.default_speed * current_dir)
		# snaps the tail to the next position if it moves past it
		if position.distance_to(current_pos) >= Autoload.tile_size:
			position = next_pos
		# sets the next position and stores previous position and direction
		if position == positions[0]:
			last_pos = current_pos
			current_pos = position
			last_dir = current_dir
			current_dir = directions[0]
			next_pos += directions[0] * Autoload.tile_size
			clear_array()


func clear_array():
	# removes the first element from both arrays
	positions.pop_front()
	directions.pop_front()
