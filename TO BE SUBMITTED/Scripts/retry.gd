extends Control

func _ready() -> void:
	visible = false
	$Button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
