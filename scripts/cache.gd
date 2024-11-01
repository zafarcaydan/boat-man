extends OceanFeature
@export var item_type : GT.resource_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	ocean_feature_ready()

func interact() -> void :
	if item_type == GT.resource_types.Cannon_Balls:
		GT.get_player().change_resource_value(GT.resource_types.Cannon_Balls, randi_range(3, 7))
	elif item_type == GT.resource_types.Wood:
		GT.get_player().change_resource_value(GT.resource_types.Wood, randi_range(2, 4))
	queue_free()
