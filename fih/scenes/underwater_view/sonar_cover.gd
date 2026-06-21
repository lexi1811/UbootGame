extends ColorRect

# Hier speichern wir den aktuellen Tween für die weiche Animation
var fade_tween: Tween

func _ready() -> void:
	game_state.system_destroyed.connect(_on_system_destroyed)
	game_state.system_fixed.connect(_on_system_fixed)
	
	# Am Anfang ist das Sonar heil, also machen wir das Loch riesengroß (1.0)
	(material as ShaderMaterial).set_shader_parameter("hole_radius", 1.0)

func _on_system_destroyed(system):
	if system == global_enums.System.SONAR:
		# Sonar kaputt -> Das Loch zieht sich auf 0.119 zusammen
		animate_hole(0.080, 1.2) # Dauert 1.2 Sekunden (kannst du anpassen)

func _on_system_fixed(system):
	if system == global_enums.System.SONAR:
		# Sonar repariert -> Das Loch wird wieder riesig (1.0)
		animate_hole(1.0, 1.0) # Dauert 1.0 Sekunde (kannst du anpassen)

# Hilfsfunktion, die den Shader-Parameter weich animiert
func animate_hole(target_radius: float, duration: float) -> void:
	# Falls noch ein alter Übergang läuft, brechen wir ihn ab
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
	
	# Neuen Tween erstellen
	fade_tween = create_tween()
	
	# Wir animieren den "hole_radius" im Shader auf den gewünschten Zielwert
	fade_tween.tween_property(
		material, 
		"shader_parameter/hole_radius", 
		target_radius, 
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
