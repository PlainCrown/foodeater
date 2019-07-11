extends Node2D

"""Makes the grid visible in-game.
This is a modified version of the grid visualizer code from the GDquest tutorial demo repository:
https://github.com/GDquest/Godot-engine-tutorial-demos/tree/master/2017/final/06-Grid-based%20movement"""

onready var quadrant_size = $"..".cell_quadrant_size

const LINE_COLOR = Color(255, 255, 255)
const LINE_WIDTH = 1


func _draw():
	# draws the grid in-game
	for x in range(quadrant_size + 1):
		var col_pos = x * Autoload.tile_size
		var limit = quadrant_size * Autoload.tile_size
		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
	for y in range(quadrant_size + 1):
		var row_pos = y * Autoload.tile_size
		var limit = quadrant_size * Autoload.tile_size
		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
