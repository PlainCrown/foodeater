extends Node

"""Autoload script containing variables that are used across multiple different scripts.
Also adds and controls a music player."""

onready var music_file := preload("res://Assets/Sound/music_track.ogg")

const SLOW = 2.5
const NORMAL = 3.5
const FAST = 4.5

var music_volume: int = -10 setget music_volume_change
var sfx_volume: int = -20 setget sfx_volume_change
var fullscreen: bool = false
var show_grid: bool = true
var head_color: Color = Color(0.72, 0, 0.13, 1) setget head_color_change
var tail_color: Color = Color(0.59, 0, 0.13, 1) setget tail_color_change

var tile_size := 40
var snake_speed := NORMAL
var best_score := 0
var obstacles := false
var just_started := true
var moving := true
var tail_scale := 0.998
var sound := true setget music_switch
var music_player := AudioStreamPlayer.new()
var all_last_pos := []
var all_current_pos := []
var all_next_pos := []
# this variable helps SnakeBody.gd tell default nodes apart from the tail nodes that are added later
var default_node_count = null


func _ready() -> void:
	# adds and starts a music player that persists through scene changes
	get_viewport().get_node("/root").call_deferred("add_child", music_player)
	music_player.stream = music_file
	music_player.volume_db = music_volume
	music_player.play()


func music_switch(boolean_value: bool) -> void:
	# turns the music player on and off when the sound variable is changed
	sound = boolean_value
	if sound:
		music_player.play()
	else:
		music_player.stop()


func music_volume_change(value: int) -> void:
	"""Stores and adjusts the music volume setting."""
	music_volume = value
	if music_volume == -40:
		music_volume = -1000
	music_player.volume_db = music_volume


func sfx_volume_change(value: int) -> void:
	"""Stores and adjusts the sound effect volume setting."""
	sfx_volume = value
	if sfx_volume == -50:
		sfx_volume = -1000


func head_color_change(new_color: Color) -> void:
	"""Stores and adjusts the color of the snake's head."""
	head_color = new_color


func tail_color_change(new_color: Color) -> void:
	"""Stores and adjusts the color of the snake's tail."""
	tail_color = new_color
