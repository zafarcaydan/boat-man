class_name Boat
extends CharacterBody2D

var safe_bullets : int
@export var move_speed : int
@export var health : int = 4
@export var external_dampener : float = 1.0
const CANNON_BALL = preload("res://scenes/cannon_ball.tscn")
const CACHE = preload("res://scenes/cache.tscn")
var force : Vector2
var external_force : Vector2
signal death

func _ready() -> void:
	pass

func spawn_cannon_ball(direction : float, type : int, speed : int, dist_from_self: int = 150) -> void:
	var new_cannon_ball := CANNON_BALL.instantiate()
	new_cannon_ball.rotation = direction
	new_cannon_ball.speed = speed
	new_cannon_ball.global_position = global_position + Vector2.RIGHT.rotated(rotation) * dist_from_self
	
	new_cannon_ball.type = type
	add_child(new_cannon_ball)
	
func process() -> void:
	if health <= 0: 
		death.emit()
		queue_free()
	var velocity_power : float = vector_power_determination()


	velocity += force * move_speed / (velocity_power/32 + 1) + external_force / external_dampener
	velocity *= 0.936 
	move_and_slide()
	external_force *= 0.5
	
func vector_power_determination(vector: Vector2 = velocity) -> float:
	if abs(vector.x) > 0: return (vector.x / vector.normalized().x)
	elif abs(vector.y) > 0: return (vector.y / vector.normalized().y)
	return 0.0
