extends Node3D

@export_group("Rotation (degrees)")
@export var speed: float = 110.0
@export var pitch_min: float = -70.0
@export var pitch_max: float = -12.0

@export_group("Zoom")
@export var zoom_min: float = 15.0
@export var zoom_max: float = 5.0
@export_range(0, 1) var zoom_ratio: float = 1
@export var smoothing: float = 5.0

var _yaw: float
var _pitch: float
var _starting_pos: Vector3

@onready var _pivot: Node3D = $Pivot
@onready var _camera: Camera3D = $Pivot/Camera3D

func _ready() -> void:
	_starting_pos = global_position
	_yaw = rotation.y
	_pitch = _pivot.rotation.x
	_camera.position.z = zoom_min

func _process(delta: float) -> void:
	var orbit_speed := deg_to_rad(speed) * delta
	_yaw += Input.get_axis("camera_right", "camera_left") * orbit_speed
	_pitch += Input.get_axis("camera_up", "camera_down") * orbit_speed
	_pitch = clampf(_pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))

	var weight := 1.0 - exp(-smoothing * delta)
	rotation.y = lerp_angle(rotation.y, _yaw, weight)
	_pivot.rotation.x = lerp_angle(_pivot.rotation.x, _pitch, weight)

	var focus := _starting_pos
	global_position = global_position.lerp(focus, weight)

	var distance := lerpf(zoom_min, zoom_max, zoom_ratio)
	_camera.position.z = lerpf(_camera.position.z, distance, weight)
