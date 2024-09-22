extends Enemy
enum STATES {TOWARD, ATTACK, AWAY}
var state : STATES = STATES.TOWARD

var future_pos : Vector2
var comparison_dist = 0


func _ready():
	ready()
	health = 2
	get_parent().get_child(0).timeout.connect(_on_world_update_timer_timeout)
	get_parent().get_child(0)
	

func _physics_process(delta):
	state_actions()
	
	if velocity != Vector2(0, 0): 
		move_and_slide()
		rotation = atan2(velocity.y, velocity.x)
	
	process(delta)
		
func _on_world_update_timer_timeout():
	pass


func state_actions():
	match state:
		
		
		STATES.TOWARD: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position)) * move_speed
			if get_dist_to_pos(player.global_position) < 600: 
				$Timer.start(1)
				state = STATES.ATTACK
		
		
		STATES.ATTACK: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.future_pos)) * move_speed/4
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
			if get_dist_to_pos(player.global_position) < 275:
				state = STATES.AWAY
		
		STATES.AWAY: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position) + PI) * move_speed
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
			


func _on_timer_timeout():
	if state == STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 1)
		state = STATES.AWAY
