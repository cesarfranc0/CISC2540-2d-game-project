extends Camera2D

var max_y_position := 0.0

func _process(delta: float) -> void:
	# Only move the camera upward when the player reaches a new height
	if global_position.y < max_y_position:
		max_y_position = global_position.y
	else:
		global_position.y = max_y_position
