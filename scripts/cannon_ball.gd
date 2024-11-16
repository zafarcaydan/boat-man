extends Area2D

var move_direction : Vector2
var damage : int
enum TYPES {PLAYER = 0, ENEMY = 1, SAFE = 2}
@export var type : TYPES 
@export var speed : int
var render_dist_mod : int = 1050

func _ready() -> void:
	move_direction = Vector2.RIGHT.rotated(global_rotation) * speed
	if speed > 500: damage = round((speed - 500)/30)  + 2
	else: damage = 2
	var color_modifyer: float = damage * 0.1 - 0.2
	modulate = Color(color_modifyer * 4 + 1 , 1 - color_modifyer * 1.1, 1 - color_modifyer )

func _process(delta: float) -> void:
	position += move_direction * delta
	
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Boat:
		if type != body.safe_bullets or randf() <= 0.3 : 
			body.health -= damage
		body.external_force += move_direction * 0.4
	queue_free()
			
