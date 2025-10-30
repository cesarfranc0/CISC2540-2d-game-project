extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -1000.0
@export var death_y = 1000.0 
@onready var anim: AnimatedSprite2D = $Sprite
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead: bool = false

func _physics_process(delta):
	if is_dead:
		return
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	# Flip sprite based on movement
	if direction != 0:
		$Sprite.flip_h = direction < 0

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	# Move
	move_and_slide()

	# Handle animations
	if direction != 0:
		$Sprite.play("run")
	else:
		$Sprite.play("idle")
		
	# check for death
	if global_position.y > death_y:
		die()
		
func _ready() -> void:
	# Make sure the 'die' animation does NOT loop even if the editor flag got missed
	if anim.sprite_frames.has_animation("die"):
		anim.sprite_frames.set_animation_loop("die", false)
	anim.play("idle")
	# Listen for animation end
	anim.animation_finished.connect(_on_animation_finished)

func die() -> void:
	if is_dead: return
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)  # stop movement logic
	anim.play("die")

func _on_animation_finished() -> void:
	if anim.animation == "die":
		# Tell Main/HUD to show the Retry UI. Pick whichever path matches your scene tree.
		var retry := get_node_or_null("/root/Main/HUD/Retry")
		if retry:
			get_tree().paused = true
			retry.visible = true
