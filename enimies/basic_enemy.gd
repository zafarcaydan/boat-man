extends Enemy

func _ready() -> void:
	super() 
	external_nodes = [$Timer]
	behaviors = [EnemyStateBehaviors.BS_Toward, EnemyStateBehaviors.B_Attack, EnemyStateBehaviors.B_Away]
	
func _on_timer_timeout() -> void:

	if state == EnemyStateBehaviors.STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 470)
		state = EnemyStateBehaviors.STATES.AWAY
		
