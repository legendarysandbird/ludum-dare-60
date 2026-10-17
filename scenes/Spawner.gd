extends Node2D

@export var sceneToSpawn: PackedScene
@export var numScenes: int
@export var scenePadding: int
@export var slideDuration: float

@onready var anchorNode: Node2D = $Anchor

var activeNodes: Array
var slideInStart: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numScenes):
		var newScene: Node2D = sceneToSpawn.instantiate()
		newScene.position.x += node_offset(i)
		anchorNode.add_child(newScene)
		activeNodes.push_back(newScene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if slideInStart <= 0:
		return

	var t = (current_time() - slideInStart) / (slideDuration * 1000)
	if t < 1:
		for i in range(len(activeNodes)):
			var node = activeNodes[i]
			node.position.x = lerp(node_offset(i + 1), node_offset(i), t)


func _on_timer_timeout() -> void:
	var scene: Node2D = activeNodes.pop_front()
	if scene != null:
		scene.queue_free()
		slideInStart = current_time()
	
func node_offset(index: int):
	return index * scenePadding * -1

func current_time():
	return Time.get_ticks_msec()
