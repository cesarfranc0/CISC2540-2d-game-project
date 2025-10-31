# Scripts/portal.gd
extends Area2D
@export_file("*.tscn") var next_scene: String = "res://Scenes/secondary_scene.tscn"
@export var follow_offset: Vector2 = Vector2(0, 0)

@onready var sprite := $Sprite
var _player: Node2D
var _locked := false

func _ready() -> void:
	add_to_group("portal")        # <— ADD THIS
	visible = false
	body_entered.connect(_on_body_entered)
	_player = get_tree().get_first_node_in_group("player") as Node2D
	if sprite is AnimatedSprite2D and sprite.sprite_frames.has_animation("idle"):
		sprite.play("idle")

func _process(_dt: float) -> void:
	if not _locked and _player:
		global_position = _player.global_position + follow_offset

func lock_and_reveal() -> void:
	_locked = true
	visible = true
	if sprite is AnimatedSprite2D and sprite.sprite_frames.has_animation("open"):
		sprite.play("open")

func _on_body_entered(body: Node) -> void:
	if not visible: return
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(next_scene)
