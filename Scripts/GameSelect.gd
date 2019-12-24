extends Control

"""Controls the speed and obstacle mode settings in the game select menu."""

onready var slow_button := $MarginContainer/VBoxContainer/SlowButton
onready var normal_button := $MarginContainer/VBoxContainer/NormalButton
onready var fast_button := $MarginContainer/VBoxContainer/FastButton
onready var obstacle_check := $ObstaclesCheck


func _ready() -> void:
	"""Sets the speed and obstacle mode settings according to previous user set values."""
	if Autoload.snake_speed == Autoload.SLOW:
		slow_button.pressed = true
	elif Autoload.snake_speed == Autoload.NORMAL:
		normal_button.pressed = true
	else:
		fast_button.pressed = true
	if Autoload.obstacles:
		obstacle_check.pressed = true


func _on_StartButton_pressed() -> void:
	"""Starts the game."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game.tscn")


# warning-ignore:unused_argument
func _on_SlowButton_toggled(button_pressed: InputEventMouse) -> void:
	"""Sets the speed to slow."""
	normal_button.pressed = false
	fast_button.pressed = false
	Autoload.snake_speed = Autoload.SLOW
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		slow_button.pressed = true


# warning-ignore:unused_argument
func _on_NormalButton_toggled(button_pressed: InputEventMouse) -> void:
	"""Sets the speed to normal."""
	slow_button.pressed = false
	fast_button.pressed = false
	Autoload.snake_speed = Autoload.NORMAL
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		normal_button.pressed = true


# warning-ignore:unused_argument
func _on_FastButton_toggled(button_pressed: InputEventMouse) -> void:
	"""Sets the speed to fast."""
	slow_button.pressed = false
	normal_button.pressed = false
	Autoload.snake_speed = Autoload.FAST
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		fast_button.pressed = true


# warning-ignore:unused_argument
func _on_ObstaclesCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns obstacle mode on and off."""
	if Autoload.obstacles:
		Autoload.obstacles = false
	else:
		Autoload.obstacles = true


func _on_BackButton_pressed() -> void:
	"""Exits the game select menu when the back button is clicked."""
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the game select menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE and event.pressed:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
