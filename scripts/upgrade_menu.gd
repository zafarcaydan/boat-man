extends Control

func _ready() -> void:
	get_tree().paused = true

func _on_button_button_down() -> void:
	queue_free()
	get_tree().paused = false
	
	


func _on_button_2_button_up():
	get_tree().change_scene_to_packed(load("res://scenes/start_menu.tscn"))
