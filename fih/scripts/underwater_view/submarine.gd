extends Area2D 

var row: int = 0
var timeout: bool = false
var move_tween: Tween

@export var taurus_scene: PackedScene
var explo_scene_sub: PackedScene = preload("res://scenes/underwater_view/explosion.tscn")

# Shield
@onready var shield_sprite: Sprite2D = $ShieldSprite

var engine: bool = true
var shield: bool = true
var weapons: bool = true

var shieldActive: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	game_state.system_destroyed.connect(_on_system_destroyed)
	game_state.system_fixed.connect(_on_system_fixed)
	game_state.health_depleted.connect(_on_game_over)
	
	shield_sprite.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_end"):
		game_state._destroy_system(global_enums.System.SHIELD)
	
	# In deiner _process oder _physics_process Funktion:
	if engine:
		# 1. Wir merken uns die Reihe vor dem Input
		var vorherige_reihe = row
		
		if Input.is_action_just_pressed("ui_down"):
<<<<<<< HEAD
			if row < 4:
				row += 1	
=======
			if row < 5:
				row += 1    
>>>>>>> f115e7a15d2db5e0837766c2d49c0641632483f2

		if Input.is_action_just_pressed("ui_up"):
			if row > 0:
				row -= 1
				
<<<<<<< HEAD
		position.y = row * 180 + 200
	
	if shield:
		if Input.is_action_just_pressed("ui_left"):
			shieldActive = !shieldActive
			print("Schild aktiv: ", shieldActive)
			
			shield_sprite.visible = shieldActive
=======
		# 2. Nur animieren, wenn der Spieler die Reihe gewechselt hat
		if row != vorherige_reihe:
			var ziel_y = row * 180 + 200
			
			# Falls sich das Objekt noch bewegt, stoppen wir die alte Bewegung sofort
			if move_tween and move_tween.is_running():
				move_tween.kill()
				
			# Neuen Tween für die flüssige Bewegung erstellen
			move_tween = create_tween()
			
			# Wir animieren position:y in 0.2 Sekunden zum ziel_y
			move_tween.tween_property(self, "position:y", ziel_y, 0.2)\
				.set_trans(Tween.TRANS_CUBIC)\
				.set_ease(Tween.EASE_OUT)
>>>>>>> f115e7a15d2db5e0837766c2d49c0641632483f2
		
	if Input.is_action_pressed("fire_taurus"):
		if weapons && !shieldActive:
			if timeout:
				return 
		
			timeout = true
			if has_node("Timer"):
				$Timer.start()
				
			if game_state._shoot():	
				var new_taurus = taurus_scene.instantiate()
				new_taurus.global_position = global_position
				new_taurus.global_position.x += 50
				get_parent().add_child(new_taurus)

func _on_body_entered(body: Node2D) -> void:
	if !shield or !shieldActive:
		game_state._take_damage(1)
	
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
		shieldActive = false 

		shield_sprite.visible = false 
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
	print("Game Over!")

func _on_timer_timeout() -> void:
	timeout = false
