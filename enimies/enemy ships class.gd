class_name Enemy

extends Boat

var player : Player

func ready():
	safe_bullets = 1
	player = GT.get_player()
	global_position += player.global_position
	move_speed += randi_range(-20, 20)

func get_dist_to_pos(pos):
		return abs(sqrt((global_position.y - pos.y) ** 2 + (global_position.x - pos.x) ** 2))
		
func get_rotation_to_pos(pos):
		return atan2(pos.y - global_position.y, pos.x - global_position.x)
