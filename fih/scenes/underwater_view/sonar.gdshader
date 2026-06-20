shader_type canvas_item;

// Schieberegler für die Lochgröße (innerer, komplett durchsichtiger Kreis)
uniform float hole_radius : hint_range(0.0, 1.0) = 0.05;

// Schieberegler für die Weichheit des Randes (je höher, desto weicher der Übergang)
uniform float feather : hint_range(0.0, 1.0) = 0.15;

void fragment() {
	// Abstand zur Mitte berechnen
	float dist = distance(UV, vec2(0.5, 0.5));
	
	// Berechnet einen weichen Übergang für den Alpha-Kanal (Sichtbarkeit)
	// smoothstep liefert Werte zwischen 0.0 (unsichtbar) und 1.0 (voll sichtbar)
	float alpha = smoothstep(hole_radius, hole_radius + feather, dist);
	
	// Wir multiplizieren den bestehenden Alpha-Wert des Pixels mit unserem weichen Verlauf
	COLOR.a *= alpha;
}