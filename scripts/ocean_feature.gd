class_name OceanFeature
extends Node2D

@export var comparison_dist : float
var player: Player
var render_dist_mod : int = 0

func _ready() -> void:
	player = GT.get_player()


func interact() -> void:
	pass
