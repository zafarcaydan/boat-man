extends OceanFeature

var unused := true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ocean_feature_ready()

func interact() -> void:
	if unused and player.check_resource_value(GT.resource_types.Wood, 5):
		player.change_resource_value(GT.resource_types.Wood, -5)
		unused = false
		player.health += 2
		
	if not unused: $StaticBody2D.rotation = PI * 1.75
