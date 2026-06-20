extends Node

signal system_destroyed(system)
signal system_fixed(system)
signal health_depleted
signal health_changed(new_health)
signal ammo_changed(new_ammo)
signal all_systems_fixed()
signal points_changed(points)

var system_state: Dictionary[global_enums.System, bool] = {}
var health_max = 5
var health = health_max
var amunition_max = 5
var amunition = amunition_max
var pointsSum: int = 0

var schummeln: bool = false

func _enemy_killed(points) -> void:
	pointsSum += points
	points_changed.emit(pointsSum)

func _ready() -> void:
	health = health_max
	amunition = amunition_max
	pointsSum = 0
	
	for s in global_enums.System.values():
		system_state[s] = true

func _destroy_system(system: global_enums.System) -> void:
	if !schummeln:
		system_state[system] = false
		system_destroyed.emit(system)
		print(system)
		print("Destroyed sytem: ", global_enums.System.find_key(system))
	
func _fix_system(system: global_enums.System) -> void:
	system_state[system] = true
	system_fixed.emit(system)
	if system_state.values().all(func(state): return state):
		all_systems_fixed.emit()
		
func _is_system_functional(system: global_enums.System) -> bool:
	return system_state[system]
	
func _take_damage(amount) -> int:
	if !schummeln:
		health -= amount
		health_changed.emit(health)
		if health <= 0:
			health_depleted.emit()
			return 0
	return health
		
func _repair_damage(amount):
	health = min(health + amount, health_max)
	health_changed.emit(health)
		
func _shoot() -> bool:
	if schummeln:
		return true
		
	if amunition > 0:
		amunition -= 1
		ammo_changed.emit(amunition)
		return true
	return false

func _reload() -> bool:
	if amunition < amunition_max:
		amunition = amunition_max
		ammo_changed.emit(amunition)
		return true
	return false
