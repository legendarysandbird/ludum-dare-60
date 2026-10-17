class_name Character
extends CharacterBody3D

@export var speed = 5.0
@export var accel = 10.0
@export var turn_speed = 10.0

@onready var visual: Node3D = $Visual

func _physics_process(delta: float) -> void:
	var direction := get_move_direction()

	var horizontal := Vector3(velocity.x, 0.0, velocity.z)
	horizontal = horizontal.move_toward(direction * speed, accel * delta)
	velocity.x = horizontal.x
	velocity.z = horizontal.z
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	if direction:
		face_direction(direction, delta)
	move_and_slide()

func get_move_direction() -> Vector3:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := Vector3(input.x, 0.0, input.y)
	var camera := get_viewport().get_camera_3d()
	if camera:
		direction = direction.rotated(Vector3.UP, camera.global_rotation.y)
	return direction.normalized()

func face_direction(direction: Vector3, delta: float) -> void:
	var target_yaw := atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_yaw, 1.0 - exp(-turn_speed * delta))
