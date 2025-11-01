extends Control

# Path to the scene you want to load
@export_file("*.tscn") var game_scene_path = "res://Scenes/main.tscn"

@onready var play_button = $CenterContainer/VBoxContainer/PlayButton

func _ready():
	# Center the title and make it larger

	# Connect the Play button
	play_button.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
	if ResourceLoader.exists(game_scene_path):
		get_tree().change_scene_to_file(game_scene_path)
	else:
		push_warning("Scene not found at: " + game_scene_path)
