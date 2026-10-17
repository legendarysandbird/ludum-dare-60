class_name WorldController
extends Node3D

#timer or stamina
@export var spawn_point: Marker3D

@onready var timer: Timer = $Timer

const playerScene = preload("res://World/Character/character.tscn")

func _ready() -> void:
	var playerInstance = playerScene.instantiate()
	add_child(playerInstance)
	var targetPos = spawn_point.global_position if spawn_point else Vector3(0,0,0)
	playerInstance.global_position = targetPos
