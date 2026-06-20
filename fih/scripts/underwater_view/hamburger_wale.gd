extends CharacterBody2D

@export var speed: float = 200.0

# richtung
var direction: Vector2 = Vector2(-1, 0)

func _physics_process(delta: float) -> void:	
	velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		#print("I collided with ", collision.get_collider().name)
		queue_free()
