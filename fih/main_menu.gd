extends Node2D

@export_file("*.tscn") var new_game_scene_path: String = "res://scenes/main_menu/main.tscn"

@onready var btn_new_game = $main_menu/main_menu/left/menu_options/new_game
@onready var btn_continue = $main_menu/main_menu/left/menu_options/continue
@onready var btn_settings = $main_menu/main_menu/left/menu_options/settings
@onready var btn_exit = $main_menu/main_menu/left/menu_options/exit

func _ready() -> void:
	btn_new_game.pressed.connect(_on_new_game_pressed)
	btn_continue.pressed.connect(_on_continue_pressed)
	btn_settings.pressed.connect(_on_settings_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)
	
	btn_new_game.grab_focus()

func _on_new_game_pressed() -> void:
	if new_game_scene_path != "":
		get_tree().change_scene_to_file(new_game_scene_path)
	else:
		print("Fehler: Kein Szenen-Pfad angegeben!")

func _on_continue_pressed() -> void:
	print("Spiel fortsetzen geklickt!")

func _on_settings_pressed() -> void:
	print("Einstellungen geklickt!")

func _on_exit_pressed() -> void:
	get_tree().quit()
