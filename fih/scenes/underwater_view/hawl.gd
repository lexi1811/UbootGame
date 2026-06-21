extends Path2D

@onready var path_follower = $PathFollow2D

var duration: float = 15.0
var move_tween: Tween

func _ready() -> void:
	# 1. Timer erstellen und einrichten
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 30.0
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(start_flying)
	add_child(spawn_timer)
	start_flying()

func start_flying():
	path_follower.progress_ratio = 0.0
	
	if move_tween and move_tween.is_running():
		move_tween.kill()
	
	move_tween = create_tween()
	move_tween.tween_property(
		path_follower, 
		"progress_ratio", 
		1.0, 
		duration
	).set_trans(Tween.TRANS_LINEAR)
