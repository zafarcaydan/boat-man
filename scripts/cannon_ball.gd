extends Area2D

var move_direction : Vector2
var damage : int
enum TYPES {PLAYER = 0, ENEMY = 1}
var type : TYPES 

func _process(delta: float) -> void:
	position += move_direction * delta
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Boat:
		if type != body.safe_bullets: 
			body.health -= damage
	queue_free()
			
