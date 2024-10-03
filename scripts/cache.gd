extends OceanFeature
var item_type : GT.resource_types = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func interact():
	if item_type == GT.resource_types.Cannon_Balls:
		get_tree().get_first_node_in_group("Boat").resources[GT.resource_types.Cannon_Balls][0] += randi_range(2, 6)
	elif item_type == GT.resource_types.Wood:
		var q= randi_range(2, 6)
		print(q)
		get_tree().get_first_node_in_group("Boat").resources[GT.resource_types.Wood][0] += q
	queue_free()
