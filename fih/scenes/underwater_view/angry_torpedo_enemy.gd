extends CharacterBody2D

@export var speed: float = 333.0
var target: Node2D = null

func _ready() -> void:
	add_to_group("torpedo")
	
	# Sucht sich automatisch das Spieler-U-Boot als Ziel
	var target_nodes = get_tree().get_nodes_in_group("player_sub")
	if target_nodes.size() > 0:
		target = target_nodes[0]

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(-1, 0) # Standard: nach links
	
	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)
		rotation = direction.angle() + PI 
		
	velocity = direction * (speed * game_state.speed_factor)
	
	# Die Bewegung als Geist: Bewegt sich direkt über die Position 
	# und ignoriert alle physikalischen Kollisionen mit anderen Gegnern!
	global_position += velocity * delta
