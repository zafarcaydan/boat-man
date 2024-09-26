extends Node2D
var balls = randi_range(2, 6)
var comparison_dist = 1.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func interact():
	get_tree().get_first_node_in_group("Boat").resources[0] += balls
	queue_free()
