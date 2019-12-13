extends Area2D

"""Calls for add_tail() in Game.gd, re-positions food after it's consumed."""

onready var main_node := $".."
onready var UI := $"../UI"
onready var food_area = $"../FoodArea"
onready var frog_timer = $FrogTimer
onready var frog_collision = $FrogCollision

var last_pos = null


func _ready() -> void:
	visible = false
	frog_collision.disabled = true


func position_check(next_pos: Vector2) -> void:
	if next_pos == position and visible == true:
		main_node.add_tail(name)
		frog_collision.disabled = true
		visible = false
		UI.add_points(name)


func spawn_attempt() -> void:
	var random := rand_range(0, 100)
	if random < 7:
		spawn()


func spawn() -> void:
	# places the food on any random cell that the snake isn't on
	# sometimes the food still gets placed under the snake for some reason
	var random_pos := Vector2(rand_range(40, 640), rand_range(40, 640))
	var new_pos := random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	while new_pos in Autoload.all_current_pos or new_pos in Autoload.all_last_pos \
	or new_pos in Autoload.all_next_pos or new_pos == Vector2(80, 320) and Autoload.just_started \
	or new_pos == food_area.position:
		random_pos = Vector2(rand_range(40, 640), rand_range(40, 640))
		new_pos = random_pos.snapped(Vector2(Autoload.tile_size, Autoload.tile_size))
	position = new_pos
	visible = true
	frog_collision.disabled = false
	frog_timer.start()


func _on_FrogTimer_timeout() -> void:
	frog_collision.disabled = true
	visible = false
