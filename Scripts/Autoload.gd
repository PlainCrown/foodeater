extends Node

"""Autoload script containing variables that are used across multiple different scripts.
Responsible for saving and loading save files and user preferences.
Also adds and controls the music audio player."""

onready var music_file := preload("res://Assets/Sound/music_track.ogg")
onready var config_path = "user://config.ini"
onready var save_path = "user://save.dat"

const SLOW = 2.5
const NORMAL = 3.5
const FAST = 4.5

var music_player := AudioStreamPlayer.new()
# warning-ignore:unused_class_variable
var tile_size := 40
# warning-ignore:unused_class_variable
var tail_scale := 0.998
# warning-ignore:unused_class_variable
var snake_speed = NORMAL
# warning-ignore:unused_class_variable
var obstacles := false
# warning-ignore:unused_class_variable
var just_started := true
# warning-ignore:unused_class_variable
var moving := true
# warning-ignore:unused_class_variable
var obstacle_positions := []
# warning-ignore:unused_class_variable
var all_last_pos := []
# warning-ignore:unused_class_variable
var all_current_pos := []
# warning-ignore:unused_class_variable
var all_next_pos := []

"""Array of positions where food and obstacles should never spawn at the start of each game."""
# warning-ignore:unused_class_variable
var no_spawn_zone := [Vector2(40, 320), Vector2(80, 320), Vector2(120, 320), Vector2(160, 320), Vector2(200, 320)]

"""Helps SnakeBody.gd distinguish betweeen tail nodes and default nodes."""
# warning-ignore:unused_class_variable
var default_node_count = null

"""Variables saved to config.ini"""
var music_volume: int setget music_volume_change
var sfx_volume: int setget sfx_volume_change
var fullscreen: bool
var show_grid: bool
var head_color: Color setget head_color_change
var tail_color: Color setget tail_color_change

"""Dictionary saved to save.dat"""
var highscore_dictionary := {} setget save_data


func _ready() -> void:
	"""Loads the config.ini and save.dat files.
	Switches to fullscreen if it has been turned on in the options menu."""
	load_config()
	if fullscreen:
		OS.window_fullscreen = true
	load_data()
	
	"""Creates and plays the music audio player which continues to play even when scenes are changed."""
	get_viewport().get_node("/root").call_deferred("add_child", music_player)
	music_player.stream = music_file
	music_player.volume_db = music_volume
	music_player.play()


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


func save_config() -> void:
	"""Creates a config file and saves all user preferences in the options menu."""
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("display", "show_grid", show_grid)
	config.set_value("snake", "head_color", head_color)
	config.set_value("snake", "tail_color", tail_color)
	var err := config.save(config_path)
	
	"""Checks if the config file was saved successfully."""
	if err != OK:
		print("Error while saving config")


func load_config() -> void:
	"""Loads the config file."""
	var config := ConfigFile.new()
	var err := config.load(config_path)
	
	"""Sets options menu values to default if the config file fails to load or does not exist."""
	if err != OK:
		music_volume = -10
		sfx_volume = -20
		fullscreen = false
		show_grid = true
		head_color = Color(0.72, 0, 0.13, 1)
		tail_color = Color(0.59, 0, 0.13, 1)
		print("Error while loading config. Default settings loaded.")
		return
	
	"""Sets option menu values to the values stored in the config file."""
	music_volume = config.get_value("audio", "music_volume")
	sfx_volume = config.get_value("audio", "sfx_volume")
	fullscreen = config.get_value("display", "fullscreen")
	show_grid = config.get_value("display", "show_grid")
	head_color = config.get_value("snake", "head_color")
	tail_color = config.get_value("snake", "tail_color")


func save_data(new_scores):
	"""Creates a save file."""
	highscore_dictionary = new_scores
	var save_file := File.new()
	var err := save_file.open(save_path, File.WRITE)
	
	"""Checks if the save file was opened successfully."""
	if err != OK:
		print("Error while opening save file")
		return
	
	"""Saves the dictionary and closes the save file."""
	save_file.store_var(highscore_dictionary)
	save_file.close()


func load_data():
	"""Loads the save file."""
	var save_file := File.new()
	var err := save_file.open(save_path, File.READ)
	
	"""Sets high score values to default if the save file fails to load or does not exist."""
	if err != OK:
		highscore_dictionary = {
			1: 0,  # SLOW
			2: 0,  # SLOW + OBSTACLES
			3: 0,  # NORMAL
			4: 0,  # NORMAL + OBSTACLES
			5: 0,  # FAST
			6: 0   # FAST + OBSTACLES
			}
		print("Error while loading save file. Default settings loaded.")
		return
	
	"""Sets high score values to the values stored in the save file."""
	highscore_dictionary = save_file.get_var()
	save_file.close()
