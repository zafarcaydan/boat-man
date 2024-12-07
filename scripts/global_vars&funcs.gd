extends Node

const INVENTORY_SLOT = preload("res://scenes/inventory_slot.tscn")
enum resource_types {Cannon_Balls = 0, Wood = 1, Stone = 2} #make all values in acending order, one by one starting from zero, doing it in another manner WILL cause an error
enum island_types {NULL = -1, Stone = 0, Wood = 1, Port = 2}
enum super_island_types {First = 1, Second = 2, Third = 3, Home = 5}

func _ready() -> void:
	pass

func _input(event) -> void:
	if event.is_action_pressed("Key_Escape"): 
		GT.get_ui()[0].add_child(load("res://scenes/upgrade_menu.tscn").instantiate())
		var lable = INVENTORY_SLOT.instantiate()
		lable.get_child(0).text = "Locate the horn and return home.\n
		You may need a few compasses.\n\n
		Controls:\n
		W, S, UP, DOWN: Move\n
		A, D, LEFT, RIGHT: Turn\n
		SPACE: Shoot Cannon Ball\n
		E: Interact\n
		Q: Blow Horn"
		get_ui()[1].add_child(lable)
func get_player() -> Player: 
	return get_tree().get_first_node_in_group("Boat_Node")

func get_ui() -> Array[Node]:
	return get_tree().get_nodes_in_group("UI_Node")
	
func increase_super_island_stage() -> void:
	get_tree().get_first_node_in_group("Super Island").stage += 1
	get_tree().get_first_node_in_group("Super Island").resources_untaken = true
	
	
func blow_horn(sounds: Node, strength: int, origin: Vector2, is_player: bool = false) -> void:
	play_random_audio(sounds)
	if not is_player: 
		get_player().push_away_from_point(strength, origin)
		get_player().push_away_from_point.call_deferred(strength * 0.75, origin)
	for i in get_tree().get_nodes_in_group("Enemies"):
		i.push_away_from_point(strength, origin)
		i.push_away_from_point.call_deferred(strength * 0.75, origin)
		
func play_random_audio(sounds : Node) -> void:
	sounds.get_children().pick_random().play()
	
func erase_super_island_status() -> void:
	for i in get_tree().get_first_node_in_group("Super Island").get_child(1).get_children(): i.remove_from_group("Super Island")
	get_tree().get_first_node_in_group("Super Island").remove_from_group("Super Island")
	get_player().compass.visible = false
	
