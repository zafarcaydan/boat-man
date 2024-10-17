extends Control

func _ready() -> void:
	get_tree().paused = true

func _on_button_button_down() -> void:
	queue_free()
	get_tree().paused = false
