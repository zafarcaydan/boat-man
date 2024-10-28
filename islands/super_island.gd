extends Islands

@export var type : GT.super_island_types
var stage : int = 0
var unused := true
var resources_untaken := true
const ISLAND := preload("res://islands/island.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ocean_feature_ready()
	for i in range(6):
		var new_island1 := ISLAND.instantiate()
		new_island1.position = Vector2.RIGHT.rotated(PI/3 * i)*1600
		new_island1.add_to_group("Super Island")
		$islands.add_child.call_deferred(new_island1)
		
		var new_island2 := ISLAND.instantiate()
		new_island2.position = Vector2.RIGHT.rotated(PI/3 * i + PI/6)*2400
		new_island2.add_to_group("Super Island")
		$islands.add_child.call_deferred(new_island2)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	match stage:
		1: if get_tree().get_node_count_in_group("Enemies") == 0: GT.increase_super_island_stage()
		3: if get_tree().get_node_count_in_group("Enemies") == 0: GT.increase_super_island_stage()
		
		


	
func interact() -> void:
	if unused:
		GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
		match type:
			GT.super_island_types.First:
				match stage:
					0:
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2, false)
						post_button([], &"_summon_enemies_round_1", 2, false)
					1:  post_button([[GT.resource_types.Wood, -2], [GT.resource_types.Stone, -2]], &"repair", 1, true)
					2:  
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2, false)
						post_button([], &"_summon_enemies_round_2", 2, false)
					3:  post_button([[GT.resource_types.Wood, -4], [GT.resource_types.Stone, -1]], &"repair", 1, true)
					4:  
						post_button([], &"_collect_horn_piece", 2, false)
						if resources_untaken:
							post_button([[2, 20]], &"stone", 2, false)
							post_button([[0, 40]], &"cannon_balls", 2, false)
							post_button([[1, 20]], &"wood", 2, false)
							
					
			GT.super_island_types.Second:
				match stage:
					0:
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2, false)
						post_button([], &"__summon_enemies_round_1", 2, false)
					1: post_button([[GT.resource_types.Wood, -3], [GT.resource_types.Stone, -3]], &"repair", 1, true)
					2: 
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2, false)
						post_button([], &"__summon_enemies_round_2", 2, false)
					3: post_button([[GT.resource_types.Wood, -4], [GT.resource_types.Stone, -2]], &"repair", 1, true)
					4: 
						post_button([], &"_collect_horn_piece", 2, false)
						if resources_untaken:
							post_button([[2, 20]], &"stone", 2, false)
							post_button([[0, 40]], &"cannon_balls", 2, false)
							post_button([[1, 20]], &"wood", 2, false)
							
			GT.super_island_types.Third:
				post_button([], &"craft_horn", 2, false)
				var new_lable := preload("res://scenes/inventory_slot.tscn").instantiate()
				new_lable.get_child(0).text = "Blow the horn. \n Find the pirate with the compass to home. \n Go home."
				GT.get_ui()[1].get_parent().add_child(new_lable)
				
		resources_untaken = false
		for i in $islands.get_children(): 
				i.unused = true
				i.set_used_display()
		unused = false
		$Timer.start()
		
func _on_timer_timeout() -> void: unused = true
