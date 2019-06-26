extends KinematicBody2D

"""Responsible for all snake movement."""

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)


var speed = 200
var tile_size = 40
var last_pos = Vector2()
var target_pos = Vector2()
var last_dir = Vector2()
var target_dir = Vector2()


func _ready():
	# starts the snake's movement at the beginning of the game
	last_pos = position
	target_pos = position + Vector2(tile_size, 0)
	target_dir = RIGHT
	last_dir = RIGHT


func _process(delta):
	# moves the snake 
	move_and_collide(speed * last_dir * delta)
	# snaps the snake to the target position if it moves too far
	if position.distance_to(last_pos) >= tile_size:
		position = target_pos
	# sets the next target position when the current target position is reached
	if position == target_pos:
		last_dir = target_dir
		last_pos = position
		target_pos += target_dir * tile_size


func _unhandled_key_input(event):
	# sets the movement direction for the next cell and prevents moving backwards into self
	if event.scancode == KEY_A or event.scancode == KEY_LEFT:
		if last_dir != RIGHT:
			target_dir = LEFT
	elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
		if last_dir != LEFT:
			target_dir = RIGHT
	elif event.scancode == KEY_W or event.scancode == KEY_UP:
		if last_dir != DOWN:
			target_dir = UP
	elif event.scancode == KEY_S or event.scancode == KEY_DOWN:
		if last_dir != UP:
			target_dir = DOWN
