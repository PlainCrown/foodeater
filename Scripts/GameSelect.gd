extends Control

onready var slow_button := $MarginContainer/VBoxContainer/SlowButton
onready var normal_button := $MarginContainer/VBoxContainer/NormalButton
onready var fast_button := $MarginContainer/VBoxContainer/FastButton
onready var obstacle_check := $ObstaclesCheck


func _ready() -> void:
	if Autoload.snake_speed == Autoload.SLOW:
		slow_button.pressed = true
	elif Autoload.snake_speed == Autoload.NORMAL:
		normal_button.pressed = true
	else:
		fast_button.pressed = true


func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_SlowButton_toggled(button_pressed) -> void:
	normal_button.pressed = false
	fast_button.pressed = false
	Autoload.snake_speed = Autoload.SLOW
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		slow_button.pressed = true


func _on_NormalButton_toggled(button_pressed) -> void:
	slow_button.pressed = false
	fast_button.pressed = false
	Autoload.snake_speed = Autoload.NORMAL
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		normal_button.pressed = true


func _on_FastButton_toggled(button_pressed) -> void:
	slow_button.pressed = false
	normal_button.pressed = false
	Autoload.snake_speed = Autoload.FAST
	if slow_button.pressed == false and normal_button.pressed == false and fast_button.pressed == false:
		fast_button.pressed = true


func _on_ObstaclesCheck_toggled(button_pressed) -> void:
	if Autoload.obstacles:
		Autoload.obstacles = false
	else:
		Autoload.obstacles = true


func _on_BackButton_pressed() -> void:
	"""Exits the options menu when the back button is clicked."""
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the options menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE and event.pressed:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
