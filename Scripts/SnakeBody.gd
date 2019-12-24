extends KinematicBody2D

"""Responsible for moving and reseting the snake head.
Also provides positions and directions to all tail nodes."""

onready var main_node := $".."
onready var food_area := $"../FoodArea"
onready var UI := $"../UI"
onready var snake_pos := $"../SnakePosition"
onready var frog := $"../Frog"
onready var audio_player := $"../AudioStreamPlayer"
onready var snake_sprite := $SnakeSprite

const CRASH_SOUND = preload("res://Assets/Sound/crash.wav")
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
	"""Sets the snake's color at the start of the game and begins its movement."""
	snake_sprite.modulate = Autoload.head_color
	reset()


func _unhandled_key_input(event) -> void:
	"""Allows the user to pick the next movement direction and prevents backward movement."""
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


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	"""Moves the snake."""
	if Autoload.moving:
		var collision := move_and_collide(Autoload.snake_speed * current_dir)
		if position.distance_to(current_pos) >= Autoload.tile_size:
			position = next_pos
		
		"""Sets the next position and stores previous position and direction."""
		if position == next_pos:
			changed_next_pos = true
			last_dir = current_dir
			current_dir = next_dir
			last_pos = current_pos
			current_pos = position
			next_pos += next_dir * Autoload.tile_size
			pos_change(next_pos)
		
		"""Informs tail nodes about their next positions and directions."""
		if changed_next_pos:
			for tail_part in range(Autoload.default_node_count, main_node.get_child_count()):
				var tail := get_parent().get_child(tail_part)
				tail.positions.append(current_pos)
				tail.directions.append(current_dir)
			changed_next_pos = false
		
		"""Stops the movement of the snake and its tail when a collision with a wall or self occurs."""
		if collision != null:
			Autoload.moving = false
			audio_player.stream = CRASH_SOUND
			audio_player.pitch_scale = 1
			audio_player.play()
			UI.show_reset_request()


func pos_change(vector: Vector2) -> void:
	"""Asks the food the and frog to compare their positions with the snake's next position."""
	next_pos = vector
	food_area.position_check(vector)
	if frog.visible == true:
		frog.position_check(vector)


func reset() -> void:
	"""Resets the snake's settings."""
	UI.point_reset()
	last_pos = Vector2(80, 320)
	current_pos = snake_pos.position
	position = current_pos
	next_pos = current_pos + Vector2(Autoload.tile_size, 0)
	last_dir = RIGHT
	current_dir = RIGHT
	next_dir = RIGHT
	Autoload.moving = true
