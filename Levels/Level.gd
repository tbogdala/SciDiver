extends Node2D
class_name Level

enum Directions {NORTH, EAST, SOUTH, WEST}

const PLAYER_NAME = "Player"
const LevelGenClass = preload("res://Levels/LevelGen.gd")

var level_gen: LevelGen
var level_root_node: LevelGen.RoomTreeNode
var current_node: LevelGen.RoomTreeNode


# Called when the node enters the scene tree for the first time.
func _ready():	
	randomize()
	level_gen = LevelGenClass.new()
	level_gen.max_walk_length = 5
	level_gen.max_rooms_total = 7
	level_gen.min_rooms_total = 3
	level_gen.branch_chance = 33
	level_gen.walker_branch_decay_rate = 0.66
	
	level_root_node = level_gen.generate_level_nodes()
	current_node = level_root_node
	level_gen.instance_room_to(self, level_root_node)
	position_player_south(1.0)


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
			position_player_south(1.0)
		Directions.EAST:
			position_player_west(1.0)
		Directions.SOUTH:
			position_player_north(1.0)
		Directions.WEST:
			position_player_east(1.0) 
	
	# remove the current room Node2D from the tree
	current_node.room_inst.travelling = false
	remove_child(current_node.room_inst)
	level_gen.instance_room_to(self, new_node)
	
	# update the current node tracking
	current_node = new_node
	
	
# hard reset player position to north door
func position_player_north(delay: float):
	_position_player_by_loc(delay, Vector2(160,55))


# hard reset player position to east door
func position_player_east(delay: float):
	_position_player_by_loc(delay, Vector2(260,120))
	
	
# hard reset player position to south door
func position_player_south(delay: float):
	_position_player_by_loc(delay, Vector2(160,175))


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
	player.visible = true
	
