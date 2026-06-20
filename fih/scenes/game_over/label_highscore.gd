extends Label

func _ready() -> void:
	# Da das Skript selbst ein Label ist, änderst du hier direkt seinen eigenen Text:
	text = "Punkte: " + str(game_state.pointsSum)
