extends Label
	
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
