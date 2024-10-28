class_name Enemy

extends Boat

var player : Player

func enemy_ready(health_value : int) -> void:
	
	boat_ready()
	safe_bullets = 1
	player = GT.get_player()
	global_position += player.global_position
	move_speed += randi_range(-20, 20)
	health = health_value
	death.connect(upon_death)

func get_dist_to_pos(pos: Vector2) -> float:
		return abs(sqrt((global_position.y - pos.y) ** 2 + (global_position.x - pos.x) ** 2))
		
func get_rotation_to_pos(pos: Vector2) -> float:
		return atan2(pos.y - global_position.y, pos.x - global_position.x)

func upon_death() -> void:
	if randf() < 0.29:
		var new_cache := CACHE.instantiate()
		new_cache.global_position = global_position
		new_cache.item_type = GT.resource_types.Wood
		add_sibling.call_deferred(new_cache)
	
	if randf() < 0.08:
		var new_cache := CACHE.instantiate()
		new_cache.global_position = global_position
		new_cache.item_type = GT.resource_types.Cannon_Balls
		add_sibling.call_deferred(new_cache)
	
