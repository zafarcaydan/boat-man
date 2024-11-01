extends Enemy
enum STATES {TOWARD, ATTACK, AWAY}
var state : STATES = STATES.TOWARD



func _ready() -> void:
	enemy_ready(4)
	



func state_actions() -> void :
	match state:
		STATES.TOWARD: 
			force = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position)) 
			if get_dist_to_pos(player.global_position) < 6250: 
				$Timer.start(0.9)
				state = STATES.ATTACK
		
		
		STATES.ATTACK: 
			force = Vector2(1,0).rotated(get_rotation_to_pos(player.future_pos)) / 3
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
			if get_dist_to_pos(player.global_position) < 275:
				state = STATES.AWAY
		
		STATES.AWAY: 
			force = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position) + PI) 
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
				
	if velocity != Vector2(0, 0): rotation = atan2(velocity.y, velocity.x)
			


func _on_timer_timeout() -> void:

	if state == STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 470)
		state = STATES.AWAY
		
func _on_death() -> void:
	if randf() < 0.2:
		var new_cache := CACHE.instantiate()
		new_cache.global_position = global_position
		new_cache.item_type = GT.resource_types.Wood
		add_sibling.call_deferred(new_cache)
