extends KinematicBody2D

const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)
const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)


var speed = 200
var tile_size = 40
var last_pos = Vector2()
var target_pos = Vector2()
var direction = Vector2()
var last_dir = Vector2()


func _ready():
	last_pos = position
	target_pos = position + Vector2(tile_size, 0)
	direction = RIGHT
	last_dir = RIGHT


func _process(delta):
	move_and_collide(speed * last_dir * delta)
	if position.distance_to(last_pos) >= tile_size:
		position = target_pos
	if position == target_pos:
		last_dir = direction
		last_pos = position
		target_pos += direction * tile_size


func _unhandled_key_input(event):
	if event.scancode == KEY_A or event.scancode == KEY_LEFT:
		if last_dir != RIGHT:
			direction = LEFT
	elif event.scancode == KEY_D or event.scancode == KEY_RIGHT:
		if last_dir != LEFT:
			direction = RIGHT
	elif event.scancode == KEY_W or event.scancode == KEY_UP:
		if last_dir != DOWN:
			direction = UP
	elif event.scancode == KEY_S or event.scancode == KEY_DOWN:
		if last_dir != UP:
			direction = DOWN
