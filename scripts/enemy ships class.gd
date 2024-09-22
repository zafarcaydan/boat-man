class_name Enemy

extends Boat

var player : Player

func ready():
	safe_bullets = 1
	player = get_tree().get_first_node_in_group("Boat")
	print(get_tree().get_first_node_in_group("Boat"))
	global_position += player.global_position

func get_dist_to_pos(pos):
		return abs(sqrt((global_position.y - pos.y) ** 2 + (global_position.x - pos.x) ** 2))
		
func get_rotation_to_pos(pos):
		return atan2(pos.y - global_position.y, pos.x - global_position.x)
