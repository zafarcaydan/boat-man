extends OceanFeature

var type : GT.super_island_types
var stage : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	ocean_feature_ready()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match type:
		GT.super_island_types.FIRST:
			if stage ==  1: if get_tree().get_node_count_in_group("Enemies") == 0: stage = 2
			elif stage == 3: if get_tree().get_node_count_in_group("Enemies") == 0: stage = 4
		
		


func post_button(costs: Array[Array], purpose: StringName, index: int) -> void:
	var button := UpgradeMenuButton.new()
	button.button_id = purpose
	button.costs = costs
	
	GT.get_ui()[index].add_child(button)
	
func interact():
	##the number of "_" in the beginning of an id shows the iteration of super island it comes from
	GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
	match type:
		GT.super_island_types.FIRST:
			if stage == 0:
				post_button([[0, 30]], &"cannon_ballls", 2)
				post_button([], &"_summon_enemies_round_1", 2)
				stage = 1
			
			elif stage == 1:
				post_button([[0, 5]], &"cannon_ballls", 2)
				post_button([[GT.resource_types.Wood, -2], [GT.resource_types.Stone, -1]], &"repair", 1)
				for i in $Node2D.get_children(): i.unused = false
				
			elif stage == 2:
				post_button([[0, 30]], &"cannon_ballls", 2)
				post_button([], &"_summon_enemies_round_2", 2)
				stage = 3
				
			elif stage == 4:
				post_button([[0, 30]], &"cannon_ballls", 2)
				post_button([], &"collect_horn_piece", 2)
				remove_from_group("Super Island")
				for i in $Node2D.get_children(): i.remove_from_group("Super Island")
				
			
