class_name WorldHud
extends CanvasLayer

@onready var _timer_label: Label = %TimerLabel

func _ready() -> void:
	pass # Replace with function body.


func UpdateTimer(secondsRemaining:int) -> void:
		var seconds = ceili(secondsRemaining) % 60
		var minutes = int(secondsRemaining) / 60
		_timer_label.text = "%d:%d" % [minutes, seconds]
