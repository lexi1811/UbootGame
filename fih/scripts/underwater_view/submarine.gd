extends Area2D 

var row: int = 0
var timeout: bool = false
var move_tween: Tween

#var taurus_scene: PackedScene = preload("res://scenes/underwater_view/taurus.tscn")
@export var taurus_scene: PackedScene
var explo_scene_sub: PackedScene = preload("res://scenes/underwater_view/explosion.tscn")

var engine: bool = true
var shield: bool = true
var weapons: bool = true

func _ready() -> void:
	# kollision
	body_entered.connect(_on_body_entered)
	game_state.system_destroyed.connect(_on_system_destroyed)
	game_state.system_fixed.connect(_on_system_fixed)
	game_state.health_depleted.connect(_on_game_over)

func _unhandled_input(event: InputEvent) -> void:
	# Prüft, ob die Aktion "ui_cancel" (Standard: Escape-Taste) gedrückt wurde
	if event.is_action_pressed("ui_cancel"):
		# Lädt die Hauptmenü-Szene
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	#Debug
	if Input.is_action_just_pressed("ui_end"):
		#game_state._destroy_system(global_enums.System.SONAR)
		game_state._take_damage(100)
	
	# In deiner _process oder _physics_process Funktion:
	if engine:
		# 1. Wir merken uns die Reihe vor dem Input
		var vorherige_reihe = row
		
		if Input.is_action_just_pressed("ui_down"):
			if row < 5:
				row += 1    

		if Input.is_action_just_pressed("ui_up"):
			if row > 0:
				row -= 1
				
		# 2. Nur animieren, wenn der Spieler die Reihe gewechselt hat
		if row != vorherige_reihe:
			var ziel_y = row * 180 + 200
			
			# Falls sich das Objekt noch bewegt, stoppen wir die alte Bewegung sofort
			if move_tween and move_tween.is_running():
				move_tween.kill()
				
			# Neuen Tween für die flüssige Bewegung erstellen
			move_tween = create_tween()
			
			# Wir animieren position:y in 0.2 Sekunden zum ziel_y
			move_tween.tween_property(self, "position:y", ziel_y, 0.5)\
				.set_trans(Tween.TRANS_CUBIC)\
				.set_ease(Tween.EASE_OUT)
		
	if Input.is_action_pressed("fire_taurus"):
		if weapons:
			if timeout:
				return 
		
			timeout = true
			if has_node("Timer"):
				$Timer.start(0.3)
				
			if game_state._shoot():	
				var new_taurus = taurus_scene.instantiate()
				new_taurus.global_position = global_position
				new_taurus.global_position.x += 50
				#new_taurus.global_position.y += 10
				get_parent().add_child(new_taurus)

# wenn kollision
func _on_body_entered(body: Node2D) -> void:
	var health = game_state._take_damage(1)
	
	if health == 0:
		return
	
	var new_explosion = explo_scene_sub.instantiate()
	new_explosion.global_position = global_position
	new_explosion.global_position.x += 50
	new_explosion.global_position.y += 20
	new_explosion.z_index = 10
	get_parent().add_child(new_explosion)

	get_tree().create_timer(0.7).timeout.connect(new_explosion.queue_free)
	body.queue_free() 

func _on_system_destroyed(system: global_enums.System) -> void:
	if system == global_enums.System.ENGINE:
		engine = false
		print("U-Boot-System: Motor ist ausgefallen!")
		
	elif system == global_enums.System.SHIELD:
		shield = false
		print("U-Boot-System: Schilde sind offline!")
		
	elif system == global_enums.System.WEAPONS:
		weapons = false
		print("U-Boot-System: Waffensystem blockiert!")


func _on_system_fixed(system: global_enums.System) -> void:
	if system == global_enums.System.ENGINE:
		engine = true
		print("U-Boot-System: Motor wurde repariert!")
		
	elif system == global_enums.System.SHIELD:
		shield = true
		print("U-Boot-System: Schilde sind wieder online!")
		
	elif system == global_enums.System.WEAPONS:
		weapons = true
		print("U-Boot-System: Waffen sind wieder einsatzbereit!")
	
func _on_game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over/game_over.tscn")

func _on_timer_timeout() -> void:
	timeout = false
