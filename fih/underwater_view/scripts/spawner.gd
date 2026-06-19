extends Node2D

# Hier laden wir die Bild-Szene, die wir oben erstellt haben
@export var image_scene: PackedScene = preload("res://underwater_view/scenes/hamburger_wale.tscn")

func _on_timer_timeout() -> void:
	# 1. Eine neue Instanz des Bildes erstellen
	var new_image = image_scene.instantiate()
	
	# 2. Dem Bild die aktuelle Position des Spawners geben
	new_image.global_position = global_position
	
	var random_int = randi_range(1, 5)
	
	new_image.global_position.y = new_image.global_position.y + 180 * random_int
	
	# 3. Das Bild zur Hauptszene hinzufügen
	get_parent().add_child(new_image)
