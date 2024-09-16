extends Area2D
var boat : CharacterBody2D
var player_present := false

func _ready():
	boat = get_tree().get_first_node_in_group("Boat")

func _on_body_entered(body): 
	if body == boat: player_present = true


func _on_body_exited(body): 
	if body == boat: player_present = false

func interact():
	if player_present: get_parent().interact()
