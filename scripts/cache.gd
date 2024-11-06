extends OceanFeature
@export var item_type : GT.resource_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void :
	super()

func interact() -> void :
	match item_type:
		GT.resource_types.Cannon_Balls:
			player.change_resource_value(GT.resource_types.Cannon_Balls, randi_range(3, 7))
		GT.resource_types.Wood:
			player.change_resource_value(GT.resource_types.Wood, randi_range(2, 4))
		GT.resource_types.Stone: 
			player.change_resource_value(GT.resource_types.Stone, randi_range(2, 3))
	queue_free()
