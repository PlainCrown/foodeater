extends Control

"""Displays and manages the score, high score, speed and reset request."""

onready var reset_request = $MarginContainer/ResetRequest
onready var score = $MarginContainer2/HBoxContainer/HBoxContainer/VBoxContainer/Score
onready var high_score = $MarginContainer2/HBoxContainer/HBoxContainer/VBoxContainer/HighScore

var points = 0
var fast = 5
var normal = 3.7
var slow = 2.4


func _ready():
	# hides the restart request label at the start of the game and puts the UI in front of the snake
	hide_reset_request()
	set_as_toplevel(1)
	high_score.text = str(Autoload.best_score)


func show_reset_request():
	# tells the player to restart the game
	reset_request.show()


func hide_reset_request():
	# hides the restart request label
	reset_request.hide()

func _on_FastButton_pressed():
	# sets snake speed to fast
	Autoload.default_speed = fast


func _on_NormalButton_pressed():
	# sets snake speed to normal
	Autoload.default_speed = normal


func _on_SlowButton_pressed():
	# sets snake speed to slow
	Autoload.default_speed = slow


func add_10():
	# increases the players score by 10 points and displays the change
	points += 10
	score.text = str(points)


func score_check():
	# checks if the users current score is better than their best score
	# called when the player dies, restarts, or returns to menu
	if points > Autoload.best_score:
		Autoload.best_score = points
		high_score.text = str(Autoload.best_score)


func point_reset():
	# sets points back to 0 after restarting
	points = 0
	score.text = str(points)
