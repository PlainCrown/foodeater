extends Control

"""Controls all the buttons in the options menu."""

onready var music_slider := $MusicSlider
onready var sfx_slider := $SFXSlider
onready var fullscreen_check := $FullscreenCheck
onready var show_grid_check := $ShowGridCheck
onready var head_color := $HeadColor
onready var tail_color := $TailColor
onready var audio_player := $AudioStreamPlayer

var playing := true


func _ready() -> void:
	"""Sets all of the options menu values to the values stored in the autoload."""
	music_slider.value = Autoload.music_volume
	sfx_slider.value = Autoload.sfx_volume
	fullscreen_check.pressed = Autoload.fullscreen
	show_grid_check.pressed = Autoload.show_grid
	head_color.color = Autoload.head_color
	tail_color.color = Autoload.tail_color
	"""Prevents the sound effect test sound from playing as soon as the options menu is opened."""
	playing = false


func _on_MusicSlider_value_changed(value: int) -> void:
	"""Changes the music volume."""
	Autoload.music_volume = value


func _on_SFXSlider_value_changed(value: int) -> void:
	"""Changes the sound effect volume."""
	Autoload.sfx_volume = value
	audio_player.volume_db = Autoload.sfx_volume
	if not playing:
		playing = true
		audio_player.play()


func _on_AudioStreamPlayer_finished() -> void:
	"""Prevents the sound effect test from playing again until the previous test has finished."""
	playing = false


# warning-ignore:unused_argument
func _on_FullscreenCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Switches the fullscreen mode on and off."""
	OS.window_fullscreen = !OS.window_fullscreen
	Autoload.fullscreen = !Autoload.fullscreen


# warning-ignore:unused_argument
func _on_ShowGridCheck_toggled(button_pressed: InputEventMouse) -> void:
	"""Turns the grid on and off."""
	Autoload.show_grid = !Autoload.show_grid


func _on_HeadColor_color_changed(color: Color) -> void:
	"""Changes the color of the snake head."""
	Autoload.head_color = color


func _on_TailColor_color_changed(color: Color) -> void:
	"""Changes the color of the snake tail."""
	Autoload.tail_color = color


func _on_BackButton_pressed() -> void:
	"""Exits the options menu when the back button is clicked."""
	Autoload.save_config()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _unhandled_key_input(event: InputEventKey) -> void:
	"""Exits the options menu when the escape key is pressed."""
	if event.scancode == KEY_ESCAPE:
		Autoload.save_config()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
