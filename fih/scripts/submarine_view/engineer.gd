extends CharacterBody2D

var speed = 300

func get_input():
	var input_dir = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	# Wir weisen der eingebauten Variable 'velocity' den Wert zu
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	# move_and_slide() nutzt automatisch die 'velocity' und verrechnet 'delta' selbst!
	move_and_slide()
