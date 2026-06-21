extends Node2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")	

func _on_how_to_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play/how_to_play.tscn")	

func _on_exit_pressed() -> void:
	get_tree().quit()
