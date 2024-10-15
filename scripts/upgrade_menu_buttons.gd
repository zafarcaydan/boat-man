class_name UpgradeMenuButton
extends Button

signal upgrade_button_pressed(button_id)
@export var button_id : StringName

func _ready() -> void:
	button_down.connect(_button_pressed)
	GT.get_player().connect_upgrade_button_signal(self)
	
	
func _button_pressed() -> void:
	upgrade_button_pressed.emit(button_id)
