extends Node
var player :Player

func BS_Toward(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(caller.get_rotation_to_pos(player.global_position)) 
	if caller.get_dist_to_pos(player.global_position) < 625: 
		caller.external_nodes[0].start(0.75)
		caller.state = caller.STATES.ATTACK

func B_Attack(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(caller.get_rotation_to_pos(player.future_pos)) / 3
	if caller.get_dist_to_pos(player.global_position) > 650: 
		caller.state = caller.STATES.TOWARD
	if caller.get_dist_to_pos(player.global_position) < 275:
		caller.state = caller.STATES.AWAY
		
func B_Away(caller: Enemy) -> void:
	caller.rotation = atan2(caller.velocity.y, caller.velocity.x)
	caller.force = Vector2(1,0).rotated(caller.get_rotation_to_pos(player.global_position) + PI) 
	if caller.get_dist_to_pos(player.global_position) > 650: 
		caller.state = caller.STATES.TOWARD
		
func FS_Away(caller: Enemy) -> void :
	pass
	
func F_Toward(caller: Enemy) -> void:
	caller.rotation = caller.get_rotation_to_pos(player.global_position + Vector2(1,0).rotated(atan2(player.velocity.y, player.velocity.x) + caller.direction_modifyer) * 400 + caller.velocity / 2)
	caller.force = Vector2(1,0).rotated(caller.rotation) 
	if caller.get_dist_to_pos(player.global_position) < 230: caller.state = caller.STATES.AWAY
	for i in caller.external_nodes[1].get_overlapping_bodies():
		if i == player:
			caller.state = caller.STATES.ATTACK
			caller.external_nodes[0].start(0.6)
			break
