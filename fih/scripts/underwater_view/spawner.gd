extends Node2D

@export var whale_scene: PackedScene = preload("res://scenes/underwater_view/hamburger_wale.tscn")
@export var shark_scene: PackedScene = preload("res://scenes/underwater_view/shark.tscn")
@export var whale_offset_scene: PackedScene = preload("res://scenes/underwater_view/GegnerchenOFFSET.tscn")
@export var krake_scene: PackedScene = preload("res://scenes/underwater_view/kraken.tscn")

@export var torpedo_scene: PackedScene = preload("res://scenes/underwater_view/angryTorpedoEnemy.tscn")

# in sec
@export var shark_unlock_time: float = 15.0
@export var whale_offset_unlock_time: float = 30.0
@export var krake_unlock_time: float = 60.0
@export var torpedo_unlock_time: float = 30.0

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	
func _on_timer_timeout() -> void:
	var random_lane: int = randi_range(0, 4)
	var lane_offset: float = 0.0
	var selected_scene: PackedScene
	
	var roll: float = randf()
	

	if roll < 0.0 and time_elapsed >= krake_unlock_time:
		selected_scene = krake_scene
		random_lane = 0
		
	# 10
	elif roll < 0.03 and time_elapsed >= torpedo_unlock_time:
		selected_scene = torpedo_scene
		# Torpedo kriegt keine Lane, sondern spawnt komplett wild auf Y!
		# Wir setzen das später unten beim Instanziieren.
		
	# 21% Wal Offset (verschoben auf 0.15 bis 0.36)
	elif roll < 0.36 and time_elapsed >= whale_offset_unlock_time:
		selected_scene = whale_offset_scene
		lane_offset = 0.5 if randf() < 0.5 else -0.5
		
	else:
		if randf() < 0.5 and time_elapsed >= shark_unlock_time: 
			selected_scene = shark_scene
			if random_lane == 4:
				selected_scene = whale_scene
		else:
			selected_scene = whale_scene

	var enemy_instance = selected_scene.instantiate()
	enemy_instance.global_position = global_position
	
	# --- NEU: Wenn es der Torpedo ist, setze ihn auf eine komplett zufällige Höhe ---
	if selected_scene == torpedo_scene:
		# Random Höhe zwischen z.B. 100 und 900 (passe das an deine Bildschirmgröße an)
		enemy_instance.global_position.y = randf_range(100.0, 900.0) 
	else:
		# Für alle anderen Gegner bleibt die Lane-Logik erhalten
		enemy_instance.global_position.y = (random_lane + lane_offset) * 180 + 200
	
	get_parent().add_child(enemy_instance)
