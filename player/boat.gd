class_name Player
extends Boat
#Node.signal.connect(method)
const ISLAND = preload("res://scenes/island.tscn")
const BASIC_ENEMY = preload("res://enimies/basic_enemy.tscn")
const INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")
var parent : Node2D
var time_passed := 0.0
var future_pos : Vector2

#GT.resource_types = [amount, name]
var resources := {}
@export var spawn_dist := 1600
@export var render_dist := 5000

var closest_enemy : Enemy 
var stats := {
	&"cannon_ball_speed": 500,
	}


func _ready() -> void:
	boat_ready()
	var rescource_names := []
	for i in GT.resource_types: rescource_names.append(i.replace("_", " ") + ": ")
	for i in GT.resource_types.values():
		resources[i] = [10, rescource_names[i]]
		%"Inventory Bar".add_child(INVENTORY_SLOT.instantiate())
	update_inventory_display()
	
	health = 10
	%"Health Bar".max_value = health * 2
	safe_bullets = 0
	parent = get_parent()
	
func _input(event: InputEvent) -> void:
			
	if event.is_action_pressed("Key_Space") and resources[GT.resource_types.Cannon_Balls][0] >= 1:
		spawn_cannon_ball(rotation, safe_bullets, stats[&"cannon_ball_speed"])
		resources[GT.resource_types.Cannon_Balls][0] -= 1
		update_inventory_display()
		
	if event.is_action_pressed("Key_E"):
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("Interactable"): area.get_parent().interact()
		

func _physics_process(delta: float) -> void:
	var move_velocity :=  Input.get_vector("Key_A", "Key_D", "Key_W", "Key_S")
	if move_velocity.x > 0: rotation += PI * delta 
	elif move_velocity.x < 0: rotation -= PI * delta 
	if move_velocity.y < 0: force = Vector2(1,0).rotated(global_rotation) 
	elif move_velocity.y > 0: force = Vector2(1,0).rotated(global_rotation + PI) * 0.8
	else: force = Vector2(0,0)

	time_passed += delta
	
	%"Health Bar".value = health
	process(delta)
	future_pos = global_position + velocity / 4
	

#spawning things on the ocean
func spawn_feature(new_feature: Node) -> void:

	var placeble := true
	for comparison_feature in get_tree().get_nodes_in_group("Spawnable"):
		var relative_pos : Vector2 = comparison_feature.global_position - new_feature.global_position
		
		if sqrt(relative_pos.x ** 2 + relative_pos.y ** 2) < spawn_dist * new_feature.comparison_dist * comparison_feature.comparison_dist: 
			placeble = false
			break
	if placeble: 
		add_sibling.call_deferred(new_feature)

func _on_world_update_timer_timeout() -> void:
	for i in range(2):
		var spawn_choice : int = [1, 1, 1, 1, 2].pick_random()
		var offset := i * PI
	
		if spawn_choice == 1:
			offset += randf_range(-PI/2, PI/2)
			var new_cache := CACHE.instantiate()
			new_cache.global_position = Vector2(cos(rotation + offset), sin(rotation + offset)) * spawn_dist + global_position 
			new_cache.item_type = GT.resource_types.Cannon_Balls
			spawn_feature(new_cache)
	
		elif spawn_choice == 2:
			offset += randf_range(-PI/12, PI/12)
			var new_island := ISLAND.instantiate()
			new_island.global_position = Vector2(cos(rotation + offset), sin(rotation + offset)) * spawn_dist + global_position 
			spawn_feature(new_island)
		
		if int(time_passed) % 28 >= 0 and int(time_passed) % 28 < %"World Update Timer".wait_time:
			for j in range(17):
				var new_enemy := BASIC_ENEMY.instantiate()
				new_enemy.global_position = Vector2(cos(rotation + j/1.25), sin(rotation + j/1.25)) * spawn_dist + global_position 
				spawn_feature(new_enemy)
				
#upgrade & inventory handling
func check_resource_value(changed_resource:GT.resource_types, value : int) -> bool:
	if resources[changed_resource][0] >= value: return true
	return false
	
func change_resource_value(changed_resource:GT.resource_types, value : int) -> void:
	if value + resources[changed_resource][0] >= 0:
		resources[changed_resource][0] += value
		update_inventory_display()

func upgrade_button_pressed(button_id: StringName) -> void:
	if button_id == &"cannon_ball_speed" and check_resource_value(GT.resource_types.Cannon_Balls, 1) and check_resource_value(GT.resource_types.Wood, 2):
		change_resource_value(GT.resource_types.Cannon_Balls, -1)
		change_resource_value(GT.resource_types.Wood, -2)
		stats[&"cannon_ball_speed"] += 18
	
func update_inventory_display() -> void:
	for i in GT.resource_types.values():
		%"Inventory Bar".get_child(i).get_child(0).text = resources[i][1] + str(resources[i][0])
		
func connect_upgrade_button_signal(button : UpgradeMenuButton) -> void:
	button.upgrade_button_pressed.connect(upgrade_button_pressed)
