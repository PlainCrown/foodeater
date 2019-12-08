extends KinematicBody2D

"""Responsible for all snake movement and provides positions and directions to tail nodes.
	The SnakeBody node always has to be at the bottom of the node tree."""

onready var main_node := $".."
onready var food_area := $"../FoodArea"
onready var UI := $"../UI"
onready var snake_pos := $"../SnakePosition"
onready var frog := $"../Frog"

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)

var last_pos := Vector2()
var current_pos := Vector2()
var next_pos := Vector2()
var last_dir := Vector2()
var current_dir := Vector2()
var next_dir := Vector2()
var changed_next_pos := false


func _ready() -> void:
	# starts the snake's movement at the beginning of the game
	reset()


func _unhandled_key_input(event) -> void:
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


func _process(delta: float) -> void:
	if Autoload.moving:
		# moves the snake
		var collision := move_and_collide(Autoload.snake_speed * current_dir)
		# snaps the snake to the next position if it moves past it
		if position.distance_to(current_pos) >= Autoload.tile_size:
			position = next_pos
		# sets the next position and stores previous position and direction
		if position == next_pos:
			changed_next_pos = true
			last_dir = current_dir
			current_dir = next_dir
			last_pos = current_pos
			current_pos = position
			next_pos += next_dir * Autoload.tile_size
			pos_change(next_pos)
		# sends direction and position changes to tail nodes
		if changed_next_pos:
			for tail_part in range(Autoload.default_node_count, main_node.get_child_count()):
				var tail := get_parent().get_child(tail_part)
				tail.positions.append(current_pos)
				tail.directions.append(current_dir)
			changed_next_pos = false
		# stops the snake and its tail from moving when it collides with a wall or itself
		if collision != null:
			Autoload.moving = false
			UI.score_check()
			UI.show_reset_request()


func pos_change(vector: Vector2) -> void:
	# asks FoodArea.gd to compare the food's location with the next position
	next_pos = vector
	food_area.position_check(vector)
	frog.position_check(vector)


func reset() -> void:
	# sets the snake to its starting settings at the beginning of the game and after a restart
	UI.score_check()
	UI.point_reset()
	last_pos = Vector2(80, 320)
	current_pos = snake_pos.position
	position = current_pos
	next_pos = current_pos + Vector2(Autoload.tile_size, 0)
	last_dir = RIGHT
	current_dir = RIGHT
	next_dir = RIGHT
	Autoload.moving = true
