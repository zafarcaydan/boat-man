extends Enemy
enum STATES {TOWARD, ATTACK, AWAY}
var state : STATES = STATES.TOWARD

var comparison_dist = 0


func _ready():
	enemy_ready()
	health = 2
	get_parent().get_child(0).timeout.connect(_on_world_update_timer_timeout)
	

func _physics_process(delta):
	state_actions()
	
	if velocity != Vector2(0, 0): 
		rotation = atan2(velocity.y, velocity.x)
	
	process(delta)
		
func _on_world_update_timer_timeout():
	pass


func state_actions():
	pass
