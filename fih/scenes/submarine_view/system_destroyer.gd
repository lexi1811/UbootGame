extends Timer

var propability = 50

func _on_timer_timeout():
	var random_int = randi_range(0, propability)
	if random_int == propability:
		var system_index = randi_range(0, global_enums.System.size() - 1) 
		game_state._destroy_system(system_index)
