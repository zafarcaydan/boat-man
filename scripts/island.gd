extends OceanFeature

var unused := true
var UI := GT.get_ui()
@export var type : GT.island_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ocean_feature_ready()
	if type == -1:
		type = randi_range(0, GT.island_types.size() -2)
	
func post_button(costs: Array[Array], purpose: StringName, index: int, dynamic: bool) -> void:
	var button := UpgradeMenuButton.new()
	button.button_id = purpose
	if dynamic:
		for i in costs:
			i[1] -= int(GT.get_player().fitness)
	button.costs = costs
	
	GT.get_ui()[index].add_child(button)

func interact() -> void:
	if unused:
		GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
		if type == GT.island_types.Stone:
			post_button([[0,0],[1,-1],[2,-6]], &"cannon_ball_speed", 1, true)
			post_button([[2,5]], &"stone", 2, false)
			
		elif type == GT.island_types.Wood:
			post_button([[1,-5], [2, -1]], &"repair", 1, true)
			post_button([[GT.resource_types.Wood, 4]], &"wood", 2, false)
			
		
		
		
		
		#player.change_resource_value(GT.resource_types.Wood, -5)
		unused = false
		#player.health += 2
		
	if not unused: $StaticBody2D.rotation = PI * 1.75
