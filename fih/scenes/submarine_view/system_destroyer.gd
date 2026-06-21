extends Timer

var propability = 10

func _ready() -> void:
	start(2)

func _on_timer_timeout():
	var random_int = randi_range(0, propability)
	if random_int == propability:
		var system_index = randi_range(0, global_enums.System.size() - 1) 
		game_state._destroy_system(system_index)
		start(5)
	else:
		start(1)
