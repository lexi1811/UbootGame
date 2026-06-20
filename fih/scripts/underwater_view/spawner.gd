extends Node2D

@export var image_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")
@export var new_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")
@export var kraken_scene: PackedScene = preload("res://scenes/underwater_view/kraken.tscn")
@export var temp_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")

func _on_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("kraken").size() > 0:
		return

	var roll = randf()
	var is_kraken = false
	
	if roll < 0.05:
		temp_scene = kraken_scene
		is_kraken = true
	elif roll < 0.30:
		temp_scene = new_scene
	else:
		temp_scene = image_scene
	
	var new_image = temp_scene.instantiate()
	new_image.global_position = global_position
	
	if not is_kraken:
		var random_int = randi_range(1, 5)
		new_image.global_position.y = new_image.global_position.y + 180 * random_int
		
	get_parent().add_child(new_image)
