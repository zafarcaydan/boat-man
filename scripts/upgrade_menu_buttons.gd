class_name UpgradeMenuButton
extends Button

signal upgrade_button_pressed(button_pressed)
@export var button_id : StringName
@export var costs : Array[Array]
	#the format of an array inside the costs array [rescource, amount

func _ready() -> void:
	button_down.connect(_button_pressed)
	GT.get_player().connect_upgrade_button_signal(self)
	for i in costs:
		text += str(i[1]) + " " + GT.resource_types.find_key(i[0]).replace("_", " ") + "\n"
	text += "\n" + button_id.replace("_", " ").capitalize()
	
	
func _button_pressed() -> void:
	upgrade_button_pressed.emit(self)
