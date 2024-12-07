extends Control

#func _ready() -> void:
#	get_tree().paused = true

func _on_button_button_down() -> void:
	queue_free()
	get_tree().paused = false
	
func _process(_delta: float) -> void:
	get_tree().paused = true


func _on_button_2_button_up():
	if get_tree().root.get_child(2) is not Control:
		get_tree().paused = false
		(func(): get_tree().paused = false).call_deferred()
		get_tree().change_scene_to_packed(load("res://scenes/start_menu.tscn"))
		
		
