extends Area2D

var move_direction : Vector2
var damage : int
enum TYPES {PLAYER = 0, ENEMY = 1}
var type : TYPES 

func _process(delta):
	position += move_direction * delta
	
func _on_body_entered(body):
	if body is PhysicsBody2D: 
		if body is Enemy and type == 0: 
			body.queue_free()
			queue_free()
		elif body is Boat and type == 1: 
			get_tree().reload_current_scene.call_deferred()
			
