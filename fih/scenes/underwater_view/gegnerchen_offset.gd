extends CharacterBody2D

@export var speed: float = 200.0
var sonar_destroyed: bool = false

func _ready() -> void:
	#game_state.system_destroyed.connect(on_system_destroyed)
	#game_state.system_fixed.connect(on_system_fixed)
	add_to_group("walOffset")
	#if !game_state._is_system_functional(global_enums.System.SONAR):
	#	sonar_destroyed = true
	
# richtung
var direction: Vector2 = Vector2(-1, 0)

func on_system_destroyed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = true

func on_system_fixed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = false

func _process(delta: float) -> void:
	if sonar_destroyed:
		$Sprite2D.hide()
	else:
		$Sprite2D.show()

func _physics_process(delta: float) -> void:	
	velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit_object = collision.get_collider()
		if !hit_object.is_in_group("haie") && !hit_object.is_in_group("taurus"):
			#print("I collided with ", collision.get_collider().name)
			queue_free()
