extends Label

func _ready() -> void:
	# Da das Skript selbst ein Label ist, änderst du hier direkt seinen eigenen Text:
	text = "Points: " + str(game_state.pointsSum)
	var sfx = preload("res://assets/audio/sfx/Sad Trombone.mp3")
	$AudioStreamPlayer2D.stream = sfx
	$AudioStreamPlayer2D.play()
