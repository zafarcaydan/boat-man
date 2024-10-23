class_name Player
extends Boat
#Node.signal.connect(method)
const ISLAND = preload("res://scenes/island.tscn")
const SUPER_ISLAND = preload("res://scenes/super_island.tscn")
const BASIC_ENEMY = preload("res://enimies/basic_enemy.tscn")
const FAST_ENEMY = preload("res://enimies/fast_enemy.tscn")
const INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")
var parent : Node2D
var time_passed := 0.0
var future_pos : Vector2
var fitness : float

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
		resources[i] = [0, GT.resource_types.find_key(i).replace("_", " ") + ": "]
		%"Inventory Bar".add_child(INVENTORY_SLOT.instantiate())
	update_inventory_display()
	
	health = 16
	%"Health Bar".max_value = health * 2
	safe_bullets = 0
	parent = get_parent()
	
func _input(event: InputEvent) -> void:
			
	if event.is_action_pressed("Key_Space") and check_resource_value(GT.resource_types.Cannon_Balls, -1):
		spawn_cannon_ball(rotation, safe_bullets, stats[&"cannon_ball_speed"])
		change_resource_value(GT.resource_types.Cannon_Balls, -1)
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
	if $Node2D.visible:
		$Node2D.global_position = global_position
		$Node2D.look_at(get_tree().get_first_node_in_group("Super Island").global_position)
		
	
	%"Health Bar".value = health
	process(delta)
	future_pos = global_position + velocity * 0.5833
	

#spawning things on the ocean
func spawn_feature(new_feature: OceanFeature) -> void:
	var placeble := true
	for comparison_feature in get_tree().get_nodes_in_group("Spawnable"):
		var relative_pos : Vector2 = comparison_feature.global_position - new_feature.global_position
		
		if sqrt(relative_pos.x ** 2 + relative_pos.y ** 2) < spawn_dist * new_feature.comparison_dist * comparison_feature.comparison_dist: 
			placeble = false
			break
	if placeble: 
		add_sibling.call_deferred(new_feature)

func _on_world_update_timer_timeout() -> void:
	fitness =  (stats[&"cannon_ball_speed"] / 250.0 + health)/10.0
	
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
		
		if int(time_passed) % 32 >= 0 and int(time_passed) % 32 < %"World Update Timer".wait_time and not $Node2D.visible:
			for j in range(16):
				var new_enemy := BASIC_ENEMY.instantiate()
				new_enemy.global_position = Vector2(cos(rotation + j/1.25), sin(rotation + j/1.25)) * spawn_dist
				%Enemies.add_sibling.call_deferred(new_enemy)
				
		if int(time_passed) >= 36 and int(time_passed) <= 36 + %"World Update Timer".wait_time:
			var new_super_island = SUPER_ISLAND.instantiate()
			new_super_island.global_position == global_position + Vector2.RIGHT.rotated(randf_range(-PI, PI)) * spawn_dist * 40
			$Node2D.visible = true
			add_sibling.call_deferred(new_super_island)
				
				
#upgrade & inventory handling
func check_resource_value(changed_resource:GT.resource_types, value : int) -> bool:
	if value + resources[changed_resource][0] >= 0: return true
	return false
	
func change_resource_value(changed_resource:GT.resource_types, value : int) -> void:
	if value + resources[changed_resource][0] >= 0:
		resources[changed_resource][0] += value
		update_inventory_display()
		
func cost_evaluation_and_action(button: UpgradeMenuButton) -> bool:
	for i in button.costs:
		if not check_resource_value(i[0], i[1]):
			return false
	for i in button.costs:
		change_resource_value(i[0], i[1])
	return true

func upgrade_button_pressed(button: UpgradeMenuButton) -> void:
	if cost_evaluation_and_action(button):
		if button.button_id == &"cannon_ball_speed": stats[&"cannon_ball_speed"] += 18
		elif button.get_parent() == GT.get_ui()[2]: 
			button.queue_free()
		elif button.button_id ==  &"repair":
			health += 2
	
func update_inventory_display() -> void:
	for i in GT.resource_types.values():
		%"Inventory Bar".get_child(i).get_child(0).text = resources[i][1] + str(resources[i][0])
	%"Health Bar".value = health
		
func connect_upgrade_button_signal(button : UpgradeMenuButton) -> void:
	button.upgrade_button_pressed.connect(upgrade_button_pressed)
