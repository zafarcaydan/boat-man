extends Enemy
enum STATES {TOWARD, ATTACK, AWAY}
var state : STATES = STATES.TOWARD
var speed := 475.0
var CANNON_BALL = preload("res://scenes/cannon_ball.tscn")

var future_pos : Vector2
var comparison_dist = 0


func _ready():
	ready()
	get_parent().get_child(0).timeout.connect(_on_world_update_timer_timeout)
	get_parent().get_child(0)
	

func _physics_process(_delta):
	state_actions()
	
	if velocity != Vector2(0, 0): 
		move_and_slide()
		rotation = atan2(velocity.y, velocity.x)
		
func _on_world_update_timer_timeout():
	pass


func state_actions():
	match state:
		
		
		STATES.TOWARD: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position)) * speed
			if get_dist_to_pos(player.global_position) < 600: 
				$Timer.start(1)
				state = STATES.ATTACK
		
		
		STATES.ATTACK: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.future_pos)) * speed/4
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
			if get_dist_to_pos(player.global_position) < 275:
				state = STATES.AWAY
		
		STATES.AWAY: 
			velocity = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position) + PI) * speed
			if get_dist_to_pos(player.global_position) > 650: 
				state = STATES.TOWARD
			


func _on_timer_timeout():
	if state == STATES.ATTACK:
		var new_cannon_ball = CANNON_BALL.instantiate()
		new_cannon_ball.rotation = rotation
		new_cannon_ball.move_direction = Vector2(cos(new_cannon_ball.rotation), sin(new_cannon_ball.rotation)) * 480
		new_cannon_ball.global_position = global_position + new_cannon_ball.move_direction / 6
		new_cannon_ball.type = new_cannon_ball.TYPES.ENEMY
		add_child(new_cannon_ball)
		state = STATES.AWAY
