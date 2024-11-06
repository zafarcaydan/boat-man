class_name Islands
extends OceanFeature

func _ready() -> void: super()

func post_button(costs: Array[Array], purpose: StringName, index: int, dynamic: bool = false) -> void:
	var button := UpgradeMenuButton.new()
	button.button_id = purpose
	if dynamic:
		for i in costs:
			if i[1] <= 0: i[1] -= int(player.fitness)
	button.costs = costs
	GT.get_ui()[index].add_child(button)
