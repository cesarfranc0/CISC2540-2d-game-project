extends Node
signal score_changed(value: int)
signal target_reached

@export var target_score := 10

var score: int = 0
var _fired := false
var score_label: Label
var portal: Area2D

func _ready() -> void:
	# Find HUD label by group or by node path
	score_label = get_tree().get_first_node_in_group("score_label")
	if score_label == null:
		score_label = get_node_or_null("/root/Main/HUD/Label") as Label

	# Find the portal placed in the scene (Area2D is inside the portal scene)
	portal = get_tree().get_first_node_in_group("portal") as Area2D
	if portal == null:
		portal = get_node_or_null("/root/Main/portal/Area2D") as Area2D

	# Connect to existing and future tokens
	for t in get_tree().get_nodes_in_group("tokens"):
		_connect_token(t)
	get_tree().node_added.connect(_on_node_added)

	_update_score_display()

func add(amount: int) -> void:
	score += amount
	emit_signal("score_changed", score)
	_update_score_display()
	if not _fired and score >= target_score:
		_fired = true
		emit_signal("target_reached")
		if portal and portal.has_method("lock_and_reveal"):
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
