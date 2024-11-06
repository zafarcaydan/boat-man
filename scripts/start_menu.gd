extends Control


@onready var main_scene := preload("res://scenes/world.tscn")

func _ready() -> void:
	pass

func _on_start_button_button_down() -> void :
	get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_button_down() -> void:
	get_tree().quit()
