class_name Player
extends Boat
#Node.signal.connect(method)
const ISLAND = preload("res://scenes/island.tscn")
const BALL_CACHE = preload("res://scenes/ball_cache.tscn")
const BASIC_ENEMY = preload("res://scenes/basic_enemy.tscn")
const INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")
var parent : Node2D
var time_passed := 0.0
var future_pos : Vector2

enum resource_types {CANNON_BALLS = 0, WOOD = 1} #make all values in acending order, one by one starting from zero, doing it in another manner WILL cause an error
var resources := {}
var cannon_balls : int = 10
@export var spawn_dist = 1600
@export var render_dist := 5000

var closest_enemy : Enemy 


func _ready():
	for i in resource_types.values():
		resources[i] = 0
		%"Inventory Bar".add_child(INVENTORY_SLOT.instantiate())
	update_inventory_display()
	health = 10
	%"Health Bar".max_value = health
	safe_bullets = 0
	parent = get_parent()
	
func _input(event):
			
	if event.is_action_pressed("Key_Space") and resources[resource_types.CANNON_BALLS] >= 1:
		spawn_cannon_ball(rotation, safe_bullets, 1)
		resources[resource_types.CANNON_BALLS] -= 1
		update_inventory_display()
		
	if event.is_action_pressed("Key_E"):
		get_tree().call_group("Interactable", "interact")
		update_inventory_display()

func _physics_process(delta):
	var move_velocity =  Input.get_vector("Key_A", "Key_D", "Key_W", "Key_S")
	if move_velocity.x > 0: rotation += PI * delta 
	elif move_velocity.x < 0: rotation -= PI * delta 
	if move_velocity.y < 0: velocity = Vector2(1,0).rotated(global_rotation) * move_speed
	elif move_velocity.y > 0: velocity = Vector2(1,0).rotated(global_rotation + PI) * (move_speed + 2)
	else: velocity = Vector2(0,0)
	time_passed += delta
	
	future_pos = global_position + velocity / 4
	move_and_slide()
	%"Health Bar".value = health
	process(delta)
	
func update_inventory_display():
	for i in resource_types.values():
		%"Inventory Bar".get_child(i).get_child(0).text = str(resources[i])
		

func spawn_feature(new_feature):
	var placeble = true
	for comparison_feature in get_tree().get_nodes_in_group("Spawnable"):
		var relative_pos = comparison_feature.global_position - new_feature.global_position
		
		if sqrt(relative_pos.x ** 2 + relative_pos.y ** 2) < spawn_dist * new_feature.comparison_dist * comparison_feature.comparison_dist: 
			placeble = false
			break
	if placeble: add_sibling.call_deferred(new_feature)

func _on_world_update_timer_timeout():
	var spawn_choice = [1, 1, 1, 1, 1, 2].pick_random()
	
	if spawn_choice == 1:
		var cache_offset = randf_range(-PI/2, PI/2)
		var new_cache = BALL_CACHE.instantiate()
		new_cache.global_position = Vector2(cos(rotation + cache_offset), sin(rotation + cache_offset)) * spawn_dist + global_position 
		spawn_feature(new_cache)
	
	elif spawn_choice == 2:
		var island_offset = randf_range(-PI/12, PI/12)
		var new_island = ISLAND.instantiate()
		new_island.global_position = Vector2(cos(rotation + island_offset), sin(rotation + island_offset)) * spawn_dist + global_position 
		spawn_feature(new_island)
	
	if int(time_passed) % 21 >= 0 and int(time_passed) % 21 < %"World Update Timer".wait_time:
		for i in range(round(time_passed/4)):
			var new_enemy = BASIC_ENEMY.instantiate()
			new_enemy.global_position = Vector2(cos(rotation + i/1.25), sin(rotation + i/1.25)) * spawn_dist + global_position 
			spawn_feature(new_enemy)
	
			
	
