class_name Player
extends Boat
#Node.signal.connect(method)
const ISLAND = preload("res://scenes/island.tscn")
const BALL_CACHE = preload("res://scenes/ball_cache.tscn")
const BASIC_ENEMY = preload("res://scenes/basic_enemy.tscn")
var parent : Node2D
var time_passed := 0.0
var future_pos : Vector2

var cannon_balls : int = 10
@export var spawn_dist = 1600
@export var render_dist := 5000

var turn_movement := true
var closest_enemy : Enemy 


func _ready():
	health = 10
	%"Health Bar".max_value = health
	safe_bullets = 0
	parent = get_parent()
	
func _input(event):
		
	if event.is_action_pressed("Key_Q"): turn_movement = not turn_movement
			
	if event.is_action_pressed("Key_Space") and cannon_balls >= 1:
		spawn_cannon_ball(rotation, safe_bullets, 1)
		cannon_balls -= 1
		%"Inventory Bar/Label".text = str(cannon_balls)
		
	if event.is_action_pressed("Key_E"):
		get_tree().call_group("Interactable", "interact")
		%"Inventory Bar/Label".text = str(cannon_balls)

func _physics_process(delta):
	if not turn_movement: 
		velocity = Input.get_vector("Key_A", "Key_D", "Key_W", "Key_S") * move_speed
		if velocity != Vector2(0, 0): 
			rotation = atan2(velocity.y, velocity.x)
	else: 
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
	
			
	
