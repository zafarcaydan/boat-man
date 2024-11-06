extends Enemy




func _ready() -> void:
	super()
	external_nodes = [$Timer]
	behaviors = [EnemyStateBehaviors.BS_Toward, EnemyStateBehaviors.FS_Away, EnemyStateBehaviors.FS_Away]
	


			


func _on_timer_timeout() -> void:
	if state == EnemyStateBehaviors.STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 533)
		
		
func away_conditions_met() -> void:
	state = EnemyStateBehaviors.STATES.TOWARD

		


func _on_death():
	if randf() < 0.3: spawn_cache(GT.resource_types.Stone)
