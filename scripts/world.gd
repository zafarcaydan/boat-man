extends Node2D
@onready var player := $Boat

func _ready() -> void: 
	EnemyStateBehaviors.player = GT.get_player()

func _on_world_update_timer_timeout() -> void:
	for object in get_tree().get_nodes_in_group("Rendered Object"):
		if not object.is_in_group("Super Island"):
			var reletive_pos : Vector2 = object.global_position - player.global_position 
			if sqrt(reletive_pos.x ** 2 + reletive_pos.y ** 2) > player.render_dist - object.render_dist_mod: object.queue_free()

	if get_tree().get_nodes_in_group("Final Enemy").size() > 0:
		if randf() < 0.5: get_tree().get_first_node_in_group("Final Enemy").rotation_direction *= -1
		
