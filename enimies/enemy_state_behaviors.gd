extends Node
var player :Player
enum STATES {TOWARD, ATTACK, AWAY}

func get_rotation_to_pos(pos: Vector2, caller: Node2D) -> float:
		return atan2(pos.y - caller.global_position.y, pos.x - caller.global_position.x)
		
func get_dist_to_pos(pos: Vector2, caller) -> float:
		return sqrt((caller.global_position.y - pos.y) ** 2 + (caller.global_position.x - pos.x) ** 2)


func BS_Toward(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position, caller)) 
	if get_dist_to_pos(player.global_position, caller) < 590: 
		caller.external_nodes[0].start(0.8)
		caller.state = STATES.ATTACK

func B_Attack(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(get_rotation_to_pos(player.future_pos, caller)) / 3
	if get_dist_to_pos(player.global_position, caller) > 650: 
		caller.state = STATES.TOWARD
	if get_dist_to_pos(player.global_position, caller) < 275:
		caller.state = STATES.AWAY
		
func B_Away(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(get_rotation_to_pos(player.global_position, caller) + PI) 
	if get_dist_to_pos(player.global_position, caller) > 650: 
		caller.state = STATES.TOWARD
		
func FS_Away(caller: Enemy) -> void :
	caller.rotation = get_rotation_to_pos(player.future_pos, caller) 
	caller.force = Vector2(1,0).rotated(caller.rotation + PI) 
	if get_dist_to_pos(player.global_position, caller) > (-caller.state + 3) * 650 :
		caller.away_conditions_met()
	
func F_Toward(caller: Enemy) -> void:
	caller.rotation = get_rotation_to_pos(player.global_position + Vector2(1,0).rotated(atan2(player.velocity.y, player.velocity.x) + caller.direction_modifyer) * 400 + caller.velocity / 2, caller)
	caller.force = Vector2(1,0).rotated(caller.rotation) 
	if get_dist_to_pos(player.global_position, caller) < 230: caller.state = STATES.AWAY
	for i in caller.external_nodes[1].get_overlapping_bodies():
		if i == player:
			caller.state = STATES.ATTACK
			caller.external_nodes[0].start(0.6)
			break
