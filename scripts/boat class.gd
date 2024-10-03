class_name Boat
extends CharacterBody2D

var safe_bullets : int
@export var move_speed : int
var health : float
const CANNON_BALL = preload("res://scenes/cannon_ball.tscn")
const CACHE = preload("res://scenes/cache.tscn")
var force : Vector2
signal death

func spawn_cannon_ball(direction, type, damage, speed):
	var new_cannon_ball = CANNON_BALL.instantiate()
	new_cannon_ball.rotation = direction
	new_cannon_ball.move_direction = Vector2(cos(new_cannon_ball.rotation), sin(new_cannon_ball.rotation)) * speed
	new_cannon_ball.global_position = global_position + new_cannon_ball.move_direction / 4
	new_cannon_ball.damage = damage
	new_cannon_ball.type = type
	add_child(new_cannon_ball)
	
func process(delta):
	if health <= 0:
		if self is Player: get_tree().reload_current_scene.call_deferred()
		else: death.emit()
		queue_free()
	
	var velocity_power : float = (abs(velocity.x) + abs(velocity.y)) / 2
		
	if velocity_power > move_speed:
		velocity = velocity.normalized()
		var velocity_direction := atan2(velocity.y, velocity.x)
		velocity= Vector2(cos(velocity_direction), sin(velocity_direction))
	
	velocity *= 0.93
	velocity += force * move_speed / (velocity_power/26 + 1)
	
	move_and_slide()
