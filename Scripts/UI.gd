extends Control

"""Displays and manages the score, high score, speed and reset request."""

onready var reset_request := $MarginContainer/ResetRequest
onready var score := $MarginContainer2/HBoxContainer/HBoxContainer/VBoxContainer/Score
onready var high_score := $MarginContainer2/HBoxContainer/HBoxContainer/VBoxContainer/HighScore

var points := 0


func _ready() -> void:
	# hides the restart request label at the start of the game and puts the UI in front of the snake
	hide_reset_request()
	set_as_toplevel(1)
	high_score.text = str(Autoload.best_score)


func show_reset_request() -> void:
	# tells the player to restart the game
	reset_request.show()


func hide_reset_request() -> void:
	# hides the restart request label
	reset_request.hide()


func add_points(food_name: String) -> void:
	# increases the players score by 10 points and displays the change
	if food_name == "FoodArea":
		points += 5
	else:
		points += 15
	score.text = str(points)


func score_check() -> void:
	# checks if the users current score is better than their best score
	# called when the player dies, restarts, or returns to menu
	if points > Autoload.best_score:
		Autoload.best_score = points
		high_score.text = str(Autoload.best_score)


func point_reset() -> void:
	# sets points back to 0 after restarting
	points = 0
	score.text = str(points)
