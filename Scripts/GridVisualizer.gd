extends Node2D

"""Draws the grid."""

onready var quadrant_size: int = $"..".cell_quadrant_size

const LINE_COLOR = Color(255, 255, 255)
const LINE_WIDTH = 1


func _draw() -> void:
	"""Draws the grid if it's turned on in the options menu."""
	if Autoload.show_grid:
		for x in range(quadrant_size + 1):
			var col_pos := x * Autoload.tile_size
			var limit := quadrant_size * Autoload.tile_size
			draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
		for y in range(quadrant_size + 1):
			var row_pos := y * Autoload.tile_size
			var limit := quadrant_size * Autoload.tile_size
			draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
