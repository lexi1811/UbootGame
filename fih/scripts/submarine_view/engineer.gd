extends CharacterBody2D

var speed = 300

enum rooms {
	NONE, # Bedeutet: Der Spieler ist gerade in keinem Raum
	SONAR,
	SHIELD,
	WEAPON,
	RELOAD,
	HEALTH,
	ENGINE,
}

# Wir starten standardmäßig in keinem Raum
var current_room = rooms.NONE

func get_input():
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = input_dir * speed

func _physics_process(_delta):
	get_input()
	move_and_slide() # Kept it clean without the broken collision variable!
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("player_repair"):
		$ProgressBar.value += 50 * delta
		if $ProgressBar.value >= $ProgressBar.max_value:
			print("Repariert im Raum: ", rooms.keys()[current_room])
			if current_room == rooms.ENGINE:
				game_state._fix_system(global_enums.System.ENGINE)
			elif current_room == rooms.SONAR:
				game_state._fix_system(global_enums.System.SONAR)
			elif current_room == rooms.SHIELD:
				game_state._fix_system(global_enums.System.SHIELD)
			elif current_room == rooms.WEAPON:
				game_state._fix_system(global_enums.System.WEAPONS)
			elif current_room == rooms.RELOAD:
				game_state._reload()
			elif current_room == rooms.HEALTH:
				game_state._repair_damage(1)
			
			
			$ProgressBar.value = 0
	else:
		$ProgressBar.value -= 20 * delta

# --- HIER SIND DEINE ENUM-FUNKTIONEN ---

func _enter_sonar(body: Node2D) -> void:
	print("signal sonar")
	current_room = rooms.SONAR

func _enter_shield(body: Node2D) -> void:
	print("signal shield")
	current_room = rooms.SHIELD

func _enter_weapon(body: Node2D) -> void:
	print("signal weapon")
	current_room = rooms.WEAPON

func _enter_reload(body: Node2D) -> void:
	print("signal reload")
	current_room = rooms.RELOAD

func _enter_health(body: Node2D) -> void:
	print("signal health")
	current_room = rooms.HEALTH

func _enter_engine(body: Node2D) -> void:
	print("signal engine")
	current_room = rooms.ENGINE

func _exit_room(body: Node2D) -> void:
	current_room = rooms.NONE
