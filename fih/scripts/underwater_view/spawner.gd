extends Node2D

# Hier laden wir die Bild-Szene, die wir oben erstellt haben
@export var image_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")

@export var new_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")

@export var temp_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")
func _on_timer_timeout() -> void:
	var random_int = randi_range(1, 5)
	var random_enemy = randi_range(1,2)
	
	if random_enemy == 1:
		temp_scene = new_scene
	elif random_enemy == 2:
		temp_scene = image_scene
	
	# 1. Eine neue Instanz des Bildes erstellen
	var new_image = temp_scene.instantiate()
	
	# 2. Dem Bild die aktuelle Position des Spawners geben
	new_image.global_position = global_position
	
	new_image.global_position.y = new_image.global_position.y + 180 * random_int
	
	# 3. Das Bild zur Hauptszene hinzufügen
	get_parent().add_child(new_image)
