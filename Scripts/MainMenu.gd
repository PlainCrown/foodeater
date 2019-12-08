extends Control

"""Controls the functionality of all the buttons on the main menu screen."""

onready var controls_page := $ControlsPage
onready var sound := $MarginContainer/VBoxContainer/Sound


func _ready() -> void:
	# hides the controls page when the game is started and makes the sound button remain toggled
	controls_page.hide()
	if Autoload.sound == true:
		sound.pressed = false
	else:
		sound.pressed = true


func _on_Start_pressed() -> void:
	# changes to the first level scene when the start button is pressed
	get_tree().change_scene("res://Scenes/GameSelect.tscn")


func _on_Controls_pressed() -> void:
	# shows the controls page
	controls_page.show()


func _on_Exit_pressed() -> void:
	# closes the game window when the exit button is pressed
	get_tree().quit()


func _on_Sound_toggled(button_pressed: InputEvent) -> void:
	# if toggled turns off all sound and music by setting the sound variable in autoload to false
	if Autoload.sound == false:
		Autoload.sound = true
	else:
		Autoload.sound = false


func _unhandled_key_input(event: InputEventKey) -> void:
	# hides the controls page when escape is pressed
	if event.scancode == KEY_ESCAPE:
		controls_page.hide()
