extends Node2D
class_name Level

const PLAYER_NAME = "Player"
const LevelGenClass = preload("res://Levels/LevelGen.gd")

var level_gen: LevelGen
var level_root_node: LevelGen.RoomTreeNode
var current_node: LevelGen.RoomTreeNode

# Called when the node enters the scene tree for the first time.
func _ready():	
	level_gen = LevelGenClass.new()
	level_root_node = level_gen.generate_level_nodes()
	current_node = level_root_node
	level_gen.instance_room_to(self, level_root_node)
	position_player_south(1.0)

func request_travel_north() -> bool:
	# ensure we could travel
	if current_node.north == null:
		push_error("attempted travel north where there's no door")
		return false
	
	# remove the current room Node2D from the tree
	remove_child(current_node.room_inst)
	level_gen.instance_room_to(self, current_node.north)
	
	# update the current node tracking
	current_node = current_node.north
	
	position_player_south(1.0)
	return true 
	
func request_travel_south() -> bool:
	# ensure we could travel
	if current_node.south == null:
		push_error("attempted travel south where there's no door")
		return false
	
	# remove the current room Node2D from the tree
	remove_child(current_node.room_inst)
	level_gen.instance_room_to(self, current_node.south)
	
	# update the current node tracking
	current_node = current_node.south
	
	position_player_north(1.0)
	return true 
	
# hard reset player position to south door
func position_player_south(delay: float):
	var player = get_node(PLAYER_NAME)
	assert(player) 
	player.visible = false
	yield(get_tree().create_timer(delay), "timeout")
	player.visible = true
	player.set_global_position(Vector2(160,175))
	
# hard reset player position to north door
func position_player_north(delay: float):
	var player = get_node(PLAYER_NAME)
	assert(player)
	player.visible = false
	yield(get_tree().create_timer(delay), "timeout")
	player.visible = true
	player.set_global_position(Vector2(160,55))
