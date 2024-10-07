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
		GT.get_player().resources[GT.resource_types.Cannon_Balls][0] += randi_range(2, 6)
	elif item_type == GT.resource_types.Wood:
		GT.get_player().resources[GT.resource_types.Wood][0] += randi_range(1, 2)
	queue_free()
