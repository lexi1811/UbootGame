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

var room_repair_speeds: Dictionary = {
	rooms.NONE: 0.0,
	rooms.SONAR: 50.0,    # Normale Geschwindigkeit
	rooms.SHIELD: 50.0,
	rooms.WEAPON: 50.0,
	rooms.RELOAD: 150.0,  # Sehr hoher Wert = Füllt sich extrem schnell!
	rooms.HEALTH: 15.0,   # Sehr niedriger Wert = Dauert sehr lange!
	rooms.ENGINE: 40.0
}

var current_room = rooms.NONE
var player_moved: bool = false

var sfx_repair = preload("res://assets/audio/sfx/repair.mp3")
var sfx_reload = preload("res://assets/audio/sfx/reload.mp3")

@export var tex_idle: Texture2D 
@export var tex_repair_1: Texture2D
@export var tex_repair_2: Texture2D
@export var tex_repair_3: Texture2D

var repair_frames: Array[Texture2D] = []
var anim_timer: float = 0.0
var current_frame: int = 0
@export var anim_speed: float = 0.15 # Wie schnell wechseln die Bilder? (In Sekunden)

func _ready() -> void:
	# Wir packen die 3 Bilder in eine Liste, um sie später durchzuwechseln
	repair_frames = [tex_repair_1, tex_repair_2, tex_repair_3]
	
	# Setzt das Standardbild beim Start
	if tex_idle and has_node("Sprite2D"):
		$Sprite2D.texture = tex_idle

func get_input():
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	velocity = input_dir * speed
	if input_dir != Vector2.ZERO:
		player_moved = true
		$ProgressBar.value = 0
		if !$AudioStreamPlayer2D.is_playing():
			var random_int = randi_range(1, 3)
			var sfx_path = "res://assets/audio/sfx/engineer-step-" + str(random_int) + ".ogg"
			var sfx = load(sfx_path)
			
			$AudioStreamPlayer2D.stream = sfx
			$AudioStreamPlayer2D.play()
	else:
		player_moved = false

func _physics_process(_delta):
	get_input()
	move_and_slide() 
	
func _process(delta: float) -> void:
	# Wir prüfen jetzt auch, ob der Spieler überhaupt in einem Raum ist,
	# damit er nicht im Gang repariert und die Luft zusammenschraubt.
	if Input.is_action_pressed("player_repair") and !player_moved and current_room != rooms.NONE:
		
		# Sound abspielen
		if !$AudioStreamPlayer2D.is_playing():
			if current_room == rooms.RELOAD:
				$AudioStreamPlayer2D.stream = sfx_reload
			else:
				$AudioStreamPlayer2D.stream = sfx_repair
			$AudioStreamPlayer2D.play()
			
		# --- NEU: BILDER ANIMIEREN ---
		if has_node("Sprite2D") and repair_frames.size() == 3:
			anim_timer += delta
			if anim_timer >= anim_speed:
				anim_timer = 0.0 # Timer zurücksetzen
				current_frame += 1 # Nächstes Bild
				
				# Wenn wir beim letzten Bild waren, fangen wir wieder bei 0 an
				if current_frame >= repair_frames.size():
					current_frame = 0
					
				# Neues Bild setzen
				$Sprite2D.texture = repair_frames[current_frame]

		# Fortschrittsbalken füllen
		var current_speed = room_repair_speeds[current_room]
		$ProgressBar.value += current_speed * delta
		
		if $ProgressBar.value >= $ProgressBar.max_value:
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
		$AudioStreamPlayer2D.stop()
		
		# --- NEU: ZURÜCK ZUM STANDARD-BILD ---
		# Wenn wir nicht reparieren, setzen wir das Bild zurück auf "Idle"
		if has_node("Sprite2D") and tex_idle:
			$Sprite2D.texture = tex_idle
			# Timer für das nächste Mal zurücksetzen
			anim_timer = 0.0
			current_frame = 0

# --- RAUM FUNKTIONEN ---

func _enter_sonar(body: Node2D) -> void:
	current_room = rooms.SONAR

func _enter_shield(body: Node2D) -> void:
	current_room = rooms.SHIELD

func _enter_weapon(body: Node2D) -> void:
	current_room = rooms.WEAPON

func _enter_reload(_body: Node2D) -> void:
	current_room = rooms.RELOAD

func _enter_health(body: Node2D) -> void:
	current_room = rooms.HEALTH

func _enter_engine(body: Node2D) -> void:
	current_room = rooms.ENGINE

func _exit_room(body: Node2D) -> void:
	current_room = rooms.NONE
