extends Node2D

@export var whale_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")
@export var shark_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")
@export var whale_scene_offset: PackedScene = preload("res://scenes/underwater_view/GegnerchenOFFSET.tscn")

func _on_timer_timeout() -> void:
	var random_lane: int = randi_range(0, 4)
	var selected_scene: PackedScene
	var spawn_chance: float = randf_range(0.0, 1.0)
	
	var lane_offset: float = 0.0
	
	if spawn_chance < 0.2:
		selected_scene = whale_scene_offset
		
		# REPARIERT: 50/50 Chance, ob der Offset exakt +0.6 oder -0.6 ist
		if randf() < 0.5:
			lane_offset = 0.6
		else:
			lane_offset = -0.6
		
	else:
		var random_enemy_type: int = randi_range(1, 2)
		
		if random_enemy_type == 1:
			selected_scene = shark_scene
			if random_lane == 4:
				selected_scene = whale_scene
		else:
			selected_scene = whale_scene
	
	var enemy_instance = selected_scene.instantiate()
	enemy_instance.global_position = global_position
	
	# Der lane_offset wird hier mathematisch eingerechnet (+/- 108 Pixel Versatz)
	enemy_instance.global_position.y = (random_lane + lane_offset) * 180 + 200
	
	get_parent().add_child(enemy_instance)
