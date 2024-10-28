class_name Islands
extends OceanFeature


func post_button(costs: Array[Array], purpose: StringName, index: int, dynamic: bool) -> void:
	var button := UpgradeMenuButton.new()
	button.button_id = purpose
	if dynamic:
		for i in costs:
			i[1] -= int(GT.get_player().fitness)
	button.costs = costs
	GT.get_ui()[index].add_child(button)
