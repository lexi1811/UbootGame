extends Area2D 

var row: int = 0
var timeout: bool = false

@export var taurus_scene: PackedScene = preload("res://scenes/underwater_view/taurus.tscn")
@export var explo_scene_sub: PackedScene = preload("res://scenes/underwater_view/explosion.tscn")


func _ready() -> void:
	# kollision
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		if row < 5:
			row += 1	

	if Input.is_action_just_pressed("ui_up"):
		if row > 0:
			row -= 1
	
	if Input.is_action_pressed("fire_taurus"):
		if timeout:
			return 
		
		timeout = true
		if has_node("Timer"):
			$Timer.start()
		
		var new_taurus = taurus_scene.instantiate()
		new_taurus.global_position = global_position
		get_parent().add_child(new_taurus)

	# Bewegung
	position.y = row * 180 + 200

# wenn kollision
func _on_body_entered(body: Node2D) -> void:
	var new_explosion = explo_scene_sub.instantiate()
	new_explosion.global_position = global_position
	new_explosion.global_position.x += 50
	new_explosion.z_index = 10
	get_parent().add_child(new_explosion)

	get_tree().create_timer(0.7).timeout.connect(new_explosion.queue_free)
	body.queue_free() 

func _on_timer_timeout() -> void:
	timeout = false
