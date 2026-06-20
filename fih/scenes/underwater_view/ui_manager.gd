extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var ammo_count: TextureProgressBar = $AmmoCount
@onready var points: Label = $Points

func _ready() -> void:
	game_state.health_changed.connect(_on_health_changed)
	game_state.ammo_changed.connect(_on_ammo_changed)
	game_state.points_changed.connect(_on_points_changed)
	
	health_bar.value = game_state.health
	ammo_count.value = game_state.amunition
	points.text = "Punkte: " + str(game_state.pointsSum)
	points.z_index = 10

func _on_points_changed(pointsSum: int) -> void:
	points.text = "Punkte: " + str(pointsSum)
	
	var tween = create_tween()
	
	# Auf das 1.2-fache vergrößern mit TRANS_SINE
	tween.tween_property(points, "scale", Vector2(1.2, 1.2), 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	# Wieder zurück auf Normalgröße (1.0)
	tween.tween_property(points, "scale", Vector2(1.0, 1.0), 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func _on_ammo_changed(new_ammo: int) -> void:
	ammo_count.value = new_ammo
