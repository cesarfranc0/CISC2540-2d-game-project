extends Node2D

@export var coin_scene: PackedScene
@export var spawn_distance_y: float = 150.0  # vertical spacing between coins
@export var min_x: float = -100.0
@export var max_x: float = 100.0
@export var max_coins: int = 20              # how many to keep alive at once

var last_coin_y: float

func _ready() -> void:
	randomize()

	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Start spawning just above the player
		last_coin_y = player.global_position.y - 200
	else:
		last_coin_y = 0.0

	# Spawn a few starter coins
	for i in range(5):
		spawn_coin()


func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	# Spawn new coins ABOVE the player as they move up
	if player.global_position.y - 400 < last_coin_y:
		spawn_coin()

	# Clean up old coins below the camera
	cleanup_coins(player.global_position.y + 600)


func spawn_coin() -> void:
	if coin_scene == null:
		return

	var y_offset = spawn_distance_y + randi_range(-30, 30)
	var x_position = randf_range(min_x, max_x)

	# Spawn ABOVE the last coin (smaller Y = higher)
	var coin = coin_scene.instantiate()
	coin.global_position = Vector2(x_position, last_coin_y - y_offset)
	add_child(coin)
	coin.add_to_group("tokens")

	last_coin_y = coin.global_position.y
	print("Spawned coin at:", coin.global_position)


func cleanup_coins(threshold_y: float) -> void:
	var coins = get_tree().get_nodes_in_group("tokens")
	for coin in coins:
		if coin.global_position.y > threshold_y:
			coin.queue_free()
