extends Node

"""Autoload script containing variables that are used across multiple different scripts.
Also adds and controls a music player."""

onready var music_file = preload("res://Assets/Sound/music_track.ogg")

var tile_size = 40
var default_speed = 3.9
var best_score = 0
var moving = true
var sound = true setget music_switch
var music_player = AudioStreamPlayer.new()
# this variable helps SnakeBody.gd tell default nodes apart from tail nodes that get added later
var default_node_count = null


func _ready():
	# adds and starts a music player that persists through scene changes
	get_viewport().get_node("/root").call_deferred("add_child", music_player)
	music_player.stream = music_file
	music_player.volume_db = -14
	music_player.play()


func music_switch(boolean_value):
	# turns the music player on and off when the sound variable is changed
	sound = boolean_value
	if sound:
		music_player.play()
	else:
		music_player.stop()
