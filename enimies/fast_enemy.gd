extends Enemy



var turn_amount := 0.0
var direction_modifyer : float = [PI/-3, PI / 3].pick_random()


func _ready() -> void:
	super()
	external_nodes = [$Timer, $"Detection Area"]
	behaviors = [EnemyStateBehaviors.F_Toward, EnemyStateBehaviors.FS_Away, EnemyStateBehaviors.FS_Away]



func _on_timer_timeout() -> void:
	if state == EnemyStateBehaviors.STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 531)
		
func away_conditions_met() -> void:
	state = EnemyStateBehaviors.STATES.TOWARD
	direction_modifyer = [PI/-3, PI / 3].pick_random()
	


func _on_death():
	pass # Replace with function body.
