extends Node

enum resource_types {Cannon_Balls = 0, Wood = 1, Stone = 2} #make all values in acending order, one by one starting from zero, doing it in another manner WILL cause an error
enum island_types {NULL = -1, Stone = 0, Wood = 1, Port = 2}
enum super_island_types {First = 1, Second = 2, Third = 3}

func _ready() -> void:
	pass

func get_player() -> Player: 
	return get_tree().get_first_node_in_group("Boat_Node")

func get_ui() -> Array[Node]:
	return get_tree().get_nodes_in_group("UI_Node")
	
func increase_super_island_stage() -> void:
	get_tree().get_first_node_in_group("Super Island").stage += 1
	get_tree().get_first_node_in_group("Super Island").resources_untaken = true
	
func play_random_audio(sounds : Node) -> void:
	sounds.get_children().pick_random().play()
	
func erase_super_island_status() -> void:
	for i in get_tree().get_first_node_in_group("Super Island").get_child(1).get_children(): i.remove_from_group("Super Island")
	get_tree().get_first_node_in_group("Super Island").remove_from_group("Super Island")
	
