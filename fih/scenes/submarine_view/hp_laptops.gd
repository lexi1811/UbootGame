extends Sprite2D

func _ready() -> void:
	make_green()

func _process(delta: float) -> void:
	if game_state.health <= 1:
		make_red()
	else:
		make_green()


# Funktion für Grün (System läuft)
func make_green():
	self.modulate = Color.from_string("#2ecc71", Color.GREEN)

# Funktion für Rot (System zerstört!)
func make_red():
	self.modulate = Color.from_string("#ff4d4d", Color.RED)
