class_name OceanFeature
extends Node

@export var comparison_dist : float
var player:Player

func ocean_feature_ready() -> void:
	player = GT.get_player()


func interact() -> void:
	pass
