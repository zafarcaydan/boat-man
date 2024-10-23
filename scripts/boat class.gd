class_name Boat
extends CharacterBody2D

var safe_bullets : int
@export var move_speed : int
var health : float
const CANNON_BALL = preload("res://scenes/cannon_ball.tscn")
const CACHE = preload("res://scenes/cache.tscn")
var force : Vector2
signal death

func boat_ready() -> void:
	move_speed *= 2

func spawn_cannon_ball(direction : float, type : int, speed : int) -> void:
	var new_cannon_ball := CANNON_BALL.instantiate()
	new_cannon_ball.rotation = direction
	new_cannon_ball.move_direction = Vector2(cos(new_cannon_ball.rotation), sin(new_cannon_ball.rotation)) * speed
	new_cannon_ball.global_position = global_position + new_cannon_ball.move_direction.normalized() * 125
	if speed > 500: new_cannon_ball.damage = round((speed - 500)/30)  + 2
	else: new_cannon_ball.damage = 2
	new_cannon_ball.type = type
	add_child(new_cannon_ball)
	
func process(_delta:float) -> void:
	if health <= 0:
		if self is Player: get_tree().change_scene_to_packed(load("res://scenes/start_menu.tscn"))
		else: death.emit()
		queue_free()
	
	var velocity_power : float = (abs(velocity.x) + abs(velocity.y))
	velocity += force * move_speed / (velocity_power/24 + 1)
	if velocity_power > move_speed:
		velocity = velocity.normalized()
		var velocity_direction := atan2(velocity.y, velocity.x)
		velocity = Vector2(cos(velocity_direction), sin(velocity_direction))
	
	velocity *= 0.936
	
	
	move_and_slide()
