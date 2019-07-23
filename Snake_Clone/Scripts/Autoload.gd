extends Node

"""Autoload script containing variables that are used across multiple different scripts"""

var tile_size = 40
var default_speed = 300
var moving = true
# this variable helps SnakeBody.gd tell default nodes apart from tail nodes that get added later
var default_node_count = null