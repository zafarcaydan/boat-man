extends OceanFeature

var unused := true
var UI := GT.get_ui()
@export var type : GT.island_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ocean_feature_ready()
	type = randi_range(0, GT.island_types.size() -1)
	
func post_buttons(costs: Array[Array], purpose: StringName, index: int) -> void:
	var button := UpgradeMenuButton.new()
	button.button_id = purpose
	button.costs = costs
	GT.get_ui()[index].add_child(button)

func interact() -> void:
	if unused:
		GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
		if type == GT.island_types.Stone:
			post_buttons([[0,-1],[1,-2],[2,-7]], &"cannon_ball_speed", 1)
			post_buttons([[2,5]], &"stone", 2)
			
		elif type == GT.island_types.Wood:
			post_buttons([[1,-6], [2, -2]], &"repair", 2)
			
		
		
		
		
		#player.change_resource_value(GT.resource_types.Wood, -5)
		unused = false
		#player.health += 2
		
	if not unused: $StaticBody2D.rotation = PI * 1.75
