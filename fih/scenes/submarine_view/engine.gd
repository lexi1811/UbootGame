extends Sprite2D

var current_system = global_enums.System.ENGINE

func _ready() -> void:
	game_state.system_destroyed.connect(on_system_destroyed)
	game_state.system_fixed.connect(on_system_fixed)
	make_green()

func on_system_destroyed(system) -> void:
	if system == current_system:
		make_red()

func on_system_fixed(system) -> void:
	if system == current_system:
		make_green()

# Funktion für Grün (System läuft)
func make_green():
	self.modulate = Color.from_string("#2ecc71", Color.GREEN)

# Funktion für Rot (System zerstört!)
func make_red():
	self.modulate = Color.from_string("#ff4d4d", Color.RED)
