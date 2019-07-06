extends KinematicBody2D

"""Responsible for all snake movement and provides positions and directions to tail nodes."""

onready var tail_scene = preload("res://Scenes/Tail.tscn")
onready var main_node = $".."

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

var speed = 100
var tile_size = 40

var last_pos = Vector2()
var current_pos = Vector2()
var next_pos = Vector2()

var last_dir = Vector2()
var current_dir = Vector2()
var next_dir = Vector2()

var changed_next_pos = false


func _ready():
	# starts the snake's movement at the beginning of the game
	last_pos = Vector2(80, 320)
	current_pos = Vector2(120, 320)
	next_pos = current_pos + Vector2(tile_size, 0)
	last_dir = RIGHT
	current_dir = RIGHT
	next_dir = RIGHT


func _unhandled_key_input(event):
	# sets the movement direction for the next cell and prevents moving backwards into self
	if event.scancode == KEY_A or event.scancode == KEY_LEFT:
		if current_dir != RIGHT:
			next_dir = LEFT
	elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
		if current_dir != LEFT:
			next_dir = RIGHT
	elif event.scancode == KEY_W or event.scancode == KEY_UP:
		if current_dir != DOWN:
			next_dir = UP
	elif event.scancode == KEY_S or event.scancode == KEY_DOWN:
		if current_dir != UP:
			next_dir = DOWN


func _process(delta):
	# moves the snake
	move_and_collide(speed * current_dir * delta)
	# snaps the snake to the next position if it moves past it
	if position.distance_to(current_pos) >= tile_size:
		position = next_pos
	# sets the next position and stores previous position and direction
	if position == next_pos:
		changed_next_pos = true
		last_dir = current_dir
		current_dir = next_dir
		last_pos = current_pos
		current_pos = position
		next_pos += next_dir * tile_size
	# sends direction and position changes to tail nodes
	if changed_next_pos:
		for tail_part in range(5, main_node.get_child_count()):
			var tail = get_parent().get_child(tail_part)
			tail.positions.append(current_pos)
			tail.directions.append(current_dir)
		changed_next_pos = false
