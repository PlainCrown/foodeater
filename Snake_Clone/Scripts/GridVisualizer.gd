extends Node2D

"""This code makes the grid visible in-game and was taken and modified from the GDquest tutorial demo repository:
	https://github.com/GDquest/Godot-engine-tutorial-demos/tree/master/2017/final/06-Grid-based%20movement"""

onready var quadrant_size = $"..".cell_quadrant_size
var tile_size = 40


func _ready():
	modulate = Color(1, 1, 1, 1)

func _draw():
	var LINE_COLOR = Color(255, 255, 255)
	var LINE_WIDTH = 1
	for x in range(quadrant_size + 1):
		var col_pos = x * tile_size
		var limit = quadrant_size * tile_size
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	for y in range(quadrant_size + 1):
		var row_pos = y * tile_size
		var limit = quadrant_size * tile_size
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
