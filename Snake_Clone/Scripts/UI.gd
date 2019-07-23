extends Control

onready var reset_request = $MarginContainer/ResetRequest

func _ready():
	# hides the restart request label at the start of the game and puts the UI in front of the snake
	hide_reset_request()
	set_as_toplevel(1)


func show_reset_request():
	# tells the player to restart the game
	reset_request.show()


func hide_reset_request():
	# hides the restart request label
	reset_request.hide()