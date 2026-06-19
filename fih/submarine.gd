extends Sprite2D
var speed = 30
var delta = 20

var row = 0
var timeout = false

# Hier laden wir die Bild-Szene, die wir oben erstellt haben
@export var taurus: PackedScene = preload("res://taurus.tscn")

func _on_timer_timeout() -> void:
	timeout = false
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Nach oben bewegen (Grenze ist 0)
	if Input.is_action_just_pressed("ui_down"):
		if row < 5:
			row += 1

	# Nach unten bewegen (Grenze ist die Viewport-Höhe .y)
	if Input.is_action_just_pressed("ui_up"):
		if row > 0:
			row -= 1
	
	if Input.is_action_pressed("fire_taurus"):
		
		print(timeout)
		
		if timeout:
			return			
		
		$Timer.start()
		
		timeout = true
		
		
		var new_taurus = taurus.instantiate()
		
		# 2. Dem Bild die aktuelle Position des Spawners geben
		new_taurus.global_position = global_position
		
		new_taurus.global_position.y = new_taurus.global_position.y
		
		# 3. Das Bild zur Hauptszene hinzufügen
		get_parent().add_child(new_taurus)
	
		
	position.y = row * 180 + 200
	pass
