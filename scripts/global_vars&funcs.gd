extends Node

enum resource_types {Cannon_Balls = 0, Wood = 1} #make all values in acending order, one by one starting from zero, doing it in another manner WILL cause an error

func get_player():
	return get_tree().get_first_node_in_group("Boat")
