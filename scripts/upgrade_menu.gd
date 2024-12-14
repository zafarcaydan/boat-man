extends Control

func _ready() -> void:
	get_tree().paused = true

func _on_button_button_down() -> void:

	(func(): get_tree().paused = false).call_deferred()
	get_tree().paused = false
	queue_free()

	



func _on_button_2_button_up():
	if get_tree().root.get_child(2) is not Control:
		get_tree().paused = false
		get_tree().change_scene_to_packed(load("res://scenes/start_menu.tscn"))
		
		
