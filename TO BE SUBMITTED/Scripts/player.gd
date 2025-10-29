extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -1000.0
@export var death_y = 1000.0 
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
		
func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	print(">>> DIE called. Playing animation...")
	$Sprite.play("die")
	
	print("Current animation:", $Sprite.animation)
 
	
	await $Sprite.animation_finished
	get_tree().reload_current_scene()
	print("Player position:", global_position, " | Dead:", is_dead)
