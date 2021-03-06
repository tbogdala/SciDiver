extends Node2D
class_name Level

enum Directions {NORTH, EAST, SOUTH, WEST}

const PLAYER_NAME = "Player"

onready var hacking_progress_bar = $Canvas/GUI/HackingProgress


var level_gen: LevelGen
var level_root_node: LevelGen.RoomTreeNode
var current_node: LevelGen.RoomTreeNode
var player_stats: PlayerStats

const _hack_duration_required: float = 1.0
const _hack_timer_interval: float = 0.20
var _current_hack_duration: float
var _hacking_timer: Timer
var _travel_delay: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize() 
	#print("RANDOMIZE IS OFF")
	
	# wire the player stats up to the user interface
	if player_stats == null:
		player_stats = PlayerStats.new()
	player_stats.connect("DepthTravelledChanged", self, "_on_update_depth_travelled")
	player_stats.connect("TotalKillsChanged", self, "_on_update_total_kills")
	$Canvas/GUI/ScoresVBox/KillsLabel.text = "Kills: %d" % player_stats.total_kills
	$Canvas/GUI/ScoresVBox/DepthLabel.text = "Depth: %d" % player_stats.depth_travelled

	level_gen = LevelGen.new()
	level_gen.max_walk_length = 5
	level_gen.max_rooms_total = 7
	level_gen.min_rooms_total = 3
	level_gen.branch_chance = 33
	level_gen.walker_branch_decay_rate = 0.66
	level_gen.max_enemies = 3 + player_stats.depth_travelled * 0.5
	level_gen.enemy_spawn_chance = 75 + player_stats.depth_travelled
	
	level_root_node = level_gen.generate_level_nodes()
	current_node = level_root_node
	level_gen.instance_room_to(self, level_root_node)
	position_player_south(0.5)

	
func request_travel_north():
	_request_travel_dir(Directions.NORTH, current_node.north)


func request_travel_east():
	_request_travel_dir(Directions.EAST, current_node.east)

	
func request_travel_south():
	_request_travel_dir(Directions.SOUTH, current_node.south)


func request_travel_west():
	_request_travel_dir(Directions.WEST, current_node.west)


func _request_travel_dir(dir, new_node: LevelGen.RoomTreeNode):
	# ensure we could travel
	if new_node == null:
		push_error("attempted travel where there's no door")
		return
		
	# reposition the player before changing rooms
	match dir:
		Directions.NORTH:
			position_player_south(_travel_delay)
		Directions.EAST:
			position_player_west(_travel_delay)
		Directions.SOUTH:
			position_player_north(_travel_delay)
		Directions.WEST:
			position_player_east(_travel_delay) 
	
	# remove the current room Node2D from the tree
	current_node.room_inst.travelling = false
	remove_child(current_node.room_inst)
	level_gen.instance_room_to(self, new_node)
	
	# update the current node tracking
	current_node = new_node
	

func request_travel_down_stairs():
	# congrats, lets keep track of the level vectory
	player_stats.increment_depth_travelled()
	self.call_deferred("_build_new_level")
	
func _build_new_level():
	var current_stats = player_stats
	player_stats.disconnect("DepthTravelledChanged", self, "_on_update_depth_travelled")
	player_stats.disconnect("TotalKillsChanged", self, "_on_update_total_kills")
	
	var root = get_node("/root")
	root.remove_child(self)
	
	var new_level: Level = load("res://Levels/Test.tscn").instance()
	# copy the stats over to the new level and bind it to the new object
	new_level.player_stats = current_stats
	root.add_child(new_level)
	
	self.queue_free()
	
	
# hard reset player position to north door
func position_player_north(delay: float):
	_position_player_by_loc(delay, Vector2(160,48))


# hard reset player position to east door
func position_player_east(delay: float):
	_position_player_by_loc(delay, Vector2(260,120))
	
	
# hard reset player position to south door
func position_player_south(delay: float):
	_position_player_by_loc(delay, Vector2(160,185))


# hard reset player position to west door
func position_player_west(delay: float):
	_position_player_by_loc(delay, Vector2(55,120))


# hard reset player position to north door
func _position_player_by_loc(delay: float, loc: Vector2):
	var player = get_node(PLAYER_NAME)
	assert(player)
	player.visible = false
	player.set_global_position(loc)
	yield(get_tree().create_timer(delay), "timeout")
	
	#FIXME: hacking this together for now. if you get moved on an enemy it's GG
	if player != null:
		player.visible = true
	
func start_hacking_terminal():
	hacking_progress_bar.value = 0
	hacking_progress_bar.visible = true
	_hacking_timer = Timer.new()
	_hacking_timer.name = "HackingTimer"
	var _err = _hacking_timer.connect("timeout", self, "_on_hacking_timer")
	assert(_err == OK)
	_hacking_timer.wait_time = _hack_timer_interval
	_hacking_timer.one_shot = false
	add_child(_hacking_timer)
	_hacking_timer.start()
	

func _on_hacking_timer():
	_current_hack_duration += _hack_timer_interval
	if _current_hack_duration >= _hack_duration_required:
		_hacking_timer.stop()
		remove_child(_hacking_timer)
		_hacking_timer.queue_free()
		
		hacking_progress_bar.visible = false
		var stairs_down = current_node.room_inst.get_stairs_down()
		stairs_down.show_and_enable()
		var hacking_term = current_node.room_inst.get_hacking_terminal()
		hacking_term.turn_on()
	else:
		hacking_progress_bar.value = _current_hack_duration / _hack_duration_required * 100
		
		
func show_game_over_screen():
	$Canvas/GUI/GameOverUI.visible = true


func _on_GameRestartButton_pressed():
	player_stats.reset_stats()
	self.call_deferred("_build_new_level")
	
	
func _on_update_total_kills(val):
	$Canvas/GUI/ScoresVBox/KillsLabel.text = "Kills: %d" % val
	
func _on_update_depth_travelled(val):
	$Canvas/GUI/ScoresVBox/DepthLabel.text = "Depth: %d" % val

