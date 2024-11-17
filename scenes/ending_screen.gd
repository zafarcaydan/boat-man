extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $CanvasLayer/VBoxContainer/HBoxContainer/Button.global_position.y > 100:
		$CanvasLayer/VBoxContainer.position.y -= 50  * delta
		$Sprite2D.position.y -= 25 * delta

func _input(event: InputEvent) -> void:
	if event.is_action("Key_Space") and $CanvasLayer/VBoxContainer/HBoxContainer/Button.global_position.y > 100:
		$CanvasLayer/VBoxContainer.position.y -=  400 * get_process_delta_time()


func _on_button_button_down() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/start_menu.tscn"))
