extends Node2D
@onready var player := $Boat

#class Items:
#	var id : String
#	var icon : Texture2D

func _on_world_update_timer_timeout() -> void:
	for object in get_tree().get_nodes_in_group("Rendered Object"):
		var reletive_pos : Vector2 = object.global_position - player.global_position 
		if sqrt(reletive_pos.x ** 2 + reletive_pos.y ** 2) > player.render_dist:
			object.queue_free()


		
