extends CharacterBody2D

@export var speed: float = 170.0

# --- Animations-Variablen (Propeller & Schwimmen) ---
@export var propeller_speed: float = -15.0 # Geschwindigkeit der Drehung
@export var float_amplitude: float = 15.0  # Wie weit schwimmt das U-Boot auf/ab
@export var float_speed: float = 3.0       # Wie schnell schwimmt es auf/ab

var time_passed: float = 0.0
var base_y: float = 0.0                     # Merkt sich die Start-Höhe der Lane
var original_propeller_scale_y: float = 1.0 # Schutz vor zu großem Propeller
var sonar_destroyed: bool = false

# richtung
var direction: Vector2 = Vector2(-1, 0)

func _ready() -> void:
	#game_state.system_destroyed.connect(on_system_destroyed)
	#game_state.system_fixed.connect(on_system_fixed)
	add_to_group("walOffset")
	
	base_y = global_position.y
	if has_node("Propeller2"):
		original_propeller_scale_y = $Propeller2.scale.y
	
	#if !game_state._is_system_functional(global_enums.System.SONAR):
	#	sonar_destroyed = true

func on_system_destroyed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = true

func on_system_fixed(system) -> void:
	if system == global_enums.System.SONAR:
		sonar_destroyed = false

func _process(delta: float) -> void:
	if is_queued_for_deletion():
		return

	if sonar_destroyed:
		$Sprite2D.hide()
		if has_node("Propeller2"):
			$Propeller2.hide()
		if has_node("Bubbles"):
			$Bubbles.emitting = false
	else:
		$Sprite2D.show()
		
		# --- KORRIGIERT: 3D-Propeller mit Skalierungsschutz ---
		if has_node("Propeller2"):
			$Propeller2.show()
			time_passed += delta
			var scale_y = sin(time_passed * abs(propeller_speed)) * original_propeller_scale_y
			$Propeller2.scale.y = scale_y
			
		if has_node("Bubbles"):
			$Bubbles.emitting = true
		
		# Auf- und Ab-Schwimm-Animation
		if not has_node("Propeller2"):
			time_passed += delta
		global_position.y = base_y + sin(time_passed * float_speed) * float_amplitude

func _physics_process(delta: float) -> void:	
	velocity = direction * (speed * game_state.speed_factor)
	
	# Da wir Y in _process animieren, bewegen wir uns via Physik nur auf X
	var collision = move_and_collide(Vector2(velocity.x, 0) * delta)
	
	if collision:
		var hit_object = collision.get_collider()
		if !hit_object.is_in_group("haie") && !hit_object.is_in_group("taurus") && !hit_object.is_in_group("wal") && !hit_object.is_in_group("torpedo"):
			queue_free()
