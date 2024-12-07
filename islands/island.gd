extends Islands

var unused := true
var UI := GT.get_ui()
@export var type : GT.island_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if type == -1:
		type = [GT.island_types.Stone, GT.island_types.Stone, GT.island_types.Wood, GT.island_types.Wood,  GT.island_types.Port].pick_random()
		if randf() < 0.4:
			var new_island := preload("res://islands/island.tscn").instantiate()
			new_island. type == [GT.island_types.Stone, GT.island_types.Wood, GT.island_types.Port, GT.island_types.Port].pick_random()
			player.spawn_feature(new_island, randf_range(-PI/2, PI/2), 1.6, 1.1)
	set_used_display()
	
	
	

func interact() -> void:
	if unused:
		GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
		match type:
			GT.island_types.Stone:
				post_button([[0,0],[1,-1],[2,-6]], &"cannon_ball_speed", 1, true)
				post_button([[2,5]], &"stone", 2)
				
				
			GT.island_types.Wood:
				post_button([[1,-4], [2, -1]], &"repair", 1, true)
				post_button([[GT.resource_types.Wood, 8]], &"wood", 2)
				if randf() < 0.3: post_button([[2,-7], [1, 16]], &"wood", 2)
				
			GT.island_types.Port:
				post_button([[1,-4], [2, -1]], &"repair", 1, true)
				post_button([[GT.resource_types.Stone, -10], [GT.resource_types.Wood, -20]], &"speed", 1, true)
				post_button([[GT.resource_types.Cannon_Balls, 5], [GT.resource_types.Wood, -2]], &"cannon_balls", 2, true)
				post_button([[GT.resource_types.Stone, 2], [GT.resource_types.Wood, -3]], &"stone", 1)
				post_button([[GT.resource_types.Wood, 24], [GT.resource_types.Stone, -1]], &"wood", 2, true)

				if not player.compass.visible and player.stats[&"horn_parts"] < 3: 
					var modifyer : int = player.stats[&"horn_parts"]+1
					post_button([[0, -12],[1, -21 - modifyer * 6], [2, -10 - modifyer * 9]], &"_" + GT.super_island_types.find_key(modifyer) + &"_compass_", 2)
			
			GT.island_types.NULL:
				post_button([], &"null", 1)
			
		post_button([[GT.resource_types.Cannon_Balls, -2], [GT.resource_types.Stone, 1]], &"stone", 1)
		post_button([[GT.resource_types.Cannon_Balls, 1], [GT.resource_types.Stone, -2]], &"cannon_balls", 1)
			
		
		unused = false
		set_used_display()
		
func set_used_display() -> void:
	if not unused: 
		$StaticBody2D/AnimatedSprite2D.play("used")
		comparison_dist = 0.95
	else: 
		$StaticBody2D/AnimatedSprite2D.play(GT.island_types.find_key(type))
		comparison_dist = 1.1
