extends CharacterBody2D

@export var speed: float = 400.0
@export var wave_amplitude: float = 500.0
@export var wave_frequency: float = 5.0

var sonar_destroyed: bool = false
var time_passed: float = 0.0
var direction: Vector2 = Vector2(-1, 0)

func _ready() -> void:
	# REPARIERT: Unterstriche vor den Funktionsnamen ergänzt
	game_state.system_destroyed.connect(_on_system_destroyed)
	game_state.system_fixed.connect(_on_system_fixed)
	
	add_to_group("haie") 
	if !game_state._is_system_functional(global_enums.System.SONAR):
		sonar_destroyed = true

func _on_system_destroyed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = true

func _on_system_fixed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = false

func _process(_delta: float) -> void:
	if sonar_destroyed:
		$Sprite2D.hide()
	else:
		$Sprite2D.show()

func _physics_process(delta: float) -> void:	
	# REPARIERT: Auch die Wellen-Zeit vergeht schneller, wenn der Speedfactor steigt
	time_passed += delta * game_state.speed_factor
	
	# Vorwärtsgeschwindigkeit mit Speedfactor multiplizieren
	var current_speed = speed * game_state.speed_factor
	
	# Vertikale Sinuswelle berechnen
	var vertical_movement = sin(time_passed * wave_frequency) * wave_amplitude
	
	# Geschwindigkeit zuweisen
	velocity = Vector2(direction.x * current_speed, vertical_movement)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit_object = collision.get_collider()
		if !hit_object.is_in_group("wale") && !hit_object.is_in_group("taurus"):
			queue_free()
