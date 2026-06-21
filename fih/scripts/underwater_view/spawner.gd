extends Node2D

@export var whale_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")
@export var shark_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")
@export var whale_offset_scene: PackedScene = preload("res://scenes/underwater_view/GegnerchenOFFSET.tscn")
@export var krake_scene: PackedScene = preload("res://scenes/underwater_view/kraken.tscn")

# in sec
@export var shark_unlock_time: float = 15.0
@export var whale_offset_unlock_time: float = 30.0
@export var krake_unlock_time: float = 60.0

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta

func _on_timer_timeout() -> void:
	var random_lane: int = randi_range(0, 4)
	var lane_offset: float = 0.0
	var selected_scene: PackedScene
	
	var roll: float = randf()
	
	if roll < 0.00 and time_elapsed >= krake_unlock_time:
		selected_scene = krake_scene
		random_lane = 0
		
	elif roll < 0.26 and time_elapsed >= whale_offset_unlock_time:
		selected_scene = whale_offset_scene
		lane_offset = 0.5 if randf() < 0.5 else -0.5
		
	else:
		if randf() < 0.3 and time_elapsed >= shark_unlock_time: 
			selected_scene = shark_scene
			if random_lane == 4:
				selected_scene = whale_scene
		else:
			selected_scene = whale_scene

	var enemy_instance = selected_scene.instantiate()
	enemy_instance.global_position = global_position
	
	enemy_instance.global_position.y = (random_lane + lane_offset) * 180 + 200
	
	get_parent().add_child(enemy_instance)
