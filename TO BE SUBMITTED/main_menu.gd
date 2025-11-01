extends Control

@export_file("*.tscn") var target_scene : String = "res://past.tscn"

@onready var play_button: Button = %PlayButton
@onready var anim: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	# Focus the Play button so Enter works immediately
	play_button.grab_focus()

	# Connect the pressed signal in code (or wire it in the editor)
	play_button.pressed.connect(_on_play_pressed)

	# Fancy: play idle pulse on the button
	if anim.has_animation("button_pulse"):
		anim.play("button_pulse")

func _unhandled_input(event: InputEvent) -> void:
	# Keyboard shortcuts
	if event.is_action_pressed("ui_accept"):
		_on_play_pressed()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_play_pressed() -> void:
	# Basic safety: check that the file exists
	if ResourceLoader.exists(target_scene):
		get_tree().change_scene_to_file(target_scene)
	else:
		push_warning("Target scene not found: %s" % target_scene)
