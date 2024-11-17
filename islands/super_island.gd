extends Islands

@export var type : GT.super_island_types
var stage : int = 0
var unused := true
var resources_untaken := true
const ISLAND := preload("res://islands/island.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if type != GT.super_island_types.Home:
		for i in range(6):
			var new_island1 := ISLAND.instantiate()
			new_island1.position = Vector2.RIGHT.rotated(PI/3 * i)*1600
			new_island1.add_to_group("Super Island")
			$islands.add_child.call_deferred(new_island1)
			
			var new_island2 := ISLAND.instantiate()
			new_island2.position = Vector2.RIGHT.rotated(PI/3 * i + PI/6)*2400
			new_island2.add_to_group("Super Island")
			$islands.add_child.call_deferred(new_island2)
	
		
	if type == GT.super_island_types.Third: add_to_group("Third_Super_Island")
		


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
						if resources_untaken: post_button([[0, 40]], &"cannon_balls", 2)
						post_button([], &"_summon_enemies_round_1", 2)
					1:  post_button([[GT.resource_types.Wood, -2], [GT.resource_types.Stone, -2]], &"repair", 1, true)
					2:  
						if resources_untaken: post_button([[0, 40]], &"cannon_balls", 2)
						post_button([], &"_summon_enemies_round_2", 2)
					3:  post_button([[GT.resource_types.Wood, -4], [GT.resource_types.Stone, -1]], &"repair", 1, true)
					4:  
						post_button([], &"_collect_horn_piece", 2)
						if resources_untaken:
							post_button([[2, 20]], &"stone", 2)
							post_button([[0, 40]], &"cannon_balls", 2)
							post_button([[1, 20]], &"wood", 2)
							
					
			GT.super_island_types.Second:
				match stage:
					0:
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2)
						post_button([], &"__summon_enemies_round_1", 2)
					1: post_button([[GT.resource_types.Wood, -2], [GT.resource_types.Stone, -3]], &"repair", 1, true)
					2: 
						if resources_untaken: post_button([[0, 40]], &"cannon_ballls", 2)
						post_button([], &"__summon_enemies_round_2", 2)
					3: post_button([[GT.resource_types.Wood, -3], [GT.resource_types.Stone, -2]], &"repair", 1, true)
					4: 
						post_button([], &"_collect_horn_piece", 2)
						if resources_untaken:
							post_button([[2, 20]], &"stone", 2)
							post_button([[0, 40]], &"cannon_balls", 2)
							post_button([[1, 20]], &"wood", 2)
							
			GT.super_island_types.Third:
				if player.stats[&"horn_parts"] == 2 :post_button([], &"craft_horn", 2)
				if resources_untaken:
					post_button([[2, 60]], &"stone", 2)
					post_button([[0, 100]], &"cannon_balls", 2)
					post_button([[1, 35]], &"wood", 2)
					post_button([], &"_repair", 2)
				post_button([], &"_replenish_islands", 2)
				post_button([[GT.resource_types.Wood, -3], [GT.resource_types.Stone, -1]], &"repair", 1, true)
				var new_lable := preload("res://scenes/inventory_slot.tscn").instantiate()
				new_lable.get_child(0).text = "Blow the horn. \n Find the pirate with the compass to home. \n Go home."
				GT.get_ui()[1].get_parent().add_child(new_lable)
		
			GT.super_island_types.Home:
				var new_lable := preload("res://scenes/inventory_slot.tscn").instantiate()
				new_lable.get_child(0).text = "Welcome Home \n Score: " + str(round((player.time_passed * 0.9 - player.highest_fitness * 8) * 100)/ 100)
				GT.get_ui()[1].add_child(new_lable)
				post_button([], &"_return_home", 1)
		if resources_untaken: replenish_islands()
		resources_untaken = false
		unused = false
		$Timer.start()
		
func _on_timer_timeout() -> void: unused = true

func replenish_islands() -> void:
	for i in $islands.get_children(): 
		i.unused = true
		i.set_used_display()
	
