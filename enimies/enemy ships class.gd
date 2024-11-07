class_name Enemy

extends Boat

var player : Player
var state : EnemyStateBehaviors.STATES = EnemyStateBehaviors.STATES.TOWARD
var external_nodes : Array[Node] 
var behaviors : Array[Callable]

func _ready() -> void:
	
	super()
	safe_bullets = 1
	player = GT.get_player()
	global_position += player.global_position
	move_speed += randi_range(-20, 20)
	death.connect(upon_death)

func spawn_cache(type: GT.resource_types) -> void:
	var new_cache := CACHE.instantiate()
	new_cache.global_position = global_position
	new_cache.item_type = type
	add_sibling.call_deferred(new_cache)
	

func upon_death() -> void:
	if randf() < 0.29:
		spawn_cache(GT.resource_types.Wood)
	
	if randf() < 0.08:
		spawn_cache(GT.resource_types.Cannon_Balls)
		
func _physics_process(delta:float) -> void:
	additional_process(delta)
	behaviors[state].call(self)
	process()
	
func additional_process(delta:float) -> void:
	pass
	
func away_conditions_met() -> void:
	pass
