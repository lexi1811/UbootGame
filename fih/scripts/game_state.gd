extends Node

signal system_destroyed(system)
signal system_fixed(system)
signal health_depleted

var system_state: Dictionary[global_enums.System, bool] = {}
var health_max = 5
var health = health_max
var amunition_max = 5
var amunition = amunition_max

func _ready() -> void:
	for s in global_enums.System.values():
		system_state[s] = true

func _destroy_system(system: global_enums.System) -> void:
	system_state[system] = false
	system_destroyed.emit(system)
	print(system)
	print("Destroyed sytem: ", global_enums.System.find_key(system))
	
func _fix_system(system: global_enums.System) -> void:
	system_state[system] = true
	system_fixed.emit(system)
	
func _take_damage(amount):
	health -= amount
	if health <= 0:
		health_depleted.emit()
		
func _repair_damage(amount):
	health = min(health + amount, health_max)
		
func _shoot() -> bool:
	if amunition > 0:
		amunition -= 1
		return true
	return false

func _reload() -> bool:
	if amunition < amunition_max:
		amunition += 1
		return true
	return false
