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


func _ready() -> void:
	"""Scales the snake and sets its color."""
	$TailSprite.scale = Vector2(Autoload.tail_scale, Autoload.tail_scale)
	$TailSprite.modulate = Autoload.tail_color
	Autoload.tail_scale -= 0.002


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	"""Moves the tail."""
	if Autoload.moving:
# warning-ignore:return_value_discarded
		move_and_collide(speed * current_dir)
		if position.distance_to(current_pos) >= Autoload.tile_size:
			position = next_pos
		"""Sets the next position and stores the previous position and direction."""
		if position == positions[0]:
			last_pos = current_pos
			current_pos = position
			last_dir = current_dir
			current_dir = directions[0]
			next_pos += directions[0] * Autoload.tile_size
			clear_array()


func clear_array() -> void:
	"""Removes the first set of directions and positions when they are reached."""
	positions.pop_front()
	directions.pop_front()
