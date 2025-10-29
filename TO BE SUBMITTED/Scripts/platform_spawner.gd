extends Node2D

@export var platform_scene: PackedScene
@export var spawn_distance_y: float = 120.0  # vertical spacing
@export var min_x: float = -200.0            # left limit
@export var max_x: float = 200.0             # right limit
@export var starter_platforms: int = 5       # how many to spawn at the start


var last_platform_y: float

func _ready() -> void:
	randomize()

	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Start spawning just above the player
		last_platform_y = player.global_position.y - 100
	else:
		last_platform_y = 0.0

	# Create some starter platforms
	for i in range(starter_platforms):
		spawn_platform()


func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	# If the player gets close to the last spawned platform, add a new one above
	if player.global_position.y - 300 < last_platform_y:
		spawn_platform()

	# Clean up platforms that are far below the player
	cleanup_platforms(player.global_position.y + 600)


func spawn_platform() -> void:
	if platform_scene == null:
		return

	var y_offset = spawn_distance_y + randi_range(-20, 20)
	var x_position = randf_range(min_x, max_x)

	var platform = platform_scene.instantiate()
	platform.global_position = Vector2(x_position, last_platform_y - y_offset)
	add_child(platform)
	platform.add_to_group("platforms")

	last_platform_y = platform.global_position.y
	print("Spawned platform at:", platform.global_position)


func cleanup_platforms(threshold_y: float) -> void:
	var platforms = get_tree().get_nodes_in_group("platforms")
	for platform in platforms:
		if platform.global_position.y > threshold_y:
			platform.queue_free()
