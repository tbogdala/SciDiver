extends KinematicBody2D

const move_boundaries = [48, 48, 274, 200] # top-left, lower-right
var pathing_timer_interval = 4.0

export(int) var Speed = 40
var _pathing_timer: Timer
var _current_target: Vector2

func _ready():
	_current_target = Vector2.ZERO
	var level: Level = get_tree().get_root().get_node("World") as Level
	Speed += level.player_stats.total_kills
	pathing_timer_interval -= level.player_stats.depth_travelled * 0.1
	
	_pathing_timer = Timer.new()
	_pathing_timer.name = "PathingAI"
	var _err = _pathing_timer.connect("timeout", self, "_on_pathing_timer")
	assert(_err == OK)
	_pathing_timer.wait_time = pathing_timer_interval
	_pathing_timer.one_shot = false
	add_child(_pathing_timer)
	_pathing_timer.start()
	_on_pathing_timer() # first hit is free
	
func _physics_process(_delta):
	var velocity = position.direction_to(_current_target) * Speed
	if position.distance_to(_current_target) > 5:
		velocity = move_and_slide(velocity)
	
	
func _on_take_damage(_damage: int):
	# keep track of total kills
	var level: Level = get_tree().get_root().get_node("World") as Level
	level.player_stats.increment_total_kills()
	
	_pathing_timer.stop()
	queue_free()


func _on_pathing_timer():
	# get a random location within boundary
	var rnd_x = randi() % (move_boundaries[2] - move_boundaries[0]) + move_boundaries[0]
	var rnd_y = randi() % (move_boundaries[3] - move_boundaries[0]) + move_boundaries[1]
	_current_target = Vector2(rnd_x, rnd_y)


func _on_Hurtbox_Area2D_area_entered(area):
	area.owner._on_take_damage(1)
