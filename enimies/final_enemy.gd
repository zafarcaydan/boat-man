extends Enemy

enum GrandBehaviors {FirstHalf = 0, ThirdQuarter = 1, FourthQuarter = 2}
var grand_state := GrandBehaviors.FirstHalf
var rotation_direction : float = [-1, 1].pick_random()
var initial_health : int
const FAST_ENEMY = preload("res://enimies/fast_enemy.tscn")

func _ready():
	super()
	behaviors = [sort, sort, sort]
	initial_health = health
	
func change_grand_state() -> void:
	grand_state += 1
	state = EnemyStateBehaviors.STATES.TOWARD
	GT.play_random_audio($"Horn sounds")
	
	
func additional_process(delta:float) -> void:
	match grand_state:
		GrandBehaviors.FirstHalf when health <= initial_health * 0.5: 
			change_grand_state()
			for i in range(6): player.spawn_enemy(i, FAST_ENEMY)
		GrandBehaviors.ThirdQuarter when health <= initial_health * 0.25: 
			change_grand_state()
			for i in range(12): player.spawn_enemy(i, FAST_ENEMY)
	
func sort(_reference_to_self) -> void:
	match [grand_state, state]:
		[GrandBehaviors.FirstHalf, EnemyStateBehaviors.STATES.TOWARD]: FH_Toward()
		[GrandBehaviors.FirstHalf, EnemyStateBehaviors.STATES.ATTACK]: FH_Attack()
		[GrandBehaviors.FirstHalf, EnemyStateBehaviors.STATES.AWAY]: FH_Away()
		[GrandBehaviors.ThirdQuarter, EnemyStateBehaviors.STATES.TOWARD]: TQ_Toward()
		[GrandBehaviors.ThirdQuarter, EnemyStateBehaviors.STATES.ATTACK]: TQ_Attack()
		[GrandBehaviors.ThirdQuarter, EnemyStateBehaviors.STATES.AWAY]: TQ_Away()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.TOWARD]: FQ_Toward()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.ATTACK]: FQ_Attack()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.AWAY]: FQ_Away()
	if get_tree().get_nodes_in_group("Enemies").size() > health / 100 * (-grand_state + 6): 
		force *= 0
		
		
func FH_Toward() -> void:
	rotation = atan2(velocity.y, velocity.x)
	force = Vector2(1,0).rotated(EnemyStateBehaviors.get_rotation_to_pos(player.global_position, self)) * 1.1
	if EnemyStateBehaviors.get_dist_to_pos(player.global_position, self) < 800: 
		$Timer.start(0.5)
		state = EnemyStateBehaviors. STATES.ATTACK

		

func FH_Attack() -> void:
	rotation = EnemyStateBehaviors.get_rotation_to_pos(player.global_position, self)
	force = Vector2.RIGHT.rotated(rotation) * 0.75
	#force = Vector2.RIGHT.rotated(rotation + rotation_direction * PI * 1.2) + (player.global_position - global_position).normalized() / 3
	var dist_to_player := EnemyStateBehaviors.get_dist_to_pos(player.future_pos, self)
	if dist_to_player > 900: state = EnemyStateBehaviors.STATES.TOWARD
	elif dist_to_player < 300: state = EnemyStateBehaviors.STATES.AWAY

	

		
func FH_Away() -> void:
	EnemyStateBehaviors.B_Away(self)
	
func TQ_Toward() -> void:
	force = Vector2(0,1)
	
func TQ_Attack() -> void:
	pass
	
func TQ_Away() -> void:
	pass
	
func FQ_Toward() -> void:
	pass
	
func FQ_Attack() -> void:
	pass
	
func FQ_Away() -> void:
	pass
	


func _on_timer_timeout():
	if state == EnemyStateBehaviors.STATES.ATTACK:
		spawn_cannon_ball(rotation, safe_bullets, 561, 175)
	$Timer.start(1)
