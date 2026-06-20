extends CanvasLayer

@onready var health_bar: ProgressBar = $HealthBar
@onready var ammo_count: ProgressBar = $AmmoCount

func _ready() -> void:
	game_state.health_changed.connect(_on_health_changed)
	game_state.ammo_changed.connect(_on_ammo_changed)
	
	health_bar.value = game_state.health
	ammo_count.value = game_state.amunition

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func _on_ammo_changed(new_ammo: int) -> void:
	ammo_count.value = new_ammo
