extends OceanFeature

var unused := true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func interact():
	if unused:
		unused = false
		get_tree().get_first_node_in_group("Boat").health += 1
