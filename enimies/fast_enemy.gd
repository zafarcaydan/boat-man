extends Enemy

enum STATES {TOWARD, AWAY, ATTACK}
var state : STATES = STATES.TOWARD

var turn_amount := 0.0
var direction_modifyer : float = [PI/-3, PI / 3].pick_random()


func _ready() -> void:
	enemy_ready(6)
	

func state_actions() -> void:
	match state:
		STATES.TOWARD:
			
			rotation = get_rotation_to_pos(player.global_position + Vector2(1,0).rotated(atan2(player.velocity.y, player.velocity.x) + direction_modifyer) * 400 + velocity / 2)
			force = Vector2(1,0).rotated(rotation) 
			if get_dist_to_pos(player.global_position) < 230:state = STATES.AWAY
			for i in $"Detection Area".get_overlapping_bodies():
				if i == player:
					state = STATES.ATTACK
					$Timer.start(0.6)
					break
		
		STATES.AWAY: away_behaviors(700)
		STATES.ATTACK: away_behaviors(1150)
	print(state)
			
			
			

func away_behaviors(reset: int) -> void:
	rotation = get_rotation_to_pos(player.future_pos) 
	force = Vector2(1,0).rotated(rotation + PI) 
	if get_dist_to_pos(player.global_position) > reset: 
		state = STATES.TOWARD
		direction_modifyer = [PI/-3, PI / 3].pick_random()

func _on_timer_timeout() -> void:
	if state == STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 531)
