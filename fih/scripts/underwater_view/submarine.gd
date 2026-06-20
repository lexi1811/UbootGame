extends Area2D 

var row: int = 0
var timeout: bool = false

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

func _process(_delta: float) -> void:
	
	#Debug
	if Input.is_action_just_pressed("ui_end"):
		game_state._destroy_system(global_enums.System.SONAR)
	
	if engine:
		if Input.is_action_just_pressed("ui_down"):
			if row < 5:
				row += 1	

		if Input.is_action_just_pressed("ui_up"):
			if row > 0:
				row -= 1
				
		position.y = row * 180 + 200
		
	if Input.is_action_pressed("fire_taurus"):
		if weapons:
			if timeout:
				return 
		
			timeout = true
			if has_node("Timer"):
				$Timer.start()
				
			if game_state._shoot():	
				var new_taurus = taurus_scene.instantiate()
				new_taurus.global_position = global_position
				new_taurus.global_position.x += 50
				#new_taurus.global_position.y += 10
				get_parent().add_child(new_taurus)

# wenn kollision
func _on_body_entered(body: Node2D) -> void:
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
