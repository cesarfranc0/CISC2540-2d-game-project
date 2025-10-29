extends Node

var score: int = 0
var score_label: Label

func _ready() -> void:
	# Cache reference to the ScoreLabel
	score_label = get_tree().get_first_node_in_group("score_label")

	# Connect to all existing tokens
	for token in get_tree().get_nodes_in_group("tokens"):
		_connect_token(token)

	# Listen for tokens being added later
	get_tree().connect("node_added", Callable(self, "_on_node_added"))

	update_score_display()


func add_point(amount: int = 1) -> void:
	score += amount
	update_score_display()


func _on_token_collected() -> void:
	add_point(1)


func _on_node_added(node: Node) -> void:
	if node.is_in_group("tokens"):
		_connect_token(node)


func _connect_token(token: Node) -> void:
	if not token.is_connected("collected", Callable(self, "_on_token_collected")):
		token.connect("collected", Callable(self, "_on_token_collected"))


func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: %d" % score
