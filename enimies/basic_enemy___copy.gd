extends Enemy

enum STATES {TOWARD, ATTACK, AWAY}
var state : STATES = STATES.TOWARD
var direction_modifyer : float = [7 * PI/-6, 7 * PI / 6].pick_random()


func _ready() -> void:
	enemy_ready(6)

func state_actions() -> void:

	match state:
		STATES.TOWARD:
			rotation = get_rotation_to_pos(player.global_position + Vector2(1,0).rotated(player.rotation + direction_modifyer + 0) * 325 )
