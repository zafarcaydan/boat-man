extends Enemy

enum GrandBehaviors {FirstQuarter = 0, Middle = 1, FourthQuarter = 2}
var grand_state := GrandBehaviors.FirstQuarter
var rotation_direction : float = [-1, 1].pick_random()
var initial_health : int
var can_move := true
var dist_to_player: float
var vincible := true
var time_spinning : float
var direction_modifyer : float = [PI/-3, PI / 3].pick_random()


const FAST_ENEMY = preload("res://enimies/fast_enemy.tscn")
const BASIC_ENEMY = preload("res://enimies/basic_enemy.tscn")
const SPECIAL_ENEMY = preload("res://enimies/special_enemy.tscn")
#200

func _ready():
	super()
	initial_health = health
	player.parent.get_child(0).timeout.connect(update)
	external_nodes = [$Timer, $"Detection Area"]
	
func change_grand_state() -> void:
	grand_state += 1
	state = EnemyStateBehaviors.STATES.TOWARD
	GT.blow_horn($"horn sounds", 1000, global_position)
	health += randi_range(5, 10)
	external_dampener += 0.25
	
func _physics_process(delta):
	player.time_passed -= 0.006
	match grand_state:
		GrandBehaviors.FirstQuarter when health <= initial_health * 0.75: 
			change_grand_state()
			for i in range(8): 
				player.spawn_enemy(i, BASIC_ENEMY)
				if i % 2 == 0: player.spawn_enemy(i, FAST_ENEMY)
		GrandBehaviors.Middle when health <= initial_health * 0.25: 
			change_grand_state()
			for i in range(12): player.spawn_enemy(i, FAST_ENEMY)
	dist_to_player = EnemyStateBehaviors.get_dist_to_pos(player.future_pos, self)
	sort()
	set_collision_layer_value(2, vincible)
	force *= int(can_move) * dist_to_player/750
	process()
	
func update():
	if get_tree().get_nodes_in_group("Final Enemy").size() > 0:
		if randf() < 0.5: get_tree().get_first_node_in_group("Final Enemy").rotation_direction *= -1
		
		can_move = get_tree().get_nodes_in_group("Enemies").size() <= 3 + grand_state * 2
		vincible = can_move
		if not can_move:
			state = EnemyStateBehaviors.STATES.TOWARD
		
	
func sort() -> void:

	match [grand_state, state]:
		[GrandBehaviors.FirstQuarter, EnemyStateBehaviors.STATES.TOWARD]: FiQ_Toward()
		[GrandBehaviors.FirstQuarter, EnemyStateBehaviors.STATES.ATTACK]: FiQ_Attack()
		[GrandBehaviors.FirstQuarter, EnemyStateBehaviors.STATES.AWAY]: FiQ_Away()
		[GrandBehaviors.Middle, EnemyStateBehaviors.STATES.TOWARD]: M_Toward()
		[GrandBehaviors.Middle, EnemyStateBehaviors.STATES.ATTACK]: M_Attack()
		[GrandBehaviors.Middle, EnemyStateBehaviors.STATES.AWAY]: M_Away()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.TOWARD]: FQ_Toward()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.ATTACK]: FQ_Attack()
		[GrandBehaviors.FourthQuarter, EnemyStateBehaviors.STATES.AWAY]: FQ_Away()
	
	
		
func FiQ_Toward() -> void:
	EnemyStateBehaviors.BS_Toward(self, 650)

		

func FiQ_Attack() -> void:
	rotation = EnemyStateBehaviors.get_rotation_to_pos(player.global_position, self)
	force = Vector2.RIGHT.rotated(rotation) * 0.75
	if dist_to_player > 900: state = EnemyStateBehaviors.STATES.TOWARD
	elif dist_to_player < 300: state = EnemyStateBehaviors.STATES.AWAY

	
func away_conditions_met() -> void:
	state = EnemyStateBehaviors.STATES.TOWARD
		
func FiQ_Away() -> void:
	EnemyStateBehaviors.FS_Away(self, 420, 0)
	force *= 2
	force /= dist_to_player/750
		
	
func M_Toward() -> void:
	rotation = atan2(velocity.y, velocity.x)
	force = Vector2(1,0).rotated(EnemyStateBehaviors.get_rotation_to_pos(player.global_position, self)) * 1.1
	if EnemyStateBehaviors.get_dist_to_pos(player.global_position, self) <= 600 and can_move:
		$Timer.start(0.5)
		if randf() < 0.65: state = EnemyStateBehaviors.STATES.ATTACK
		else: 
			time_spinning = 0
			state = EnemyStateBehaviors.STATES.AWAY

	
func M_Attack() -> void:
	rotation = EnemyStateBehaviors.get_rotation_to_pos(player.future_pos, self)
	force = Vector2.RIGHT.rotated(rotation + PI / 2 * rotation_direction) * 0.75
	if dist_to_player > 1000: state = EnemyStateBehaviors.STATES.TOWARD
	
func M_Away() -> void:
	time_spinning += get_physics_process_delta_time()
	force = Vector2.ZERO
	rotation += TAU * get_physics_process_delta_time() 
	vincible = false
	if time_spinning > 4: 
		state = EnemyStateBehaviors.STATES.TOWARD
		vincible = true
	
func FQ_Toward() -> void:
	rotation = EnemyStateBehaviors.get_rotation_to_pos(player.global_position + Vector2(1,0).rotated(atan2(player.velocity.y, player.velocity.x) + direction_modifyer) * 550 + velocity / 3, self)
	force = Vector2(1,0).rotated(rotation) 
	if dist_to_player < 230: 
		time_spinning = 0
		state = EnemyStateBehaviors.STATES.AWAY
		$Timer.start(0.3)
	force /= dist_to_player/750
	for i in $"Detection Area".get_overlapping_bodies():
		if i == player:
			state = EnemyStateBehaviors.STATES.ATTACK
			$Timer.start(0.6)
			break
	
func FQ_Attack() -> void:
	M_Attack()
	
func FQ_Away() -> void:
	M_Away()
	


func _on_timer_timeout() -> void:
	if state == EnemyStateBehaviors.STATES.ATTACK or (state == EnemyStateBehaviors.STATES.AWAY and grand_state == GrandBehaviors.FirstQuarter):
		spawn_cannon_ball(rotation, safe_bullets, 531 + grand_state * 30, 175)
		$Timer.start(0.82)
	elif state == EnemyStateBehaviors.STATES.AWAY and (grand_state == GrandBehaviors.Middle or grand_state == GrandBehaviors.FourthQuarter): 
		spawn_cannon_ball(rotation, safe_bullets, 531 + grand_state * 30, 175)
		$Timer.start(0.0625)
		


func _on_death() -> void:
	GT.erase_super_island_status()
	spawn_cache(4)
