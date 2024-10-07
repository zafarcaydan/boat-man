extends Control


@onready var main_scene := preload("res://scenes/world.tscn")

func _on_start_button_button_down():
	get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_button_down():
	get_tree().quit()
