extends Control

"""Displays and manages the scores, high scores, and the reset request."""

onready var reset_request := $ResetRequest
onready var speed_label := $MarginContainer/VBoxContainer/HBoxContainer/SpeedLabel
onready var obstacles_label := $MarginContainer/VBoxContainer/HBoxContainer/ObstaclesLabel
onready var score := $MarginContainer/VBoxContainer/HBoxContainer2/Score
onready var high_score := $MarginContainer/VBoxContainer/HBoxContainer3/Highscore

var points := 0
var game_type := 0

func _ready() -> void:
	"""Sets the game type and loads the appropriate high score from the Autoload."""
	if Autoload.obstacles:
		game_type += 1
		obstacles_label.visible = true
	if Autoload.snake_speed == Autoload.SLOW:
		game_type += 1
		speed_label.text = "Slow"
	elif Autoload.snake_speed == Autoload.NORMAL:
		game_type += 3
		speed_label.text = "Normal"
	else:
		game_type += 5
		speed_label.text = "Fast"
	high_score.text = str(Autoload.highscore_dictionary[game_type])
	
	"""Places the user interface on the top level of the game. This prevents the snake 
	from covering the reset label even though it's at the bottom of the node tree."""
	set_as_toplevel(1)


func show_reset_request() -> void:
	"""Shows the reset request."""
	reset_request.show()


func hide_reset_request() -> void:
	"""Hides the reset request."""
	reset_request.hide()


func add_points(food_name: String) -> void:
	"""Increases the points according to the type of food eaten and updates the score."""
	if food_name == "FoodArea":
		points += 5
	else:
		points += 15
	score.text = str(points)
	
	"""Updates the high score if the previous high score is beaten."""
	if points > Autoload.highscore_dictionary[game_type]:
		Autoload.highscore_dictionary[game_type] = points
		high_score.text = str(points)


func point_reset() -> void:
	"""Resets the score to 0 when the game is restarted."""
	points = 0
	score.text = str(points)
