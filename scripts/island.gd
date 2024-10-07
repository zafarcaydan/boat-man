extends OceanFeature

var unused := true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func interact():
	if unused and GT.get_player().resources[GT.resource_types.Wood][0] > 5:
		GT.get_player().resources[GT.resource_types.Wood][0] -= 5
		unused = false
		GT.get_player().health += 1
		
	if not unused: $StaticBody2D/Sprite2D.rotation = PI * 0.75
