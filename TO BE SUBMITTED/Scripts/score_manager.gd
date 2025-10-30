extends Node
signal score_changed(value: int)
signal target_reached

@export var target_score := 10
@export var portal_scene: PackedScene         # ← set this in Inspector to Scenes/portal.tscn

var score: int = 0
var _fired := false
var score_label: Label
var portal: Area2D

func _ready() -> void:
	# HUD label found by group (your Label is already in group "score_label")
	score_label = get_tree().get_first_node_in_group("score_label")

	# Spawn portal now (hidden + following handled by portal.gd)
	if portal_scene:
		portal = portal_scene.instantiate() as Area2D
		get_tree().current_scene.add_child(portal)

	# Connect existing + future tokens
	for token in get_tree().get_nodes_in_group("tokens"):
		_connect_token(token)
	get_tree().node_added.connect(_on_node_added)

	_update_score_display()

func add(points: int) -> void:
	score += points
	emit_signal("score_changed", score)
	_update_score_display()
	if score >= target_score and not _fired:
		_fired = true
		emit_signal("target_reached")
		if is_instance_valid(portal) and portal.has_method("lock_and_reveal"):
			portal.lock_and_reveal()

func _on_node_added(node: Node) -> void:
	if node.is_in_group("tokens"):
		_connect_token(node)

func _connect_token(token: Node) -> void:
	if not token.is_connected("collected", Callable(self, "_on_token_collected")):
		token.connect("collected", Callable(self, "_on_token_collected"))

func _on_token_collected() -> void:
	add(1)

func _update_score_display() -> void:
	if score_label:
		score_label.text = "Score = %d" % score
