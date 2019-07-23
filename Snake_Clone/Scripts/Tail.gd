extends KinematicBody2D

"""Responsible for all tail movement."""

var speed = 100
var last_pos = Vector2()
var current_pos = Vector2()
var next_pos = Vector2()
var last_dir = Vector2()
var current_dir = Vector2()
var positions = []
var directions = []
var last_part = null


func _ready():
	"""This code makes sure that each new tail does not spawn too far or too close to the last one.
	It solves a problem that should not exist in the first place if the base code was written perfectly.
	The issue occurs because the tail's new position is set as the last position of the last tail in Game.gd, 
	but the snake parts do not move in sync even if they all have the same speed value.
	Without this code, the new snake part can spawn nearly 80 pixels away from the last part or inside of it."""
	var distance = position.distance_to(last_part.global_position) - Autoload.tile_size
	if position.x != last_part.global_position.x and position.y != last_part.global_position.y:
		if distance > 1:
			position = next_pos
	elif distance > 1:
		position += current_dir * distance


func _process(delta):
	if Autoload.moving:
		# moves the snake 
		move_and_collide(speed * current_dir * delta)
		# snaps the snake to the next position if it moves past it
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
			
		"""For some reason giving all snake parts equal movement speed does not make them move in sync.
		(might be because of the variable delta that is multiplied by speed in the _process function)
		This code forces the snake parts to maintain a Autoload.tile_size distance between each other.
		Without this, the first part of the tail eventually exceeds the speed of the snake head and calls 
		the clear_array() function before the snake head can append the next elements, crashing the game."""
		if position.distance_to(last_part.position) > Autoload.tile_size:
			speed = Autoload.default_speed + 30
		elif position.distance_to(last_part.position) < Autoload.tile_size:
			speed = Autoload.default_speed - 0.3
		else:
			speed = Autoload.default_speed


func clear_array():
	# removes the first element from both arrays
	positions.pop_front()
	directions.pop_front()
