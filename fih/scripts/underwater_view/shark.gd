extends CharacterBody2D

@export var speed: float = 400.0
@export var wave_amplitude: float = 500.0
@export var wave_frequency: float = 5.0

var sonar_destroyed: bool = false
var time_passed: float = 0.0
var direction: Vector2 = Vector2(-1, 0)

func _ready() -> void:
	game_state.system_destroyed.connect(on_system_destroyed)
	game_state.system_fixed.connect(on_system_fixed)
	add_to_group("haie") 
	if !game_state._is_system_functional(global_enums.System.SONAR):
		sonar_destroyed = true

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
	time_passed += delta
	var vertical_movement = sin(time_passed * wave_frequency) * wave_amplitude
	velocity = Vector2(direction.x * speed, vertical_movement)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
