extends KinematicBody2D

"""Responsible for all tail movement."""

var speed = Autoload.snake_speed
var last_pos := Vector2()
var current_pos := Vector2()
var next_pos := Vector2()
var last_dir := Vector2()
var current_dir := Vector2()
var positions := []
var directions := []


func _ready():
	$TailSprite.scale = Vector2(Autoload.tail_scale, Autoload.tail_scale)
	Autoload.tail_scale -= 0.001


func _process(delta: float) -> void:
	if Autoload.moving:
		# moves the tail
		move_and_collide(speed * current_dir)
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


func clear_array() -> void:
	# removes the first element from both arrays
	positions.pop_front()
	directions.pop_front()
