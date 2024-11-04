extends Enemy




func _ready() -> void:
	enemy_ready(4)
	external_nodes = [$Timer]
	



func state_actions() -> void :
	match state:
		STATES.TOWARD: 
			EnemyStateBehaviors.BS_Toward(self)

		
		
		STATES.ATTACK: 
			EnemyStateBehaviors.B_Attack(self)
		
		STATES.AWAY: 
			EnemyStateBehaviors.B_Away(self)
				
	
			


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
