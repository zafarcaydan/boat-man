class_name Boat
extends CharacterBody2D

var safe_bullets : int
@export var move_speed : int
var health : float
const CANNON_BALL = preload("res://scenes/cannon_ball.tscn")

func spawn_cannon_ball(direction, type, damage):
	var new_cannon_ball = CANNON_BALL.instantiate()
	new_cannon_ball.rotation = direction
	new_cannon_ball.move_direction = Vector2(cos(new_cannon_ball.rotation), sin(new_cannon_ball.rotation)) * 480
	new_cannon_ball.global_position = global_position + new_cannon_ball.move_direction / 6
	new_cannon_ball.damage = damage
	new_cannon_ball.type = type
	add_child(new_cannon_ball)
	
func process(delta):
	if health <= 0:
		if self is Player: get_tree().reload_current_scene.call_deferred()
		queue_free()
