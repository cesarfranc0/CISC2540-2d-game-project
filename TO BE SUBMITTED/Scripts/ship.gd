# ship.gd (Godot 4)
extends CharacterBody2D

@export var max_speed: float = 350.0
@export var accel: float = 6.0
@export var turn_speed: float = 10.0
@export var arrive_radius: float = 24.0
@export var stop_radius: float = 6.0
@export var clamp_to_screen: bool = true

@onready var _vp: Viewport = get_viewport()

func _physics_process(delta: float) -> void:
	var target: Vector2 = get_global_mouse_position()
	var to_target: Vector2 = target - global_position
	var dist: float = to_target.length()

	# Desired speed (slow near cursor)
	var desired_speed: float = max_speed
	if dist < arrive_radius:
		var denom: float = maxf(0.001, arrive_radius - stop_radius)
		var t: float = clampf((dist - stop_radius) / denom, 0.0, 1.0)
		desired_speed = lerpf(0.0, max_speed, t)

	# Desired velocity
	var desired_vel: Vector2 = Vector2.ZERO
	if dist > stop_radius:
		desired_vel = to_target.normalized() * desired_speed

	# Steer toward desired velocity
	velocity = velocity.lerp(desired_vel, accel * delta)
	move_and_slide()

	# Face movement direction
	if velocity.length() > 1.0:
		var desired_rot: float = velocity.angle()
		rotation = lerp_angle(rotation, desired_rot, turn_speed * delta)  # <- fixed

	# Keep inside screen (optional)
	if clamp_to_screen:
		var r: Rect2 = _vp.get_visible_rect()
		global_position.x = clampf(global_position.x, r.position.x, r.end.x)
		global_position.y = clampf(global_position.y, r.position.y, r.end.y)
