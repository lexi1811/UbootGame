extends CharacterBody2D

@export var speed: float = 300.0
@export var explo_scene: PackedScene = preload("res://scenes/underwater_view/explosion.tscn")

signal enemy_killed(points)

# richtung
var direction: Vector2 = Vector2(1, 0)

func _physics_process(delta: float) -> void:	
	velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		var hit_object = collision.get_collider()
		if hit_object.is_in_group("wale"):
			hit_object.queue_free()
			enemy_killed.emit(10)
		elif hit_object.is_in_group("rightBorder"):
			queue_free()
		
		var new_explosion = explo_scene.instantiate()
		new_explosion.global_position = global_position
		new_explosion.global_position.x += 200
		get_parent().add_child(new_explosion)
		get_tree().create_timer(0.7).timeout.connect(new_explosion.queue_free)
		
		queue_free()
