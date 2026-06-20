extends Node2D

@export_file("*.tscn") var new_game_scene_path: String = "res://scenes/main_menu/main.tscn"

func _on_start_pressed() -> void:
	if new_game_scene_path != "":
		get_tree().change_scene_to_file(new_game_scene_path)
	else:
		print("Fehler: Kein Szenen-Pfad angegeben!")

func _on_how_to_pressed() -> void:
	print("How to geklickt!")

func _on_settings_pressed() -> void:
	print("Einstellungen geklickt!")

func _on_exit_pressed() -> void:
	get_tree().quit()
