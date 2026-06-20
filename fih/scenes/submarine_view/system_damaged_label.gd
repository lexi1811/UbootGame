extends Label



# Wir merken uns den aktuellen Tween, damit wir ihn abbrechen können,
# falls schnell nacheinander ein- und ausgeblendet wird (verhindert Ruckler).
var fade_tween: Tween

func _ready() -> void:
	game_state.system_destroyed.connect(show_label)
	game_state.all_systems_fixed.connect(hide_label)
	hide_label()
	

func show_label(system) -> void:
	# Falls noch eine Animation läuft, stoppen wir sie
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
		
	# Start-Zustand für das Einblenden setzen: unsichtbar und klein
	modulate.a = 0.0
	scale = Vector2(0.7, 0.7)
	show() # Sicherstellen, dass das Label generell sichtbar geschaltet ist
	
	fade_tween = create_tween().set_parallel(true) # .set_parallel sorgt dafür, dass Deckkraft und Größe GLEICHZEITIG animiert werden
	
	# In 0.2 Sekunden voll sichtbar machen (Alpha auf 1.0)
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	# In 0.2 Sekunden auf Normalgröße skalieren mit einem schönen, leicht federnden Effekt
	fade_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)


func hide_label() -> void:
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()
		
	fade_tween = create_tween().set_parallel(true)
	
	# In 0.15 Sekunden unsichtbar machen
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.15)
	# Gleichzeitig etwas zusammenschrumpfen lassen
	fade_tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.15)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
		
	# Sobald die Animation FERTIG ist, machen wir das Label komplett unsichtbar (spart Performance)
	fade_tween.chain().tween_callback(hide)
	
func pulse_animation():
		var tween = create_tween()
		
		# Auf das 1.2-fache vergrößern mit TRANS_SINE
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
			
		# Wieder zurück auf Normalgröße (1.0)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN)
