extends Button


func _pressed() -> void:
	game_state._ready()
	get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")
