extends Area2D

signal collected

func _ready() -> void:
	# Play idle/rotation animation if you have one
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("spin")

	# Connect the body_entered signal
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # make sure your Player is in "player" group
		emit_signal("collected")
		queue_free()  # remove coin after collecting
