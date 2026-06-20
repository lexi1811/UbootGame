extends Node2D

@export var whale_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")
@export var shark_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")

func _on_timer_timeout() -> void:
	var random_lane: int = randi_range(0, 4)
	var random_enemy_type: int = randi_range(1, 2)
	var selected_scene: PackedScene
	
	if random_enemy_type == 1:
		selected_scene = shark_scene
		if random_lane == 4:
			selected_scene = whale_scene
	else:
		selected_scene = whale_scene
	
	var enemy_instance = selected_scene.instantiate()
	enemy_instance.global_position = global_position
	enemy_instance.global_position.y = random_lane * 180 + 200
	
	get_parent().add_child(enemy_instance)
